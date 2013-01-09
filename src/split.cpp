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
#include <string>

/** 
 * .... 
 */
SEXP stri_split(SEXP s)
{
   s = stri_prepare_arg_string(s);
   int n = LENGTH(s);
   int* count = (int*)R_alloc(n, sizeof(int)); 
   SEXP e;
   PROTECT(e = allocVector(VECSXP,n));
   SEXP curs,temp;
   int k=0,b=0;
   for (int i=0; i<n; ++i) {
   	curs = STRING_ELT(s, i);
   	k = LENGTH(curs);
   	count[i]=0;
   	for(int j=0; j<k; ++j){
   		b = (int)CHAR(curs)[j];
   		if(b==10)
				count[i]++;
   	}
   	PROTECT(temp = allocVector(STRSXP,count[i]+1));
   	printf("count%d=%d ",i,count[i]);
   	SET_STRING_ELT(temp,i, mkChar("ala"));
   	SET_VECTOR_ELT(e,i,temp);
   	UNPROTECT(1);
   }
   UNPROTECT(1);
   return e;
}
