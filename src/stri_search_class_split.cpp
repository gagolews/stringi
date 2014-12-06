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
#include "stri_container_charclass.h"
#include "stri_container_integer.h"
#include "stri_container_logical.h"
#include <deque>
#include <utility>
using namespace std;


/**
 * Split a string by occurrences of a character class
 *
 * @param str character vector
 * @param pattern character vector
 * @param n integer vector
 * @param omit_empty logical vector
 * @param tokens_only single logical value
 * @param simplify single logical value
 *
 * @return a list of character vectors or character matrix
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-14)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-15)
 *          omit_empty, use StriContainerInteger, StriContainerLogical,
 *          and StriContainerCharClass
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-03)
 *          detects invalid UTF-8 byte stream
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-05)
 *          StriContainerCharClass now relies on UnicodeSet
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
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-04)
 *    allow `simplify=NA`; FR #126: pass n to stri_list2matrix
 */
SEXP stri_split_charclass(SEXP str, SEXP pattern, SEXP n,
                          SEXP omit_empty, SEXP tokens_only, SEXP simplify)
{
   bool tokens_only1 = stri__prepare_arg_logical_1_notNA(tokens_only, "tokens_only");
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   PROTECT(n = stri_prepare_arg_integer(n, "n"));
   PROTECT(omit_empty = stri_prepare_arg_logical(omit_empty, "omit_empty"));
   PROTECT(simplify = stri_prepare_arg_logical_1(simplify, "simplify"));
   R_len_t vectorize_length = stri__recycling_rule(true, 4,
      LENGTH(str), LENGTH(pattern), LENGTH(n), LENGTH(omit_empty));

   STRI__ERROR_HANDLER_BEGIN(5)
   StriContainerUTF8      str_cont(str, vectorize_length);
   StriContainerInteger   n_cont(n, vectorize_length);
   StriContainerLogical   omit_empty_cont(omit_empty, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || pattern_cont.isNA(i) || n_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      const UnicodeSet* pattern_cur = &pattern_cont.get(i);
      int  n_cur            = n_cont.get(i);
      int  omit_empty_cur   = !omit_empty_cont.isNA(i) && omit_empty_cont.get(i);

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

      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j, k;
      UChar32 chr;
      deque< pair<R_len_t, R_len_t> > fields; // byte based-indices
      fields.push_back(pair<R_len_t, R_len_t>(0,0));

      for (j=0, k=1; j<str_cur_n && k < n_cur; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, chr);
         if (chr < 0) // invalid utf-8 sequence
            throw StriException(MSG__INVALID_UTF8);
         if (pattern_cur->contains(chr)) {
            if (omit_empty_cur && fields.back().second == fields.back().first)
               fields.back().first = fields.back().second = j; // don't start any new field
            else {
               fields.push_back(pair<R_len_t, R_len_t>(j, j)); // start a new field here
               ++k; // another field
            }
         }
         else {
            fields.back().second = j;
         }
      }
      if (k == n_cur)
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
      STRI__UNPROTECT(1)
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
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
