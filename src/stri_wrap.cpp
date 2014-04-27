/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#include "stri_stringi.h"
#include "stri_container_utf8_indexable.h"
#include <deque>
#include <vector>
#include <utility>
#include <unicode/brkiter.h>


/** Word wrap text
 * 
 * @param str character vector
 * @param width single integer
 * @param cost_exponent single double
 * @param locale locale identifier or NULL for default locale
 * 
 * @return list
 * 
 * @version 0.1-?? (Bartek Tartanus)
 * 
 * @version 0.2-2 (Marek Gagolewski, 2014-04-27)
 *          single function for wrap_greedy and wrap_dynamic
 *          use BreakIterator
 */
SEXP stri_wrap(SEXP str, SEXP width, SEXP cost_exponent, SEXP locale)
{
   str = stri_prepare_arg_string(str, "str");
   const char* qloc = stri__prepare_arg_locale(locale, "locale", true);
   Locale loc = Locale::createFromName(qloc);
   double exponent_val = stri__prepare_arg_double_1_notNA(cost_exponent, "width");
   int width_val = stri__prepare_arg_integer_1_notNA(width, "width");
   if (width_val <= 0)
      Rf_error(MSG__EXPECTED_POSITIVE, "width");
   // @TODO: check if width_val > 0

   R_len_t str_length = LENGTH(str);
   BreakIterator* briter = NULL;
   UText* str_text = NULL;
   
   STRI__ERROR_HANDLER_BEGIN
   UErrorCode status = U_ZERO_ERROR;
   briter = BreakIterator::createLineInstance(loc, status);
   if (U_FAILURE(status)) throw StriException(status);
   
   StriContainerUTF8_indexable str_cont(str, str_length);
   
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, str_length));
   for (R_len_t i = 0; i < str_length; ++i)
   {
      if (str_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
         continue;
      }
      
      status = U_ZERO_ERROR;
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_n = str_cont.get(i).length();
      str_text = utext_openUTF8(str_text, str_cur_s, str_cont.get(i).length(), &status);
      if (U_FAILURE(status)) throw StriException(status);
      briter->setText(str_text, status);
      if (U_FAILURE(status)) throw StriException(status);
      
      // all right, first let's generate a list of places at which we may do line breaks
      deque< R_len_t > occurences_list; // this could be an R_len_t queue
      R_len_t match = briter->first();
      while (match != BreakIterator::DONE) {
         occurences_list.push_back(match);
         match = briter->next();
      }
      
      R_len_t noccurences = (R_len_t)occurences_list.size();
      if (noccurences <= 2) { // no match or match whole text
         SET_VECTOR_ELT(ret, i, str_cont.toR(i));
         continue;
      }
      
      // convert to a vector:
      std::vector<R_len_t> pos(noccurences);
      deque<R_len_t>::iterator iter = occurences_list.begin();
      for (R_len_t j = 0; iter != occurences_list.end(); ++iter, ++j) {
         pos[j] = (*iter); // this is a UTF-8 index
      }
      

      // now:
      // get the number of code points in each chunk
      std::vector<R_len_t> counts_orig(noccurences-1);
      // get the number of code points without trailing whitespaces
      std::vector<R_len_t> counts_trim(noccurences-1);
      // detect line endings (fail on a match)
      
   
   
   Rf_error("TO DO");
   
      
      UChar32 c = 0;
      R_len_t j = 0;
      while (j < str_cur_n) {
         U8_NEXT(str_cur_s, j, str_cur_n, c);
         if (c < 0) { // invalid utf-8 sequence
            SET_VECTOR_ELT(ret, i, str_cont.toR(i));
            continue;
         }
         
         
      }

      
      
//
//      R_len_t noccurences = (R_len_t)occurences.size();
//      if (noccurences <= 0) {
//         SEXP ans;
//         STRI__PROTECT(ans = Rf_allocVector(STRSXP, 1));
//         SET_STRING_ELT(ans, 0, Rf_mkCharLen("", 0));
//         SET_VECTOR_ELT(ret, i, ans);
//         STRI__UNPROTECT(1);
//         continue;
//      }
//
//      SEXP ans;
//      STRI__PROTECT(ans = Rf_allocVector(STRSXP, noccurences));
//      deque< pair<R_len_t,R_len_t> >::iterator iter = occurences.begin();
//      for (R_len_t j = 0; iter != occurences.end(); ++iter, ++j) {
//         SET_STRING_ELT(ans, j, Rf_mkCharLenCE(str_cur_s+(*iter).first,
//            (*iter).second-(*iter).first, CE_UTF8));
//      }
//      SET_VECTOR_ELT(ret, i, ans);
//      STRI__UNPROTECT(1);
      
   }
   
   if (briter) { delete briter; briter = NULL; }
   if (str_text) { utext_close(str_text); str_text = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      if (briter) { delete briter; briter = NULL; }
      if (str_text) { utext_close(str_text); str_text = NULL; }
   })
}



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
//	double* costm = (double*)R_alloc(n*n, (int)sizeof(double)); // don't use R_alloc!!
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
