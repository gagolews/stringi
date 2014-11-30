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
#include "stri_container_utf16.h"
#include "stri_container_usearch.h"
#include "stri_container_bytesearch.h"
#include "stri_container_integer.h"
#include "stri_container_logical.h"
#include <deque>
#include <utility>
#include <unicode/brkiter.h>
#include <unicode/rbbi.h>
using namespace std;


/**
 * Split a single string into text lines
 *
 * @param str character vector
 *
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-04)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_split_lines1(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string_1(str, "str"));
   R_len_t vectorize_length = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerUTF8 str_cont(str, vectorize_length);

   if (str_cont.isNA(0)) {
      STRI__UNPROTECT_ALL
      return str;
   }

   const char* str_cur_s = str_cont.get(0).c_str();
   R_len_t str_cur_n = str_cont.get(0).length();

   UChar32 c;
   R_len_t jlast;
   deque< pair<R_len_t, R_len_t> > occurrences;
   occurrences.push_back(pair<R_len_t, R_len_t>(0, 0));
   for (R_len_t j=0; j < str_cur_n; /* null */) {
      jlast = j;
      U8_NEXT(str_cur_s, j, str_cur_n, c);

      switch (c) {
         case ASCII_CR: /* CR */
            /* check if next is LF */
            if (str_cur_s[j] == ASCII_LF) { // look ahead one byte
               j++; // just one byte
            }
            break;

         case ASCII_LF: /* LF */
            break;

         case UCHAR_NEL: /* NEL */
            break;

         case ASCII_VT: /* VT */
            break;

         case ASCII_FF: /* FF */
            break;

         case UCHAR_LS: /* LS */
            break;

         case UCHAR_PS: /* PS */
            break;

         default:
            /* not a newline character */
            occurrences.back().second = j;
            continue;
      }

      occurrences.back().second = jlast;
      if (j < str_cur_n)
         occurrences.push_back(pair<R_len_t, R_len_t>(j, j));
   }

   SEXP ans;
   STRI__PROTECT(ans = Rf_allocVector(STRSXP, (R_len_t)occurrences.size()));
   deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
   for (R_len_t k = 0; iter != occurrences.end(); ++iter, ++k) {
      pair<R_len_t, R_len_t> curoccur = *iter;
      SET_STRING_ELT(ans, k,
         Rf_mkCharLenCE(str_cur_s+curoccur.first, curoccur.second-curoccur.first, CE_UTF8));
   }
   STRI__UNPROTECT_ALL
   return ans;

   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/**
 * Split a string into text lines
 *
 * @param str character vector
 * @param omit_empty logical vector
 *
 * @return list of character vectors
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-04)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 *                removed `n_max` arg, as it doesn't make sense
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_split_lines(SEXP str, SEXP omit_empty)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
//   n_max = stri_prepare_arg_integer(n_max, "n_max");
   PROTECT(omit_empty = stri_prepare_arg_logical(omit_empty, "omit_empty"));
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), /*LENGTH(n_max), */LENGTH(omit_empty));

   STRI__ERROR_HANDLER_BEGIN(2)
   StriContainerUTF8 str_cont(str, vectorize_length);
//   StriContainerInteger   n_max_cont(n_max, vectorize_length);
   StriContainerLogical   omit_empty_cont(omit_empty, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_n = str_cont.get(i).length();
//      int  n_max_cur        = n_max_cont.get(i);
      int  omit_empty_cur   = omit_empty_cont.get(i);

//      if (n_max_cur < 0)
//         n_max_cur = INT_MAX;
//      else if (n_max_cur == 0) {
//         SET_VECTOR_ELT(ret, i, Rf_allocVector(STRSXP, 0));
//         continue;
//      }

//#define STRI_INDEX_NEWLINE_CR   0
//#define STRI_INDEX_NEWLINE_LF   1
//#define STRI_INDEX_NEWLINE_CRLF 2
//#define STRI_INDEX_NEWLINE_NEL  3
//#define STRI_INDEX_NEWLINE_VT   4
//#define STRI_INDEX_NEWLINE_FF   5
//#define STRI_INDEX_NEWLINE_LS   6
//#define STRI_INDEX_NEWLINE_PS   7
//#define STRI_INDEX_NEWLINE_LAST 8

//      int counts[STRI_INDEX_NEWLINE_LAST];
//      for (R_len_t j=0; j<STRI_INDEX_NEWLINE_LAST; ++j)
//         counts[j] = 0;

      UChar32 c;
      R_len_t jlast, k=1;
      deque< pair<R_len_t, R_len_t> > occurrences;
      occurrences.push_back(pair<R_len_t, R_len_t>(0, 0));
      for (R_len_t j=0; j < str_cur_n /*&& k < n_max_cur*/; /* null */) {
         jlast = j;
         U8_NEXT(str_cur_s, j, str_cur_n, c);

         switch (c) {
            case ASCII_CR: /* CR */
//               counts[STRI_INDEX_NEWLINE_CR]++;
               /* check if next is LF */
               if (str_cur_s[j] == ASCII_LF) { // look ahead one byte
//                  counts[STRI_INDEX_NEWLINE_LF]++;
//                  counts[STRI_INDEX_NEWLINE_CRLF]++;
                  j++; // just one byte
               }
               break;

            case ASCII_LF: /* LF */
//               counts[STRI_INDEX_NEWLINE_LF]++;
               break;

            case UCHAR_NEL: /* NEL */
//               counts[STRI_INDEX_NEWLINE_NEL]++;
               break;

            case ASCII_VT: /* VT */
//               counts[STRI_INDEX_NEWLINE_VT]++;
               break;

            case ASCII_FF: /* FF */
//               counts[STRI_INDEX_NEWLINE_FF]++;
               break;

            case UCHAR_LS: /* LS */
//               counts[STRI_INDEX_NEWLINE_LS]++;
               break;

            case UCHAR_PS: /* PS */
//               counts[STRI_INDEX_NEWLINE_PS]++;
               break;

            default:
               /* not a newline character */
               occurrences.back().second = j;
               continue;
         }

         // if here, then at newline
         if (omit_empty_cur && occurrences.back().second == occurrences.back().first)
            occurrences.back().first = occurrences.back().second = j; // don't start any new field
         else {
            occurrences.back().second = jlast;
            occurrences.push_back(pair<R_len_t, R_len_t>(j, j));
            ++k; // another field
         }
      }

//      if (k == n_max_cur)
//         occurrences.back().second = str_cur_n;
      if (omit_empty_cur && occurrences.back().first == occurrences.back().second)
         occurrences.pop_back();

      SEXP ans;
      STRI__PROTECT(ans = Rf_allocVector(STRSXP, (R_len_t)occurrences.size()));

      deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
      for (R_len_t l = 0; iter != occurrences.end(); ++iter, ++l) {
         pair<R_len_t, R_len_t> curoccur = *iter;
         SET_STRING_ELT(ans, l,
            Rf_mkCharLenCE(str_cur_s+curoccur.first, curoccur.second-curoccur.first, CE_UTF8));
      }

      SET_VECTOR_ELT(ret, i, ans);
      STRI__UNPROTECT(1);
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
