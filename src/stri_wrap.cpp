/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "stri_stringi.h"
//#include <limits>

///**
// * ....
// * @param count ...
// * @param width ...
// * @param spacecost ...
// * @return ...
// */
//
//SEXP stri_wrap_greedy(SEXP count, int width, int spacecost)
//{
//   int n = LENGTH(count);
//   int* icount = INTEGER(count);
//   int cost = icount[0];
//
//	SEXP space;
//	PROTECT(space = allocVector(LGLSXP, n));
//
//	for(int i=1;i<n;i++){
//		if(cost+spacecost+icount[i]>width){
//			LOGICAL(space)[i-1] = true;
//			cost = icount[i];
//		}else{
//			LOGICAL(space)[i-1] = false;
//			cost = cost + spacecost + icount[i];
//		}
//	}
//	UNPROTECT(1);
//	return(space);
//}
//
//
//SEXP stri_wrap_dynamic(SEXP count, int width, int spacecost)
//{
//   // maybe a call to stri_prepare_arg_integer?
//
//	int n = LENGTH(count);
//	double* costm = (double*)R_alloc(n*n, (int)sizeof(double));
//	double ct = 0;
//	double sum = 0;
//   int* icount = INTEGER(count);
//
//	for(int i=0;i<n;i++){
//		for(int j=i;j<n;j++){
//			sum=0;
//			for(int k=i;k<=j;k++) //sum of costs words from i to j
//				sum = sum + icount[k];
//			ct = width-(j-i)*spacecost-sum;
//			if(ct<0){ //if the cost is bigger than width, put infinity
//				costm[i*n+j]=std::numeric_limits<double>::infinity();
//			}else //put squared cost into matrix
//				costm[i*n+j]=ct*ct;
//		}
//	}
//	//i-th element of f - cost of
//	double* f = (double*)R_alloc(n, (int)sizeof(double));
//	int j=0;
//	//where to put space (false) and where break line (true)
//	SEXP space;
//	PROTECT(space = allocVector(LGLSXP, n*n));
//	for(int i=0;i<n*n;i++) // put false everywhere
//		LOGICAL(space)[i]=false;
//	while(j<n && costm[j]<std::numeric_limits<double>::infinity()){
//		f[j] = costm[j];
//		LOGICAL(space)[j*n+j] = true;
//		j=j+1;
//	}
//	double min=0;
//	int w=0;
//	double* temp = (double*)R_alloc(n, (int)sizeof(double));
//	if(j<n){
//	    for(int i=j;i<n;i++){
//			//to find min we use array "temp"
//			//temp = new double[i-1]; <- we can use this, because in every
//         //loop step we need i-1 elements array, but to avoid multiple
//         //reallocation we alloc one big array outside the loop and
//         // overwrite each element
//			temp[0]=f[0]+costm[1*n+i];
//			min=temp[0];
//			w=0;
//			for(int k=1;k<i-1;k++){
//				temp[k]=f[k]+costm[(k+1)*n+i];
//				if(temp[k]<min){
//					min=temp[k];
//					w=k;
//				}
//			}
//			f[i] = temp[w];
//			for(int k=0;k<n;k++)
//				LOGICAL(space)[i*n+k] = LOGICAL(space)[w*n+k];
//			LOGICAL(space)[i*n+i] = true;
//		}
//	}
//	//return the last row of the matrix
//	SEXP out;
//	PROTECT(out = allocVector(LGLSXP, n));
//	for(int i=0;i<n;i++)
//		LOGICAL(out)[i]=LOGICAL(space)[(n-1)*n+i];
//	UNPROTECT(2);
//	return(out);
//}
//
///**
// * ....
// * @param wordslist list of words
// * @param method integer vector of wraping methods (2==dynamic, else greedy)
// * @param width
// * @param spacecost ...
// * @return character vector
// */
//
// SEXP stri_wrap(SEXP wordslist, SEXP method, SEXP width, SEXP spacecost)
// {
//   R_len_t nwordslist = LENGTH(wordslist);
//   R_len_t nmethod = LENGTH(method);
//   R_len_t nwidth = LENGTH(width);
//   R_len_t nspacecost = LENGTH(spacecost);
//   R_len_t nmax = stri__recycling_rule(true, 4, nwordslist, nmethod, nwidth, nspacecost);
//
//   SEXP ret, sep;
//   PROTECT(ret = allocVector(STRSXP,nmax));
//   //sep for stri_flatten
//   PROTECT(sep = allocVector(STRSXP,1));
//   SET_STRING_ELT(sep,0,mkCharLen("",0));
//   SEXP words,count,temp,space,where;
//
//   int* iwidth     = INTEGER(width);
//   int* ispacecost = INTEGER(spacecost);
//
//   for(int i=0;i<nmax;i++)
//   {
//      words = VECTOR_ELT(wordslist,i % nwordslist);
//      count = stri_length(words);
//      if(INTEGER(method)[i % nmethod]==2)
//         where = stri_wrap_dynamic(count,iwidth[i%nwidth],ispacecost[i%nspacecost]);
//      else
//         where = stri_wrap_greedy(count,iwidth[i%nwidth],ispacecost[i%nspacecost]);
//      int nwhere = LENGTH(where);
//      PROTECT(space = allocVector(STRSXP,nwhere));
//      for(int k = 0; k < nwhere-1; k++){
//         if(INTEGER(where)[k])
//            SET_STRING_ELT(space,k,mkCharLen("\n", 1));
//         else
//            SET_STRING_ELT(space,k,mkCharLen(" ", 1));
//      }
//      SET_STRING_ELT(space, nwhere-1, mkCharLen("", 0));
//      temp = STRING_ELT(stri_flatten(stri_join2(words,space),sep),0);
//      SET_STRING_ELT(ret,i,temp);
//      UNPROTECT(1);
//   }
//   UNPROTECT(2);
//   return ret;
// }
