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
 * .... 
 * @param s ...
 * @param pattern ...
 * @return ...
 */
SEXP stri_detect_fixed(SEXP s, SEXP pattern)
{
   s = stri_prepare_arg_string(s);
   pattern = stri_prepare_arg_string(pattern);
   int ns = LENGTH(s);
   int npattern = LENGTH(pattern);
   //if any length is 0 then return empty list
   if (ns==0 || npattern==0)
      return allocVector(LGLSXP, 0);
   int nmax = ns;
   if(npattern>nmax) nmax=npattern;
   if (nmax % ns != 0 || nmax % npattern != 0)
      warning(MSG__WARN_RECYCLING_RULE);
   SEXP e;
   PROTECT(e = allocVector(LGLSXP, nmax));
   SEXP curs,curpat;
   int k=0,curslen,curpatlen;
   
   for (int i=0; i<nmax; ++i) {
      curs = STRING_ELT(s, i % ns);
      curpat = STRING_ELT(pattern, i % npattern);
      
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


/** 
 * .... 
 * @param str R character vector
 * @param pattern R character vector containing regular expressions
 */
SEXP stri_detect_regex(SEXP str, SEXP pattern) {
   str = stri_prepare_arg_string(str);
   pattern = stri_prepare_arg_string(pattern);
   
   int ns = LENGTH(str);
   int np = LENGTH(pattern);
   if (ns == 0 || np == 0)
      return allocVector(LGLSXP, 0);
   int nmax = ns;
   if (np > ns)
      nmax = np;
   if (nmax % np != 0 || nmax % ns != 0)
      warning(MSG__WARN_RECYCLING_RULE);
   
   SEXP ret, s, p;
   PROTECT(ret = allocVector(LGLSXP, nmax));
   UErrorCode status;
 
 
//   for (int i = 0; i < nmax; i++) { 
//      s = STRING_ELT(str, i % ns);
//      p = STRING_ELT(pattern, i % np);
//      if (p == NA_STRING) {
//         LOGICAL(ret)[i] = NA_LOGICAL;
//      }
//      else {
//         status = U_ZERO_ERROR;
//         RegexMatcher *matcher = new RegexMatcher(UnicodeString::fromUTF8(StringPiece(CHAR(p))), 0, status);
//         if (U_FAILURE(status))
//            error(u_errorName(status));
//         matcher->reset(UnicodeString::fromUTF8(StringPiece(CHAR(s))));
//         int found = (int)matcher->find(0, status);
//         if (U_FAILURE(status))
//            error(u_errorName(status));
//         LOGICAL(ret)[i] = found;
//         delete matcher;
//      }
//   }
 
   for (int i = 0; i < np; i++) { // for each pattern
      p = STRING_ELT(pattern, i);
      if (p == NA_STRING) {
         for (int j = i; j < nmax; j += np)
            LOGICAL(ret)[j] = NA_LOGICAL;
      }
      else {
         status = U_ZERO_ERROR;
         RegexMatcher *matcher = new RegexMatcher(CHAR(p), 0, status);
         if (U_FAILURE(status))
            error(u_errorName(status));
         for (int j = i; j < nmax; j += np) {
            s = STRING_ELT(str, j % ns);
            if (s == NA_STRING)
               LOGICAL(ret)[j] = NA_LOGICAL;
            else {
               matcher->reset(CHAR(s));
               int found = (int)matcher->find();
               LOGICAL(ret)[j] = found;
            }
         }
         delete matcher;
      }
   }
   
   UNPROTECT(1);
   return ret;
}



