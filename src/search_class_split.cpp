/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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
 
#include "stringi.h"




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
 * @version 0.2 (Marek Gagolewski, 2013-06-15) omit_empty
 */
SEXP stri_split_charclass(SEXP str, SEXP pattern, SEXP n_max, SEXP omit_empty)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   n_max = stri_prepare_arg_integer(n_max, "n_max");
   omit_empty = stri_prepare_arg_integer(omit_empty, "omit_empty");
   
   R_len_t str_length = LENGTH(str);
   R_len_t pattern_length = LENGTH(pattern);
   R_len_t n_max_length = LENGTH(n_max);
   R_len_t omit_empty_length = LENGTH(omit_empty);
   R_len_t vectorize_length = stri__recycling_rule(true, 4, str_length, pattern_length, n_max_length, omit_empty_length);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, vectorize_length);
   
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, vectorize_length));
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<vectorize_length; ++i) {
      SEXP pattern_cur = STRING_ELT(pattern, i%pattern_length); // TO DO: same patterns should form a sequence
      int  n_max_cur = INTEGER(n_max)[i%n_max_length];
      int  omit_empty_cur = LOGICAL(omit_empty)[i%omit_empty_length];
      
      if (ss->isNA(i) || pattern_cur == NA_STRING || n_max_cur == NA_INTEGER || omit_empty_cur == NA_LOGICAL) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }
         
      if (last_pattern != CHAR(pattern_cur)) {
         last_pattern = CHAR(pattern_cur);
         cc = CharClass(pattern_cur); // it's a simple struct => fast copy
      }
      
      if (cc.isNA()) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }
      
      if (n_max_cur < 0)
         n_max_cur = INT_MAX;
      else if (n_max_cur == 0) {
         SET_VECTOR_ELT(ret, i, allocVector(STRSXP, 0));
         continue;
      }
      
      R_len_t     str_cur_n = ss->get(i).length();
      const char* str_cur_s = ss->get(i).c_str();
      R_len_t j, k;
      UChar32 chr;
      deque<R_len_t_x2> fields; // byte based-indices
      fields.push_back(R_len_t_x2(0,0));
         
      for (j=0, k=1; j<str_cur_n && k < n_max_cur; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, chr);
         if (cc.test(chr)) {
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
      PROTECT(ans = allocVector(STRSXP, fields.size()));
      
      deque<R_len_t_x2>::iterator iter = fields.begin();
      for (k = 0; iter != fields.end(); ++iter, ++k) {
         R_len_t_x2 curoccur = *iter;
         SET_STRING_ELT(ans, k, mkCharLenCE(str_cur_s+curoccur.v1, curoccur.v2-curoccur.v1, CE_UTF8));
      }
      
      SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(1);
   }

   delete ss;
   UNPROTECT(1);
   return ret;
}
