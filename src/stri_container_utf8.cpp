/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * 'stringi' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'stringi' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.
 */


#include "stri_stringi.h"


/**
 * Default constructor
 *
 */
StriContainerUTF8::StriContainerUTF8()
   : StriContainerBase()
{
   str = NULL;
   last_ind_back_str = NULL;
   last_ind_fwd_str = NULL;
}


/**
 * Construct String Container from R character vector
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
   this->init_Base(nrstr, _nrecycle, _shallowrecycle); // calling LENGTH(rstr) fails on constructor call

   if (this->n > 0) {
      this->str = new String8*[this->n];
      for (R_len_t i=0; i<this->n; ++i)
         this->str[i] = NULL; // in case it fails during conversion (this is NA)

      UConverter* ucnvLatin1 = NULL;
      UConverter* ucnvNative = NULL;
      int bufsize = -1;
      char* buf = NULL;

      for (R_len_t i=0; i<nrstr; ++i) {
         SEXP curs = STRING_ELT(rstr, i);
         if (curs == NA_STRING) {
            continue; // keep NA
         }
         else {
            if (IS_ASCII(curs)) { // ASCII - ultra fast
               this->str[i] = new String8(CHAR(curs), LENGTH(curs), !_shallowrecycle);
            }
            else if (IS_UTF8(curs)) { // UTF-8 - ultra fast
               this->str[i] = new String8(CHAR(curs), LENGTH(curs), !_shallowrecycle);
            }
            else if (IS_BYTES(curs))
               throw StriException(MSG__BYTESENC);
            else {
//             LATIN1 ------- OR ------ Any encoding - detection needed
//             Assume it's Native; this assumes the user working in an 8-bit environment
//             would convert strings to UTF-8 manually if needed - I think is's
//             a more reasonable approach (Native --> input via keyboard)


// version 0.1 - through UnicodeString & std::string
//               if (!ucnvNative) ucnvNative = stri__ucnv_open((char*)NULL);
//               UErrorCode status = U_ZERO_ERROR;
//               UnicodeString tmp(CHAR(curs), LENGTH(curs), ucnvNative, status);
//               if (U_FAILURE(status))
//                  throw StriException(status);
//               std::string tmp2;
//               tmp.toUTF8String(tmp2);
//               this->str[i] = new String8(tmp2.c_str(), tmp2.size(), true);
//               this->enc[i] = STRI_ENC_NATIVE;

// version 0.2 - faster - through UnicodeString & u_strToUTF8
               UConverter* ucnvCurrent;
               if (IS_LATIN1(curs)) {
                  if (!ucnvLatin1) ucnvLatin1 = stri__ucnv_open("ISO-8859-1");
                  ucnvCurrent = ucnvLatin1;
               }
               else {
                  if (!ucnvNative) ucnvNative = stri__ucnv_open((char*)NULL);
                  ucnvCurrent = ucnvNative;
               }
               UErrorCode status = U_ZERO_ERROR;
               UnicodeString tmp(CHAR(curs), LENGTH(curs), ucnvCurrent, status);
               if (U_FAILURE(status))
                  throw StriException(status);

               if (!buf) {
                  // calculate max string length
                  R_len_t maxlen = 0;
                  for (R_len_t z=i; z<nrstr; ++z) { // start from current string (this wasn't needed before)
                     SEXP tmps = STRING_ELT(rstr, z);
                     if ((tmps != NA_STRING) && (maxlen < LENGTH(tmps)))
                        maxlen = LENGTH(tmps);
                  }
                  bufsize = maxlen*3+1; // 1 UChar -> max 3 UTF8 bytes
                  buf = new char[bufsize];
               }
               int realsize = 0;

               u_strToUTF8(buf, bufsize, &realsize,
               		tmp.getBuffer(), tmp.length(), &status);
               if (U_FAILURE(status))
                  throw StriException(status);

               this->str[i] = new String8(buf, realsize, true);
            }
         }
      }

      if (ucnvLatin1) ucnv_close(ucnvLatin1);
      if (ucnvNative) ucnv_close(ucnvNative);
      if (buf) delete [] buf;


      if (!_shallowrecycle) {
         for (R_len_t i=nrstr; i<this->n; ++i) {
            if (this->str[i%nrstr] == NULL)
               this->str[i] = NULL;
            else
               this->str[i] = new String8(*this->str[i%nrstr]);
         }
      }
   }
}


StriContainerUTF8::StriContainerUTF8(StriContainerUTF8& container)
   :    StriContainerBase((StriContainerBase&)container)
{
   if (container.str) {
      this->str = new String8*[this->n];
      for (int i=0; i<this->n; ++i) {
         if (container.str[i])
            this->str[i] = new String8(*(container.str[i]));
         else
            this->str[i] = NULL;
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
      this->str = new String8*[this->n];
      for (int i=0; i<this->n; ++i) {
         if (container.str[i])
            this->str[i] = new String8(*(container.str[i]));
         else
            this->str[i] = NULL;
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
      for (int i=0; i<n; ++i) {
         if (str[i])
            delete str[i];
      }
      delete [] str;
      str = NULL;
   }
}




/** Export character vector to R
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *  Recycle rule is applied, so length == nrecycle
 * @return STRSXP
 */
SEXP StriContainerUTF8::toR() const
{
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, nrecycle));

   for (R_len_t i=0; i<nrecycle; ++i) {
      if (!str[i%n])
         SET_STRING_ELT(ret, i, NA_STRING);
      else {
         SET_STRING_ELT(ret, i,
            Rf_mkCharLenCE(str[i%n]->c_str(), str[i%n]->length(), CE_UTF8));
      }
   }

   UNPROTECT(1);
   return ret;
}



/** Export string to R
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *  @param i index [with recycle]
 * @return CHARSXP
 */
SEXP StriContainerUTF8::toR(R_len_t i) const
{
#ifndef NDEBUG
   if (i < 0 || i >= nrecycle)
      throw StriException("StriContainerUTF8::toR(): INDEX OUT OF BOUNDS");
#endif

   if (str[i%n] == NULL)
      return NA_STRING;
   else
      // This is already in UTF-8
      return Rf_mkCharLenCE(str[i%n]->c_str(), str[i%n]->length(), CE_UTF8);
}





/** Convert BACKWARD UChar32-based index to UTF-8 based
 *
 * @param i string index (in container)
 * @param wh UChar32 character's position to look for,
 * counting starts from 0 == byte after last character in the i-th string
 * @return UTF-8 (byte) index
 *
 *
 * @version 0.1 (Bartek Tartanus)  stri_sub
 * @version 0.2 (Marek Gagolewski) stri__UChar32_to_UTF8_index
 * @version 0.3 (Marek Gagolewski, 2013-06-01) moved to StriContainerUTF8
 */
R_len_t StriContainerUTF8::UChar32_to_UTF8_index_back(R_len_t i, R_len_t wh)
{
   R_len_t cur_n = get(i).length();
   const char* cur_s = get(i).c_str();

   if (wh <= 0) return cur_n;

   if (last_ind_back_str != cur_s) {
      // starting search in a different string
      last_ind_back_codepoint = 0;
      last_ind_back_utf8 = cur_n;
      last_ind_back_str = cur_s;
   }



   R_len_t j = 0;
   R_len_t jres = cur_n;

   if (last_ind_back_codepoint > 0) {
      if (wh < last_ind_back_codepoint) {
         // check if it makes sense to go towards the end of the string
         // or maybe it will be better to start from the end and move backwards
         if ((last_ind_back_codepoint-wh) < (wh-0)) {
            // less code points will be considered when going backwards
            j    = last_ind_back_codepoint;
            jres = last_ind_back_utf8;
            while (j > wh && jres < cur_n) {
               U8_FWD_1((const uint8_t*)cur_s, jres, cur_n);
               --j;
            }

            last_ind_back_codepoint = wh;
            last_ind_back_utf8 = jres;
            return jres; // stop right now
         }
         // else
      }
      else { //if (wh >= last_ind_back_codepoint)  // continue last search
         j    = last_ind_back_codepoint;
         jres = last_ind_back_utf8;
      }
   }

   // go backward
   while (j < wh && jres > 0) {
      U8_BACK_1((const uint8_t*)cur_s, 0, jres);
      ++j;
   }

   last_ind_back_codepoint = wh;
   last_ind_back_utf8 = jres;

   return jres;
}



/** Convert FORWARD UChar32-based index to UTF-8 based
 *
 * @param i string index (in container)
 * @param wh UChar32 character's position to look for,
 * counting starts from 0 == first character in i-th string
 * @return UTF-8 (byte) index
 *
 *
 * @version 0.1 (Bartek Tartanus)  stri_sub
 * @version 0.2 (Marek Gagolewski) stri__UChar32_to_UTF8_index
 * @version 0.3 (Marek Gagolewski, 2013-06-01) moved to StriContainerUTF8
 */
R_len_t StriContainerUTF8::UChar32_to_UTF8_index_fwd(R_len_t i, R_len_t wh)
{
   if (wh <= 0) return 0;

   R_len_t cur_n = get(i).length();
   const char* cur_s = get(i).c_str();

   if (last_ind_fwd_str != cur_s) {
      // starting search in a different string
      last_ind_fwd_codepoint = 0;
      last_ind_fwd_utf8 = 0;
      last_ind_fwd_str = cur_s;
   }

   R_len_t j = 0;
   R_len_t jres = 0;

   if (last_ind_fwd_codepoint > 0) {
      if (wh < last_ind_fwd_codepoint) {
         // check if it makes sense to go backwards from last position,
         // or it is better to start from scratch
         if ((last_ind_fwd_codepoint-wh) < (wh-0)) {
            // less code points will be considered when going backwards
            j    = last_ind_fwd_codepoint;
            jres = last_ind_fwd_utf8;
            while (j > wh && jres > 0) {
               U8_BACK_1((const uint8_t*)cur_s, 0, jres);
               --j;
            }

            last_ind_fwd_codepoint = wh;
            last_ind_fwd_utf8 = jres;
            return jres; // stop right now
         }
         // else
      }
      else { //if (wh >= last_ind_fwd_codepoint)  // continue last search
         j    = last_ind_fwd_codepoint;
         jres = last_ind_fwd_utf8;
      }
   }

   // go forward
   while (j < wh && jres < cur_n) {
      U8_FWD_1((const uint8_t*)cur_s, jres, cur_n);
      ++j;
   }

   last_ind_fwd_codepoint = wh;
   last_ind_fwd_utf8 = jres;
   return jres;
}





 /** Convert UTF8-byte indices to Unicode32 (code points)
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
void StriContainerUTF8::UTF8_to_UChar32_index(R_len_t i,
   int* i1, int* i2, const int ni, int adj1, int adj2)
{
   const char* cstr = get(i).c_str();
   const int nstr = get(i).length();

   int j1 = 0;
   int j2 = 0;

   int i8 = 0;
   int i32 = 0;
   while (i8 < nstr && (j1 < ni || j2 < ni)) {

      if (j1 < ni && i1[j1] <= i8) {
#ifndef NDEBUG
      if (j1 < ni-1 && i1[j1] >= i1[j1+1])
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index");
#endif
         i1[j1] = i32 + adj1;
         ++j1;
      }

      if (j2 < ni && i2[j2] <= i8) {
#ifndef NDEBUG
      if (j2 < ni-1 && i2[j2] >= i2[j2+1])
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index");
#endif
         i2[j2] = i32 + adj2;
         ++j2;
      }

      // Next UChar32
      U8_FWD_1(cstr, i8, nstr);
      ++i32;
   }

   // CONVERT LAST:
   if (j1 < ni && i1[j1] <= nstr) {
#ifndef NDEBUG
      if (j1 < ni-1 && i1[j1] >= i1[j1+1])
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index");
#endif
         i1[j1] = i32 + adj1;
         ++j1;
   }

   if (j2 < ni && i2[j2] <= nstr) {
#ifndef NDEBUG
      if (j2 < ni-1 && i2[j2] >= i2[j2+1])
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index");
#endif
         i2[j2] = i32 + adj2;
         ++j2;
   }

   // CHECK:
#ifndef NDEBUG
      if (i8 >= nstr && (j1 < ni || j2 < ni))
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index()");
#endif
}
