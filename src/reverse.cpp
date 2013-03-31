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
 * Reverse string 
 * @param s character vector
 * @return character vector which contains every string reversed
 */
SEXP stri_reverse(SEXP s)
{
   s   = stri_prepare_arg_string(s);
   R_len_t ns   = LENGTH(s);
   int curslen, lastj, k, j;
   SEXP e, curs;
   UChar32 c;
   
   PROTECT(e = allocVector(STRSXP,ns));
   
   for (int i=0; i<ns; ++i) {
      curs = STRING_ELT(s, i);
      if(curs == NA_STRING){
         SET_STRING_ELT(e, i, NA_STRING);
         continue;
      }
      curslen = LENGTH(curs);
      const char* string = CHAR(curs);
      char* rev = R_alloc(curslen, sizeof(char));
      for(j=0; j < curslen;){ //no need to use ++j here, U8_NEXT does that
         lastj = j;
         U8_NEXT(string, j, curslen, c);
         for(k=0; k < j-lastj; ++k){ //copy char
            rev[curslen-j+k] = string[lastj+k];
         }
      }
      SET_STRING_ELT(e, i, mkCharLen(rev,curslen));
   }
   UNPROTECT(1);
   return e;
}

