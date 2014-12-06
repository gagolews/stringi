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
#include "stri_container_utf16.h"
#include "stri_string8buf.h"
#include "stri_ucnv.h"


/**
 * Default constructor
 *
 */
StriContainerUTF16::StriContainerUTF16()
   : StriContainerBase()
{
   this->str = NULL;
}


/** container for nrecycle fresh, brand new, writable UnicodeStrings
 *
 * Each string is initially empty.
 *
 * @param nrecycle number of strings
 */
StriContainerUTF16::StriContainerUTF16(R_len_t _nrecycle)
{
   this->str = NULL;
   this->init_Base(_nrecycle, _nrecycle, false);
   if (this->n > 0) {
      this->str = new UnicodeString[this->n];
      if (!this->str) throw StriException(MSG__MEM_ALLOC_ERROR);
   }
}


/**
 * Construct String Container from an R character vector
 *
 * @param rstr R character vector
 * @param nrecycle extend length [vectorization]
 * @param shallowrecycle will \code{this->str} be ever modified?
 */
StriContainerUTF16::StriContainerUTF16(SEXP rstr, R_len_t _nrecycle, bool _shallowrecycle)
{
   this->str = NULL;
#ifndef NDEBUG
   if (!isString(rstr))
      throw StriException("DEBUG: !isString in StriContainerUTF16::StriContainerUTF16(SEXP rstr)");
#endif
   R_len_t nrstr = LENGTH(rstr);
   this->init_Base(nrstr, _nrecycle, _shallowrecycle); // calling LENGTH(rstr) fails on constructor call

   if (this->n == 0)
      return; /* nothing more to do */

   this->str = new UnicodeString[this->n];
   if (!this->str) throw StriException(MSG__MEM_ALLOC_ERROR);
   for (R_len_t i=0; i<this->n; ++i)
      this->str[i].setToBogus(); // in case it fails during conversion (this is NA)

   /* Important: ICU provides full internationalization functionality
   without any conversion table data. The common library contains
   code to handle several important encodings algorithmically: US-ASCII,
   ISO-8859-1, UTF-7/8/16/32, SCSU, BOCU-1, CESU-8, and IMAP-mailbox-name */
   StriUcnv ucnvASCII("US-ASCII");
   StriUcnv ucnvLatin1("ISO-8859-1");
   StriUcnv ucnvNative(NULL);

   for (R_len_t i=0; i<nrstr; ++i) {
      SEXP curs = STRING_ELT(rstr, i);
      if (curs == NA_STRING) {
         continue; // keep NA
      }

      if (IS_ASCII(curs)) {
         // Version 1:
         UConverter* ucnv = ucnvASCII.getConverter();
         UErrorCode status = U_ZERO_ERROR;
         this->str[i].setTo(
            UnicodeString((const char*)CHAR(curs), (int32_t)LENGTH(curs), ucnv, status)
         );
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

         // Performance improvement attempt #1:
         // this->str[i] = new UnicodeString(UnicodeString::fromUTF8(CHAR(curs)));
         // if (!this->str) throw StriException(MSG__MEM_ALLOC_ERROR);
         // slower than the above

         // Performance improvement attempt #2:
         // Create UChar buf with LENGTH(curs) items, fill it with (CHAR(curs)[i], 0x00), i=1,...
         // This wasn't faster than the ucnvASCII approach.

         // Performance improvement attempt #3:
         // slightly slower than ucnvASCII
         // R_len_t curs_n = LENGTH(curs);
         // const char* curs_s = CHAR(curs);
         // this->str[i].remove(); // unset bogus (NA)
         // UChar* buf = this->str[i].getBuffer(curs_n);
         // for (R_len_t k=0; k<curs_n; ++k)
         //   buf[k] = (UChar)curs_s[k]; // well, this is ASCII :)
         // this->str[i].releaseBuffer(curs_n);
      }
      else if (IS_UTF8(curs)) {
         // using ucnvUTF8 is slower for UTF-8
         // the same is done for native encoding && ucnvNative_isUTF8
         this->str[i].setTo(UnicodeString::fromUTF8(CHAR(curs)));
      }
      else if (IS_LATIN1(curs)) {
         UConverter* ucnv = ucnvLatin1.getConverter();
         UErrorCode status = U_ZERO_ERROR;
         this->str[i].setTo(
            UnicodeString((const char*)CHAR(curs), (int32_t)LENGTH(curs), ucnv, status)
         );
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }
      else if (IS_BYTES(curs)) {
         throw StriException(MSG__BYTESENC);
      }
      else {
         // an "unknown" (native) encoding may be set to UTF-8 (speedup)
         if (ucnvNative.isUTF8()) {
            // UTF-8
            this->str[i].setTo(UnicodeString::fromUTF8(CHAR(curs)));
         }
         else {
            UConverter* ucnv = ucnvNative.getConverter();
            UErrorCode status = U_ZERO_ERROR;
            this->str[i].setTo(
               UnicodeString((const char*)CHAR(curs), (int32_t)LENGTH(curs), ucnv, status)
            );
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         }
      }
   }

   if (!_shallowrecycle) {
      for (R_len_t i=nrstr; i<this->n; ++i) {
         this->str[i].setTo(str[i%nrstr]);
      }
   }
}


/** Copy constructor
 *
 *  @param container source
 */
StriContainerUTF16::StriContainerUTF16(StriContainerUTF16& container)
   :    StriContainerBase((StriContainerBase&)container)
{
   if (container.str) {
      this->str = new UnicodeString[this->n];
      if (!this->str) throw StriException(MSG__MEM_ALLOC_ERROR);
      for (int i=0; i<this->n; ++i) {
         this->str[i].setTo(container.str[i]);
      }
   }
   else {
      this->str = NULL;
   }
}


/**
 *  @param container source
 *  @return self
 */
StriContainerUTF16& StriContainerUTF16::operator=(StriContainerUTF16& container)
{
   this->~StriContainerUTF16();
   (StriContainerBase&) (*this) = (StriContainerBase&)container;

   if (container.str) {
      this->str = new UnicodeString[this->n];
      if (!this->str) throw StriException(MSG__MEM_ALLOC_ERROR);
      for (int i=0; i<this->n; ++i) {
         this->str[i].setTo(container.str[i]);
      }
   }
   else {
      this->str = NULL;
   }
   return *this;
}


/** Destructor
 *
 */
StriContainerUTF16::~StriContainerUTF16()
{
   if (str) {
      delete [] str;
      str = NULL;
   }
}


/** Export character vector to R
 *
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *
 *  Recycle rule is applied, so length == nrecycle
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-23)
 *          using 1 tmpbuf + u_strToUTF8 for slightly better performance
 *
 * @return STRSXP
 */
SEXP StriContainerUTF16::toR() const
{
   R_len_t outbufsize = 0;
   for (R_len_t i=0; i<nrecycle; ++i) {
      if (!str[i%n].isBogus()) {
         R_len_t thissize = str[i%n].length();
         if (thissize > outbufsize)
            outbufsize = thissize;
      }
   }
   // One UChar -- <= U+FFFF  -> 1-3 bytes UTF8
   // Two UChars -- >=U+10000 ->   4 bytes UTF8
   outbufsize = UCNV_GET_MAX_BYTES_FOR_STRING(outbufsize, 3);
   String8buf outbuf(outbufsize);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, nrecycle));

   UErrorCode status = U_ZERO_ERROR;
   for (R_len_t i=0; i<nrecycle; ++i) {
      if (str[i%n].isBogus())
         SET_STRING_ELT(ret, i, NA_STRING);
      else {
         int outrealsize = 0;
         u_strToUTF8(outbuf.data(), outbufsize, &outrealsize,
            str[i%n].getBuffer(), str[i%n].length(), &status);
         STRI__CHECKICUSTATUS_THROW(status, {UNPROTECT(1);})
         SET_STRING_ELT(ret, i,
            Rf_mkCharLenCE(outbuf.data(), outrealsize, (cetype_t)CE_UTF8));
      }
   }

   UNPROTECT(1);
   return ret;
}


/** Export string to R
 *
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *
 *  @param i index [with recycle]
 *  @return CHARSXP
 */
SEXP StriContainerUTF16::toR(R_len_t i) const
{
#ifndef NDEBUG
   if (i < 0 || i >= nrecycle)
      throw StriException("StriContainerUTF16::toR(): INDEX OUT OF BOUNDS");
#endif

   if (str[i%n].isBogus())
      return NA_STRING;
   else {
      std::string s;
      str[i%n].toUTF8String(s);
      return Rf_mkCharLenCE(s.c_str(), (int)s.length(), (cetype_t)CE_UTF8);
   }
}


/** Convert Unicode16-Char indices to Unicode32 (code points)
 *
 * \code{i1} and \code{i2} must be sorted increasingly
 *
 * @param i element index
 * @param i1 indices, 1-based [in/out]
 * @param i2 indices, 1-based [in/out]
 * @param ni size of \code{i1} and \code{i2}
 * @param adj1 adjust for \code{i1}
 * @param adj2 adjust for \code{i2}
 *
 */
void StriContainerUTF16::UChar16_to_UChar32_index(R_len_t i,
   int* i1, int* i2, const int ni, int adj1, int adj2)
{
   const UnicodeString* str_data = &(this->get(i));
   const UChar* cstr = str_data->getBuffer();
   const int nstr = str_data->length();

   int j1 = 0;
   int j2 = 0;

   int i16 = 0;
   int i32 = 0;
   while (i16 < nstr && (j1 < ni || j2 < ni)) {
      if (j1 < ni && i1[j1] <= i16) {
#ifndef NDEBUG
      if (j1 < ni-1 && i1[j1] >= i1[j1+1])
         throw StriException("DEBUG: stri__UChar16_to_UChar32_index");
#endif
         i1[j1] = i32 + adj1;
         ++j1;
      }

      if (j2 < ni && i2[j2] <= i16) {
#ifndef NDEBUG
      if (j2 < ni-1 && i2[j2] >= i2[j2+1])
         throw StriException("DEBUG: stri__UChar16_to_UChar32_index");
#endif
         i2[j2] = i32 + adj2;
         ++j2;
      }

      // Next UChar32
      U16_FWD_1(cstr, i16, nstr);
      ++i32;
   }

   // CONVERT LAST:
   if (j1 < ni && i1[j1] <= nstr) {
#ifndef NDEBUG
      if (j1 < ni-1 && i1[j1] >= i1[j1+1])
         throw StriException("DEBUG: stri__UChar16_to_UChar32_index");
#endif
         i1[j1] = i32 + adj1;
         ++j1;
   }

   if (j2 < ni && i2[j2] <= nstr) {
#ifndef NDEBUG
      if (j2 < ni-1 && i2[j2] >= i2[j2+1])
         throw StriException("DEBUG: stri__UChar16_to_UChar32_index");
#endif
         i2[j2] = i32 + adj2;
         ++j2;
   }

   // CHECK:
#ifndef NDEBUG
      if (i16 >= nstr && (j1 < ni || j2 < ni))
         throw StriException("DEBUG: stri__UChar16_to_UChar32_index()");
#endif
}
