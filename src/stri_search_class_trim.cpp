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
#include "stri_container_charclass.h"


/**
 * Trim characters from a charclass from left AND/OR right side of the string
 *
 * @param str character vector
 * @param pattern character vector
 * @param left from left?
 * @param right from left?
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-04)
 *          Use StriContainerUTF8 and CharClass
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly & Use StrContainerCharClass
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-03)
 *          detects invalid UTF-8 byte stream
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-05)
 *          StriContainerCharClass now relies on UnicodeSet
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
*/
SEXP stri__trim_leftright(SEXP str, SEXP pattern, bool left, bool right)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   R_len_t vectorize_length =
      stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   STRI__ERROR_HANDLER_BEGIN(2)
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || pattern_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      const UnicodeSet* pattern_cur = &pattern_cont.get(i);
      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t jlast1 = 0;
      R_len_t jlast2 = str_cur_n;

      if (left) {
         UChar32 chr;
         for (R_len_t j=0; j<str_cur_n; ) {
            U8_NEXT(str_cur_s, j, str_cur_n, chr); // "look ahead"
            if (chr < 0) // invalid utf-8 sequence
               throw StriException(MSG__INVALID_UTF8);
            if (pattern_cur->contains(chr)) {
               break; // break at first occurrence
            }
            jlast1 = j;
         }
      }

      if (right && jlast1 < str_cur_n) {
         UChar32 chr;
         for (R_len_t j=str_cur_n; j>0; ) {
            U8_PREV(str_cur_s, 0, j, chr); // "look behind"
            if (chr < 0) // invalid utf-8 sequence
               throw StriException(MSG__INVALID_UTF8);
            if (pattern_cur->contains(chr)) {
               break; // break at first occurrence
            }
            jlast2 = j;
         }
      }

      // now jlast is the index, from which we start copying
      SET_STRING_ELT(ret, i,
         Rf_mkCharLenCE(str_cur_s+jlast1, (jlast2-jlast1), CE_UTF8));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/**
 * Trim characters from a charclass from both sides of the string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-04)
 *          Use stri__trim_leftright
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
*/
SEXP stri_trim_both(SEXP str, SEXP pattern)
{
   return stri__trim_leftright(str, pattern, true, true);
}


/**
 * Trim characters from a charclass from the left of the string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-04)
 *          Use stri__trim_leftright
*/
SEXP stri_trim_left(SEXP str, SEXP pattern)
{
   return stri__trim_leftright(str, pattern, true, false);
}


/**
 * Trim characters from a charclass from the right of the string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-04)
 *          Use stri__trim_leftright
*/
SEXP stri_trim_right(SEXP str, SEXP pattern)
{
   return stri__trim_leftright(str, pattern, false, true);
}
