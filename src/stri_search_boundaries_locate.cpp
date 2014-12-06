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


/**
 * Locate first or last boundaries
 *
 * @param str character vector
 * @param opts_brkiter list
 * @param first looking for first or last match?
 * @return integer matrix (2 columns)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-05)
 */
SEXP stri__locate_firstlast_boundaries(SEXP str, SEXP opts_brkiter, bool first)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   StriBrkIterOptions opts_brkiter2(opts_brkiter, "line_break");

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);
   StriRuleBasedBreakIterator brkiter(opts_brkiter2);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocMatrix(INTSXP, str_length, 2));
   stri__locate_set_dimnames_matrix(ret);
   int* ret_tab = INTEGER(ret);

   for (R_len_t i = 0; i < str_length; ++i)
   {
      ret_tab[i]            = NA_INTEGER;
      ret_tab[i+str_length] = NA_INTEGER;

      if (str_cont.isNA(i) || str_cont.get(i).length() == 0) continue;

      brkiter.setupMatcher(str_cont.get(i).c_str(), str_cont.get(i).length());
      pair<R_len_t,R_len_t> curpair;

      if (first) {
         brkiter.first();
         if (!brkiter.next(curpair)) continue;
      }
      else {
         brkiter.last();
         if (!brkiter.previous(curpair)) continue;
      }

      ret_tab[i]            = curpair.first;
      ret_tab[i+str_length] = curpair.second;

      // Adjust UTF8 byte index -> UChar32 index
      str_cont.UTF8_to_UChar32_index(i,
            ret_tab+i, ret_tab+i+str_length, 1,
            1, // 0-based index -> 1-based
            0  // end returns position of next character after match
      );
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}


/**
 * Locate first boundary
 *
 * @param str character vector
 * @param opts_brkiter list
 * @return integer matrix (2 columns)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-05)
 */
SEXP stri_locate_first_boundaries(SEXP str, SEXP opts_brkiter)
{
   return stri__locate_firstlast_boundaries(str, opts_brkiter, true);
}


/**
 * Locate last boundary
 *
 * @param str character vector
 * @param opts_brkiter list
 * @return integer matrix (2 columns)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-05)
 */
SEXP stri_locate_last_boundaries(SEXP str, SEXP opts_brkiter)
{
   return stri__locate_firstlast_boundaries(str, opts_brkiter, false);
}


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
SEXP stri_locate_all_boundaries(SEXP str, SEXP omit_no_match, SEXP opts_brkiter)
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
