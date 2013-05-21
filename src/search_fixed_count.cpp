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
 * Count the number of recurrences of \code{pattern} in \code{str} [fast but dummy bitewise compare]
 * @param str strings to search in
 * @param pattern patterns to search for
 * @return integer vector
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8
 */
SEXP stri_count_fixed(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   int ns = LENGTH(str);
   int np = LENGTH(pattern);
   if (ns <= 0 || np <= 0) return allocVector(INTSXP, 0);
   int nmax = stri__recycling_rule(true, 2, ns, np);
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* sp = new StriContainerUTF8(pattern, nmax);

   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nmax));
   int* ret_tab = INTEGER(ret);
   
   for (R_len_t i=0; i<nmax; ++i) {  
      if (ss->isNA(i) || sp->isNA(i)) {
         ret_tab[i] = NA_INTEGER;
         continue;
      }
      
      ret_tab[i] = 0;
      const String8* curs = &ss->get(i);
      const String8* curp = &sp->get(i);
      const char* chs = curs->c_str();
      const char* chp = curp->c_str();
      int ns = curs->length();
      int np = curp->length();
      
      ret_tab[i] = false;
      for (int j=0; j<ns-np+1; ++j) {                  // O(ns*np) algorithm
         int k=0;
         while(k<np && chs[j+k] == chp[k])
            k++;
      	if(k == np) {
            ++ret_tab[i];
            //if match then skip and check next element of s
            j += np-1; // skip next np chars (-1, as we do ++j)
   		}
   	}
   }
   
   delete ss;
   delete sp;
   UNPROTECT(1);
   return ret;
}
