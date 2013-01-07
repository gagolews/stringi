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

*/
SEXP stri_wrap_greedy(SEXP count, SEXP width, SEXP spacecost)
{
	int n = LENGTH(count);
	int cost = INTEGER(count)[0];
	SEXP space;
	PROTECT(space = allocVector(LGLSXP, n));
	for(int i=1;i<n;i++){
		if(cost+INTEGER(spacecost)[0]+INTEGER(count)[i]>INTEGER(width)[0]){
			LOGICAL(space)[i-1] = true;
			cost = INTEGER(count)[i];
		}else{
			LOGICAL(space)[i-1] = false;
			cost = cost + INTEGER(spacecost)[0] + INTEGER(count)[i];
		}
	}
	UNPROTECT(1);
	return(space);
}
