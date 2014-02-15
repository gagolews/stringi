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
 * Extract first occurence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @param first logical - search for the first or the last occurence?
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-20)
 */
SEXP stri__extract_firstlast_regex(SEXP str, SEXP pattern, SEXP opts_regex, bool first)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   pattern = stri_prepare_arg_string(pattern, "pattern"); // prepare string argument
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);, SET_STRING_ELT(ret, i, NA_STRING);)

      UErrorCode status = U_ZERO_ERROR;
      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
      if (U_FAILURE(status)) throw StriException(status);

      int m_start = -1;
      int m_end = -1;
      matcher->reset(str_text);
      if ((int)matcher->find()) { // find first match
         m_start = (int)matcher->start(status); // The **native** position in the input string :-)
         m_end   = (int)matcher->end(status);
         if (U_FAILURE(status)) throw StriException(status);
      }
      else {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      if (!first) { // continue searching
         while ((int)matcher->find()) {
            m_start = (int)matcher->start(status);
            m_end   = (int)matcher->end(status);
            if (U_FAILURE(status)) throw StriException(status);
         }
      }

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cont.get(i).c_str()+m_start, m_end-m_start, CE_UTF8));
   }

   if (str_text) {
      utext_close(str_text);
      str_text = NULL;
   }
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(if (str_text) utext_close(str_text);)
}


/**
 * Extract first occurence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-20)
 */
SEXP stri_extract_first_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   return stri__extract_firstlast_regex(str, pattern, opts_regex, true);
}



/**
 * Extract last occurence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-20)
 */
SEXP stri_extract_last_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   return stri__extract_firstlast_regex(str, pattern, opts_regex, false);
}




/**
 * Extract all occurences of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @return list of character vectors
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-20)
 */
SEXP stri_extract_all_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   pattern = stri_prepare_arg_string(pattern, "pattern"); // prepare string argument
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));)

      UErrorCode status = U_ZERO_ERROR;
      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
      if (U_FAILURE(status)) throw StriException(status);

      matcher->reset(str_text);

      deque<R_len_t_x2> occurences;
      while ((int)matcher->find()) {
         occurences.push_back(R_len_t_x2((R_len_t)matcher->start(status), (R_len_t)matcher->end(status)));
         if (U_FAILURE(status)) throw StriException(status);
      }

      R_len_t noccurences = (R_len_t)occurences.size();
      if (noccurences <= 0) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      const char* str_cur_s = str_cont.get(i).c_str();
      SEXP cur_res;
      PROTECT(cur_res = Rf_allocVector(STRSXP, noccurences));
      deque<R_len_t_x2>::iterator iter = occurences.begin();
      for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
         R_len_t_x2 curo = *iter;
         SET_STRING_ELT(cur_res, j, Rf_mkCharLenCE(str_cur_s+curo.v1, curo.v2-curo.v1, CE_UTF8));
      }
      SET_VECTOR_ELT(ret, i, cur_res);
      UNPROTECT(1);
   }

   if (str_text) {
      utext_close(str_text);
      str_text = NULL;
   }
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(if (str_text) utext_close(str_text);)
}
