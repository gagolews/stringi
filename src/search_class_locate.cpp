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
 * Locate first or last occurences of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return matrix with 2 columns
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-04)
 */
SEXP stri__locate_firstlast_charclass(SEXP str, SEXP pattern, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t npat = LENGTH(pattern);
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), npat);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   
   SEXP ret;
   PROTECT(ret = allocMatrix(INTSXP, nmax, 2));
   stri__locate_set_dimnames_matrix(ret);
   int* ret_tab = INTEGER(ret);
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%npat); // TO DO: same patterns should form a sequence
      
      ret_tab[i]      = NA_INTEGER;
      ret_tab[i+nmax] = NA_INTEGER;
      
      if (ss->isNA(i) || cur_pattern == NA_STRING)
         continue;
         
      if (last_pattern != CHAR(cur_pattern)) {
         last_pattern = CHAR(cur_pattern);
         cc = CharClass(cur_pattern); // it's a simple struct => fast copy
      }
      
      if (cc.isNA())
         continue;
      
      R_len_t curn = ss->get(i).length();
      const char* curs = ss->get(i).c_str();
      R_len_t j;
      R_len_t k = 0;
      UChar32 chr;
         
      for (j=0; j<curn; ) {
         U8_NEXT(curs, j, curn, chr);
         k++; // 1-based index
         if (cc.test(chr)) {
            ret_tab[i]      = k;
            if (first) break; // that's enough for first
            // note that for last, we can't go backwards from the end, as we need a proper index!
         }
      }
      ret_tab[i+nmax] = ret_tab[i];
   }

   delete ss;
   UNPROTECT(1);
   return ret;
}



/** 
 * Locate first occurence of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return matrix with 2 columns
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-04)
 */
SEXP stri_locate_first_charclass(SEXP str, SEXP pattern)
{
   return stri__locate_firstlast_charclass(str, pattern, true);
}


/** 
 * Locate last occurence of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return matrix with 2 columns
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-04)
 */
SEXP stri_locate_last_charclass(SEXP str, SEXP pattern)
{
   return stri__locate_firstlast_charclass(str, pattern, false);
}




/** 
 * Locate first or last occurences of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return list of matrices with 2 columns
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-04)
 */
SEXP stri_locate_all_charclass(SEXP str, SEXP pattern, SEXP merge)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   merge = stri_prepare_arg_logical(merge, "merge");
   R_len_t npat = LENGTH(pattern);
   R_len_t nmerge = LENGTH(merge);
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), npat, nmerge);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   
   SEXP notfound; // this matrix will be set iff not found or NA
   PROTECT(notfound = stri__matrix_NA_INTEGER(1, 2));
   
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, nmax));
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%npat); // TO DO: same patterns should form a sequence
      bool cur_merge = LOGICAL(merge)[i%nmerge];
      
      if (ss->isNA(i) || cur_pattern == NA_STRING || cur_merge == NA_LOGICAL) {
         SET_VECTOR_ELT(ret, i, notfound);
         continue;
      }
         
      if (last_pattern != CHAR(cur_pattern)) {
         last_pattern = CHAR(cur_pattern);
         cc = CharClass(cur_pattern); // it's a simple struct => fast copy
      }
      
      if (cc.isNA()) {
         SET_VECTOR_ELT(ret, i, notfound);
         continue;
      }
      
      R_len_t curn = ss->get(i).length();
      const char* curs = ss->get(i).c_str();
      R_len_t j;
      R_len_t k = 0;
      UChar32 chr;
      deque<R_len_t> occurences; // codepoint based-indices
         
      for (j=0; j<curn; ) {
         U8_NEXT(curs, j, curn, chr);
         k++; // 1-based index
         if (cc.test(chr)) {
            occurences.push_back(k);
         }
      }
      
      R_len_t noccurences = occurences.size();
      if (noccurences == 0)
         SET_VECTOR_ELT(ret, i, notfound);
      else if (cur_merge && noccurences > 1) {
         // do merge  
         deque<R_len_t> occurences2;
         deque<R_len_t>::iterator iter = occurences.begin();
         occurences2.push_back(*iter);
         occurences2.push_back(*iter);
         for (++iter; iter != occurences.end(); ++iter) {
            R_len_t curoccur = *iter;
            if (occurences2.back() == curoccur - 1) { // continue seq
               occurences2.back() = curoccur;  // change `end`
            }
            else { // new seq
               occurences2.push_back(curoccur);
               occurences2.push_back(curoccur);
            }
         }
         
         // create resulting matrix from occurences2
         R_len_t noccurences2 = occurences2.size()/2;
         SEXP cur_res;
         PROTECT(cur_res = allocMatrix(INTSXP, noccurences2, 2));
         iter = occurences2.begin();
         for (R_len_t j = 0; iter != occurences2.end(); ++iter, ++j) {
            INTEGER(cur_res)[j] = *iter;
            ++iter;
#ifndef NDEBUG
            if (iter == occurences2.end()) error(MSG__INTERNAL_ERROR);
#endif
            INTEGER(cur_res)[j+noccurences2] = *iter;
         }
         SET_VECTOR_ELT(ret, i, cur_res);
         UNPROTECT(1);
      }
      else {
         // do not merge
         SEXP cur_res;
         PROTECT(cur_res = allocMatrix(INTSXP, noccurences, 2));
         deque<R_len_t>::iterator iter = occurences.begin();
         for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j)
            INTEGER(cur_res)[j] = INTEGER(cur_res)[j+noccurences] = *iter;
         SET_VECTOR_ELT(ret, i, cur_res);
         UNPROTECT(1);
      }
   }

   delete ss;
   stri__locate_set_dimnames_list(ret);
   UNPROTECT(2);
   return ret;
}
