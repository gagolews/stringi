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
 * Trim characters from a charclass from left AND/OR right side of the string
 *  
 * @param str character vector
 * @param pattern character vector
 * @param left from left?
 * @param right from left?
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus)  
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use StriContainerUTF8 and CharClass
*/
SEXP stri__trim_leftright(SEXP str, SEXP pattern, bool left, bool right)
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
      
      if (ss->isNA(i) || cur_pattern == NA_STRING) {
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
      R_len_t j;
      R_len_t jlast1 = 0;
      R_len_t jlast2 = curn;
      UChar32 chr;
      
      if (left) {
         for (j=0; j<curn; ) {
            U8_NEXT(curs, j, curn, chr); // "look ahead"
            if (cc.test(chr)) {
               break; // break at first occurence
            }
            jlast1 = j;
         }
      }
      
      if (right && jlast1 < curn) {
         for (j=curn; j>0; ) {
            U8_PREV(curs, 0, j, chr); // "look behind"
            if (cc.test(chr)) {
               break; // break at first occurence
            }
            jlast2 = j;
         }
      }
      
      // now jlast is the index, from which we start copying
      SET_STRING_ELT(ret, i, mkCharLenCE(curs+jlast1, (jlast2-jlast1), CE_UTF8));
   }

   delete ss;
   UNPROTECT(1);
   return ret;  
}


/** 
 * Trim characters from a charclass from both sides of the string
 *  
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus)  
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use stri__trim_leftright
*/
SEXP stri_trim_both(SEXP str, SEXP pattern)
{
   return stri__trim_leftright(str, pattern, true, true);
}




/** 
 * Trim characters from a charclass from the left of the string
 *  
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus) 
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use stri__trim_leftright
*/
SEXP stri_trim_left(SEXP str, SEXP pattern)
{   
   return stri__trim_leftright(str, pattern, true, false);
}


/** 
 * Trim characters from a charclass from the right of the string
 *  
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus)  
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use stri__trim_leftright
*/
SEXP stri_trim_right(SEXP str, SEXP pattern)
{   
   return stri__trim_leftright(str, pattern, false, true);
}



/** 
   vectorized over s
   if s is NA the result will be NA
   
*/
SEXP stri_trim_all(SEXP s)
{
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   R_len_t ns = LENGTH(s);
   SEXP e,subs, curs, temp, temp2, white, space;
   PROTECT(e = allocVector(STRSXP, ns));
   PROTECT(white = allocVector(STRSXP, 1));
   PROTECT(space = allocVector(STRSXP, 1));
   SET_STRING_ELT(white,0,mkCharLen("^WHITE_SPACE",12));
   SET_STRING_ELT(space,0,mkCharLen(" ",1));
   subs = stri_locate_all_charclass(s, white, ScalarLogical(FALSE));
   int n;
   for(int i=0; i < ns; ++i){
      curs = STRING_ELT(s, i);
      if(curs == NA_STRING){
         SET_STRING_ELT(e, i, NA_STRING);
         continue;
      }
      temp = VECTOR_ELT(subs, 0);
      n = LENGTH(temp)/2;
      int* fromto = INTEGER(temp);
      //if from==NA then string contains only white space -> return empty
      if(fromto[0] == NA_INTEGER){
         SET_STRING_ELT(e, i, mkCharLen("",0));
         continue;
      }
      temp2 = stri__split_pos(CHAR(curs), fromto, fromto + n,LENGTH(curs),n);
      SET_STRING_ELT(e, i,STRING_ELT(stri_flatten(temp2, space),0));
   }
   UNPROTECT(3);
   return e;
}

