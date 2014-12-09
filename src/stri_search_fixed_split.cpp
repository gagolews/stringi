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
#include "stri_container_integer.h"
#include "stri_container_logical.h"
#include <deque>
#include <utility>
using namespace std;


/**
 * Split a string into parts [byte compare]
 *
 * The pattern matches identify delimiters that separate the input into fields.
 * The input data between the matches becomes the fields themselves.
 *
 * @param str character vector
 * @param pattern character vector
 * @param n integer vector
 * @param omit_empty logical vector
 * @param tokens_only single logical value
 * @param simplify single logical value
 *
 * @return list of character vectors  or character matrix
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-25)
 *          StriException friendly, use StriContainerUTF8
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-07-10)
 *          BUGFIX: wrong behavior on empty str
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
 *          stri_split_fixed now uses byte search only
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-19)
 *          added tokens_only param
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-23)
 *          added split param
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-24)
 *          allow omit_empty=NA
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-04)
 *    allow `simplify=NA`; FR #126: pass n to stri_list2matrix
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    FR #110, #23: opts_fixed arg added
 */
SEXP stri_split_fixed(SEXP str, SEXP pattern, SEXP n,
                      SEXP omit_empty, SEXP tokens_only, SEXP simplify, SEXP opts_fixed)
{
   uint32_t pattern_flags = StriContainerByteSearch::getByteSearchFlags(opts_fixed);
   bool tokens_only1 = stri__prepare_arg_logical_1_notNA(tokens_only, "tokens_only");
   PROTECT(simplify = stri_prepare_arg_logical_1(simplify, "simplify"));
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   PROTECT(n = stri_prepare_arg_integer(n, "n"));
   PROTECT(omit_empty = stri_prepare_arg_logical(omit_empty, "omit_empty"));

   STRI__ERROR_HANDLER_BEGIN(5)
   R_len_t vectorize_length = stri__recycling_rule(true, 4,
      LENGTH(str), LENGTH(pattern), LENGTH(n), LENGTH(omit_empty));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length, pattern_flags);
   StriContainerInteger n_cont(n, vectorize_length);
   StriContainerLogical omit_empty_cont(omit_empty, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (n_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }
      int  n_cur        = n_cont.get(i);
      int  omit_empty_cur   = !omit_empty_cont.isNA(i) && omit_empty_cont.get(i);

      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));,
         SET_VECTOR_ELT(ret, i,
            (omit_empty_cont.isNA(i))?stri__vector_NA_strings(1):
            stri__vector_empty_strings((omit_empty_cur || n_cur == 0)?0:1));)

      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();

      if (n_cur >= INT_MAX-1)
         throw StriException(MSG__EXPECTED_SMALLER, "n");
      else if (n_cur < 0)
         n_cur = INT_MAX;
      else if (n_cur == 0) {
         SET_VECTOR_ELT(ret, i, Rf_allocVector(STRSXP, 0));
         continue;
      }
      else if (tokens_only1)
         n_cur++; // we need to do one split ahead here

      pattern_cont.setupMatcherFwd(i, str_cur_s, str_cur_n);
      R_len_t k;
      deque< pair<R_len_t, R_len_t> > fields; // byte based-indices
      fields.push_back(pair<R_len_t, R_len_t>(0,0));

      for (k=1; k < n_cur && USEARCH_DONE != pattern_cont.findNext(); ) {
         R_len_t s1 = (R_len_t)pattern_cont.getMatchedStart();
         R_len_t s2 = (R_len_t)pattern_cont.getMatchedLength() + s1;

         if (omit_empty_cur && fields.back().first == s1)
            fields.back().first = s2; // don't start any new field
         else {
            fields.back().second = s1;
            fields.push_back(pair<R_len_t, R_len_t>(s2, s2)); // start a new field here
            ++k; // another field
         }
      }
      fields.back().second = str_cur_n;
      if (omit_empty_cur && fields.back().first == fields.back().second)
         fields.pop_back();

      if (tokens_only1 && n_cur < INT_MAX) {
         n_cur--; // one split ahead could have been made, see above
         while (fields.size() > (size_t)n_cur)
            fields.pop_back(); // get rid of the remainder
      }

      SEXP ans;
      STRI__PROTECT(ans = Rf_allocVector(STRSXP, fields.size()));

      deque< pair<R_len_t, R_len_t> >::iterator iter = fields.begin();
      for (k = 0; iter != fields.end(); ++iter, ++k) {
         pair<R_len_t, R_len_t> curoccur = *iter;
         if (curoccur.second == curoccur.first && omit_empty_cont.isNA(i))
            SET_STRING_ELT(ans, k, NA_STRING);
         else
            SET_STRING_ELT(ans, k,
               Rf_mkCharLenCE(str_cur_s+curoccur.first,
                  curoccur.second-curoccur.first, CE_UTF8));
      }

      SET_VECTOR_ELT(ret, i, ans);
      STRI__UNPROTECT(1);
   }

   if (LOGICAL(simplify)[0] == NA_LOGICAL || LOGICAL(simplify)[0]) {
      R_len_t n_min = 0;
      R_len_t n_length = LENGTH(n);
      int* n_tab = INTEGER(n);
      for (R_len_t i=0; i<n_length; ++i) {
         if (n_tab[i] != NA_INTEGER && n_min < n_tab[i])
            n_min = n_tab[i];
      }
      STRI__PROTECT(ret = stri_list2matrix(ret, Rf_ScalarLogical(TRUE),
         (LOGICAL(simplify)[0] == NA_LOGICAL)?stri__vector_NA_strings(1)
                                             :stri__vector_empty_strings(1),
         Rf_ScalarInteger(n_min)))
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(; /* nothing interesting on error */)
}
