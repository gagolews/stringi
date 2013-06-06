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
 * @version 0.1 (Marek Gagolewski) 
 */
SEXP stri_replace_all_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));


   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
 
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* rr = new StriContainerUTF8(replacement, nmax);
 
 
 
   error("TO DO");
 
 
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
 * @version 0.1 (Marek Gagolewski) 
 */
SEXP stri_replace_first_charclass(SEXP str, SEXP pattern, SEXP replacement)
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
 
   char* buf = 0;
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
      R_len_t j, jlast = 0;
      UChar32 chr;
      
      for (j=0; j<curn; ) {
         U8_NEXT(curs, j, curn, chr);
         if (cc.test(chr)) {
            break;
         } 
         jlast = j;
      }
      
      // match is at jlast, and ends right before j
      
      if (jlast < curn) { // iff found
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
 * Replace last occurence of a character class
 * 
 * @param str character vector; strings to search in
 * @param pattern character vector; charclasses to search for
 * @param replacement character vector; strings to replace with
 * 
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski) 
 */
SEXP stri_replace_last_charclass(SEXP str, SEXP pattern, SEXP replacement)
{
   str          = stri_prepare_arg_string(str, "str");
   pattern      = stri_prepare_arg_string(pattern, "pattern");
   replacement  = stri_prepare_arg_string(replacement, "replacement");
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(pattern), LENGTH(replacement));


   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
 
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* rr = new StriContainerUTF8(replacement, nmax);
 
 
 
   error("TO DO");
 
 
   delete ss;
   delete rr;
   UNPROTECT(1);
   return ret;
}
