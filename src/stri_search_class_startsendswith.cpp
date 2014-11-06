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
#include "stri_container_utf8_indexable.h"
#include "stri_container_integer.h"
#include "stri_container_charclass.h"


/**
 * Detect if a string starts with a pattern match
 *
 * @param str character vector
 * @param pattern character vector
 * @param from integer vector
 * @return logical vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-31)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_startswith_charclass(SEXP str, SEXP pattern, SEXP from)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   PROTECT(from = stri_prepare_arg_integer(from, "from"));

   STRI__ERROR_HANDLER_BEGIN(3)
   int vectorize_length = stri__recycling_rule(true, 3,
      LENGTH(str), LENGTH(pattern), LENGTH(from));
   StriContainerUTF8_indexable str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);
   StriContainerInteger from_cont(from, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || pattern_cont.isNA(i) || from_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      R_len_t from_cur = from_cont.get(i);
      if (from_cur == 1)
         from_cur = 0; /* most commonly used case */
      else if (from_cur >= 0)
         from_cur = str_cont.UChar32_to_UTF8_index_fwd(i, from_cur-1);
      else
         from_cur = str_cont.UChar32_to_UTF8_index_back(i, -from_cur);
      // now surely from_cur >= 0 && from_cur <= cur_n

      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t     str_cur_n = str_cont.get(i).length();
      const UnicodeSet* pattern_cur = &pattern_cont.get(i);

      if (from_cur > str_cur_n)
         ret_tab[i] = FALSE;
      else {
         UChar32 chr = 0;
         U8_NEXT(str_cur_s, from_cur, str_cur_n, chr);
         if (chr < 0) // invalid utf-8 sequence
            throw StriException(MSG__INVALID_UTF8);
         ret_tab[i] = pattern_cur->contains(chr);
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}


/**
 * Detect if a string ends with a pattern match
 *
 * @param str character vector
 * @param pattern character vector
 * @param to integer vector
 * @return logical vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-31)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_endswith_charclass(SEXP str, SEXP pattern, SEXP to)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   PROTECT(to = stri_prepare_arg_integer(to, "to"));

   STRI__ERROR_HANDLER_BEGIN(3)
   int vectorize_length = stri__recycling_rule(true, 3,
      LENGTH(str), LENGTH(pattern), LENGTH(to));
   StriContainerUTF8_indexable str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);
   StriContainerInteger to_cont(to, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || pattern_cont.isNA(i) || to_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t     str_cur_n = str_cont.get(i).length();
      const UnicodeSet* pattern_cur = &pattern_cont.get(i);

      R_len_t to_cur = to_cont.get(i);
      if (to_cur == -1)
         to_cur = str_cur_n; /* most commonly used case */
      else if (to_cur >= 0)
         to_cur = str_cont.UChar32_to_UTF8_index_fwd(i, to_cur);
      else
         to_cur = str_cont.UChar32_to_UTF8_index_back(i, -to_cur-1);
      // now surely to_cur >= 0 && to_cur <= cur_n

      if (to_cur <= 0)
         ret_tab[i] = FALSE;
      else {
         UChar32 chr = 0;
         U8_PREV(str_cur_s, 0, to_cur, chr);
         if (chr < 0) // invalid utf-8 sequence
            throw StriException(MSG__INVALID_UTF8);
         ret_tab[i] = pattern_cur->contains(chr);
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}
