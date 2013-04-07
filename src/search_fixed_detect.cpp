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
 * Detect if a pattern occurs in a string
 * @param s ...
 * @param pattern ...
 * @return ...
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_detect_fixed(SEXP s, SEXP pattern)
{
   s = stri_prepare_arg_string(s);
   pattern = stri_prepare_arg_string(pattern);
   int ns = LENGTH(s);
   int np = LENGTH(pattern);
   if (ns <= 0 || np <= 0) return allocVector(LGLSXP, 0);
   int nmax = stri__recycling_rule(true, 2, ns, np);
   
   SEXP e;
   PROTECT(e = allocVector(LGLSXP, nmax));
   SEXP curs,curpat;
   int k=0,curslen,curpatlen;
   
   for (int i=0; i<nmax; ++i) {
      curs = STRING_ELT(s, i % ns);
      curpat = STRING_ELT(pattern, i % np);
      
      if(curs == NA_STRING || curpat == NA_STRING){
         LOGICAL(e)[i] = NA_LOGICAL;
         continue;
      }
      
      curslen = LENGTH(curs);
      curpatlen = LENGTH(curpat);
      const char* string = CHAR(curs);
      const char* spat = CHAR(curpat);
      
      LOGICAL(e)[i] = false;
   	for(int j=0; j<curslen; ++j){
         k=0;
         while(string[j+k]==spat[k] && k<curpatlen)
            k++;
   		if(k==curpatlen){
            LOGICAL(e)[i] = true;
            //if match then skip and check next element of s
            break;
   		}
   	}
   }
   UNPROTECT(1);
   return e;
}



