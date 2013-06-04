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




//THIS IS INTERNAL FUNCTION ONLY FOR STRI_TRIM
/** Locate the first and/or the last occurence of character class in one string
 * 
 *  if first/last is NA_INTEGER on input, then we are not interested in that
 *  @param s string
 *  @param n numbytes for s
 *  @param first [IN/OUT] code point index of the first occurence, 
 *       -1 if not found; 0-based
 *  @param last  [IN/OUT] code point index of the last occurence,
 *       -1 if not found; 0-based
 */
void stri__locate_trim1(const char* s, int n, int& first, int& last)
{
   int32_t cls[2] = {-1, 1073741855};
   int i, previ;
   UChar32 chr;
   int charnum = 0;
   
   if (first != NA_INTEGER && last != NA_INTEGER) {
      first = -1;
      last  = -1;
   }   
   else if (first == NA_INTEGER)
      last  = -1;
   else
      first = -1;
   
   // if-for/else-for insted of for-if/else made here for efficiency reasons
#define STRI__LOCATE_FIRST_CLASS1_DO(__CHR_CLS_TEST__) \
      for (i=0; i<n; charnum++) {                      \
         previ = i;                                    \
         U8_NEXT(s, i, n, chr);                        \
         if (__CHR_CLS_TEST__) {                       \
            if (last != NA_INTEGER)                    \
               last = i;                               \
            if (first != NA_INTEGER && first <0) {     \
               first = previ;                          \
               if (last == NA_INTEGER)                 \
                  return;                              \
            }                                          \
         }                                             \
      }
   
   if (STRI__UCHAR_IS_MATCHING_GCMASK(cls)) {
      // General Category (matching)
      int mask = STRI__UCHAR_GET_MATCHING_GCMASK(cls);
      STRI__LOCATE_FIRST_CLASS1_DO((U_GET_GC_MASK(chr) & mask) != 0)
   }
   else if (STRI__UCHAR_IS_COMPLEMENT_GCMASK(cls)) {
      // General Category (complement)
      int mask = STRI__UCHAR_GET_COMPLEMENT_GCMASK(cls);
      STRI__LOCATE_FIRST_CLASS1_DO((U_GET_GC_MASK(chr) & mask) == 0)
   }
   else if (STRI__UCHAR_IS_MATCHING_BINPROP(cls)) {
      // Binary property (matching)
      UProperty prop = (UProperty)STRI__UCHAR_GET_MATCHING_BINPROP(cls);
      STRI__LOCATE_FIRST_CLASS1_DO(u_hasBinaryProperty(chr, prop))
   }
   else if (STRI__UCHAR_IS_COMPLEMENT_BINPROP(cls)) {
      // Binary property (complement)
      UProperty prop = (UProperty)STRI__UCHAR_GET_COMPLEMENT_BINPROP(cls);
      STRI__LOCATE_FIRST_CLASS1_DO(!u_hasBinaryProperty(chr, prop))
   }
   else
      error(MSG__INCORRECT_UCHAR_CLASS_ID);
}



/** 
 * Trim characters from a charclass from both sides of the string
 *  
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus)  
*/
SEXP stri_trim_both(SEXP s, SEXP pattern)
{
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   
   R_len_t ns = LENGTH(s);
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, ns));
   int from=-1, to=-1;
   
   for (int i=0; i<ns; ++i)
   {
      SEXP ss = STRING_ELT(s, i);
      if (ss == NA_STRING)
         SET_STRING_ELT(ret, i, NA_STRING);
      else {
         const char* string = CHAR(ss);
         int nstring = LENGTH(ss);
         from=-1;
         to=-1;
         stri__locate_trim1(string, nstring, from, to);
         SET_STRING_ELT(ret, i, mkCharLen(string+from, max(0,to-from)));
      }
   }
   UNPROTECT(1);
   return ret;
}




/** 
 * Trim characters from a charclass from the left of the string
 *  
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus) 
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use StriContainerUTF8 and CharClass
*/
SEXP stri_trim_left(SEXP str, SEXP pattern)
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
      R_len_t jlast = 0;
      UChar32 chr;
      
      for (j=0; j<curn; ) {
         U8_NEXT(curs, j, curn, chr); // "look ahead"
         if (cc.test(chr)) {
            break; // break at first occurence
         }
         jlast = j;
      }
      
      // now jlast is the index, from which we start copying
      SET_STRING_ELT(ret, i, mkCharLenCE(curs+jlast, curn-jlast, CE_UTF8));
   }

   delete ss;
   UNPROTECT(1);
   return ret;
}


/** 
 * Trim characters from a charclass from the right of the string
 *  
 * @param str character vector
 * @param pattern character vector
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus)  
 * @version 0.2 (Marek Gagolewski, 2013-06-04) Use StriContainerUTF8 and CharClass
*/
SEXP stri_trim_right(SEXP str, SEXP pattern)
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
      R_len_t jlast = curn;
      UChar32 chr;
      
      for (j=curn; j>0; ) {
         U8_PREV(curs, 0, j, chr); // "look behind"
         if (cc.test(chr)) {
            break; // break at first occurence
         }
         jlast = j;
      }
      
      // now jlast is the index, from which we start copying
      SET_STRING_ELT(ret, i, mkCharLenCE(curs, jlast, CE_UTF8));
   }

   delete ss;
   UNPROTECT(1);
   return ret;
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

