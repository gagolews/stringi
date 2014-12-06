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
#include "stri_container_logical.h"
#include <deque>
#include <utility>
using namespace std;


/**
 * Extract first or last occurrences of a character class in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-08)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-15)
 *          Use StrContainerCharClass
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
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri__extract_firstlast_charclass(SEXP str, SEXP pattern, bool first)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   STRI__ERROR_HANDLER_BEGIN(2)
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      SET_STRING_ELT(ret, i, NA_STRING);

      if (str_cont.isNA(i) || pattern_cont.isNA(i))
         continue;

      const UnicodeSet* pattern_cur = &pattern_cont.get(i);
      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j, jlast;
      UChar32 chr;

      if (first) {
         for (jlast=j=0; j<str_cur_n; ) {
            U8_NEXT(str_cur_s, j, str_cur_n, chr);
            if (chr < 0) // invalid utf-8 sequence
               throw StriException(MSG__INVALID_UTF8);
            if (pattern_cur->contains(chr)) {
               SET_STRING_ELT(ret, i,
                  Rf_mkCharLenCE(str_cur_s+jlast, j-jlast, CE_UTF8));
               break; // that's enough for first
            }
            jlast = j;
         }
      }
      else {
         for (jlast=j=str_cur_n; j>0; ) {
            U8_PREV(str_cur_s, 0, j, chr); // go backwards
            if (chr < 0) // invalid utf-8 sequence
               throw StriException(MSG__INVALID_UTF8);
            if (pattern_cur->contains(chr)) {
               SET_STRING_ELT(ret, i,
                  Rf_mkCharLenCE(str_cur_s+j, jlast-j, CE_UTF8));
               break; // that's enough for last
            }
            jlast = j;
         }
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/**
 * Extract first occurrence of a character class in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-08)
 */
SEXP stri_extract_first_charclass(SEXP str, SEXP pattern)
{
   return stri__extract_firstlast_charclass(str, pattern, true);
}


/**
 * Extract last occurrence of a character class in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-08)
 */
SEXP stri_extract_last_charclass(SEXP str, SEXP pattern)
{
   return stri__extract_firstlast_charclass(str, pattern, false);
}


/**
 * Extract all occurrences of a character class in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param simplify single logical value
 *
 * @return list of character vectors  or character matrix
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-08)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-15)
 *          Use StrContainerCharClass
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
 * @version 0.3-1 (Marek Gagolewski, 2014-10-24)
 *          added simplify param
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
 *          using StriContainerCharClass::locateAll;
 *          no longer vectorized over merge
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *    FR #117: omit_no_match arg added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-04)
 *    allow `simplify=NA`
 */
SEXP stri_extract_all_charclass(SEXP str, SEXP pattern, SEXP merge, SEXP simplify, SEXP omit_no_match)
{
   bool merge_cur = stri__prepare_arg_logical_1_notNA(merge, "merge");
   bool omit_no_match1 = stri__prepare_arg_logical_1_notNA(omit_no_match, "omit_no_match");
   PROTECT(simplify = stri_prepare_arg_logical_1(simplify, "simplify"));
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern = stri_prepare_arg_string(pattern, "pattern"));
   R_len_t vectorize_length = stri__recycling_rule(true, 2,
      LENGTH(str), LENGTH(pattern));

   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (pattern_cont.isNA(i) || str_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      R_len_t str_cur_n     = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      deque< pair<R_len_t, R_len_t> > occurrences;
      StriContainerCharClass::locateAll(
         occurrences, &pattern_cont.get(i),
         str_cur_s, str_cur_n, merge_cur,
         false /* byte-based indices */
      );

      R_len_t noccurrences = (R_len_t)occurrences.size();
      if (noccurrences == 0) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(omit_no_match1?0:1));
         continue;
      }

      SEXP cur_res;
      STRI__PROTECT(cur_res = Rf_allocVector(STRSXP, noccurrences));
      deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
      for (R_len_t f = 0; iter != occurrences.end(); ++iter, ++f) {
         pair<R_len_t, R_len_t> curo = *iter;
         SET_STRING_ELT(cur_res, f,
            Rf_mkCharLenCE(str_cur_s+curo.first, curo.second-curo.first, CE_UTF8));
      }
      SET_VECTOR_ELT(ret, i, cur_res);
      STRI__UNPROTECT(1)
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
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
