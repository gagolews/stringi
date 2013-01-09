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



/** vectorized over s1 and s2 

   optimized for s1 longer than s2
   if s1 or s2 is NA then result is NA
   if s1 or s2 is empty, then the result is just s1 or s2
   
   TO DO: Encoding!!!
*/
SEXP stri_join2(SEXP s1, SEXP s2)
{
   s1 = stri_prepare_arg_string(s1); // prepare string argument
   s2 = stri_prepare_arg_string(s2); // prepare string argument
   
   R_len_t ns1 = LENGTH(s1);
   R_len_t ns2 = LENGTH(s2);
   if (ns1 <= 0) return s2;
   else if (ns2 <= 0) return s1;
   R_len_t nsm = max(ns1, ns2);
   
   if (nsm % ns1 != 0 || nsm % ns2 != 0)
      warning("longer object length is not a multiple of shorter object length");
   
   // find maximal length of the buffer needed
   R_len_t maxsize = 0;
   for (int i=0; i<ns1; ++i) {
      SEXP curs1 = STRING_ELT(s1, i);
      if (curs1 == NA_STRING) continue;
      R_len_t cnsl = LENGTH(curs1);
      
      for (int j=i; j<nsm; j+=ns1) {
         SEXP curs2 = STRING_ELT(s2, j%ns2);
         if (curs2 == NA_STRING) continue;
         R_len_t cns2 = LENGTH(curs2);
         
         if (cnsl+cns2 > maxsize) maxsize = cnsl+cns2;
      }
   }
   
   SEXP e;
   PROTECT(e = allocVector(STRSXP, nsm)); // output vector
      
   // it may happen that maxsize == 0!
   if (maxsize <= 0) {
      // => we'll have NA_character_ or "" in the output vector
      for (int i=0; i<nsm; ++i) {
         if (STRING_ELT(s1, i%ns1) == NA_STRING
          || STRING_ELT(s2, i%ns2) == NA_STRING)
            SET_STRING_ELT(e, i, NA_STRING);
         else
            SET_STRING_ELT(e, i, mkCharLen("", 0));
      }
   }
   else {
      char* buf = R_alloc(maxsize, sizeof(char)); // to be thread-safe
      char* buf2;
      
      // at least one string should be copied (for some i, j)
      for (int i=0; i<ns1; ++i) {
         SEXP ss1 = STRING_ELT(s1, i);
         if (ss1 == NA_STRING) {
            for (int j=i; j<nsm; j+=ns1)
               SET_STRING_ELT(e, j, NA_STRING); // NA %+% ??? == NA
         }
         else {
            buf2 = buf; // don't copy ss1 yet (copy only when needed)
         
            const char* si1 = CHAR(ss1); // this is not NA
            R_len_t sn1 = LENGTH(ss1);   // this may be equal to 0
               
            for (int j=i; j<nsm; j+=ns1) {  
               SEXP ss2 = STRING_ELT(s2, j%ns2);
               if (ss2 == NA_STRING)
                  SET_STRING_ELT(e, j, NA_STRING);
               else {
                  const char* si2 = CHAR(ss2); // this is not NA
                  R_len_t sn2 = LENGTH(ss2);   // this may be equal to 0
                  
                  if (sn1 != 0 && buf2 == buf) {
                     // now copy of ss1 is needed
                     memcpy(buf, si1, sn1);
                     buf2 = buf + sn1;
                  }
                  if (sn2 != 0)
                     memcpy(buf2, si2, sn2);
                  SET_STRING_ELT(e, j, mkCharLen(buf, sn1+sn2)); // sn1+sn2 may be equal to 0
               }
            }
         }
      }
   }
   
   UNPROTECT(1);
   return e;
}


/** TO DO: Encoding marking!

   if any of s is NA, the result will be NA_character_
*/
SEXP stri_flatten(SEXP s)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return s;
   
   SEXP e;
   PROTECT(e = allocVector(STRSXP, 1));
   
   R_len_t totalsize = 0;
   for (int i=0; i<ns; ++i){
      SEXP curs = STRING_ELT(s, i);
      if (curs == NA_STRING) {
         SET_STRING_ELT(e, 0, NA_STRING);
         UNPROTECT(1);
         return e;
      }
      totalsize += LENGTH(curs);
   }
   
   // if we are here - output is definitely not NA_character_
   
   if (totalsize <= 0)
      SET_STRING_ELT(e, 0, mkCharLen("", 0)); // empty string on output
   else {
      // not an empty string
      char* buf = R_alloc(totalsize, sizeof(char)); // to be thread-safe
      char* buf2 = buf;
      for (int i=0; i<ns; ++i) {
         SEXP ss = STRING_ELT(s, i);
         int ni = LENGTH(ss);
         if (ni > 0) {
            memcpy(buf2, CHAR(ss), ni);
            buf2 += ni;
         }
      }
      SET_STRING_ELT(e, 0, mkCharLen(buf, totalsize));
   }
   UNPROTECT(1);
   return e;
}

