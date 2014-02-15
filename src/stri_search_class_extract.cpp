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
 * Extract first or last occurences of a character class in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-08)
 * @version 0.2 (Marek Gagolewski, 2013-06-15) Use StrContainerCharClass
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri__extract_firstlast_charclass(SEXP str, SEXP pattern, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      SET_STRING_ELT(ret, i, NA_STRING);

      if (str_cont.isNA(i) || pattern_cont.isNA(i))
         continue;

      CharClass pattern_cur = pattern_cont.get(i);
      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j, jlast;
      UChar32 chr;

      if (first) {
         for (jlast=j=0; j<str_cur_n; ) {
            U8_NEXT(str_cur_s, j, str_cur_n, chr);
            if (pattern_cur.test(chr)) {
               SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cur_s+jlast, j-jlast, CE_UTF8));
               break; // that's enough for first
            }
            jlast = j;
         }
      }
      else {
         for (jlast=j=str_cur_n; j>0; ) {
            U8_PREV(str_cur_s, 0, j, chr); // go backwards
            if (pattern_cur.test(chr)) {
               SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cur_s+j, jlast-j, CE_UTF8));
               break; // that's enough for last
            }
            jlast = j;
         }
      }
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
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
 * Extract all occurences of a character class in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @return list of character vectors
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-08)
 * @version 0.2 (Marek Gagolewski, 2013-06-15) Use StrContainerCharClass
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_extract_all_charclass(SEXP str, SEXP pattern, SEXP merge)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   merge = stri_prepare_arg_logical(merge, "merge");
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(merge));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);
   StriContainerLogical merge_cont(merge, vectorize_length);

   SEXP notfound; // this vector will be set iff not found or NA
   PROTECT(notfound = stri__vector_NA_strings(1));

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
      R_len_t j, jlast;
      UChar32 chr;
      deque<R_len_t_x2> occurences; // codepoint based-indices

      for (jlast=j=0; j<str_cur_n; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, chr);
         if (pattern_cur.test(chr)) {
            occurences.push_back(R_len_t_x2(jlast, j));
         }
         jlast = j;
      }

      R_len_t noccurences = (R_len_t)occurences.size();
      if (noccurences == 0)
         SET_VECTOR_ELT(ret, i, notfound);
      else if (merge_cur && noccurences > 1) {
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
         R_len_t noccurences2 = (R_len_t)occurences2.size();
         SEXP cur_res;
         PROTECT(cur_res = Rf_allocVector(STRSXP, noccurences2));
         iter = occurences2.begin();
         for (R_len_t f = 0; iter != occurences2.end(); ++iter, ++f) {
            R_len_t_x2 curo = *iter;
            SET_STRING_ELT(cur_res, f, Rf_mkCharLenCE(str_cur_s+curo.v1, curo.v2-curo.v1, CE_UTF8));
         }
         SET_VECTOR_ELT(ret, i, cur_res);
         UNPROTECT(1);
      }
      else {
         // do not merge
         SEXP cur_res;
         PROTECT(cur_res = Rf_allocVector(STRSXP, noccurences));
         deque<R_len_t_x2>::iterator iter = occurences.begin();
         for (R_len_t f = 0; iter != occurences.end(); ++iter, ++f) {
            R_len_t_x2 curo = *iter;
            SET_STRING_ELT(cur_res, f, Rf_mkCharLenCE(str_cur_s+curo.v1, curo.v2-curo.v1, CE_UTF8));
         }
         SET_VECTOR_ELT(ret, i, cur_res);
         UNPROTECT(1);
      }
   }

   UNPROTECT(2);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
