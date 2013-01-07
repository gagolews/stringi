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
	int n = LENGTH(count);
	SEXP costm;
	PROTECT(costm = allocVector(REALSXP, n*n));
	double ct = 0;
	double sum = 0;
	for(int i=0;i<n;i++){
		for(int j=i;j<n;j++){
			sum=0;
			for(int k=i;k<=j;k++) //sumujemy koszt slow od i do j
				sum = sum + INTEGER(count)[k];
			ct = INTEGER(width)[0]-(j-i)*INTEGER(spacecost)[0]-sum;
			if(ct<0){ //nie miesci sie, to infinity
				REAL(costm)[i*n+j]=std::numeric_limits<double>::infinity();
			}else //jak miesci to kwadrat i wpisujemy w tablice
				REAL(costm)[i*n+j]=ct*ct;
		}
	}
	//i-ty element f to koszt wypisania pierwszych i slow
	SEXP f;
	PROTECT(f = allocVector(REALSXP, n));
	int j=0;
	//gdzie beda space (false) a gdzie nowy wiersz (true)
	SEXP space;
	PROTECT(space = allocVector(LGLSXP, n*n));
	for(int i=0;i<n;i++) //zerowanie (false'owanie) 
		for(int j=0;j<n;j++)
			LOGICAL(space)[i*n+j]=false;
	while(j<n && REAL(costm)[j]<std::numeric_limits<double>::infinity()){
		REAL(f)[j] = REAL(costm)[j];
		LOGICAL(space)[j*n+j] = true;
		j=j+1;
	}
	double min=0;
	int w=0;
	SEXP temp;
	PROTECT(temp = allocVector(REALSXP, n));
	if(j<n){
	    for(int i=j;i<n;i++){
			//tablica pomoze nam szukac min
			//temp = new double[i-1]; tablica o rozm i-1 starczy
			REAL(temp)[0]=REAL(f)[0]+REAL(costm)[1*n+i];
			min=REAL(temp)[0];
			w=0;
			for(int k=1;k<i-1;k++){
				REAL(temp)[k]=REAL(f)[k]+REAL(costm)[(k+1)*n+i];
				if(REAL(temp)[k]<min){
					min=REAL(temp)[k];
					w=k;
				}
			}
			REAL(f)[i] = REAL(temp)[w];
//			delete []temp;
			for(int k=0;k<n;k++)
				LOGICAL(space)[i*n+k] = LOGICAL(space)[w*n+k];
			LOGICAL(space)[i*n+i] = true;
		}
	}
	//zwracamy ostani wiersz macierzy
	SEXP out;
	PROTECT(out = allocVector(LGLSXP, n));
	for(int i=0;i<n;i++)
		LOGICAL(out)[i]=LOGICAL(space)[(n-1)*n+i];
	UNPROTECT(5);
	return(out);
}