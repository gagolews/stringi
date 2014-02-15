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
 * Locate all pattern occurences in a string [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri__locate_all_fixed_byte} is called
 * @return list of integer matrices (2 columns)
 *
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 * @version 0.3 (Marek Gagolewski, 2013-06-23) StriException friendly, use StriContainerUStringSearch
 */
SEXP stri_locate_all_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");

   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* collator = stri__ucol_open(collator_opts);
   if (!collator)
      return stri__locate_all_fixed_byte(str, pattern);

   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF16 str_cont(str, vectorize_length);
   StriContainerUStringSearch pattern_cont(pattern, vectorize_length, collator);  // collator is not owned by pattern_cont

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));,
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));)

      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cont.get(i));
      usearch_reset(matcher);

      UErrorCode status = U_ZERO_ERROR;
      int start = (int)usearch_first(matcher, &status);
      if (U_FAILURE(status)) throw StriException(status);

      if (start == USEARCH_DONE) {
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));
         continue;
      }

      deque<R_len_t_x2> occurences;
      while (start != USEARCH_DONE) {
         occurences.push_back(R_len_t_x2(start, start+usearch_getMatchedLength(matcher)));
         start = usearch_next(matcher, &status);
         if (U_FAILURE(status)) throw StriException(status);
      }

      R_len_t noccurences = (R_len_t)occurences.size();
      SEXP ans;
      PROTECT(ans = Rf_allocMatrix(INTSXP, noccurences, 2));
      int* ans_tab = INTEGER(ans);
      deque<R_len_t_x2>::iterator iter = occurences.begin();
      for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
         R_len_t_x2 match = *iter;
         ans_tab[j]             = match.v1;
         ans_tab[j+noccurences] = match.v2;
      }

      // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
      str_cont.UChar16_to_UChar32_index(i, ans_tab,
            ans_tab+noccurences, noccurences,
            1, // 0-based index -> 1-based
            0  // end returns position of next character after match
      );
      SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(1);
   }

   stri__locate_set_dimnames_list(ret);
   if (collator) { ucol_close(collator); collator=NULL; }
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}




/**
 * Locate first or last occurences of pattern in a string [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts passed to stri__ucol_open(),
 * if \code{NA}, then \code{stri__locate_firstlast_fixed_byte} is called
 * @param first looking for first or last match?
 * @return integer matrix (2 columns)
 *
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 * @version 0.3 (Marek Gagolewski, 2013-06-23) StriException friendly, use StriContainerUStringSearch
 */
SEXP stri__locate_firstlast_fixed(SEXP str, SEXP pattern, SEXP collator_opts, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");

   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* collator = stri__ucol_open(collator_opts);
   if (!collator)
      return stri__locate_firstlast_fixed_byte(str, pattern, first);

   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF16 str_cont(str, vectorize_length);
   StriContainerUStringSearch pattern_cont(pattern, vectorize_length, collator);  // collator is not owned by pattern_cont

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
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         ;/*nothing*/, ;/*nothing*/)

      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cont.get(i));
      usearch_reset(matcher);
      UErrorCode status = U_ZERO_ERROR;

      int start;
      if (first) {
         start = usearch_first(matcher, &status);
      } else {
         start = usearch_last(matcher, &status);
      }
      if (U_FAILURE(status)) throw StriException(status);

      // if we have match (otherwise don't do anything)
      if (start != USEARCH_DONE) {
         ret_tab[i]                  = start;
         ret_tab[i+vectorize_length] = start + usearch_getMatchedLength(matcher);

         // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
         str_cont.UChar16_to_UChar32_index(i,
               ret_tab+i, ret_tab+i+vectorize_length, 1,
               1, // 0-based index -> 1-based
               0  // end returns position of next character after match
         );
      }
   }

   if (collator) { ucol_close(collator); collator=NULL; }
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}


/**
 * Locate first occurences of pattern in a string [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts list
 * @return integer matrix (2 columns)
 *
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 * @version 0.3 (Marek Gagolewski, 2013-06-23) use stri_locate_firstlast_fixed
 */
SEXP stri_locate_first_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   return stri__locate_firstlast_fixed(str, pattern, collator_opts, true);
}




/**
 * Locate last occurences of pattern in a string [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts list
 * @return integer matrix (2 columns)
 *
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-09) StriContainerUTF16 & collator
 * @version 0.3 (Marek Gagolewski, 2013-06-23) use stri_locate_firstlast_fixed
 */
SEXP stri_locate_last_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   return stri__locate_firstlast_fixed(str, pattern, collator_opts, false);
}






/**
 * Locate first or last occurences of pattern in a string [with collation]
 *
 * @param str character vector
 * @param pattern character vector
 * @param first looking for first or last match?
 * @return integer matrix (2 columns)
 *
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-23) StriException friendly, use StriContainerByteSearch
 */
SEXP stri__locate_firstlast_fixed_byte(SEXP str, SEXP pattern, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");

   STRI__ERROR_HANDLER_BEGIN
   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length);

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
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         ;/*nothing*/, ;/*nothing*/)

      pattern_cont.setupMatcher(i, str_cont.get(i).c_str(), str_cont.get(i).length());

      int start;
      if (first) {
         start = pattern_cont.findFirst();
      } else {
         start = pattern_cont.findLast();
      }

      if (start != USEARCH_DONE) {
         ret_tab[i]                  = start;
         ret_tab[i+vectorize_length] = start+pattern_cont.getMatchedLength();

         // Adjust UTF8 byte index -> UChar32 index
         str_cont.UTF8_to_UChar32_index(i,
               ret_tab+i, ret_tab+i+vectorize_length, 1,
               1, // 0-based index -> 1-based
               0  // end returns position of next character after match
         );
      }
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}



/** Locate all occurences of fixed-byte pattern
 *
 * @param str character vector
 * @param pattern character vector
 * @return list of integer matrices (2 columns)
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-23) StriException friendly, use StriContainerByteSearch
 */
SEXP stri__locate_all_fixed_byte(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");

   STRI__ERROR_HANDLER_BEGIN
   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
      i != pattern_cont.vectorize_end();
      i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));,
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));)

      pattern_cont.setupMatcher(i, str_cont.get(i).c_str(), str_cont.get(i).length());

      int start = pattern_cont.findFirst();
      if (start == USEARCH_DONE) {
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_INTEGER(1, 2));
         continue;
      }

      deque<R_len_t_x2> occurences;
      while (start != USEARCH_DONE) {
         occurences.push_back(R_len_t_x2(start, start+pattern_cont.getMatchedLength()));
         start = pattern_cont.findNext();
      }

      R_len_t noccurences = (R_len_t)occurences.size();
      SEXP ans;
      PROTECT(ans = Rf_allocMatrix(INTSXP, noccurences, 2));
      int* ans_tab = INTEGER(ans);
      deque<R_len_t_x2>::iterator iter = occurences.begin();
      for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
         R_len_t_x2 match = *iter;
         ans_tab[j]             = match.v1;
         ans_tab[j+noccurences] = match.v2;
      }

      // Adjust UChar index -> UChar32 index (1-2 byte UTF16 to 1 byte UTF32-code points)
      str_cont.UTF8_to_UChar32_index(i, ans_tab,
            ans_tab+noccurences, noccurences,
            1, // 0-based index -> 1-based
            0  // end returns position of next character after match
      );
      SET_VECTOR_ELT(ret, i, ans);
      UNPROTECT(1);
   }

   stri__locate_set_dimnames_list(ret);
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}
