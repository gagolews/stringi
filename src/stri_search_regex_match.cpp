/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "stri_stringi.h"




/**
 * Extract all capture groups of the first/last occurence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @param firs logical - search for the first or the last occurence?
 * @return character matrix
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-22)
 */
SEXP stri__match_firstlast_regex(SEXP str, SEXP pattern, SEXP opts_regex, bool first)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   pattern = stri_prepare_arg_string(pattern, "pattern"); // prepare string argument
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   vector< vector<charptr_x2> > occurences(vectorize_length); // we don't know how many capture groups are there
   R_len_t occurences_max = 1;

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         /*do nothing*/;,
         int pattern_cur_groups = pattern_cont.getMatcher(i)->groupCount();
         if (occurences_max < pattern_cur_groups+1) occurences_max=pattern_cur_groups+1;
      )

      UErrorCode status = U_ZERO_ERROR;
      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      int pattern_cur_groups = matcher->groupCount();
      if (occurences_max < pattern_cur_groups+1) occurences_max=pattern_cur_groups+1;
      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
      if (U_FAILURE(status)) throw StriException(status);
      const char* str_cur_s = str_cont.get(i).c_str();

      occurences[i] = vector<charptr_x2>(pattern_cur_groups+1);
      matcher->reset(str_text);
      while ((int)matcher->find()) {
         occurences[i][0].v1 = str_cur_s+(int)matcher->start(status);
         occurences[i][0].v2 = str_cur_s+(int)matcher->end(status);
         for (R_len_t j=1; j<=pattern_cur_groups; ++j) {
            int m_start = (int)matcher->start(j, status);
            int m_end = (int)matcher->end(j, status);
            if (m_start < 0 || m_end < 0)
               occurences[i][j].v1 = occurences[i][j].v2 = NULL;
            else {
               occurences[i][j].v1 = str_cur_s+m_start;
               occurences[i][j].v2 = str_cur_s+m_end;
            }
         }
         if (U_FAILURE(status)) throw StriException(status);
         if (first) break;
      }
   }

   if (str_text) {
      utext_close(str_text);
      str_text = NULL;
   }

   SEXP ret;
   PROTECT(ret = stri__matrix_NA_STRING(vectorize_length, occurences_max));

   for (R_len_t i=0; i<vectorize_length; ++i) {
      R_len_t ni = (R_len_t)occurences[i].size();
      for (R_len_t j=0; j<ni; ++j) {
         charptr_x2 retij = occurences[i][j];
         if (retij.v1 != NULL && retij.v2 != NULL)
            SET_STRING_ELT(ret, i+j*vectorize_length, Rf_mkCharLenCE(retij.v1, (R_len_t)(retij.v2-retij.v1), CE_UTF8));
      }
   }


   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(if (str_text) utext_close(str_text);)
}


/**
 * Extract all capture groups of the first occurence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @return character matrix
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-22)
 */
SEXP stri_match_first_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   return stri__match_firstlast_regex(str, pattern, opts_regex, true);
}



/**
 * Extract all capture groups of the  last occurence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @return character matrix
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-22)
 */
SEXP stri_match_last_regex(SEXP str, SEXP pattern, SEXP opts_regex)
{
   return stri__match_firstlast_regex(str, pattern, opts_regex, false);
}




/**
 * Extract all capture groups of  all occurences of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @return list of character matrices
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-22)
 */
SEXP stri_match_all_regex(SEXP str, SEXP pattern, SEXP opts_regex)
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
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_STRING(1, 1));,
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_STRING(1, 1+pattern_cont.getMatcher(i)->groupCount()));)

      UErrorCode status = U_ZERO_ERROR;
      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      int pattern_cur_groups = matcher->groupCount();
      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
      if (U_FAILURE(status)) throw StriException(status);

      matcher->reset(str_text);

      deque<R_len_t_x2> occurences;
      while ((int)matcher->find()) {
         occurences.push_back(R_len_t_x2((R_len_t)matcher->start(status), (R_len_t)matcher->end(status)));
         for (R_len_t j=0; j<pattern_cur_groups; ++j)
            occurences.push_back(R_len_t_x2((R_len_t)matcher->start(j+1, status), (R_len_t)matcher->end(j+1, status)));
         if (U_FAILURE(status)) throw StriException(status);
      }

      R_len_t noccurences = (R_len_t)occurences.size()/(pattern_cur_groups+1);
      if (noccurences <= 0) {
         SET_VECTOR_ELT(ret, i, stri__matrix_NA_STRING(1, pattern_cur_groups+1));
         continue;
      }

      const char* str_cur_s = str_cont.get(i).c_str();
      SEXP cur_res;
      PROTECT(cur_res = Rf_allocMatrix(STRSXP, noccurences, pattern_cur_groups+1));
      deque<R_len_t_x2>::iterator iter = occurences.begin();
      for (R_len_t j = 0; iter != occurences.end(); ++j) {
         R_len_t_x2 curo = *iter;
         SET_STRING_ELT(cur_res, j, Rf_mkCharLenCE(str_cur_s+curo.v1, curo.v2-curo.v1, CE_UTF8));
         ++iter;
         for (R_len_t k = 0; iter != occurences.end() && k < pattern_cur_groups; ++iter, ++k) {
            curo = *iter;
            if (curo.v1 < 0 || curo.v2 < 0)
               SET_STRING_ELT(cur_res, j+(k+1)*noccurences, NA_STRING);
            else
               SET_STRING_ELT(cur_res, j+(k+1)*noccurences, Rf_mkCharLenCE(str_cur_s+curo.v1, curo.v2-curo.v1, CE_UTF8));
         }
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
