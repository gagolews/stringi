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


/**
 * Detect if a pattern occurs in a string
 *
 * @param str R character vector
 * @param pattern R character vector containing regular expressions
 * @param opts_regex list
 *
 * @version 0.1 (Marcin Bujarski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF16
 * @version 0.3 (Marek Gagolewski) - use StriContainerUTF16's vectorization
 * @version 0.4 (Marek Gagolewski, 2013-06-18) use StriContainerRegexPattern + opts_regex
 */
SEXP stri_detect_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   // this will work for vectorize_length == 0:

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   STRI__ERROR_HANDLER_BEGIN

   StriContainerUTF16 str_cont(str, vectorize_length);
   // MG: tried StriContainerUTF8 + utext_openUTF8 - this was slower
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont, ret_tab[i] = NA_LOGICAL, ret_tab[i] = FALSE)

      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      matcher->reset(str_cont.get(i));
      ret_tab[i] = (int)matcher->find();
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


// Another version (MG)
// No conversion to UTF-16, using UText
// This is slower than the StriContainerUTF16 + C++ API for regex
// Well... we've tried. :)
//
//SEXP stri_detect_regex(SEXP str, SEXP pattern)
//{
//   str = stri_prepare_arg_string(str, "str");
//   pattern = stri_prepare_arg_string(pattern, "pattern");
//   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
//   // this will work for nmax == 0:
//
//   SEXP ret;
//   PROTECT(ret = allocVector(LGLSXP, nmax));
//
//   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
//   StriContainerUTF8* pp = new StriContainerUTF8(pattern, nmax);
//
//   UText *uts = NULL;
//   UText *utp = NULL;
//   const String8* last_s = NULL;
//   const String8* last_p = NULL;
//   URegularExpression* matcher = NULL;
//   UErrorCode err = U_ZERO_ERROR;
//
//   for (R_len_t i = pp->vectorize_init();
//         i != pp->vectorize_end();
//         i = pp->vectorize_next(i))
//   {
//      if (pp->isNA(i) || ss->isNA(i)) {
//         LOGICAL(ret)[i] = NA_LOGICAL;
//      }
//      else {
//         const String8* cur_s = &(ss->get(i));
//         const String8* cur_p = &(pp->get(i));
//
//         if (last_p != cur_p) {
//            last_p = cur_p;
//            if (matcher) uregex_close(matcher);
//            utp = utext_openUTF8(utp, last_p->c_str(), last_p->length(), &err);
//            matcher = uregex_openUText(utp, 0, NULL, &err);
//            if (U_FAILURE(err))
//               error(MSG__REGEXP_FAILED);
//         }
//
//         if (last_s != cur_s) {
//            last_s = cur_s;
//            uts = utext_openUTF8(uts, last_s->c_str(), last_s->length(), &err);
//         }
//
//         uregex_setUText(matcher, uts, &err);
//         uregex_reset(matcher, 0, &err);
//         int found = (int)uregex_find(matcher, -1, &err);
//         LOGICAL(ret)[i] = found;
//         if (U_FAILURE(err))
//            error(MSG__REGEXP_FAILED);
//      }
//   }
//
//   if (matcher) uregex_close(matcher);
//   if (uts) utext_close(uts);
//   if (utp) utext_close(utp);
//   delete ss;
//   delete pp;
//   UNPROTECT(1);
//   return ret;
//}
