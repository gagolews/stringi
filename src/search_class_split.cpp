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
 * Split a string on a character class' occurences
 * 
 * @param str character vector
 * @param pattern character vector
 * @param n integer vector
 * 
 * @return a list of character vectors
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-14)
 */
SEXP stri_split_charclass(SEXP str, SEXP pattern, SEXP splitmax)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   splitmax = stri_prepare_arg_integer(splitmax, "n");
   R_len_t npat = LENGTH(pattern);
   R_len_t nsplitmax = LENGTH(splitmax);
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), npat, nsplitmax);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, nmax));
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%npat); // TO DO: same patterns should form a sequence
      int cur_splitmax = INTEGER(splitmax)[i%nsplitmax];
      
      if (ss->isNA(i) || cur_pattern == NA_STRING || cur_splitmax == NA_INTEGER) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }
         
      if (last_pattern != CHAR(cur_pattern)) {
         last_pattern = CHAR(cur_pattern);
         cc = CharClass(cur_pattern); // it's a simple struct => fast copy
      }
      
      if (cc.isNA()) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }
      
      if (cur_splitmax < 0)
         cur_splitmax = INT_MAX;
      else if (cur_splitmax == 0) {
         SET_VECTOR_ELT(ret, i, allocVector(STRSXP, 0));
         continue;
      }
      
      R_len_t curn = ss->get(i).length();
      const char* curs = ss->get(i).c_str();
      R_len_t j, jlast;
      R_len_t k = 1;
      UChar32 chr;
      deque<R_len_t_x2> occurences; // codepoint based-indices
         
      for (jlast=j=0; j<curn && k < cur_splitmax; ) {
         U8_NEXT(curs, j, curn, chr);
         if (cc.test(chr)) {
            occurences.push_back(R_len_t_x2(jlast, j));
            ++k;
         }
         jlast = j;
      }
      
      SEXP ans;
      PROTECT(ans = allocVector(STRSXP, k));
      
      j = 0;
      
      deque<R_len_t_x2>::iterator iter = occurences.begin();
      for (k = 0; iter != occurences.end(); ++iter, ++k) {
         R_len_t_x2 curoccur = *iter;
         SET_STRING_ELT(ans, k, mkCharLenCE(curs+j, curoccur.v1-j, CE_UTF8));
         j = curoccur.v2;
      }
      
      SET_STRING_ELT(ans, k, mkCharLenCE(curs+j, curn-j, CE_UTF8));
      
      SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(1);
   }

   delete ss;
   UNPROTECT(1);
   return ret;
}
