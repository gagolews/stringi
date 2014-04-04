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
#include "stri_container_utf16.h"
#include "stri_string8buf.h"
#include <vector>
#include <unicode/uniset.h>


/** Generate random permutations of code points in each string
 *
 * @param str character vector
 * @return character vector
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-04)
 */
SEXP stri_rand_shuffle(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t n = LENGTH(str);

   GetRNGstate();
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, n);

   R_len_t bufsize = 0;
   for (R_len_t i=0; i<n; ++i) {
      if (str_cont.isNA(i)) continue;
      R_len_t ni = str_cont.get(i).length();
      if (ni > bufsize) bufsize = ni;
   }
   std::vector<UChar32> buf1(bufsize); // at most bufsize UChars32 (bufsize/4 min.)
   String8buf buf2(bufsize);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, n));

   for (R_len_t i=0; i<n; ++i) {

      if (str_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      // fill buf1
      UChar32 c = (UChar32)0;
      const char* s = str_cont.get(i).c_str();
      R_len_t sn = str_cont.get(i).length();
      R_len_t j = 0;
      R_len_t k = 0;
      while (c >= 0 && j < sn) {
         U8_NEXT(s, j, sn, c);
         buf1[k++] = (int)c;
      }

      if (c < 0) {
         Rf_warning(MSG__INVALID_UTF8);
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      // do shuffle buf1 at pos 0..k-1: (Fischer-Yates shuffle)
      R_len_t cur_n = k;
      for (j=0; j<cur_n-1; ++j) {
         // rand from i to cur_n-1
         R_len_t r = (R_len_t)floor(unif_rand()*(double)(cur_n-i)+(double)i);
         UChar32 tmp = buf1[r];
         buf1[r] = buf1[j];
         buf1[j] = tmp;
      }

      // create string:
      char* buf2data = buf2.data();
      c = (UChar32)0;
      j = 0;
      k = 0;
      UBool err = FALSE;
      while (!err && k < cur_n) {
         c = buf1[k++];
         U8_APPEND((uint8_t*)buf2data, j, bufsize, c, err);
      }

      if (err) throw StriException(MSG__INTERNAL_ERROR);

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf2data, j, CE_UTF8));
   }

   PutRNGstate();
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      PutRNGstate();
   })
}


/** Generate random strings
 *
 * @param n single integer
 * @param length integer vector
 * @param pattern single string, not NA
 * @return character vector
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-04)
 */
SEXP stri_rand_strings(SEXP n, SEXP length, SEXP pattern)
{
   int n_val = stri__prepare_arg_integer_1_notNA(n, "n");
   length    = stri_prepare_arg_integer(length, "length");
   pattern   = stri_prepare_arg_string_1(pattern, "pattern");

   if (n_val < 0) n_val = 0; /* that's not NA for sure now */

   R_len_t length_len = LENGTH(length);
   if (length_len <= 0)
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, "length");
   else if (length_len > n_val || n_val % length_len != 0)
      Rf_warning(MSG__WARN_RECYCLING_RULE2);

   GetRNGstate();
   STRI__ERROR_HANDLER_BEGIN

   StriContainerUTF16 pattern_cont(pattern, 1);
   if (pattern_cont.isNA(0))
      return stri__vector_NA_strings(n_val); // n_val NAs

   UErrorCode status = U_ZERO_ERROR;
   UnicodeSet uset(pattern_cont.get(0) /* that's not NA */, status);
   if (U_FAILURE(status))
      throw StriException(status);
   int32_t uset_size = uset.size();

   // get max required bufsize
   int*    length_tab = INTEGER(length);
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<length_len; ++i) {
      if (length_tab[i] != NA_INTEGER && length_tab[i] > bufsize)
         bufsize = length_tab[i];
   }
   bufsize *= 4;  // 1 UChar32 -> max. 4 UTF-8 bytes
   String8buf buf(bufsize);
   char* bufdata = buf.data();

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, n_val));

   for (R_len_t i=0; i<n_val; ++i) {
      int length_cur = length_tab[i%length_len];
      if (length_cur == NA_INTEGER) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      else if (length_cur < 0)
         length_cur = 0;


      // generate string:
      R_len_t j = 0;
      UBool err = FALSE;
      for (R_len_t k=0; k<length_cur; ++k) {
         int32_t idx = (int32_t)floor(unif_rand()*(double)uset_size); /* 0..uset_size-1 */
         UChar32 c = uset.charAt(idx);
         if (c < 0) throw StriException(MSG__INTERNAL_ERROR);

         U8_APPEND((uint8_t*)bufdata, j, bufsize, c, err);
         if (err) throw StriException(MSG__INTERNAL_ERROR);
      }
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(bufdata, j, CE_UTF8));
   }

   PutRNGstate();
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      PutRNGstate();
   })
}
