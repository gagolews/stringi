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
#include "stri_container_bytesearch.h"


/**
 * Detect if a pattern occurs in a string [fast but dummy bitewise compare]
 *
 * @param str character vector
 * @param pattern character vector
 * @return logical vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *    use StriContainerUTF8, BUGFIX: the loop could go to far
 *
 * @version 0.1-?? (Marek Gagolewski)
 *    corrected behavior on empty str/pattern
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-23)
 *    make StriException-friendly, use StriContainerByteSearch
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_detect_fixed now uses byte search only
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri_detect_fixed(SEXP str, SEXP pattern, SEXP opts_fixed)
{
   uint32_t pattern_flags = StriContainerByteSearch::getByteSearchFlags(opts_fixed);
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));

   STRI__ERROR_HANDLER_BEGIN(2)
   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length, pattern_flags);

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

      pattern_cont.setupMatcherFwd(i, str_cont.get(i).c_str(), str_cont.get(i).length());
      ret_tab[i] = (int)(pattern_cont.findFirst() != USEARCH_DONE);
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )


//   Version 2 -- slower for long strings
//   UText *uts = NULL;
//   UText *utp = NULL;
//   URegularExpression* matcher = NULL;
//
//   STRI__ERROR_HANDLER_BEGIN
//   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
//   StriContainerUTF8 str_cont(str, vectorize_length);
//   StriContainerByteSearch pattern_cont(pattern, vectorize_length);
//
//   SEXP ret;
//   PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
//   int* ret_tab = LOGICAL(ret);
//
//
//   const String8* last_s = NULL;
//   const String8* last_p = NULL;
//   UErrorCode err = U_ZERO_ERROR;
//
//   for (R_len_t i = pattern_cont.vectorize_init();
//         i != pattern_cont.vectorize_end();
//         i = pattern_cont.vectorize_next(i))
//   {
//      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
//         ret_tab[i] = NA_LOGICAL,
//         ret_tab[i] = FALSE)
//
//      const String8* cur_s = &(str_cont.get(i));
//      const String8* cur_p = &(pattern_cont.get(i));
//
//      if (last_p != cur_p) {
//         last_p = cur_p;
//         if (matcher) uregex_close(matcher);
//         utp = utext_openUTF8(utp, last_p->c_str(), last_p->length(), &err);
//         matcher = uregex_openUText(utp, UREGEX_LITERAL, NULL, &err);
//         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
//      }
//
//      if (last_s != cur_s) {
//         last_s = cur_s;
//         uts = utext_openUTF8(uts, last_s->c_str(), last_s->length(), &err);
//      }
//
//      uregex_setUText(matcher, uts, &err);
//      uregex_reset(matcher, 0, &err);
//      int found = (int)uregex_find(matcher, -1, &err);
//      if (U_FAILURE(err))
//         throw StriException(MSG__REGEXP_FAILED);
//      LOGICAL(ret)[i] = found;
//   }
//
//   if (matcher) { uregex_close(matcher); matcher=NULL; }
//   if (uts) { utext_close(uts); uts=NULL; }
//   if (utp) { utext_close(utp); utp=NULL; }
//   UNPROTECT(1);
//   return ret;
//   STRI__ERROR_HANDLER_END({
//      if (matcher) { uregex_close(matcher); matcher=NULL; }
//      if (uts) { utext_close(uts); uts=NULL; }
//      if (utp) { utext_close(utp); utp=NULL; }
//   })
}
