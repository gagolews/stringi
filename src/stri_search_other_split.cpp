/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * 'stringi' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'stringi' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.
 */


#include "stri_stringi.h"


/**
 * Split a single string into text lines
 *
 * @param str character vector
 *
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-08-04)
 */
SEXP stri_split_lines1(SEXP str)
{
   str = stri_prepare_arg_string_1(str, "str");
   R_len_t vectorize_length = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);

   if (str_cont.isNA(0))
      return str;

   const char* str_cur_s = str_cont.get(0).c_str();
   R_len_t str_cur_n = str_cont.get(0).length();

   UChar32 c;
   R_len_t jlast;
   deque<R_len_t_x2> occurences;
   occurences.push_back(R_len_t_x2(0, 0));
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
            occurences.back().v2 = j;
            continue;
      }

      occurences.back().v2 = jlast;
      if (j < str_cur_n)
         occurences.push_back(R_len_t_x2(j, j));
   }

   SEXP ans;
   PROTECT(ans = Rf_allocVector(STRSXP, (R_len_t)occurences.size()));
   deque<R_len_t_x2>::iterator iter = occurences.begin();
   for (R_len_t k = 0; iter != occurences.end(); ++iter, ++k) {
      R_len_t_x2 curoccur = *iter;
      SET_STRING_ELT(ans, k, Rf_mkCharLenCE(str_cur_s+curoccur.v1, curoccur.v2-curoccur.v1, CE_UTF8));
   }
   UNPROTECT(1);
   return ans;

   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}

/**
 * Split a string into text lines
 *
 * @param str character vector
 * @param n_max integer vector
 * @param omit_empty logical vector
 *
 * @return list of character vectors
 *
 * @version 0.1 (Marek Gagolewski, 2013-08-04)
 */
SEXP stri_split_lines(SEXP str, SEXP n_max, SEXP omit_empty)
{
   str = stri_prepare_arg_string(str, "str");
   n_max = stri_prepare_arg_integer(n_max, "n_max");
   omit_empty = stri_prepare_arg_logical(omit_empty, "omit_empty");
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(n_max), LENGTH(omit_empty));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerInteger   n_max_cont(n_max, vectorize_length);
   StriContainerLogical   omit_empty_cont(omit_empty, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

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
      int  n_max_cur        = n_max_cont.get(i);
      int  omit_empty_cur   = omit_empty_cont.get(i);

      if (n_max_cur < 0)
         n_max_cur = INT_MAX;
      else if (n_max_cur == 0) {
         SET_VECTOR_ELT(ret, i, Rf_allocVector(STRSXP, 0));
         continue;
      }

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
      deque<R_len_t_x2> occurences;
      occurences.push_back(R_len_t_x2(0, 0));
      for (R_len_t j=0; j < str_cur_n && k < n_max_cur; /* null */) {
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
               occurences.back().v2 = j;
               continue;
         }

         // if here, then at newline
         if (omit_empty_cur && occurences.back().v2 == occurences.back().v1)
            occurences.back().v1 = occurences.back().v2 = j; // don't start new field
         else {
            occurences.back().v2 = jlast;
            occurences.push_back(R_len_t_x2(j, j));
            ++k; // another field
         }
      }

      if (k == n_max_cur)
         occurences.back().v2 = str_cur_n;
      if (omit_empty_cur && occurences.back().v1 == occurences.back().v2)
         occurences.pop_back();

      SEXP ans;
      PROTECT(ans = Rf_allocVector(STRSXP, (R_len_t)occurences.size()));

      deque<R_len_t_x2>::iterator iter = occurences.begin();
      for (R_len_t l = 0; iter != occurences.end(); ++iter, ++l) {
         R_len_t_x2 curoccur = *iter;
         SET_STRING_ELT(ans, l, Rf_mkCharLenCE(str_cur_s+curoccur.v1, curoccur.v2-curoccur.v1, CE_UTF8));
      }

      SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(1);
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
