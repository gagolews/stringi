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
 * @version 0.1-?? (Marek Gagolewski)
 * @version 0.1-?? (Marek Gagolewski) - use StriContainerUTF8's vectorization
 * @version 0.1-?? (Marek Gagolewski, 2013-06-15) use StriContainerInteger
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16) make StriException friendly
*/
SEXP stri_dup(SEXP str, SEXP times)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   times = stri_prepare_arg_integer(times, "times"); // prepare string argument
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(times));
   if (vectorize_length <= 0) return Rf_allocVector(STRSXP, 0);

   STRI__ERROR_HANDLER_BEGIN
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
   String8 buf(bufsize);
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

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
         SET_STRING_ELT(ret, i, Rf_mkCharLen("", 0));
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
         memcpy(buf.data()+str_last_index, str_cur->c_str(), (size_t)str_cur_n);
      }

      // the result is always in UTF-8
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), max_index, CE_UTF8));
   }


   // STEP 4.
   // Clean up & finish

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
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
 * @version 0.1-?? (Marek Gagolewski)
 * @version 0.1-?? (Marek Gagolewski) - use StriContainerUTF8's vectorization
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16) make StriException friendly
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

   STRI__ERROR_HANDLER_BEGIN
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
   String8 buf(nchar);
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length)); // output vector

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
         memcpy(buf.data(), cur_string_1->c_str(), (size_t)last_buf_idx);
      }

      const String8* cur_string_2 = &(e2_cont.get(i));
      R_len_t  cur_len_2 = cur_string_2->length();
      memcpy(buf.data()+last_buf_idx, cur_string_2->c_str(), (size_t)cur_len_2);
      // the result is always in UTF-8
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), last_buf_idx+cur_len_2, CE_UTF8));
   }

   // 4. Cleanup & finish
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}




/**
 * Concatenate Character Vectors
 * @param strlist list of character vectors
 * @param sep single string
 * @param collapse single string
 * @return character vector
 *
 *
 * @version 0.1-?? (Marek Gagolewski)
 * @version 0.1-?? (Marek Gagolewski) - use StriContainerUTF8's vectorization
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16) make StriException-friendly, useStriContainerListUTF8
 * @version 0.1-12 (Marek Gagolewski, 2013-12-04) fixed bug #49
 */
SEXP stri_join(SEXP strlist, SEXP sep, SEXP collapse)
{
   strlist = stri_prepare_arg_list_string(strlist, "...");
   R_len_t strlist_length = LENGTH(strlist);
   if (strlist_length <= 0) return stri__vector_empty_strings(0);

   // get length of the longest character vector
   R_len_t vectorize_length = 0;
   for (R_len_t i=0; i<strlist_length; ++i) {
      R_len_t strlist_cur_length = LENGTH(VECTOR_ELT(strlist, i));
      if (strlist_cur_length <= 0) return stri__vector_empty_strings(0);
      if (strlist_cur_length > vectorize_length) vectorize_length = strlist_cur_length;
   }

   sep = stri_prepare_arg_string_1(sep, "sep");
   if (STRING_ELT(sep, 0) == NA_STRING)
      return stri__vector_NA_strings(vectorize_length);

   // an often occuring case - we have a specialized function for this :-)
   if (LENGTH(STRING_ELT(sep,0)) == 0 && strlist_length == 2) {
      if (isNull(collapse))
         return stri_join2(VECTOR_ELT(strlist, 0), VECTOR_ELT(strlist, 1));
      else
         return stri_flatten(stri_join2(VECTOR_ELT(strlist, 0), VECTOR_ELT(strlist, 1)), collapse);
   }

   SEXP ret;
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 ssep(sep, 1);
   const char* sep_char = ssep.get(0).c_str();
   R_len_t     sep_len  = ssep.get(0).length();


   StriContainerListUTF8 strlist_cont(strlist, vectorize_length);


   // 4. Get buf size and check out NAs
   R_len_t buf_maxbytes = 0;
   vector<bool> whichNA(vectorize_length, false);
   for (R_len_t i=0; i<vectorize_length; ++i) {
      for (R_len_t j=0; j<strlist_length; ++j) {
         if (strlist_cont.get(j).isNA(i)) {
            whichNA[i] = true;
            break;
         }
      }
      if (!whichNA[i]) {
         R_len_t curchar = 0;
         for (R_len_t j=0; j<strlist_length; ++j) {
            curchar += strlist_cont.get(j).get(i).length() + ((j<strlist_length-1)?sep_len:0);
         }
         if (curchar > buf_maxbytes) buf_maxbytes = curchar;
      }
   }

   // 5. Create ret val
   String8 buf(buf_maxbytes);
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (whichNA[i]) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      R_len_t cursize = 0;
      for (R_len_t j=0; j<strlist_length; ++j) {

         const String8* curstring = &(strlist_cont.get(j).get(i));
         memcpy(buf.data()+cursize, curstring->c_str(), (size_t)curstring->length());
         cursize += curstring->length();

         if (j < strlist_length-1 && sep_len > 0) {
            memcpy(buf.data()+cursize, sep_char, (size_t)sep_len);
            cursize += sep_len;
         }
      }

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), cursize, CE_UTF8));
   }


   UNPROTECT(1);
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)

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
 * @version 0.1-?? (Marek Gagolewski)
 * @version 0.1-?? (Marek Gagolewski) - StriContainerUTF8 - any R Encoding
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16) make StriException friendly
 */
SEXP stri_flatten_nosep(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);
   if (str_length <= 0) return str;

   STRI__ERROR_HANDLER_BEGIN
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
   String8 buf(nchar);
   R_len_t cur = 0;
   for (int i=0; i<str_length; ++i) {
      R_len_t ncur = str_cont.get(i).length();
      memcpy(buf.data()+cur, str_cont.get(i).c_str(), (size_t)ncur);
      cur += ncur;
   }


   // 3. Get ret val & solongfarewellaufwiedersehenadieu
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, 1));
   SET_STRING_ELT(ret, 0, Rf_mkCharLenCE(buf.data(), nchar, CE_UTF8));
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/** String vector flatten, with separator possible between each string
 *
 *  if any of str is NA, the result will be NA_character_
 *
 *  @param str character vector
 *  @param collapse a single string [R name: collapse]
 *  @return if s is not empty, then a character vector of length 1
 *
 * @version 0.1-?? (Marek Gagolewski)
 * @version 0.1-?? (Bartek Tartanus) - collapse arg added (1 sep supported)
 * @version 0.1-?? (Marek Gagolewski) - StriContainerUTF8 - any R Encoding
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16) make StriException friendly
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

   STRI__ERROR_HANDLER_BEGIN
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
   String8 buf(nbytes);
   R_len_t cur = 0;
   for (int i=0; i<str_length; ++i) {
      R_len_t ncur = str_cont.get(i).length();
      memcpy(buf.data()+cur, str_cont.get(i).c_str(), (size_t)ncur);
      cur += ncur;
      if (i < str_length-1 && collapse_nbytes > 0) {
         memcpy(buf.data()+cur, collapse_s, (size_t)collapse_nbytes);
         cur += collapse_nbytes;
      }
   }


   // 3. Get ret val & solongfarewellaufwiedersehenadieu
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, 1));
   SET_STRING_ELT(ret, 0, Rf_mkCharLenCE(buf.data(), nbytes, CE_UTF8));
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
