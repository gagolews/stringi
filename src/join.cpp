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




/** Duplicate given strings
 * 
 *
 *  @param s character vector
 *  @param c integer vector == times
 *  @return character vector;
 * 
 *  The function is vectorized over s and c
 *  if s is NA or c is NA the result will be NA
 *  if c<0 the result will be NA
 *  if c==0 the result will be an empty string
 *  if s or c is an empty vector then the result is an empty vector
 *  
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8's vectorization
*/
SEXP stri_dup(SEXP s, SEXP c)
{
   s = stri_prepare_arg_string(s, "str"); // prepare string argument
   c = stri_prepare_arg_integer(c, "times"); // prepare string argument
   R_len_t nc = LENGTH(c);
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(s), nc);
   if (nmax <= 0) return allocVector(STRSXP, 0);
   
   int* cc = INTEGER(c);
   StriContainerUTF8* ss = new StriContainerUTF8(s, nmax);
   
   // STEP 1.
   // Calculate the required buffer length
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      if (ss->isNA(i) || cc[i % nc] == NA_INTEGER)
         continue;
         
      R_len_t cursize = cc[i % nc]*ss->get(i).size();
      if (cursize > bufsize)
         bufsize = cursize;
   }
   
   // STEP 2.
   // Alloc buffer & result vector
   char* buf = new char[bufsize+1];   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));

   // STEP 3.
   // Duplicate
   const String8* last_string = NULL; // this will allow for reusing buffer...
   R_len_t last_index = 0;                // ...useful for stri_dup('a', 1:1000) or stri_dup('a', 1000:1)
   
   for (R_len_t i = ss->vectorize_init(); // this iterator allows for...
         i != ss->vectorize_end();        // ...smart buffer reusage
         i = ss->vectorize_next(i))
   {
      R_len_t cur_dups = cc[i % nc];
      if (ss->isNA(i) || cur_dups == NA_INTEGER || cur_dups < 0)
         SET_STRING_ELT(ret, i, NA_STRING);
      else {
         const String8* cur_string = &ss->get(i);
         R_len_t cur_length = cur_string->length();
         if (cur_dups <= 0 || cur_length <= 0) {
            SET_STRING_ELT(ret, i, mkCharLen("", 0));
            continue;
         }
         
         // all right, here the result will neither be NA nor an empty string
         
         if (cur_string != last_string) {
            // well, no reuse possible - resetting
            last_string = cur_string;
            last_index = 0;
         }
         
         // we paste only "additional" duplicates
         R_len_t max_index = cur_length*cur_dups;
         for (; last_index < max_index; last_index += cur_length) {
            memcpy(buf+last_index, cur_string->c_str(), cur_length);
         }
         
         // the result is always in UTF-8
         SET_STRING_ELT(ret, i, mkCharLenCE(buf, max_index, CE_UTF8));
      }
   }
   
   
   // STEP 4.
   // Clean up & finish
   
   delete buf;
   delete ss;
   UNPROTECT(1);
   return ret;
}




/** Join two character vectors, element by element
 * 
 * Vectorized over s1 and s2. Optimized for |s1| >= |s2|
 * @param s1 character vector
 * @param s2 character vector
 * @return character vector, res_i=s1_i + s2_i for |s1|==|s2|
 *  if s1 or s2 is NA then result is NA
 *  if s1 or s2 is empty, then the result is just s1 or s2
 *  
 *  
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8's vectorization
*/
SEXP stri_join2(SEXP s1, SEXP s2)
{
   s1 = stri_prepare_arg_string(s1, "e1"); // prepare string argument
   s2 = stri_prepare_arg_string(s2, "e2"); // prepare string argument
   
   R_len_t ns1 = LENGTH(s1);
   R_len_t ns2 = LENGTH(s2);
   R_len_t nmax = stri__recycling_rule(true, 2, ns1, ns2);
   
   if (ns1 <= 0) return s1;
   if (ns2 <= 0) return s2;
   
   StriContainerUTF8* ss1 = new StriContainerUTF8(s1, nmax);
   StriContainerUTF8* ss2 = new StriContainerUTF8(s2, nmax);
   
   // 1. find maximal length of the buffer needed
   R_len_t nchar = 0;
   for (int i=0; i<nmax; ++i) {
      if (ss1->isNA(i) || ss2->isNA(i))
         continue;
      
      R_len_t c1 = ss1->get(i).length();
      R_len_t c2 = ss2->get(i).length();
         
      if (c1+c2 > nchar) nchar = c1+c2;
   }
   
   // 2. Create buf & retval
   char* buf = new char[nchar+1]; // NULL not needed, but nchar could be == 0
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax)); // output vector
   
   // 3. Set retval
   const String8* last_string_1 = NULL;
   R_len_t last_buf_idx = 0;
   for (R_len_t i = ss1->vectorize_init(); // this iterator allows for...
         i != ss1->vectorize_end();        // ...smart buffer reusage
         i = ss1->vectorize_next(i))
   {
      if (ss1->isNA(i) || ss2->isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      // If e1 has length < length of e2, this will be faster:      
      const String8* cur_string_1 = &(ss1->get(i));
      if (cur_string_1 != last_string_1) {
         last_string_1 = cur_string_1;
         last_buf_idx = cur_string_1->length();
         memcpy(buf, cur_string_1->c_str(), last_buf_idx);
      }
      
      const String8* cur_string_2 = &(ss2->get(i));
      R_len_t  cur_len_2 = cur_string_2->length();
      memcpy(buf+last_buf_idx, cur_string_2->c_str(), cur_len_2);
      // the result is always in UTF-8
      SET_STRING_ELT(ret, i, mkCharLenCE(buf, last_buf_idx+cur_len_2, CE_UTF8));
   }
   
   // 4. Cleanup & finish
   delete buf;
   delete ss1;
   delete ss2;
   UNPROTECT(1);
   return ret;
}




/**
 * Concatenate Character Vectors
 * @param s list of character vectors
 * @param sep single string
 * @param collapse single string
 * @return character vector
 * 
 *  
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8's vectorization
 */
SEXP stri_join(SEXP s, SEXP sep, SEXP collapse)
{
   // 1. Check whether s is a list, prepare string agrs,
   //    calculate length of the longest char. vect.
   if (!isVectorList(s))
      error(MSG__INCORRECT_INTERNAL_ARG); // this shouldn't happen (see R call)
   R_len_t narg = LENGTH(s);
   if (narg <= 0) return stri__vector_empty_strings(0);
   
#ifndef NDEBUG
   // check whether we are free to change s
   // if this has been called in R as list(...) - it must be OK
   if (NAMED(s) > 0) error(MSG__INTERNAL_ERROR);
#endif
   R_len_t nmax = 0; // length of the longest character vector
   for (R_len_t i=0; i<narg; ++i) {
      SEXP cur = stri_prepare_arg_string(VECTOR_ELT(s, i), "...");  
      R_len_t ncur = LENGTH(cur);
      SET_VECTOR_ELT(s, i, cur); // Here we are sure that this is legal and does not influence other objects
      if (ncur <= 0) return stri__vector_empty_strings(0);
      if (ncur > nmax) nmax = ncur;
   }
   
   // 2. Prepare sep
   sep = stri_prepare_arg_string_1(sep, "sep");   
   if (STRING_ELT(sep, 0) == NA_STRING)
      return stri__vector_NA_strings(nmax);
   StriContainerUTF8* ssep = new StriContainerUTF8(sep, 1);
   const char* sep_char = ssep->get(0).c_str();
   R_len_t     sep_len  = ssep->get(0).length();
   
   
   // an often occuring case - we have a specialized function for this :-)
   if (sep_len == 0 && narg == 2) {
      if (isNull(collapse))
         return stri_join2(VECTOR_ELT(s, 0), VECTOR_ELT(s, 1));
      else
         return stri_flatten(stri_join2(VECTOR_ELT(s, 0), VECTOR_ELT(s, 1)), collapse);
   }
   
   // 3. Convert character vectors to be concatenated
   StriContainerUTF8** ss = new StriContainerUTF8*[narg];
   for (R_len_t i=0; i<narg; ++i) {
      ss[i] = new StriContainerUTF8(VECTOR_ELT(s, i), nmax);
   }
   
   // 4. Get buf size
   R_len_t nchar = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      R_len_t curchar = 0;
      for (R_len_t j=0; j<narg; ++j) {
         if (ss[j]->isNA(i)) {
            curchar = 0;
            break;
         }
         curchar += ss[j]->get(i).length() + ((j<narg-1)?sep_len:0);
      }
      
      if (curchar > nchar) nchar = curchar;
   }
   
   // 5. Create ret val
   char* buf = new char[nchar+1];
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
   
   for (R_len_t i=0; i<nmax; ++i) {
      bool anyNA = false;
      R_len_t cursize = 0;
      for (R_len_t j=0; j<narg; ++j) {
         if (ss[j]->isNA(i)) {
            anyNA = true;
            break;
         }
         
         const String8* curstring = &(ss[j]->get(i));
         memcpy(buf+cursize, curstring->c_str(), curstring->length());
         cursize += curstring->length();
         
         if (j < narg-1 && sep_len > 0) {
            memcpy(buf+cursize, sep_char, sep_len);
            cursize += sep_len;
         }
      }
      
      if (anyNA)
         SET_STRING_ELT(ret, i, NA_STRING);
      else
         SET_STRING_ELT(ret, i, mkCharLenCE(buf, cursize, CE_UTF8));
   }
   
   
   // 6. Clean up & return
   for (R_len_t i=0; i<narg; ++i)
      delete ss[i];
   delete [] ss;
   delete ssep;
   delete buf;
   UNPROTECT(1);
   
   if (isNull(collapse))
      return ret;
   else
      return stri_flatten(ret, collapse);
}




/** String vector flatten, with no separator
 *
 *  if any of s is NA, the result will be NA_character_
 * 
 *  @param s character vector
 *  @return if s is not empty, then a character vector of length 1 
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - StriContainerUTF8 - any R Encoding
 */
SEXP stri_flatten_nosep(SEXP s)
{
   s = stri_prepare_arg_string(s, "str");
   
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return s;
   
   StriContainerUTF8* ss = new StriContainerUTF8(s, ns);
   
   // 1. Get required buffer size
   R_len_t nchar = 0;
   for (int i=0; i<ns; ++i) {
      if (ss->isNA(i)) {
         delete ss;
         return stri__vector_NA_strings(1); // at least 1 NA => return NA
      }
      nchar += ss->get(i).length();
   }
   
   // 2. Fill the buf!
   char* buf = new char[nchar+1]; // NULL not needed, but nchar could be == 0
   R_len_t cur = 0;
   for (int i=0; i<ns; ++i) {
      R_len_t ncur = ss->get(i).length();
      memcpy(buf+cur, ss->get(i).c_str(), ncur);
      cur += ncur;
   }
   
   
   // 3. Get ret val & solongfarewellaufwiedersehenadieu
   SEXP ret; 
   PROTECT(ret = allocVector(STRSXP, 1));
   SET_STRING_ELT(ret, 0, mkCharLenCE(buf, nchar, CE_UTF8));
   delete buf;
   delete ss;
   UNPROTECT(1);
   return ret;
}


/** String vector flatten, with separator possible between each string
 *
 *  if any of s is NA, the result will be NA_character_
 * 
 *  @param s character vector
 *  @param collapse a single string [R name: collapse]
 *  @return if s is not empty, then a character vector of length 1 
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Bartek Tartanus) - collapse arg added (1 sep supported)
 * @version 0.3 (Marek Gagolewski) - StriContainerUTF8 - any R Encoding
 */
SEXP stri_flatten(SEXP s, SEXP collapse)
{
   // Check if collapse is given?
   collapse = stri_prepare_arg_string_1(collapse, "collapse");
   s = stri_prepare_arg_string(s, "str"); // prepare string argument   
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return stri__vector_empty_strings(0);
   
   if (STRING_ELT(collapse, 0) == NA_STRING)
      return stri__vector_NA_strings(1);
   
   StriContainerUTF8* scollapse = new StriContainerUTF8(collapse, 1);
   
   R_len_t ncharcollapse = scollapse->get(0).length();
   
   StriContainerUTF8* ss = new StriContainerUTF8(s, ns);
   
   // 1. Get required buffer size
   R_len_t nchar = 0;
   for (int i=0; i<ns; ++i) {
      if (ss->isNA(i)) {
         delete scollapse;
         delete ss;
         return stri__vector_NA_strings(1); // at least 1 NA => return NA
      }
      nchar += ss->get(i).length() + ((i<ns-1)?ncharcollapse:0);
   }

   
   // 2. Fill the buf!
   char* buf = new char[nchar+1]; // NULL not needed, but nchar could be == 0
   R_len_t cur = 0;
   for (int i=0; i<ns; ++i) {
      R_len_t ncur = ss->get(i).length();
      memcpy(buf+cur, ss->get(i).c_str(), ncur);
      cur += ncur;
      if (i < ns-1 && ncharcollapse > 0) {
         memcpy(buf+cur, scollapse->get(0).c_str(), ncharcollapse);
         cur += ncharcollapse;  
      }
   }
   
   
   // 3. Get ret val & solongfarewellaufwiedersehenadieu
   SEXP ret; 
   PROTECT(ret = allocVector(STRSXP, 1));
   SET_STRING_ELT(ret, 0, mkCharLenCE(buf, nchar, CE_UTF8));
   delete buf;
   delete scollapse;
   delete ss;
   UNPROTECT(1);
   return ret;
}

