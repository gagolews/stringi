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
 */
SEXP stri_replace_all_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   
   R_len_t npat = LENGTH(pattern);
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), npat, LENGTH(replacement));


   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
 
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* rr = new StriContainerUTF8(replacement, nmax);
 
   char* buf = 0; // @TODO: consider calculating buflen a priori
   R_len_t buf_len = 0;
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%npat); // TO DO: same patterns should form a sequence
      
      if (ss->isNA(i) || rr->isNA(i) || cur_pattern == NA_STRING) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      if (last_pattern != CHAR(cur_pattern)) {
         last_pattern = CHAR(cur_pattern);
         cc = CharClass(cur_pattern); // it's a simple struct => fast copy
      }
      
      if (cc.isNA()) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      R_len_t curn = ss->get(i).length();
      const char* curs = ss->get(i).c_str();
      R_len_t j, jlast;
      UChar32 chr;
      
      R_len_t sumbytes = 0;
      deque<R_len_t_x2> occurences;
      for (jlast=j=0; j<curn; ) {
         U8_NEXT(curs, j, curn, chr); 
         if (cc.test(chr)) {
            occurences.push_back(R_len_t_x2(jlast, j));
            sumbytes += j-jlast;
         } 
         jlast = j;
      }
      
      if (occurences.size() > 0) { // iff found any
         R_len_t repn = rr->get(i).length();
         const char* reps = rr->get(i).c_str();
         R_len_t buf_need = curn+occurences.size()*repn-sumbytes;
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
            memcpy(curbuf, curs+jlast, match.v1-jlast);
            curbuf += match.v1-jlast;
            jlast = match.v2;
            memcpy(curbuf, reps, repn);
            curbuf += repn;
         }
         memcpy(curbuf, curs+jlast, curn-jlast);
         SET_STRING_ELT(ret, i, mkCharLenCE(buf, buf_need, CE_UTF8));
      }
      else {
         SET_STRING_ELT(ret, i, ss->toR(i)); // no change  
      }
   } 
 
   if (buf) delete [] buf;
   delete ss;
   delete rr;
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
 */
SEXP stri__replace_firstlast_charclass(SEXP str, SEXP pattern, SEXP replacement, bool first)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   
   R_len_t npat = LENGTH(pattern);
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), npat, LENGTH(replacement));


   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
 
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* rr = new StriContainerUTF8(replacement, nmax);
 
   char* buf = 0; // @TODO: consider calculating buflen a priori
   R_len_t buf_len = 0;
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%npat); // TO DO: same patterns should form a sequence
      
      if (ss->isNA(i) || rr->isNA(i) || cur_pattern == NA_STRING) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      if (last_pattern != CHAR(cur_pattern)) {
         last_pattern = CHAR(cur_pattern);
         cc = CharClass(cur_pattern); // it's a simple struct => fast copy
      }
      
      if (cc.isNA()) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      R_len_t curn = ss->get(i).length();
      const char* curs = ss->get(i).c_str();
      R_len_t j, jlast;
      UChar32 chr;
      
      if (first) { // search for first
         for (jlast=j=0; j<curn; ) {
            U8_NEXT(curs, j, curn, chr); // "look ahead"
            if (cc.test(chr)) {
               break; // break at first occurence
            } 
            jlast = j;
         }
      }
      else { // search for last
        for (jlast=j=curn; jlast>0; ) {
            U8_PREV(curs, 0, jlast, chr); // "look behind"
            if (cc.test(chr)) {
               break; // break at first occurence
            }
            j = jlast;
         }
      }
      
      // match is at jlast, and ends right before j
      
      if (j != jlast) { // iff found
         R_len_t repn = rr->get(i).length();
         const char* reps = rr->get(i).c_str();
         R_len_t buf_need = curn+repn-(j-jlast);
         if (!buf || buf_len < buf_need) {
            if (buf) delete [] buf;
            buf_len = buf_need;
            buf = new char[buf_len]; // NUL not needed
         }
         memcpy(buf, curs, jlast);
         memcpy(buf+jlast, reps, repn);
         memcpy(buf+jlast+repn, curs+j, curn-j);
         SET_STRING_ELT(ret, i, mkCharLenCE(buf, buf_need, CE_UTF8));
      }
      else {
         SET_STRING_ELT(ret, i, ss->toR(i)); // no change  
      }
   } 
 
   if (buf) delete [] buf;
   delete ss;
   delete rr;
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
