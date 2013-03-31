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
SEXP stri_count_fixed(SEXP s, SEXP pattern)
{
   s = stri_prepare_arg_string(s);
   pattern = stri_prepare_arg_string(pattern);
   R_len_t ns = LENGTH(s);
   R_len_t np = LENGTH(pattern);
   //if any length is 0 then return empty list
   if (ns <= 0 || np <= 0)
      return allocVector(INTSXP, 0);
   R_len_t nmax = stri__recycling_rule(ns, np);

   int count = 0;
   SEXP e;
   PROTECT(e = allocVector(INTSXP, nmax));
   SEXP curs,curpat;
   int k=0,curslen,curpatlen;
   
   for (int i=0; i<nmax; ++i) {
   	curs = STRING_ELT(s, i % ns);
      curpat = STRING_ELT(pattern, i % np);
      
      if(curs == NA_STRING || curpat == NA_STRING){
         INTEGER(e)[i] = NA_INTEGER;
         continue;
      }
      curslen = LENGTH(curs);
      curpatlen = LENGTH(curpat);
      const char* string = CHAR(curs);
      const char* spat = CHAR(curpat);
   	count=0;
   	for(int j=0; j<curslen; ++j){
         k=0;
         while(string[j+k]==spat[k] && k<curpatlen)
            k++;
   		if(k==curpatlen){
            count++;
            j=j+k-1; //if match then skip next k char
   		}
   	}
      INTEGER(e)[i] = count;
   }
   UNPROTECT(1);
   return e;
}


/** 
 * .... 
 * @param str R character vector
 * @param pattern R character vector containing regular expressions
 */
SEXP stri_count_regex(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str);
   pattern = stri_prepare_arg_string(pattern);
   
   R_len_t ns = LENGTH(str);
   R_len_t np = LENGTH(pattern);
   if (ns <= 0 || np <= 0)
      return allocVector(INTSXP, 0);
   R_len_t nmax = stri__recycling_rule(ns, np);
   
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nmax));
   UErrorCode status;
 
   StriContainerUTF16* ss = new StriContainerUTF16(str);
   StriContainerUTF16* pp = new StriContainerUTF16(pattern);

   for (int i = 0; i < np; i++) { // for each pattern
      if (pp->isNA(i)) {
         for (int j = i; j < nmax; j += np)
            INTEGER(ret)[j] = NA_INTEGER;
      }
      else {
//          ICU team [ICU trac #10054] answer for our [stringi-issue #17]:
//          The parameter type to Reset is (const UnicodeString &). The matcher
//          retains a reference to the caller supplied string; it does not copy it.
//          UnicodeString has a constructor from (const char *). So we get a temporary
//          UnicodeString constructed, then deleted after the reset() returns, leaving
//          the matcher to operate on deleted data.

         status = U_ZERO_ERROR;
         RegexMatcher *matcher = new RegexMatcher(pp->get(i), 0, status);
         if (U_FAILURE(status))
            error(u_errorName(status));
         for (int j = i; j < nmax; j += np) {
            if (ss->isNA(j % ns))
               INTEGER(ret)[j] = NA_INTEGER;
            else {
               matcher->reset(ss->get(j%ns));
               int count = 0;
               int found = (int)matcher->find();
               while(found){
                  ++count;
                  found = (int)matcher->find();
               }
               INTEGER(ret)[j] = count;
            }
         }
         delete matcher;
      }
   }
   
   delete ss;
   delete pp;
   UNPROTECT(1);
   return ret;
}
