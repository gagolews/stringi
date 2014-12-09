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
#include <deque>
#include <utility>
using namespace std;


/**
 * Extract first or last occurrences of pattern in a string [exact byte search]
 *
 * @param str character vector
 * @param pattern character vector
 * @param first looking for first or last match?
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-24)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_extract_fixed now uses byte search only
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *          new args: opts_fixed
 */
SEXP stri__extract_firstlast_fixed(SEXP str, SEXP pattern, SEXP opts_fixed, bool first)
{
   uint32_t pattern_flags = StriContainerByteSearch::getByteSearchFlags(opts_fixed);
   PROTECT(str = stri_prepare_arg_string(str, "str")); // prepare string argument
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern")); // prepare string argument

   STRI__ERROR_HANDLER_BEGIN(2)
   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);, SET_STRING_ELT(ret, i, NA_STRING);)

      int start, len;
      if (first) {
         pattern_cont.setupMatcherFwd(i, str_cont.get(i).c_str(), str_cont.get(i).length());
         start = pattern_cont.findFirst();
      } else {
         pattern_cont.setupMatcherBack(i, str_cont.get(i).c_str(), str_cont.get(i).length());
         start = pattern_cont.findLast();
      }
      if (start == USEARCH_DONE) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      len = pattern_cont.getMatchedLength();

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cont.get(i).c_str()+start, len, CE_UTF8));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({ /* no-op */ })
}


/**
 * Extract first occurrence of a fixed pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-24)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_extract_fixed now uses byte search only
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *          new args: opts_fixed
 */
SEXP stri_extract_first_fixed(SEXP str, SEXP pattern, SEXP opts_fixed)
{
   return stri__extract_firstlast_fixed(str, pattern, opts_fixed, true);
}


/**
 * Extract last occurrence of a fixed pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-24)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_extract_fixed now uses byte search only
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *          new args: opts_fixed
 */
SEXP stri_extract_last_fixed(SEXP str, SEXP pattern, SEXP opts_fixed)
{
   return stri__extract_firstlast_fixed(str, pattern, opts_fixed, false);
}


/**
 * Extract all occurrences of pattern in a string [exact byte search]
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-24)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_extract_fixed now uses byte search only
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *          new args: opts_fixed, omit_no_match, simplify
 */
SEXP stri_extract_all_fixed(SEXP str, SEXP pattern, SEXP simplify, SEXP omit_no_match, SEXP opts_fixed)
{
   uint32_t pattern_flags = StriContainerByteSearch::getByteSearchFlags(opts_fixed, /*allow_overlap*/true);
   bool omit_no_match1 = stri__prepare_arg_logical_1_notNA(omit_no_match, "omit_no_match");
   PROTECT(simplify = stri_prepare_arg_logical_1(simplify, "simplify"));
   PROTECT(str = stri_prepare_arg_string(str, "str")); // prepare string argument
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern")); // prepare string argument

   STRI__ERROR_HANDLER_BEGIN(3)
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(omit_no_match1?0:1));)

      pattern_cont.setupMatcherFwd(i, str_cont.get(i).c_str(), str_cont.get(i).length());

      int start = pattern_cont.findFirst();
      deque< pair<R_len_t, R_len_t> > occurrences;
      while (start != USEARCH_DONE) {
         occurrences.push_back(pair<R_len_t, R_len_t>(start, start+pattern_cont.getMatchedLength()));
         start = pattern_cont.findNext();
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
   STRI__ERROR_HANDLER_END({/* no-op */})
}
