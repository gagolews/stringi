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
 * Split a string into parts.
 *
 * The pattern matches identify delimiters that separate the input into fields.
 * The input data between the matches becomes the fields themselves.
 *
 * @param str character vector
 * @param pattern character vector
 * @param n_max integer vector
 * @param opts_regex
 * @return list of character vectors
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-21)
 * @version 0.2 (Marek Gagolewski, 2013-07-10) - BUGFIX: wrong behavior on empty str
 */
SEXP stri_split_regex(SEXP str, SEXP pattern, SEXP n_max, SEXP omit_empty, SEXP opts_regex)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   n_max = stri_prepare_arg_integer(n_max, "n_max");
   omit_empty = stri_prepare_arg_logical(omit_empty, "omit_empty");
   R_len_t vectorize_length = stri__recycling_rule(true, 4, LENGTH(str), LENGTH(pattern), LENGTH(n_max), LENGTH(omit_empty));

   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);

   UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8      str_cont(str, vectorize_length);
   StriContainerInteger   n_max_cont(n_max, vectorize_length);
   StriContainerLogical   omit_empty_cont(omit_empty, vectorize_length);
   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (n_max_cont.isNA(i) || omit_empty_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }

      int  n_max_cur        = n_max_cont.get(i);
      int  omit_empty_cur   = omit_empty_cont.get(i);

      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));,
         SET_VECTOR_ELT(ret, i, stri__vector_empty_strings((omit_empty_cur || n_max_cur == 0)?0:1));)

      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();

      if (n_max_cur < 0)
         n_max_cur = INT_MAX;
      else if (n_max_cur == 0) {
         SET_VECTOR_ELT(ret, i, Rf_allocVector(STRSXP, 0));
         continue;
      }

      UErrorCode status = U_ZERO_ERROR;
      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
      if (U_FAILURE(status)) throw StriException(status);

      matcher->reset(str_text);


      R_len_t k;
      deque<R_len_t_x2> fields; // byte based-indices
      fields.push_back(R_len_t_x2(0,0));

      for (k=1; k < n_max_cur && (int)matcher->find(); ) {
         R_len_t s1 = (R_len_t)matcher->start(status);
         R_len_t s2 = (R_len_t)matcher->end(status);
         if (U_FAILURE(status)) throw StriException(status);

         if (omit_empty_cur && fields.back().v1 == s1)
            fields.back().v1 = s2; // don't start new field
         else {
            fields.back().v2 = s1;
            fields.push_back(R_len_t_x2(s2, s2)); // start new field here
            ++k; // another field
         }
      }
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
