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
 * Locate first or last occurences of a character class in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @return matrix with 2 columns
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-04)
 * @version 0.2 (Marek Gagolewski, 2013-06-15) Use StrContainerCharClass
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri__locate_firstlast_charclass(SEXP str, SEXP pattern, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocMatrix(INTSXP, vectorize_length, 2));
   stri__locate_set_dimnames_matrix(ret);
   int* ret_tab = INTEGER(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      ret_tab[i]                  = NA_INTEGER;
      ret_tab[i+vectorize_length] = NA_INTEGER;

      if (str_cont.isNA(i) || pattern_cont.isNA(i))
         continue;

      CharClass pattern_cur = pattern_cont.get(i);
      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j;
      R_len_t k = 0;
      UChar32 chr;

      for (j=0; j<str_cur_n; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, chr);
         k++; // 1-based index
         if (pattern_cur.test(chr)) {
            ret_tab[i]      = k;
            if (first) break; // that's enough for first
            // note that for last, we can't go backwards from the end, as we need a proper index!
         }
      }
      ret_tab[i+vectorize_length] = ret_tab[i];
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
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
 * @version 0.2 (Marek Gagolewski, 2013-06-09) use R_len_t_x2 for merge=TRUE
 * @version 0.3 (Marek Gagolewski, 2013-06-15) Use StrContainerCharClass
 * @version 0.4 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_locate_all_charclass(SEXP str, SEXP pattern, SEXP merge)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   merge = stri_prepare_arg_logical(merge, "merge");
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(merge));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);
   StriContainerLogical merge_cont(merge, vectorize_length);

   SEXP notfound; // this matrix will be set iff not found or NA
   PROTECT(notfound = stri__matrix_NA_INTEGER(1, 2));

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (pattern_cont.isNA(i) || str_cont.isNA(i) || merge_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, notfound);
         continue;
      }

      bool merge_cur = merge_cont.get(i);
      CharClass pattern_cur = pattern_cont.get(i);
      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j;
      R_len_t k = 0;
      UChar32 chr;
      deque<R_len_t> occurences; // codepoint based-indices

      for (j=0; j<str_cur_n; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, chr);
         k++; // 1-based index
         if (pattern_cur.test(chr)) {
            occurences.push_back(k);
         }
      }

      R_len_t noccurences = (R_len_t)occurences.size();
      if (noccurences == 0)
         SET_VECTOR_ELT(ret, i, notfound);
      else if (merge_cur && noccurences > 1) {
         // do merge
         deque<R_len_t_x2> occurences2;
         deque<R_len_t>::iterator iter = occurences.begin();
         occurences2.push_back(R_len_t_x2(*iter, *iter));
         for (++iter; iter != occurences.end(); ++iter) {
            R_len_t curoccur = *iter;
            if (occurences2.back().v2 == curoccur - 1) { // continue seq
               occurences2.back().v2 = curoccur;  // change `end`
            }
            else { // new seq
               occurences2.push_back(R_len_t_x2(curoccur, curoccur));
            }
         }

         // create resulting matrix from occurences2
         R_len_t noccurences2 = (R_len_t)occurences2.size();
         SEXP cur_res;
         PROTECT(cur_res = Rf_allocMatrix(INTSXP, noccurences2, 2));
         int* cur_res_int = INTEGER(cur_res);
         deque<R_len_t_x2>::iterator iter2 = occurences2.begin();
         for (R_len_t f = 0; iter2 != occurences2.end(); ++iter2, ++f) {
            R_len_t_x2 curoccur = *iter2;
            cur_res_int[f] = curoccur.v1;
            cur_res_int[f+noccurences2] = curoccur.v2;
         }
         SET_VECTOR_ELT(ret, i, cur_res);
         UNPROTECT(1);
      }
      else {
         // do not merge
         SEXP cur_res;
         PROTECT(cur_res = Rf_allocMatrix(INTSXP, noccurences, 2));
         int* cur_res_int = INTEGER(cur_res);
         deque<R_len_t>::iterator iter = occurences.begin();
         for (R_len_t f = 0; iter != occurences.end(); ++iter, ++f)
            cur_res_int[f] = cur_res_int[f+noccurences] = *iter;
         SET_VECTOR_ELT(ret, i, cur_res);
         UNPROTECT(1);
      }
   }

   stri__locate_set_dimnames_list(ret);
   UNPROTECT(2);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
