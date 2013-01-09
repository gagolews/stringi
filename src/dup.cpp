/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus
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


/** The function is vectorized over s and c
 *  if s is NA or c is NA the result will be NA
 *  if c<0 the result will be NA
 *  if c==0 the result will be an empty string
 *  if s or c is an empty vector then the result is an empty vector
 *  
 *  @TODO Encoding!!!
*/
SEXP stri_dup(SEXP s, SEXP c)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   c = stri_prepare_arg_integer(c); // prepare string argument
   R_len_t ns = LENGTH(s);
   R_len_t nc = LENGTH(c);
   if (ns <= 0)       return s;
   else if (nc <= 0)  return allocVector(STRSXP, 0);
      
   R_len_t nm = max(ns, nc);
   if (nm % ns != 0 || nm % nc != 0)
      warning("longer object length is not a multiple of shorter object length");
      
   int* cc = INTEGER(c);
   
   R_len_t maxsize = 0;
   for (int i=0; i<ns; ++i) {
      SEXP curs = STRING_ELT(s, i);
      if (curs == NA_STRING) continue;
      R_len_t cursl = LENGTH(curs);
      
      for (int j=i; j<nm; j+=ns) {
         R_len_t curc = cc[j%nc];
         if (curc == NA_INTEGER) continue;
         // don't care if curc <= 0 (won't change)
         
         if (cursl*curc > maxsize) maxsize = cursl*curc;
      }
   }
   
   
   SEXP e;
   PROTECT(e = allocVector(STRSXP, nm));

   // it may happen that maxsize == 0!
   if (maxsize <= 0) {
      // => we'll have NA_character_ or "" in the output vector
      for (int i=0; i<nm; ++i) {
         if (STRING_ELT(s, i%ns) == NA_STRING
                     || cc[i%nc] == NA_INTEGER)
            SET_STRING_ELT(e, i, NA_STRING);
         else
            SET_STRING_ELT(e, i, mkCharLen("", 0));
      }
   }
   else {
      char* buf = R_alloc(maxsize, sizeof(char)); // thread-safe
      char* buf2;
      // at least one string should be copied (for some i, j)
      
      for (int i=0; i<ns; ++i) {
         SEXP ss = STRING_ELT(s, i);
         if (ss == NA_STRING) {
            for (int j=i; j<nm; j+=ns)
               SET_STRING_ELT(e, j, NA_STRING);
         }
         else {
            const char* si = CHAR(ss);
            R_len_t ni = LENGTH(ss);
            
            // if last ci <= currect ci, the buffer will be reused
            char* buf2 = buf;
            int k = 0;
            for (int j=i; j<nm; j+=ns)
            {  
               int ci = cc[j%nc];
               if (ci == NA_INTEGER || ci < 0)
                  SET_STRING_ELT(e, j, NA_STRING);
               else {
                  if (k > ci) { 
                     buf2=buf2-(k-ci)*ni;
                     k=ci;
                  } // don't reuse previous
                  else {
                     // if k == ci then do nothing, otherwise "paste" some more si
                     for (; k<ci; ++k) {
                        memcpy(buf2, si, ni);
                        buf2 += ni;
                     }
                  }
                  SET_STRING_ELT(e, j, mkCharLen(buf, ci*ni));
               }
            }
         }
      }
   }
   
   UNPROTECT(1);
   return e;
}
