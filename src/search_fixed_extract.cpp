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
 * Extract first occurence of a fixed pattern in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts list
 * @param firs logical - search for the first or the last occurence?
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-24)
 */
SEXP stri__extract_firstlast_fixed(SEXP str, SEXP pattern, SEXP collator_opts, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");

   // call stri__ucol_open after prepare_arg:
   // if prepare_arg had failed, we would have a mem leak
   UCollator* collator = stri__ucol_open(collator_opts);
   if (!collator)
      return stri__extract_firstlast_fixed_byte(str, pattern, first);
   
   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF16 str_cont(str, vectorize_length, false); // writable
   StriContainerUStringSearch pattern_cont(pattern, vectorize_length, collator);  // collator is not owned by pattern_cont
   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, vectorize_length));
   
   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);, SET_STRING_ELT(ret, i, NA_STRING);)
         
      UStringSearch *matcher = pattern_cont.getMatcher(i, str_cont.get(i));
      usearch_reset(matcher);
      
      int start;
      if (first) {
         UErrorCode status = U_ZERO_ERROR;
         start = (int)usearch_first(matcher, &status);
         if (U_FAILURE(status)) throw StriException(status);
      } else {
         UErrorCode status = U_ZERO_ERROR;
         start = (int)usearch_last(matcher, &status);
         if (U_FAILURE(status)) throw StriException(status);
      }
      
      if (start == USEARCH_DONE) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      str_cont.getWritable(i).setTo(str_cont.get(i), (int32_t) start, (int32_t) usearch_getMatchedLength(matcher));
      SET_STRING_ELT(ret, i, str_cont.toR(i));
   }
   
   if (collator) { ucol_close(collator); collator=NULL; }
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(
      if (collator) ucol_close(collator);
   )
}


/** 
 * Extract first occurence of a fixed pattern in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts list
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-24)
 */
SEXP stri_extract_first_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   return stri__extract_firstlast_fixed(str, pattern, collator_opts, true);
}



/** 
 * Extract last occurence of a fixed pattern in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts list
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-24)
 */
SEXP stri_extract_last_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   return stri__extract_firstlast_fixed(str, pattern, collator_opts, false);
}




/** 
 * Extract all occurences of a fixed pattern in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @param collator_opts list
 * @return list of character vectors
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-24)
 */
SEXP stri_extract_all_fixed(SEXP str, SEXP pattern, SEXP collator_opts)
{
   return R_NilValue;
//   str = stri_prepare_arg_string(str, "str"); // prepare string argument
//   pattern = stri_prepare_arg_string(pattern, "pattern"); // prepare string argument
//   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
// 
//   uint32_t pattern_flags = StriContainerRegexPattern::getRegexFlags(opts_regex);
//   
//   UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
//   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF8 str_cont(str, vectorize_length);
//   StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_flags);
//   
//   SEXP ret;
//   PROTECT(ret = allocVector(VECSXP, vectorize_length));
//   
//   for (R_len_t i = pattern_cont.vectorize_init();
//         i != pattern_cont.vectorize_end();
//         i = pattern_cont.vectorize_next(i))
//   {
//      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
//         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));,
//         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));)
//      
//      UErrorCode status = U_ZERO_ERROR;
//      RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
//      str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
//      if (U_FAILURE(status)) throw StriException(status);
//      
//      matcher->reset(str_text);
//      
//      deque<R_len_t_x2> occurences;
//      while ((int)matcher->find()) { 
//         occurences.push_back(R_len_t_x2((R_len_t)matcher->start(status), (R_len_t)matcher->end(status)));
//         if (U_FAILURE(status)) throw StriException(status);
//      }
//
//      R_len_t noccurences = occurences.size();
//      if (noccurences <= 0) {
//         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
//         continue;
//      }
//      
//      const char* str_cur_s = str_cont.get(i).c_str();
//      SEXP cur_res;
//      PROTECT(cur_res = allocVector(STRSXP, noccurences));
//      deque<R_len_t_x2>::iterator iter = occurences.begin();
//      for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
//         R_len_t_x2 curo = *iter;
//         SET_STRING_ELT(cur_res, j, mkCharLenCE(str_cur_s+curo.v1, curo.v2-curo.v1, CE_UTF8));
//      }
//      SET_VECTOR_ELT(ret, i, cur_res);
//      UNPROTECT(1);
//   }
//   
//   if (str_text) {
//      utext_close(str_text);
//      str_text = NULL;
//   }
//   UNPROTECT(1);
//   return ret;
//   STRI__ERROR_HANDLER_END(if (str_text) utext_close(str_text);)
}





/** 
 * Extract first or last occurences of pattern in a string [with collation] - THIS IS DUMB! :)
 * 
 * @param str character vector
 * @param pattern character vector
 * @param first looking for first or last match? [WHATEVER]
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-24) 
 */
SEXP stri__extract_firstlast_fixed_byte(SEXP str, SEXP pattern, bool)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   
   STRI__ERROR_HANDLER_BEGIN
   int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerByteSearch pattern_cont(pattern, vectorize_length);

   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, vectorize_length));
   
   for (R_len_t i = pattern_cont.vectorize_init();
      i != pattern_cont.vectorize_end();
      i = pattern_cont.vectorize_next(i))
   {  
      STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
         SET_STRING_ELT(ret, i, NA_STRING);, SET_STRING_ELT(ret, i, NA_STRING);)
      
      pattern_cont.setupMatcher(i, str_cont.get(i).c_str(), str_cont.get(i).length());
      
      int start = pattern_cont.findFirst(); // whatever
      
      if (start == USEARCH_DONE)
         SET_STRING_ELT(ret, i, NA_STRING);
      else
         SET_STRING_ELT(ret, i, pattern_cont.toR(i));
   }
   
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
}

