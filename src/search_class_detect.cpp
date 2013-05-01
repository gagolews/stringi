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
 * Detect if a character class occurs in a string
 * @param s ...
 * @param c ...
 * @return ...
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_detect_class(SEXP s, SEXP c)
{
   s = stri_prepare_arg_string(s);
   c = stri_prepare_arg_integer(c);
   int ns = LENGTH(s);
   int nc = LENGTH(c);
   if (ns <= 0 || nc <= 0) return allocVector(LGLSXP, 0);
   int nmax = stri__recycling_rule(true, 2, ns, nc);
   
   SEXP e;
   PROTECT(e = allocVector(LGLSXP, nmax));
   SEXP curs,curc;
   error("Not implemented yet!")
   for (int i=0; i<nmax; ++i) {
      curs = STRING_ELT(s, i % ns);
      
      if(curs == NA_STRING || curpat == NA_STRING){
         LOGICAL(e)[i] = NA_LOGICAL;
         continue;
      }
      
   }
   UNPROTECT(1);
   return e;
}



