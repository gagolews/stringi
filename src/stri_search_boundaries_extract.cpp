/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2017, Marek Gagolewski and other contributors.
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
 * Extract first or last text between boundaries
 *
 * @param str character vector
 * @param opts_brkiter list
 * @param first looking for first or last match?
 * @return character vector
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-19)
 */
SEXP stri__extract_firstlast_boundaries(SEXP str, SEXP opts_brkiter, bool first)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   StriBrkIterOptions opts_brkiter2(opts_brkiter, "line_break");

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);
   StriRuleBasedBreakIterator brkiter(opts_brkiter2);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, str_length));

   for (R_len_t i = 0; i < str_length; ++i)
   {
      SET_STRING_ELT(ret, i, NA_STRING);

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

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cont.get(i).c_str()+curpair.first, curpair.second-curpair.first, CE_UTF8));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}


/**
 * Extract first  text between boundaries
 *
 * @param str character vector
 * @param opts_brkiter list
 * @return character vector
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-19)
 */
SEXP stri_extract_first_boundaries(SEXP str, SEXP opts_brkiter)
{
   return stri__extract_firstlast_boundaries(str, opts_brkiter, true);
}


/**
 * Extract last  text between boundaries
 *
 * @param str character vector
 * @param opts_brkiter list
 * @return character vector
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-19)
 */
SEXP stri_extract_last_boundaries(SEXP str, SEXP opts_brkiter)
{
   return stri__extract_firstlast_boundaries(str, opts_brkiter, false);
}


/** Extract all  text between boundaries
 *
 * @param str character vector
 * @param simplify logical
 * @param omit_no_match logical
 * @param opts_brkiter named list
 * @return list or matrix
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-19)
 */
SEXP stri_extract_all_boundaries(SEXP str, SEXP simplify, SEXP omit_no_match, SEXP opts_brkiter)
{
   bool omit_no_match1 = stri__prepare_arg_logical_1_notNA(omit_no_match, "omit_no_match");
   PROTECT(simplify = stri_prepare_arg_logical_1(simplify, "simplify"));
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   StriBrkIterOptions opts_brkiter2(opts_brkiter, "line_break");

   STRI__ERROR_HANDLER_BEGIN(2)
      R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);
   StriRuleBasedBreakIterator brkiter(opts_brkiter2);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, str_length));

   for (R_len_t i = 0; i < str_length; ++i)
   {
      if (str_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
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

   if (LOGICAL(simplify)[0] == NA_LOGICAL || LOGICAL(simplify)[0]) {
      SEXP robj_TRUE, robj_zero, robj_na_strings, robj_empty_strings;
      STRI__PROTECT(robj_TRUE = Rf_ScalarLogical(TRUE));
      STRI__PROTECT(robj_zero = Rf_ScalarInteger(0));
      STRI__PROTECT(robj_na_strings = stri__vector_NA_strings(1));
      STRI__PROTECT(robj_empty_strings = stri__vector_empty_strings(1));
      STRI__PROTECT(ret = stri_list2matrix(ret, robj_TRUE,
                                           (LOGICAL(simplify)[0] == NA_LOGICAL)?robj_na_strings
                                              :robj_empty_strings,
                                               robj_zero));
   }

   STRI__UNPROTECT_ALL
      return ret;
   STRI__ERROR_HANDLER_END({/* no-op */})
}
