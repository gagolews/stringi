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
#include "stri_container_regex.h"
#include <deque>
#include <utility>
using namespace std;


/**
 * Extract first occurrence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @param first logical - search for the first or the last occurrence?
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-20)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri__extract_firstlast_regex(SEXP str, SEXP pattern, SEXP opts_regex, bool first)
{
   PROTECT(str = stri_prepare_arg_string(str, "str")); // prepare string argument
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern")); // prepare string argument
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
   STRI__ERROR_HANDLER_BEGIN(2)
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);, SET_STRING_ELT(ret, i, NA_STRING);)

      UErrorCode status = U_ZERO_ERROR;
      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      int m_start = -1;
      int m_end = -1;
      matcher->reset(str_text);
      if ((int)matcher->find()) { // find first match
         m_start = (int)matcher->start(status); // The **native** position in the input string :-)
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         m_end   = (int)matcher->end(status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }
      else {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      if (!first) { // continue searching
         while ((int)matcher->find()) {
            m_start = (int)matcher->start(status);
            m_end   = (int)matcher->end(status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         }
      }

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cont.get(i).c_str()+m_start, m_end-m_start, CE_UTF8));
   }

   if (str_text) {
      utext_close(str_text);
      str_text = NULL;
   }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(if (str_text) utext_close(str_text);)
}


/**
 * Extract first occurrence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-20)
 */
SEXP stri_extract_first_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   return stri__extract_firstlast_regex(str, pattern, opts_regex, true);
}


/**
 * Extract last occurrence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-20)
 */
SEXP stri_extract_last_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   return stri__extract_firstlast_regex(str, pattern, opts_regex, false);
}


/**
 * Extract all occurrences of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @param simplify single logical value
 *
 * @return list of character vectors  or character matrix
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-20)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-24)
 *          added simplify param
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *    FR #117: omit_no_match arg added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-04)
 *    allow `simplify=NA`
 */
SEXP stri_extract_all_regex(SEXP str, SEXP pattern, SEXP simplify, SEXP omit_no_match, SEXP opts_regex)
{
   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);
   bool omit_no_match1 = stri__prepare_arg_logical_1_notNA(omit_no_match, "omit_no_match");
   PROTECT(simplify = stri_prepare_arg_logical_1(simplify, "simplify"));
   PROTECT(str = stri_prepare_arg_string(str, "str")); // prepare string argument
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern")); // prepare string argument
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(omit_no_match1?0:1));)

      UErrorCode status = U_ZERO_ERROR;
      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      matcher->reset(str_text);

      deque< pair<R_len_t, R_len_t> > occurrences;
      while ((int)matcher->find()) {
         occurrences.push_back(pair<R_len_t, R_len_t>(
            (R_len_t)matcher->start(status), (R_len_t)matcher->end(status)
         ));
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }

      R_len_t noccurrences = (R_len_t)occurrences.size();
      if (noccurrences <= 0) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(omit_no_match1?0:1));
         continue;
      }

      const char* str_cur_s = str_cont.get(i).c_str();
      SEXP cur_res;
      STRI__PROTECT(cur_res = Rf_allocVector(STRSXP, noccurrences));
      deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
      for (R_len_t j = 0; iter != occurrences.end(); ++iter, ++j) {
         pair<R_len_t, R_len_t> curo = *iter;
         SET_STRING_ELT(cur_res, j,
            Rf_mkCharLenCE(str_cur_s+curo.first, curo.second-curo.first, CE_UTF8));
      }
      SET_VECTOR_ELT(ret, i, cur_res);
      STRI__UNPROTECT(1);
   }

   if (str_text) {
      utext_close(str_text);
      str_text = NULL;
   }

   if (LOGICAL(simplify)[0] == NA_LOGICAL) {
      STRI__PROTECT(ret = stri_list2matrix(ret, Rf_ScalarLogical(TRUE),
         stri__vector_NA_strings(1), Rf_ScalarInteger(0)))
   }
   else if (LOGICAL(simplify)[0]) {
      STRI__PROTECT(ret = stri_list2matrix(ret, Rf_ScalarLogical(TRUE),
         stri__vector_empty_strings(1), Rf_ScalarInteger(0)))
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(if (str_text) utext_close(str_text);)
}
