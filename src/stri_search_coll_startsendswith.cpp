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
#include "stri_container_usearch.h"
#include "stri_container_integer.h"


/**
 * Detect if a string starts with a pattern match
 *
 * @param str character vector
 * @param pattern character vector
 * @param from integer vector
 * @param opts_collator named list
 * @return logical vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-01)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_startswith_coll(SEXP str, SEXP pattern, SEXP from, SEXP opts_collator)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   PROTECT(from = stri_prepare_arg_integer(from, "from"));

   UCollator* collator = NULL;
   collator = stri__ucol_open(opts_collator);

   STRI__ERROR_HANDLER_BEGIN(3)
   int vectorize_length = stri__recycling_rule(true, 3,
      LENGTH(str), LENGTH(pattern), LENGTH(from));
   StriContainerUTF16 str_cont(str, vectorize_length);
   StriContainerUStringSearch pattern_cont(pattern, vectorize_length, collator);  // collator is not owned by pattern_cont
   StriContainerInteger from_cont(from, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         ret_tab[i] = NA_LOGICAL,
         ret_tab[i] = FALSE)

      if (from_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      const UnicodeString* str_cur_data = &(str_cont.get(i));
      const UChar* str_cur_s = str_cur_data->getBuffer();
      const int str_cur_n = str_cur_data->length();

      R_len_t from_cur = from_cont.get(i);
      if (from_cur == 1)
         from_cur = 0; /* most commonly used case */
      else if (from_cur >= 0) {
         R_len_t nskip = from_cur-1;
         from_cur = 0;
         U16_FWD_N(str_cur_s, from_cur, str_cur_n, nskip);
      }
      else {
         R_len_t nskip = -from_cur;
         from_cur = str_cur_n;
         U16_BACK_N(str_cur_s, 0, from_cur, nskip);
      }
      // now surely from_cur >= 0 && from_cur <= str_cur_n

      ret_tab[i] = FALSE;
      if (from_cur >= str_cur_n) continue; // no match

      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cur_s+from_cur, str_cur_n-from_cur);
      usearch_reset(matcher);
      UErrorCode status = U_ZERO_ERROR;
      int start = usearch_first(matcher, &status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      if (start != USEARCH_DONE && start == 0) ret_tab[i] = TRUE;
   }

   if (collator) { ucol_close(collator); collator=NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}


/**
 * Detect if a string ends with a pattern match
 *
 * @param str character vector
 * @param pattern character vector
 * @param to integer vector
 * @param opts_collator named list
 * @return logical vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-01)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_endswith_coll(SEXP str, SEXP pattern, SEXP to, SEXP opts_collator)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   PROTECT(to = stri_prepare_arg_integer(to, "to"));

   UCollator* collator = NULL;
   collator = stri__ucol_open(opts_collator);

   STRI__ERROR_HANDLER_BEGIN(3)
   int vectorize_length = stri__recycling_rule(true, 3,
      LENGTH(str), LENGTH(pattern), LENGTH(to));
   StriContainerUTF16 str_cont(str, vectorize_length);
   StriContainerUStringSearch pattern_cont(pattern, vectorize_length, collator);  // collator is not owned by pattern_cont
   StriContainerInteger to_cont(to, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         ret_tab[i] = NA_LOGICAL,
         ret_tab[i] = FALSE)

      if (to_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      const UnicodeString* str_cur_data = &(str_cont.get(i));
      const UChar* str_cur_s = str_cur_data->getBuffer();
      const int str_cur_n = str_cur_data->length();

      R_len_t to_cur = to_cont.get(i);
      if (to_cur == -1)
         to_cur = str_cur_n; /* most commonly used case */
      else if (to_cur >= 0) {
         R_len_t nskip = to_cur;
         to_cur = 0;
         U16_FWD_N(str_cur_s, to_cur, str_cur_n, nskip);
      }
      else {
         R_len_t nskip = -to_cur-1;
         to_cur = str_cur_n;
         U16_BACK_N(str_cur_s, 0, to_cur, nskip);
      }
      // now surely to_cur >= 0 && to_cur <= str_cur_n

      ret_tab[i] = FALSE;
      if (to_cur <= 0) continue; // no match

      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cur_s, to_cur);
      usearch_reset(matcher);
      UErrorCode status = U_ZERO_ERROR;
      int start = usearch_last(matcher, &status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      if (start != USEARCH_DONE && start+usearch_getMatchedLength(matcher) == to_cur)
         ret_tab[i] = TRUE;
   }

   if (collator) { ucol_close(collator); collator=NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}
