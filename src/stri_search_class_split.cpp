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
 * Split a string on by occurences of a character class
 *
 * @param str character vector
 * @param pattern character vector
 * @param n_max integer vector
 * @param omit_empty logical vector
 *
 * @return a list of character vectors
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-14)
 * @version 0.2 (Marek Gagolewski, 2013-06-15) omit_empty, use StriContainerInteger, StriContainerLogical, StriContainerCharClass
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_split_charclass(SEXP str, SEXP pattern, SEXP n_max, SEXP omit_empty)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   n_max = stri_prepare_arg_integer(n_max, "n_max");
   omit_empty = stri_prepare_arg_logical(omit_empty, "omit_empty");
   R_len_t vectorize_length = stri__recycling_rule(true, 4, LENGTH(str), LENGTH(pattern), LENGTH(n_max), LENGTH(omit_empty));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8      str_cont(str, vectorize_length);
   StriContainerInteger   n_max_cont(n_max, vectorize_length);
   StriContainerLogical   omit_empty_cont(omit_empty, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || pattern_cont.isNA(i) || n_max_cont.isNA(i) || omit_empty_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      CharClass pattern_cur = pattern_cont.get(i);
      int  n_max_cur        = n_max_cont.get(i);
      int  omit_empty_cur   = omit_empty_cont.get(i);

      if (n_max_cur < 0)
         n_max_cur = INT_MAX;
      else if (n_max_cur == 0) {
         SET_VECTOR_ELT(ret, i, Rf_allocVector(STRSXP, 0));
         continue;
      }

      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j, k;
      UChar32 chr;
      deque<R_len_t_x2> fields; // byte based-indices
      fields.push_back(R_len_t_x2(0,0));

      for (j=0, k=1; j<str_cur_n && k < n_max_cur; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, chr);
         if (pattern_cur.test(chr)) {
            if (omit_empty_cur && fields.back().v2 == fields.back().v1)
               fields.back().v1 = fields.back().v2 = j; // don't start new field
            else {
               fields.push_back(R_len_t_x2(j, j)); // start new field here
               ++k; // another field
            }
         }
         else {
            fields.back().v2 = j;
         }
      }
      if (k == n_max_cur)
         fields.back().v2 = str_cur_n;
      if (omit_empty_cur && fields.back().v1 == fields.back().v2)
         fields.pop_back();

      SEXP ans;
      PROTECT(ans = Rf_allocVector(STRSXP, fields.size()));

      deque<R_len_t_x2>::iterator iter = fields.begin();
      for (k = 0; iter != fields.end(); ++iter, ++k) {
         R_len_t_x2 curoccur = *iter;
         SET_STRING_ELT(ans, k, Rf_mkCharLenCE(str_cur_s+curoccur.v1, curoccur.v2-curoccur.v1, CE_UTF8));
      }

      SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(1);
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
