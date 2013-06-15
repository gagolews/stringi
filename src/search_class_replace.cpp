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
 * Replace all occurences of a character class
 * 
 * @param str character vector; strings to search in
 * @param pattern character vector; charclasses to search for
 * @param replacement character vector; strings to replace with
 * 
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-07) 
 * @version 0.2 (Marek Gagolewski, 2013-06-15) Use StrContainerCharClass
 */
SEXP stri_replace_all_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));

   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerUTF8 replacement_cont(replacement, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, vectorize_length));
 
   char* buf = 0; // @TODO: consider calculating buflen a priori
   R_len_t buf_len = 0;
   
   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {       
      if (str_cont.isNA(i) || replacement_cont.isNA(i) || pattern_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      CharClass pattern_cur = pattern_cont.get(i);
      R_len_t str_cur_n     = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j, jlast;
      UChar32 chr;
      
      R_len_t sumbytes = 0;
      deque<R_len_t_x2> occurences;
      for (jlast=j=0; j<str_cur_n; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, chr); 
         if (pattern_cur.test(chr)) {
            occurences.push_back(R_len_t_x2(jlast, j));
            sumbytes += j-jlast;
         } 
         jlast = j;
      }
      
      if (occurences.size() > 0) { // iff found any
         R_len_t     replacement_cur_n = replacement_cont.get(i).length();
         const char* replacement_cur_s = replacement_cont.get(i).c_str();
         R_len_t buf_need = str_cur_n+occurences.size()*replacement_cur_n-sumbytes;
         if (!buf || buf_len < buf_need) {
            if (buf) delete [] buf;
            buf_len = buf_need;
            buf = new char[buf_len]; // NUL not needed
         }
         
         jlast = 0;
         char* curbuf = buf;
         deque<R_len_t_x2>::iterator iter = occurences.begin();
         for (; iter != occurences.end(); ++iter) {
            R_len_t_x2 match = *iter;
            memcpy(curbuf, str_cur_s+jlast, match.v1-jlast);
            curbuf += match.v1-jlast;
            jlast = match.v2;
            memcpy(curbuf, replacement_cur_s, replacement_cur_n);
            curbuf += replacement_cur_n;
         }
         memcpy(curbuf, str_cur_s+jlast, str_cur_n-jlast);
         SET_STRING_ELT(ret, i, mkCharLenCE(buf, buf_need, CE_UTF8));
      }
      else {
         SET_STRING_ELT(ret, i, str_cont.toR(i)); // no change  
      }
   } 
 
   if (buf) delete [] buf;
   UNPROTECT(1);
   return ret;
}



/** 
 * Replace first or last occurence of a character class [internal]
 * 
 * @param str character vector; strings to search in
 * @param pattern character vector; charclasses to search for
 * @param replacement character vector; strings to replace with
 * @param first replace first (TRUE) or last (FALSE)?
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-06) 
 * @version 0.2 (Marek Gagolewski, 2013-06-15) Use StrContainerCharClass
 */
SEXP stri__replace_firstlast_charclass(SEXP str, SEXP pattern, SEXP replacement, bool first)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));

   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerUTF8 replacement_cont(replacement, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);


   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, vectorize_length));
 
   char* buf = 0; // @TODO: consider calculating buflen a priori
   R_len_t buf_len = 0;
   
   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {       
      if (str_cont.isNA(i) || replacement_cont.isNA(i) || pattern_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      CharClass pattern_cur = pattern_cont.get(i);
      R_len_t str_cur_n     = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t j, jlast;
      UChar32 chr;
      
      if (first) { // search for first
         for (jlast=j=0; j<str_cur_n; ) {
            U8_NEXT(str_cur_s, j, str_cur_n, chr); // "look ahead"
            if (pattern_cur.test(chr)) {
               break; // break at first occurence
            } 
            jlast = j;
         }
      }
      else { // search for last
        for (jlast=j=str_cur_n; jlast>0; ) {
            U8_PREV(str_cur_s, 0, jlast, chr); // "look behind"
            if (pattern_cur.test(chr)) {
               break; // break at first occurence
            }
            j = jlast;
         }
      }
      
      // match is at jlast, and ends right before j
      
      if (j != jlast) { // iff found
         R_len_t     replacement_cur_n = replacement_cont.get(i).length();
         const char* replacement_cur_s = replacement_cont.get(i).c_str();
         R_len_t buf_need = str_cur_n+replacement_cur_n-(j-jlast);
         if (!buf || buf_len < buf_need) {
            if (buf) delete [] buf;
            buf_len = buf_need;
            buf = new char[buf_len]; // NUL not needed
         }
         memcpy(buf, str_cur_s, jlast);
         memcpy(buf+jlast, replacement_cur_s, replacement_cur_n);
         memcpy(buf+jlast+replacement_cur_n, str_cur_s+j, str_cur_n-j);
         SET_STRING_ELT(ret, i, mkCharLenCE(buf, buf_need, CE_UTF8));
      }
      else {
         SET_STRING_ELT(ret, i, str_cont.toR(i)); // no change  
      }
   } 
 
   if (buf) delete [] buf;
   UNPROTECT(1);
   return ret;
}



/** 
 * Replace first occurence of a character class
 * 
 * @param str character vector; strings to search in
 * @param pattern character vector; charclasses to search for
 * @param replacement character vector; strings to replace with
 * 
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-06) 
 */
SEXP stri_replace_first_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   return stri__replace_firstlast_charclass(str, pattern, replacement, true);
}



/** 
 * Replace last occurence of a character class
 * 
 * @param str character vector; strings to search in
 * @param pattern character vector; charclasses to search for
 * @param replacement character vector; strings to replace with
 * 
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-06) 
 */
SEXP stri_replace_last_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   return stri__replace_firstlast_charclass(str, pattern, replacement, false);
}
