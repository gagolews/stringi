/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#include "stri_stringi.h"
#include "stri_container_utf8.h"
#include "stri_ucnv.h"
#include "stri_string8buf.h"

/**
 * Default constructor
 *
 */
StriContainerUTF8::StriContainerUTF8()
   : StriContainerBase()
{
   str = NULL;
}


/**
 * Construct String Container from R character vector
 *
 * @param rstr R character vector
 * @param nrecycle extend length [vectorization]
 * @param shallowrecycle will \code{this->str} be ever modified?
 */
StriContainerUTF8::StriContainerUTF8(SEXP rstr, R_len_t _nrecycle, bool _shallowrecycle)
{
   this->str = NULL;

#ifndef NDEBUG
   if (!isString(rstr))
      throw StriException("DEBUG: !isString in StriContainerUTF8::StriContainerUTF8(SEXP rstr)");
#endif
   R_len_t nrstr = LENGTH(rstr);
   this->init_Base(nrstr, _nrecycle, _shallowrecycle, rstr); // calling LENGTH(rstr) fails on constructor call

   if (this->n == 0)
      return; /* nothing more to do */


   this->str = new String8[this->n];
   if (!this->str) throw StriException(MSG__MEM_ALLOC_ERROR);

   /* Important: ICU provides full internationalization functionality
   without any conversion table data. The common library contains
   code to handle several important encodings algorithmically: US-ASCII,
   ISO-8859-1, UTF-7/8/16/32, SCSU, BOCU-1, CESU-8, and IMAP-mailbox-name */
   // for conversion from non-utf8/ascii native charsets:
   StriUcnv ucnvLatin1("ISO-8859-1");
   StriUcnv ucnvNative(NULL);
   R_len_t outbufsize = -1;
   String8buf outbuf(0);
//      int    tmpbufsize = -1;
//      UChar* tmpbuf = NULL;


   for (R_len_t i=0; i<nrstr; ++i) {
      SEXP curs = STRING_ELT(rstr, i);
      if (curs == NA_STRING) {
         continue; // keep NA
      }

      if (IS_ASCII(curs) || IS_UTF8(curs)) {
         // ASCII or UTF-8 - ultra fast
         this->str[i].initialize(CHAR(curs), LENGTH(curs), false/*!_shallowrecycle*/, true);  /* kill UTF-8 BOM */
         // the same is done for native encoding && ucnvNative_isUTF8
         // @TODO: use macro (here & ucnvNative_isUTF8 below)
      }
      else if (IS_BYTES(curs)) {
         // "bytes encoding" is not allowed except
         // for some special functions which do encoding themselves
         throw StriException(MSG__BYTESENC);
      }
      else {
//             LATIN1 ------- OR ------ Native encoding

         UConverter* ucnvCurrent;
         if (IS_LATIN1(curs)) {
            ucnvCurrent = ucnvLatin1.getConverter();
         }
         else { // "unknown" (native) encoding
            // an "unknown" (native) encoding may be set to UTF-8 (speedup)
            if (ucnvNative.isUTF8()) {
               // UTF-8 - ultra fast
               // @TODO: use macro
               this->str[i].initialize(CHAR(curs), LENGTH(curs), false /*!_shallowrecycle*/, true); /* kill UTF-8 BOM */
               continue;
            }

            ucnvCurrent = ucnvNative.getConverter();
         }

         if (outbufsize < 0) {
            // calculate max string length
            R_len_t maxlen = LENGTH(curs);
            for (R_len_t z=i+1; z<nrstr; ++z) {
               // start from the current string (this no need to re-encode for < i)
               SEXP tmps = STRING_ELT(rstr, z);
               if ((tmps != NA_STRING)
                     && !(IS_ASCII(tmps) || IS_UTF8(tmps) || IS_BYTES(tmps))
                     && (maxlen < LENGTH(tmps)))
                  maxlen = LENGTH(tmps);
            }
//                  tmpbufsize = UCNV_GET_MAX_BYTES_FOR_STRING(maxlen, 4)+1;
//                  tmpbuf = new UChar[tmpbufsize];
//                  if (!tmpbuf) throw StriException(MSG__MEM_ALLOC_ERROR);
            // UCNV_GET_MAX_BYTES_FOR_STRING calculates the size
            // of a buffer for conversion from Unicode to a charset.
            // this may be overestimated
            outbufsize = UCNV_GET_MAX_BYTES_FOR_STRING(maxlen, 4)+1;
            outbuf.resize(outbufsize, false);
         }


         // version 1: use ucnv's pivot buffer (slower than v2)
//               UErrorCode status = U_ZERO_ERROR;
//               int realsize = ucnv_toAlgorithmic(UCNV_UTF8, ucnvCurrent,
//                  outbuf, outbufsize, CHAR(curs), LENGTH(curs), &status);
//               if (U_FAILURE(status)) { // STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
//                  CLEANUP_StriContainerUTF8
//                  throw StriException(status);
//               }

         // @TODO: test ucnv_convertEx


         // version 2: use u_strToUTF8 (faster than v1 and v2)
         // latin1/native -> UTF16
         UErrorCode status = U_ZERO_ERROR;
         UnicodeString tmp(CHAR(curs), LENGTH(curs), ucnvCurrent, status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

         // UTF-16 -> UTF-8
// // this is not faster than u_strToUTF8
//               const UChar* tmpbuf = tmp.getBuffer();
//               int tmpbufsize = tmp.length();
//               // tmpbuf is a well-formed UTF-16 string
//               int i1 = 0, outrealsize = 0;
//               UChar32 c;
//               while (i1 < tmpbufsize) {
//                  U16_NEXT_UNSAFE(tmpbuf, i1, c);
//                  U8_APPEND_UNSAFE(outbuf, outrealsize, c);
//#ifndef NDEBUG
//               if (outrealsize > outbufsize)
//                  throw StriException(U_BUFFER_OVERFLOW_ERROR);
//#endif
//               }

         int outrealsize = 0;
         u_strToUTF8(outbuf.data(), outbuf.size(), &outrealsize,
               tmp.getBuffer(), tmp.length(), &status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

         this->str[i].initialize(outbuf.data(), outrealsize, true);

         // version 3: use tmpbuf (slower than v2)
//               UErrorCode status = U_ZERO_ERROR;
//               int tmprealsize = ucnv_toUChars(ucnvCurrent, tmpbuf, tmpbufsize,
//                     CHAR(curs), LENGTH(curs), &status);
//               if (U_FAILURE(status)) { // STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
//                  CLEANUP_FAILURE_StriContainerUTF8
//                  throw StriException(status);
//               }
//
//               // UTF-16 -> UTF-8
//               int outrealsize = ucnv_fromUChars(ucnvUTF8,
//                  outbuf, outbufsize, tmpbuf, tmprealsize, &status);
//               if (U_FAILURE(status)) { // STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
//                  CLEANUP_FAILURE_StriContainerUTF8
//                  throw StriException(status);
//               }
      }
   }

   if (!_shallowrecycle) {
      for (R_len_t i=nrstr; i<this->n; ++i) {
            this->str[i] = str[i%nrstr];
      }
   }
}


StriContainerUTF8::StriContainerUTF8(StriContainerUTF8& container)
   :    StriContainerBase((StriContainerBase&)container)
{
   if (container.str) {
      this->str = new String8[this->n];
      if (!this->str) throw StriException(MSG__MEM_ALLOC_ERROR);
      for (int i=0; i<this->n; ++i) {
         this->str[i] = container.str[i];
      }
   }
   else {
      this->str = NULL;
   }
}


StriContainerUTF8& StriContainerUTF8::operator=(StriContainerUTF8& container)
{
   this->~StriContainerUTF8();
   (StriContainerBase&) (*this) = (StriContainerBase&)container;

   if (container.str) {
      this->str = new String8[this->n];
      if (!this->str) throw StriException(MSG__MEM_ALLOC_ERROR);
      for (int i=0; i<this->n; ++i) {
         this->str[i] = container.str[i];
      }
   }
   else {
      this->str = NULL;
   }
   return *this;
}


StriContainerUTF8::~StriContainerUTF8()
{
   if (str) {
//      for (int i=0; i<n; ++i) {
//         if (str[i])
//            delete str[i];
//      }
      delete [] str;
      str = NULL;
   }
}


/** Export character vector to R
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *
 *  Recycle rule is applied, so length == nrecycle
 *
 * @return STRSXP
 *
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-22)
 *    returns original CHARSXP if possible for increased performance
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
 *    call toR(int)
 */
SEXP StriContainerUTF8::toR() const
{
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, nrecycle));

   for (R_len_t i=0; i<nrecycle; ++i) {
      SET_STRING_ELT(ret, i, this->toR(i));
   }

   UNPROTECT(1);
   return ret;
}


/** Export string to R
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *
 * @param i index [with recycle]
 * @return CHARSXP
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-22)
 *    returns original CHARSXP if possible for increased performance
 */
SEXP StriContainerUTF8::toR(R_len_t i) const
{
#ifndef NDEBUG
   if (i < 0 || i >= nrecycle)
      throw StriException("StriContainerUTF8::toR(): INDEX OUT OF BOUNDS");
#endif

   String8* curs = &(str[i%n]);
   if (curs->isNA()) {
      return NA_STRING;
   }
   else if (curs->isReadOnly()) {
      // if ReadOnly, then surely in ASCII or UTF-8 and without BOMS (see SEXP-constructor)
      return STRING_ELT(sexp, i%n);
   }
   else {
      // This is already in UTF-8
      return Rf_mkCharLenCE(curs->c_str(), curs->length(), CE_UTF8);
   }
}
