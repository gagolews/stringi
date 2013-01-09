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
//   if (LENGTH(spacecost) != 1) error("spacecost should be a vector of length 1");
   
	int n = LENGTH(count);
	double* costm = (double*)R_alloc(n*n, sizeof(double)); 
	double ct = 0;
	double sum = 0;
	for(int i=0;i<n;i++){
		for(int j=i;j<n;j++){
			sum=0;
			for(int k=i;k<=j;k++) //sumujemy koszt slow od i do j -- ENGLISH :)
				sum = sum + INTEGER(count)[k];
			ct = INTEGER(width)[0]-(j-i)*INTEGER(spacecost)[0]-sum;
			if(ct<0){ //nie miesci sie, to infinity
				costm[i*n+j]=std::numeric_limits<double>::infinity();
			}else //jak miesci to kwadrat i wpisujemy w tablice
				costm[i*n+j]=ct*ct;
		}
	}
	//i-ty element f to koszt wypisania pierwszych i slow-- ENGLISH :)
	double* f = (double*)R_alloc(n, sizeof(double));
	int j=0;
	//gdzie beda space (false) a gdzie nowy wiersz (true)-- ENGLISH :)
	SEXP space;
	PROTECT(space = allocVector(LGLSXP, n*n));
	for(int i=0;i<n;i++) //zerowanie (false'owanie) 
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
			//tablica pomoze nam szukac min-- ENGLISH :)
			//temp = new double[i-1]; tablica o rozm i-1 starczy-- ENGLISH :)
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
	//zwracamy ostani wiersz macierzy-- ENGLISH :)
	SEXP out;
	PROTECT(out = allocVector(LGLSXP, n));
	for(int i=0;i<n;i++)
		LOGICAL(out)[i]=LOGICAL(space)[(n-1)*n+i];
	UNPROTECT(2);
	return(out);
}