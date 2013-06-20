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
 * Extract first occurence of a regex pattern in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @param firs logical - search for the first or the last occurence?
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
   PROTECT(ret = allocVector(STRSXP, vectorize_length));
   
   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);, SET_STRING_ELT(ret, i, NA_STRING);)
      
      UErrorCode status = U_ZERO_ERROR;
      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
      if (U_FAILURE(status)) throw StriException(MSG__REGEXP_FAILED);
      
      int m_start = -1;
      int m_end = -1;
      matcher->reset(str_text);
      if ((int)matcher->find()) { //find first matches
         m_start = (int)matcher->start(status); // The **native** position in the input string :-) 
         m_end   = (int)matcher->end(status);
         if (U_FAILURE(status)) throw StriException(MSG__REGEXP_FAILED);
      }
      else {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      if (!first) { // continue searching
         while ((int)matcher->find()) {
            m_start = (int)matcher->start(status);
            m_end   = (int)matcher->end(status);
            if (U_FAILURE(status)) throw StriException(MSG__REGEXP_FAILED);
         } 
      }
      
      SET_STRING_ELT(ret, i, mkCharLenCE(str_cont.get(i).c_str()+m_start, m_end-m_start, CE_UTF8));
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
  error("TO DO");
}
