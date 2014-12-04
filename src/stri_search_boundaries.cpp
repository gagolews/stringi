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
#include "stri_brkiter.h"


/** Locate all BreakIterator boundaries
 *
 * @param str character vector
 * @param omit_no_match logical
 * @param opts_brkiter named list
 * @return list
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-22)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-23)
 *          removed "title": For Unicode 4.0 and above title boundary
 *          iteration, please use Word Boundary iterator.
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-25)
 *          use stri__split_or_locate_boundaries
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *          use opts_brkiter
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-28)
 *          new args: omit_no_match
 * 
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 *          use StriRuleBasedBreakIterator
 */
SEXP stri_locate_boundaries(SEXP str, SEXP omit_no_match, SEXP opts_brkiter)
{
   bool omit_no_match1 = stri__prepare_arg_logical_1_notNA(omit_no_match, "omit_no_match");
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   StriBrkIterOptions opts_brkiter2(opts_brkiter, "line_break");

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);
   StriRuleBasedBreakIterator brkiter(opts_brkiter2);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, str_length));

   for (R_len_t i = 0; i < str_length; ++i)
   {
      if (str_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));
         continue;
      }

      brkiter.setupMatcher(str_cont.get(i).c_str(), str_cont.get(i).length());
      brkiter.first();
      
      deque< pair<R_len_t,R_len_t> > occurrences;
      pair<R_len_t,R_len_t> curpair;
      while (brkiter.next(curpair))
         occurrences.push_back(curpair);

      R_len_t noccurrences = (R_len_t)occurrences.size();
      if (noccurrences <= 0) {
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(omit_no_match1?0:1, 2));
         continue;
      }

      SEXP ans;
      STRI__PROTECT(ans = Rf_allocMatrix(INTSXP, noccurrences, 2));
      int* ans_tab = INTEGER(ans);
      deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
      for (R_len_t j = 0; iter != occurrences.end(); ++iter, ++j) {
         pair<R_len_t, R_len_t> cur_match = *iter;
         ans_tab[j]             = cur_match.first;
         ans_tab[j+noccurrences] = cur_match.second;
      }

      // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
      str_cont.UTF8_to_UChar32_index(i, ans_tab,
            ans_tab+noccurrences, noccurrences,
            1, // 0-based index -> 1-based
            0  // end returns position of next character after match
      );
      SET_VECTOR_ELT(ret, i, ans);
      STRI__UNPROTECT(1);
   }

   stri__locate_set_dimnames_list(ret);
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({ /* nothing special t.b.d. on error */ })
}


/** Split a string at BreakIterator boundaries
 *
 * @param str character vector
 * @param n integer
 * @param tokens_only logical
 * @param simplify logical
 * @param opts_brkiter named list
 * @return list
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-21)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-23)
 *          removed "title": For Unicode 4.0 and above title boundary
 *          iteration, please use Word Boundary iterator.
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-25)
 *          use stri__split_or_locate_boundaries
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-29)
 *          use opts_brkiter
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-28)
 *          new args: n, tokens_only, simplify
 * 
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 *          use StriRuleBasedBreakIterator
 * 
 * @version 0.4-1 (Marek Gagolewski, 2014-12-04)
 *    allow `simplify=NA`
 */
SEXP stri_split_boundaries(SEXP str, SEXP n, SEXP tokens_only, SEXP simplify, SEXP opts_brkiter)
{
   bool tokens_only1 = stri__prepare_arg_logical_1_notNA(tokens_only, "tokens_only");
   PROTECT(simplify = stri_prepare_arg_logical_1(simplify, "simplify"));
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(n = stri_prepare_arg_integer(n, "n"));
   StriBrkIterOptions opts_brkiter2(opts_brkiter, "line_break");

   STRI__ERROR_HANDLER_BEGIN(3)
   R_len_t vectorize_length = stri__recycling_rule(true, 2,
      LENGTH(str), LENGTH(n));
   StriContainerUTF8_indexable str_cont(str, vectorize_length);
   StriContainerInteger n_cont(n, vectorize_length);
   StriRuleBasedBreakIterator brkiter(opts_brkiter2);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = 0; i < vectorize_length; ++i)
   {
      if (n_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }
      int  n_cur = n_cont.get(i);

      if (str_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      if (n_cur >= INT_MAX-1)
         throw StriException(MSG__EXPECTED_SMALLER, "n");
      else if (n_cur < 0)
         n_cur = INT_MAX;
      else if (n_cur == 0) {
         SET_VECTOR_ELT(ret, i, Rf_allocVector(STRSXP, 0));
         continue;
      }

      R_len_t str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      deque< pair<R_len_t,R_len_t> > occurrences;
      brkiter.setupMatcher(str_cur_s, str_cur_n);
      brkiter.first();
      
      pair<R_len_t,R_len_t> curpair;
      R_len_t k = 0;
      while (k < n_cur && brkiter.next(curpair)) {
         occurrences.push_back(curpair);
         ++k; // another field
      }
      

      R_len_t noccurrences = (R_len_t)occurrences.size();
      if (noccurrences <= 0) {
         SET_VECTOR_ELT(ret, i, stri__vector_empty_strings(0)); // @TODO: Should it be a NA? Hard to say...
         continue;
      }
      if (k == n_cur && !tokens_only1)
         occurrences.back().second = str_cur_n;

      SEXP ans;
      STRI__PROTECT(ans = Rf_allocVector(STRSXP, noccurrences));
      deque< pair<R_len_t,R_len_t> >::iterator iter = occurrences.begin();
      for (R_len_t j = 0; iter != occurrences.end(); ++iter, ++j) {
         SET_STRING_ELT(ans, j, Rf_mkCharLenCE(str_cur_s+(*iter).first,
            (*iter).second-(*iter).first, CE_UTF8));
      }
      SET_VECTOR_ELT(ret, i, ans);
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
   STRI__ERROR_HANDLER_END({ /* no action */ })
}


/** Count the number of BreakIterator boundaries
 *
 * @param str character vector
 * @param opts_brkiter identifier
 * @return character vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 * 
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 *          use StriRuleBasedBreakIterator
 */
SEXP stri_count_boundaries(SEXP str, SEXP opts_brkiter)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   StriBrkIterOptions opts_brkiter2(opts_brkiter, "line_break");

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_length));
   StriRuleBasedBreakIterator brkiter(opts_brkiter2);

   for (R_len_t i = 0; i < str_length; ++i)
   {
      if (str_cont.isNA(i)) {
         INTEGER(ret)[i] = NA_INTEGER;
         continue;
      }

      brkiter.setupMatcher(str_cont.get(i).c_str(), str_cont.get(i).length());
      brkiter.first();
      
      R_len_t cur_count = 0;
      while (brkiter.next())
         ++cur_count;

      INTEGER(ret)[i] = cur_count;
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({ /* no action */  })
}
