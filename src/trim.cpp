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
   vectorized over s
   if s is NA the result will be NA
   
   TO DO: Encoding marking!
*/
SEXP stri_trim(SEXP s)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   
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
   vectorized over s
   if s is NA the result will be NA
   
*/
SEXP stri_ltrim(SEXP s)
{   
   s = stri_prepare_arg_string(s); // prepare string argument
   
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
         to=NA_INTEGER;
         stri__locate_trim1(string, nstring, from, to);
         SET_STRING_ELT(ret, i, mkCharLen(string+from, max(0,nstring-from)));
      }
   }
   UNPROTECT(1);
   return ret;
}


/** 
   vectorized over s
   if s is NA the result will be NA
   
*/
SEXP stri_rtrim(SEXP s)
{   
   s = stri_prepare_arg_string(s); // prepare string argument
   
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
         from=NA_INTEGER;
         to=-1;
         stri__locate_trim1(string, nstring, from, to);
         SET_STRING_ELT(ret, i, mkCharLen(string, max(0,to)));
      }
   }
   UNPROTECT(1);
   return ret;
}



/** 
   vectorized over s
   if s is NA the result will be NA
   
*/
SEXP stri_trim_all(SEXP s)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   R_len_t ns = LENGTH(s);
   SEXP e,subs, curs, temp, temp2, white, space;
   PROTECT(e = allocVector(STRSXP, ns));
   PROTECT(white = allocVector(STRSXP, 1));
   PROTECT(space = allocVector(STRSXP, 1));
   SET_STRING_ELT(white,0,mkCharLen("^WHITE_SPACE",12));
   SET_STRING_ELT(space,0,mkCharLen(" ",1));
   subs = stri_locate_all_class(s, stri_char_getpropertyid(white));
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


/** 
   vectorized over s, width and side
   if s is NA the result will be NA
   
*/

SEXP stri_pad(SEXP s, SEXP width, SEXP side, SEXP pad)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   width = stri_prepare_arg_integer(width);
   pad = stri_prepare_arg_string(pad);
   
   R_len_t ns = LENGTH(s);
   R_len_t nside = LENGTH(side);
   R_len_t nwidth = LENGTH(width);
   R_len_t np = LENGTH(pad);
   
   //check if pad is single character
   int* iplen = INTEGER(stri_length(pad));
   for(R_len_t i=0; i<np; ++i){
      if(iplen[i] != 1) 
      error("pad must be single character");
   }
   
   R_len_t nmax = stri__recycling_rule(true, 4, ns, nside, nwidth, np);
   
   int needed=0;
   SEXP e, curs, slen, snum, pnum;
   PROTECT(e = allocVector(STRSXP, nmax));
   
   slen = stri_length(s);
   snum = stri_numbytes(s);
   pnum = stri_numbytes(pad);
   int* iwidth = INTEGER(width);
   int* iside  = INTEGER(side);
   int* islen  = INTEGER(slen);
   int* isnum  = INTEGER(snum);
   int* ipnum  = INTEGER(pnum);
   
   for (R_len_t i=0; i<nmax; ++i){
      curs = STRING_ELT(s, i % ns);
      const char* p = CHAR(STRING_ELT(pad, i % np));
      if(curs == NA_STRING || iwidth[i % nwidth] == NA_INTEGER){
         SET_STRING_ELT(e, i, NA_STRING);
         continue;
      }
      
      needed = max(0, iwidth[i % nwidth] - islen[i % ns]);
      if(needed == 0){
         SET_STRING_ELT(e, i, curs);
         continue;
      }
      char* buf = R_alloc(isnum[i%ns]+ipnum[i%np]*needed, sizeof(char)); 
      char* buf2 = buf;
      switch(iside[i % nside]){
         //left
         case 1:
         for(int j=0; j<needed; ++j){
            memcpy(buf2, p, ipnum[i%np]);
            buf2 += ipnum[i%np];
         }
         memcpy(buf2, CHAR(curs), isnum[i % ns]);
         break;
         //right
         case 2:
         memcpy(buf2, CHAR(curs), isnum[i % ns]);
         buf2 += isnum[i % ns];
         for(int j=0; j<needed; ++j){
            memcpy(buf2, p, ipnum[i%np]);
            buf2 += ipnum[i%np];
         }
         break;
         //both
         case 3:
         for(int j=0; j<floor(needed/2); ++j){
            memcpy(buf2, p, ipnum[i%np]);
            buf2 += ipnum[i%np];
         }
         memcpy(buf2, CHAR(curs), isnum[i % ns]);
         buf2 += isnum[i % ns];
         for(int j=0; j<ceil(double(needed)/2); ++j){
            memcpy(buf2, p, ipnum[i%np]);
            buf2 += ipnum[i%np];
         }
         break;
      }
      SET_STRING_ELT(e, i, mkCharLen(buf, isnum[i%ns]+ipnum[i%np]*needed));
   }
   
   UNPROTECT(1);
   return e;
}