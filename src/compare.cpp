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


/** 
 * TO DO
 */
SEXP stri_casecompare(SEXP x, SEXP y)
{
   x = stri_prepare_arg_string(x); // prepare string argument
   y = stri_prepare_arg_string(y); // prepare string argument
   int nx = LENGTH(x);
   int ny = LENGTH(y);
   int nmax = max(nx, ny);
   if(nmax % nx != 0 || nmax % ny != 0)
      warning(MSG__WARN_RECYCLING_RULE);
   SEXP e, curx, cury;
   int curlen, j;
   PROTECT(e = allocVector(LGLSXP, nmax));
   for(int i=0; i < nmax; ++i){
      curx = STRING_ELT(x, i % nx);
      cury = STRING_ELT(y, i % ny);
      if(curx == NA_STRING || cury == NA_STRING){
         LOGICAL(e)[i] = NA_LOGICAL;
         continue;
      }
      curlen = LENGTH(curx);
      if(curlen != LENGTH(cury)){
         LOGICAL(e)[i] = false;
         continue;
      }
      const char* stringx = CHAR(curx);
      const char* stringy = CHAR(cury);
      for(j=0; j < curlen; ++j){
         if(stringx[j] != stringy[j]){
            LOGICAL(e)[i] = false;
            break;
         }
      }
      if(j == curlen)
         LOGICAL(e)[i] = true;
   }
   UNPROTECT(1);
   return e;   
}
