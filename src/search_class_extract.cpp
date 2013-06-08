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
 * Extract first or last occurences of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-08)
 */
SEXP stri__extract_firstlast_charclass(SEXP str, SEXP pattern, bool first)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t npat = LENGTH(pattern);
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), npat);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%npat); // TO DO: same patterns should form a sequence
      
      SET_STRING_ELT(ret, i, NA_STRING);
      
      if (ss->isNA(i) || cur_pattern == NA_STRING)
         continue;
         
      if (last_pattern != CHAR(cur_pattern)) {
         last_pattern = CHAR(cur_pattern);
         cc = CharClass(cur_pattern); // it's a simple struct => fast copy
      }
      
      if (cc.isNA())
         continue;
      
      R_len_t curn = ss->get(i).length();
      const char* curs = ss->get(i).c_str();
      R_len_t j, jlast;
      UChar32 chr;
      
      if (first) {
         for (jlast=j=0; j<curn; ) {
            U8_NEXT(curs, j, curn, chr);
            if (cc.test(chr)) {
               SET_STRING_ELT(ret, i, mkCharLenCE(curs+jlast, j-jlast, CE_UTF8));
               break; // that's enough for first
            }
            jlast = j;
         }
      }
      else {
         for (jlast=j=curn; j>0; ) {
            U8_PREV(curs, 0, j, chr); // go backwards
            if (cc.test(chr)) {
               SET_STRING_ELT(ret, i, mkCharLenCE(curs+j, jlast-j, CE_UTF8));
               break; // that's enough for last
            }
            jlast = j;
         }
      }
   }

   delete ss;
   UNPROTECT(1);
   return ret;
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
 * Extract first or last occurences of a character class in each string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return list of character vectors
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-08)
 */
SEXP stri_extract_all_charclass(SEXP str, SEXP pattern, SEXP merge)
{
   return R_NilValue;
}
