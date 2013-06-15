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
 *  @param str character vector
 *  @param times integer vector
 *  @return character vector
 * 
 *  The function is vectorized over str and times
 *  if str is NA or times is NA the result will be NA
 *  if times<0 the result will be NA
 *  if times==0 the result will be an empty string
 *  if str or times is an empty vector then the result is an empty vector
 *  
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8's vectorization
 * @version 0.3 (Marek Gagolewski, 2013-06-15) use StriContainerInteger
*/
SEXP stri_dup(SEXP str, SEXP times)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   times = stri_prepare_arg_integer(times, "times"); // prepare string argument
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(times));
   if (vectorize_length <= 0) return allocVector(STRSXP, 0);
   
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerInteger times_cont(times, vectorize_length);
   
   // STEP 1.
   // Calculate the required buffer length
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (str_cont.isNA(i) || times_cont.isNA(i))
         continue;
         
      R_len_t cursize = times_cont.get(i) * str_cont.get(i).size();
      if (cursize > bufsize)
         bufsize = cursize;
   }
   
   // STEP 2.
   // Alloc buffer & result vector
   char* buf = new char[bufsize+1];   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, vectorize_length));

   // STEP 3.
   // Duplicate
   const String8* str_last = NULL; // this will allow for reusing buffer...
   R_len_t str_last_index  = 0;    // ...useful for stri_dup('a', 1:1000) or stri_dup('a', 1000:1)
   
   for (R_len_t i = str_cont.vectorize_init(); // this iterator allows for...
         i != str_cont.vectorize_end();        // ...smart buffer reusage
         i = str_cont.vectorize_next(i))
   {
      R_len_t times_cur;
      if (str_cont.isNA(i) || times_cont.isNA(i) || (times_cur = times_cont.get(i)) < 0) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      const String8* str_cur = &(str_cont.get(i));
      R_len_t str_cur_n = str_cur->length();
      if (times_cur <= 0 || str_cur_n <= 0) {
         SET_STRING_ELT(ret, i, mkCharLen("", 0));
         continue;
      }
      
      // all right, here the result will neither be NA nor an empty string
      
      if (str_cur != str_last) {
         // well, no reuse possible - resetting
         str_last = str_cur;
         str_last_index = 0;
      }
      
      // we paste only "additional" duplicates
      R_len_t max_index = str_cur_n*times_cur;
      for (; str_last_index < max_index; str_last_index += str_cur_n) {
         memcpy(buf+str_last_index, str_cur->c_str(), str_cur_n);
      }
      
      // the result is always in UTF-8
      SET_STRING_ELT(ret, i, mkCharLenCE(buf, max_index, CE_UTF8));
   }
   
   
   // STEP 4.
   // Clean up & finish
   
   delete buf;
   UNPROTECT(1);
   return ret;
}




/** Join two character vectors, element by element
 * 
 * Vectorized over e1 and e2. Optimized for |e1| >= |e2|
 * @param e1 character vector
 * @param e2 character vector
 * @return character vector, res_i=s1_i + s2_i for |e1|==|e2|
 *  if e1 or e2 is NA then result is NA
 *  if e1 or e2 is empty, then the result is just e1 or e2
 *  
 *  
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8's vectorization
*/
SEXP stri_join2(SEXP e1, SEXP e2)
{
   e1 = stri_prepare_arg_string(e1, "e1"); // prepare string argument
   e2 = stri_prepare_arg_string(e2, "e2"); // prepare string argument
   
   R_len_t e1_length = LENGTH(e1);
   R_len_t e2_length = LENGTH(e2);
   R_len_t vectorize_length = stri__recycling_rule(true, 2, e1_length, e2_length);
   
   if (e1_length <= 0) return e1;
   if (e2_length <= 0) return e2;
   
   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);
   
   // 1. find maximal length of the buffer needed
   R_len_t nchar = 0;
   for (int i=0; i<vectorize_length; ++i) {
      if (e1_cont.isNA(i) || e2_cont.isNA(i))
         continue;
      
      R_len_t c1 = e1_cont.get(i).length();
      R_len_t c2 = e2_cont.get(i).length();
         
      if (c1+c2 > nchar) nchar = c1+c2;
   }
   
   // 2. Create buf & retval
   char* buf = new char[nchar+1]; // NULL not needed, but nchar could be == 0
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, vectorize_length)); // output vector
   
   // 3. Set retval
   const String8* last_string_1 = NULL;
   R_len_t last_buf_idx = 0;
   for (R_len_t i = e1_cont.vectorize_init(); // this iterator allows for...
         i != e1_cont.vectorize_end();        // ...smart buffer reusage
         i = e1_cont.vectorize_next(i))
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      // If e1 has length < length of e2, this will be faster:      
      const String8* cur_string_1 = &(e1_cont.get(i));
      if (cur_string_1 != last_string_1) {
         last_string_1 = cur_string_1;
         last_buf_idx = cur_string_1->length();
         memcpy(buf, cur_string_1->c_str(), last_buf_idx);
      }
      
      const String8* cur_string_2 = &(e2_cont.get(i));
      R_len_t  cur_len_2 = cur_string_2->length();
      memcpy(buf+last_buf_idx, cur_string_2->c_str(), cur_len_2);
      // the result is always in UTF-8
      SET_STRING_ELT(ret, i, mkCharLenCE(buf, last_buf_idx+cur_len_2, CE_UTF8));
   }
   
   // 4. Cleanup & finish
   delete buf;
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
   R_len_t vectorize_length = 0; // length of the longest character vector
   for (R_len_t i=0; i<narg; ++i) {
      SEXP cur = stri_prepare_arg_string(VECTOR_ELT(s, i), "...");  
      R_len_t ncur = LENGTH(cur);
      SET_VECTOR_ELT(s, i, cur); // Here we are sure that this is legal and does not influence other objects
      if (ncur <= 0) return stri__vector_empty_strings(0);
      if (ncur > vectorize_length) vectorize_length = ncur;
   }
   
   // 2. Prepare sep
   sep = stri_prepare_arg_string_1(sep, "sep");   
   if (STRING_ELT(sep, 0) == NA_STRING)
      return stri__vector_NA_strings(vectorize_length);
   StriContainerUTF8 ssep(sep, 1);
   const char* sep_char = ssep.get(0).c_str();
   R_len_t     sep_len  = ssep.get(0).length();
   
   
   // an often occuring case - we have a specialized function for this :-)
   if (sep_len == 0 && narg == 2) {
      if (isNull(collapse))
         return stri_join2(VECTOR_ELT(s, 0), VECTOR_ELT(s, 1));
      else
         return stri_flatten(stri_join2(VECTOR_ELT(s, 0), VECTOR_ELT(s, 1)), collapse);
   }
   
   // 3. Convert character vectors to be concatenated
   // @TODO: add StriContainerListUTF8 class
   StriContainerUTF8** ss = new StriContainerUTF8*[narg];
   for (R_len_t i=0; i<narg; ++i) {
      ss[i] = new StriContainerUTF8(VECTOR_ELT(s, i), vectorize_length);
   }
   
   // 4. Get buf size
   R_len_t nchar = 0;
   for (R_len_t i=0; i<vectorize_length; ++i) {
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
   PROTECT(ret = allocVector(STRSXP, vectorize_length));
   
   for (R_len_t i=0; i<vectorize_length; ++i) {
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
   for (R_len_t i=0; i<narg; ++i)  // |
      delete ss[i];                // | @TODO: add StriContainerListUTF8 class
   delete [] ss;                   // |
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
SEXP stri_flatten_nosep(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   
   R_len_t str_length = LENGTH(str);
   if (str_length <= 0) return str;
   
   StriContainerUTF8 str_cont(str, str_length);
   
   // 1. Get required buffer size
   R_len_t nchar = 0;
   for (int i=0; i<str_length; ++i) {
      if (str_cont.isNA(i)) {
         return stri__vector_NA_strings(1); // at least 1 NA => return NA
      }
      nchar += str_cont.get(i).length();
   }
   
   // 2. Fill the buf!
   char* buf = new char[nchar+1]; // NULL not needed, but nchar could be == 0
   R_len_t cur = 0;
   for (int i=0; i<str_length; ++i) {
      R_len_t ncur = str_cont.get(i).length();
      memcpy(buf+cur, str_cont.get(i).c_str(), ncur);
      cur += ncur;
   }
   
   
   // 3. Get ret val & solongfarewellaufwiedersehenadieu
   SEXP ret; 
   PROTECT(ret = allocVector(STRSXP, 1));
   SET_STRING_ELT(ret, 0, mkCharLenCE(buf, nchar, CE_UTF8));
   delete buf;
   UNPROTECT(1);
   return ret;
}


/** String vector flatten, with separator possible between each string
 *
 *  if any of str is NA, the result will be NA_character_
 * 
 *  @param str character vector
 *  @param collapse a single string [R name: collapse]
 *  @return if s is not empty, then a character vector of length 1 
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Bartek Tartanus) - collapse arg added (1 sep supported)
 * @version 0.3 (Marek Gagolewski) - StriContainerUTF8 - any R Encoding
 */
SEXP stri_flatten(SEXP str, SEXP collapse)
{
   // Check if collapse is given?
   collapse = stri_prepare_arg_string_1(collapse, "collapse");
   str = stri_prepare_arg_string(str, "str"); // prepare string argument   
   R_len_t str_length = LENGTH(str);
   if (str_length <= 0) return stri__vector_empty_strings(0);
   
   if (STRING_ELT(collapse, 0) == NA_STRING)
      return stri__vector_NA_strings(1);
   
   
   StriContainerUTF8 str_cont(str, str_length);
   StriContainerUTF8 collapse_cont(collapse, 1);
   R_len_t collapse_nbytes = collapse_cont.get(0).length();
   const char* collapse_s = collapse_cont.get(0).c_str();
   
   
   
   // 1. Get required buffer size
   R_len_t nbytes = 0;
   for (int i=0; i<str_length; ++i) {
      if (str_cont.isNA(i)) {
         return stri__vector_NA_strings(1); // at least 1 NA => return NA
      }
      nbytes += str_cont.get(i).length() + ((i<str_length-1)?collapse_nbytes:0);
   }

   
   // 2. Fill the buf!
   char* buf = new char[nbytes+1]; // NULL not needed, but nbytes could be == 0
   R_len_t cur = 0;
   for (int i=0; i<str_length; ++i) {
      R_len_t ncur = str_cont.get(i).length();
      memcpy(buf+cur, str_cont.get(i).c_str(), ncur);
      cur += ncur;
      if (i < str_length-1 && collapse_nbytes > 0) {
         memcpy(buf+cur, collapse_s, collapse_nbytes);
         cur += collapse_nbytes;  
      }
   }
   
   
   // 3. Get ret val & solongfarewellaufwiedersehenadieu
   SEXP ret; 
   PROTECT(ret = allocVector(STRSXP, 1));
   SET_STRING_ELT(ret, 0, mkCharLenCE(buf, nbytes, CE_UTF8));
   delete buf;
   UNPROTECT(1);
   return ret;
}

