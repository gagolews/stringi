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
 * Count the number of recurrences of \code{pattern} in \code{s}
 * @param str strings to search in
 * @param pattern patterns to search for
 * @return integer vector
 */
SEXP stri_count_fixed(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str);
   pattern = stri_prepare_arg_string(pattern);
   R_len_t ns = LENGTH(str);
   R_len_t np = LENGTH(pattern);
   if (ns <= 0 || np <= 0) return allocVector(INTSXP, 0);
   R_len_t nmax = stri__recycling_rule(ns, np);

   int count = 0;
   SEXP e;
   PROTECT(e = allocVector(INTSXP, nmax));
   SEXP curs,curpat;
   int k=0,curslen,curpatlen;
   
   for (int i=0; i<nmax; ++i) {
   	curs = STRING_ELT(str, i % ns);
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
 * Count the number of recurrences of \code{pattern} in \code{s}
 * @param str strings to search in
 * @param pattern regex patterns to search for
 * @return integer vector
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF16's vectorization
 */
SEXP stri_count_regex(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str);
   pattern = stri_prepare_arg_string(pattern);
   R_len_t ns = LENGTH(str);
   R_len_t np = LENGTH(pattern);
   if (ns <= 0 || np <= 0) return allocVector(INTSXP, 0);
   R_len_t nmax = stri__recycling_rule(ns, np);
   
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nmax));
   
   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax);
   StriContainerUTF16* pp = new StriContainerUTF16(pattern, nmax);
 
   for (R_len_t i = pp->vectorize_init();
         i != pp->vectorize_end();
         i = pp->vectorize_next(i))
   {
      if (pp->isNA(i) || ss->isNA(i)) {
         INTEGER(ret)[i] = NA_INTEGER;
      }
      else {
         RegexMatcher *matcher = pp->vectorize_getMatcher(i); // will be deleted automatically
         matcher->reset(ss->get(i));
         int count = 0;
         bool found = (bool)matcher->find();
         while(found) {
            ++count;
            found = (bool)matcher->find();
         }
         INTEGER(ret)[i] = count;
      }
   }

   delete ss;
   delete pp;
   UNPROTECT(1);
   return ret;
}
