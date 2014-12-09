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
#include "stri_container_bytesearch.h"
#include <deque>
#include <utility>
using namespace std;


/**
 * Locate first or last occurrences of a pattern in a string
 *
 * @param str character vector
 * @param pattern character vector
 * @param first looking for first or last match?
 * @return integer matrix (2 columns)
 *
 * @version 0.1-?? (Bartlomiej Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-23)
 *          StriException friendly, use StriContainerByteSearch
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          Use StriContainerUTF8_indexable
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_locate_fixed now uses byte search only
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri__locate_firstlast_fixed(SEXP str, SEXP pattern, SEXP opts_fixed, bool first)
{
   uint32_t pattern_flags = StriContainerByteSearch::getByteSearchFlags(opts_fixed);
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));

   STRI__ERROR_HANDLER_BEGIN(2)
   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8_indexable str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocMatrix(INTSXP, vectorize_length, 2));
   stri__locate_set_dimnames_matrix(ret);
   int* ret_tab = INTEGER(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
      i != pattern_cont.vectorize_end();
      i = pattern_cont.vectorize_next(i))
   {
      ret_tab[i]                  = NA_INTEGER;
      ret_tab[i+vectorize_length] = NA_INTEGER;
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         ;/*nothing*/, ;/*nothing*/)

      int start;
      if (first) {
         pattern_cont.setupMatcherFwd(i, str_cont.get(i).c_str(), str_cont.get(i).length());
         start = pattern_cont.findFirst();
      } else {
         pattern_cont.setupMatcherBack(i, str_cont.get(i).c_str(), str_cont.get(i).length());
         start = pattern_cont.findLast();
      }

      if (start != USEARCH_DONE) {
         ret_tab[i]                  = start;
         ret_tab[i+vectorize_length] = start+pattern_cont.getMatchedLength();

         // Adjust UTF8 byte index -> UChar32 index
         str_cont.UTF8_to_UChar32_index(i,
               ret_tab+i, ret_tab+i+vectorize_length, 1,
               1, // 0-based index -> 1-based
               0  // end returns position of next character after match
         );
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}


/**
 * Locate first occurrences of pattern in a string [fixed pattern]
 *
 * @param str character vector
 * @param pattern character vector
 * @return integer matrix (2 columns)
 *
 * @version 0.1-?? (Bartlomiej Tartanus)
 *
 * @version 0.1-?? (Bartlomiej Tartanus, 2013-06-09)
 *          StriContainerUTF16 & collator
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-23)
 *          use stri_locate_firstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_locate_fixed now uses byte search only
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri_locate_first_fixed(SEXP str, SEXP pattern, SEXP opts_fixed)
{
   return stri__locate_firstlast_fixed(str, pattern, opts_fixed, true);
}


/**
 * Locate last occurrences of pattern in a string [fixed pattern]
 *
 * @param str character vector
 * @param pattern character vector
 * @return integer matrix (2 columns)
 *
 * @version 0.1-?? (Bartlomiej Tartanus)
 *
 * @version 0.1-?? (Bartlomiej Tartanus, 2013-06-09)
 *          StriContainerUTF16 & collator
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-23)
 *          use stri_locate_firstlast_fixed
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_locate_fixed now uses byte search only
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri_locate_last_fixed(SEXP str, SEXP pattern, SEXP opts_fixed)
{
   return stri__locate_firstlast_fixed(str, pattern, opts_fixed, false);
}


/** Locate all occurrences of fixed-byte pattern
 *
 * @param str character vector
 * @param pattern character vector
 * @return list of integer matrices (2 columns)
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-23)
 *          StriException friendly, use StriContainerByteSearch
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          Use StriContainerUTF8_indexable
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_locate_fixed now uses byte search only
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *    FR #117: omit_no_match arg added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri_locate_all_fixed(SEXP str, SEXP pattern, SEXP omit_no_match, SEXP opts_fixed)
{
   uint32_t pattern_flags = StriContainerByteSearch::getByteSearchFlags(opts_fixed, /*allow_overlap*/true);
   bool omit_no_match1 = stri__prepare_arg_logical_1_notNA(omit_no_match, "omit_no_match");
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));

   STRI__ERROR_HANDLER_BEGIN(2)
   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8_indexable str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
      i != pattern_cont.vectorize_end();
      i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));,
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(omit_no_match1?0:1, 2));)

      pattern_cont.setupMatcherFwd(i, str_cont.get(i).c_str(), str_cont.get(i).length());

      int start = pattern_cont.findFirst();
      if (start == USEARCH_DONE) { // no matches at all
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(omit_no_match1?0:1, 2));
         continue;
      }

      deque< pair<R_len_t, R_len_t> > occurrences;
      while (start != USEARCH_DONE) {
         occurrences.push_back(pair<R_len_t, R_len_t>(start, start+pattern_cont.getMatchedLength()));
         start = pattern_cont.findNext();
      }

      R_len_t noccurrences = (R_len_t)occurrences.size();
      SEXP ans;
      STRI__PROTECT(ans = Rf_allocMatrix(INTSXP, noccurrences, 2));
      int* ans_tab = INTEGER(ans);
      deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
      for (R_len_t j = 0; iter != occurrences.end(); ++iter, ++j) {
         pair<R_len_t, R_len_t> match = *iter;
         ans_tab[j]              = match.first;
         ans_tab[j+noccurrences] = match.second;
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
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}
