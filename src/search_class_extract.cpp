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
 * Extract first or last occurences of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-08)
 */
SEXP stri__extract_firstlast_charclass(SEXP str, SEXP pattern, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t npat = LENGTH(pattern);
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), npat);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%npat); // TO DO: same patterns should form a sequence
      
      SET_STRING_ELT(ret, i, NA_STRING);
      
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
      R_len_t j, jlast;
      UChar32 chr;
      
      if (first) {
         for (jlast=j=0; j<curn; ) {
            U8_NEXT(curs, j, curn, chr);
            if (cc.test(chr)) {
               SET_STRING_ELT(ret, i, mkCharLenCE(curs+jlast, j-jlast, CE_UTF8));
               break; // that's enough for first
            }
            jlast = j;
         }
      }
      else {
         for (jlast=j=curn; j>0; ) {
            U8_PREV(curs, 0, j, chr); // go backwards
            if (cc.test(chr)) {
               SET_STRING_ELT(ret, i, mkCharLenCE(curs+j, jlast-j, CE_UTF8));
               break; // that's enough for last
            }
            jlast = j;
         }
      }
   }

   delete ss;
   UNPROTECT(1);
   return ret;
}



/** 
 * Extract first occurence of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-08)
 */
SEXP stri_extract_first_charclass(SEXP str, SEXP pattern)
{
   return stri__extract_firstlast_charclass(str, pattern, true);
}


/** 
 * Extract last occurence of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-08)
 */
SEXP stri_extract_last_charclass(SEXP str, SEXP pattern)
{
   return stri__extract_firstlast_charclass(str, pattern, false);
}




/** 
 * Extract first or last occurences of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return list of character vectors
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-08)
 */
SEXP stri_extract_all_charclass(SEXP str, SEXP pattern, SEXP merge)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   merge = stri_prepare_arg_logical(merge, "merge");
   R_len_t npat = LENGTH(pattern);
   R_len_t nmerge = LENGTH(merge);
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), npat, nmerge);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   
   SEXP notfound; // this vector will be set iff not found or NA
   PROTECT(notfound = stri__vector_NA_strings(1));
   
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
      R_len_t j, jlast;
      UChar32 chr;
      deque<R_len_t_x2> occurences; // codepoint based-indices
         
      for (jlast=j=0; j<curn; ) {
         U8_NEXT(curs, j, curn, chr);
         if (cc.test(chr)) {
            occurences.push_back(R_len_t_x2(jlast, j));
         }
         jlast = j;
      }
      
      R_len_t noccurences = occurences.size();
      if (noccurences == 0)
         SET_VECTOR_ELT(ret, i, notfound);
      else if (cur_merge && noccurences > 1) {
         // do merge  
         deque<R_len_t_x2> occurences2;
         deque<R_len_t_x2>::iterator iter = occurences.begin();
         occurences2.push_back(*iter);
         for (++iter; iter != occurences.end(); ++iter) {
            R_len_t_x2 curoccur = *iter;
            if (occurences2.back().v2 == curoccur.v1) { // continue seq
               occurences2.back().v2 = curoccur.v2;  // change `end`
            }
            else { // new seq
               occurences2.push_back(curoccur);
            }
         }
         
         // create resulting matrix from occurences2
         R_len_t noccurences2 = occurences2.size();
         SEXP cur_res;
         PROTECT(cur_res = allocVector(STRSXP, noccurences2));
         iter = occurences2.begin();
         for (R_len_t j = 0; iter != occurences2.end(); ++iter, ++j) {
            R_len_t_x2 curo = *iter;
            SET_STRING_ELT(cur_res, j, mkCharLenCE(curs+curo.v1, curo.v2-curo.v1, CE_UTF8));
         }
         SET_VECTOR_ELT(ret, i, cur_res);
         UNPROTECT(1);
      }
      else {
         // do not merge
         SEXP cur_res;
         PROTECT(cur_res = allocVector(STRSXP, noccurences));
         deque<R_len_t_x2>::iterator iter = occurences.begin();
         for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
            R_len_t_x2 curo = *iter;
            SET_STRING_ELT(cur_res, j, mkCharLenCE(curs+curo.v1, curo.v2-curo.v1, CE_UTF8));
         }
         SET_VECTOR_ELT(ret, i, cur_res);
         UNPROTECT(1);
      }
   }

   delete ss;
   UNPROTECT(2);
   return ret;
}
