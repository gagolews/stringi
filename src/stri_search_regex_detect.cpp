/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
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
#include "stri_container_utf8.h"
#include "stri_container_regex.h"

/**
 * Detect if a pattern occurs in a string
 *
 * @param str R character vector
 * @param pattern R character vector containing regular expressions
 * @param negate single bool
 * @param max_count single int
 * @param opts_regex list
 *
 * @version 0.1-?? (Marcin Bujarski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF16
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF16's vectorization
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-18)
 *          use StriContainerRegexPattern + opts_regex
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 1.0-2 (Marek Gagolewski, 2016-01-29)
 *    Issue #214: allow a regex pattern like `.*`  to match an empty string
 *
 * @version 1.0-3 (Marek Gagolewski, 2016-02-03)
 *    FR #216: `negate` arg added
 *
 * @version 1.3.1 (Marek Gagolewski, 2019-02-08)
 *    #232: `max_count` arg added
 */
SEXP stri_detect_regex(SEXP str, SEXP pattern, SEXP negate,
    SEXP max_count, SEXP opts_regex)
{
   bool negate_1 = stri__prepare_arg_logical_1_notNA(negate, "negate");
   int max_count_1 = stri__prepare_arg_integer_1_notNA(max_count, "max_count");
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   R_len_t vectorize_length =
      stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   STRI__ERROR_HANDLER_BEGIN(2)
   StriContainerUTF16 str_cont(str, vectorize_length);
//   StriContainerUTF8 str_cont(str, vectorize_length); // utext_openUTF8, see below
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (max_count_1 == 0) {
          ret_tab[i] = NA_LOGICAL;
          continue;
      }

      STRI__CONTINUE_ON_EMPTY_OR_NA_PATTERN(str_cont,
         pattern_cont, ret_tab[i] = NA_LOGICAL)

      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      matcher->reset(str_cont.get(i));

      UErrorCode status = U_ZERO_ERROR;
      ret_tab[i] = (int)matcher->find(status); // returns UBool
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      if (negate_1) ret_tab[i] = !ret_tab[i];
      if (max_count_1 > 0 && ret_tab[i]) --max_count_1;

//      // mbmark-regex-detect1.R: UTF16 0.07171792 s; UText 0.10531605 s
//      UText* str_text = NULL;
//      UErrorCode status = U_ZERO_ERROR;
//      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
//      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
//      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
//      matcher->reset(str_text);
//      ret_tab[i] = (int)matcher->find(status); // returns UBool
//      utext_close(str_text);
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
