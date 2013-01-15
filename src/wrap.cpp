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
#include <limits>

/** 

*/
SEXP stri_wrap_greedy(SEXP count, SEXP width, SEXP spacecost)
{
   // maybe a call to stri_prepare_arg_integer?
//   if (LENGTH(spacecost) != 1) error("spacecost should be a vector of length 1");
   
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


SEXP stri_wrap_dynamic(SEXP count, SEXP width, SEXP spacecost)
{
   // maybe a call to stri_prepare_arg_integer? 
   // i've just meet you, so call me maybe :P
//   if (LENGTH(spacecost) != 1) error("spacecost should be a vector of length 1");
   
	int n = LENGTH(count);
	double* costm = (double*)R_alloc(n*n, sizeof(double)); 
	double ct = 0;
	double sum = 0;
	for(int i=0;i<n;i++){
		for(int j=i;j<n;j++){
			sum=0;
			for(int k=i;k<=j;k++) //sum of costs words from i to j
				sum = sum + INTEGER(count)[k];
			ct = INTEGER(width)[0]-(j-i)*INTEGER(spacecost)[0]-sum;
			if(ct<0){ //if the cost is bigger than width, put infinity
				costm[i*n+j]=std::numeric_limits<double>::infinity();
			}else //put squared cost into matrix
				costm[i*n+j]=ct*ct;
		}
	}
	//i-th element of f - cost of
	double* f = (double*)R_alloc(n, sizeof(double));
	int j=0;
	//where to put space (false) and where break line (true)
	SEXP space;
	PROTECT(space = allocVector(LGLSXP, n*n));
	for(int i=0;i<n;i++) // put false everywhere
		for(int j=0;j<n;j++)
			LOGICAL(space)[i*n+j]=false;
	while(j<n && costm[j]<std::numeric_limits<double>::infinity()){
		f[j] = costm[j];
		LOGICAL(space)[j*n+j] = true;
		j=j+1;
	}
	double min=0;
	int w=0;
	double* temp = (double*)R_alloc(n, sizeof(double));
	if(j<n){
	    for(int i=j;i<n;i++){
			//to find min we use array "temp"
			//temp = new double[i-1]; <- we can use this, because in every
         //loop step we need i-1 elements array, but to avoid multiple
         //reallocation we alloc one big array outside the loop and
         // overwrite each element
			temp[0]=f[0]+costm[1*n+i];
			min=temp[0];
			w=0;
			for(int k=1;k<i-1;k++){
				temp[k]=f[k]+costm[(k+1)*n+i];
				if(temp[k]<min){
					min=temp[k];
					w=k;
				}
			}
			f[i] = temp[w];
			for(int k=0;k<n;k++)
				LOGICAL(space)[i*n+k] = LOGICAL(space)[w*n+k];
			LOGICAL(space)[i*n+i] = true;
		}
	}
	//return the last row of the matrix
	SEXP out;
	PROTECT(out = allocVector(LGLSXP, n));
	for(int i=0;i<n;i++)
		LOGICAL(out)[i]=LOGICAL(space)[(n-1)*n+i];
	UNPROTECT(2);
	return(out);
}