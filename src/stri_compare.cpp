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
#include "stri_container_utf8.h"
#include "stri_container_utf16.h"
#include <unicode/ucol.h>
#include <vector>
#include <algorithm>


/** Compare 2 strings in UTF8, codepoint-wise [internal]
 * 
 * Used by stri_order_codepoints and stri_cmp_codepoints
 *
 * @param str1 string in UTF8
 * @param str2 string in UTF8
 * @param n1 length of str1
 * @param n2 length of str2
 * @return -1, 0, or 1, like in strcmp
 *
 * @version 0.1-?? (Marek Gagolewski)
 * 
 * @version 0.2-1 (Marek Gagolewski, 2014-03-19)
 *          BUGFIX: possibly incorrect results for strings of inequal number
 *                  of codepoints
 */
int stri__cmp_codepoints(const char* str1, R_len_t n1, const char* str2, R_len_t n2)
{
   // @NOTE: strangely, this is being outperformed by ucol_strcollUTF8
   //        in some benchmarks...
   int i1 = 0;
   int i2 = 0;
   UChar32 c1 = 0;
   UChar32 c2 = 0;
   while (c1 == c2 && i1 < n1 && i2 < n2) {
      // we could use U8_NEXT_OR_FFFD here - but it's ICU51 DRAFT API
      U8_NEXT(str1, i1, n1, c1);
      U8_NEXT(str2, i2, n2, c2);
   }
   
   if (c1 < c2)
      return -1;
   else if (c1 > c2)
      return 1;

   // reached here => first i1==i2 codepoints are the same
   if (i1 < n1)      return  1;
   else if (i2 < n2) return -1;
   else              return  0;
}


/**
 * Check for equality of 2 character strings, byte-wise [internal]
 *
 * @param e1 character vector
 * @param e2 character vector
 * 
 * @return logical vector
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-19)
 *
 */
int stri__cmp_eq_codepoints(const char* cur1_s, R_len_t cur1_n, const char* cur2_s, R_len_t cur2_n)
{
   if (cur1_n != cur2_n) // different number of bytes => not equal
      return FALSE;
   
   // some memcmp implementations are very fast:
   return (memcmp(cur1_s, cur2_s, cur1_n) == 0);
}





/* *************************************************************************
                                  STRI_CMP_LOGICAL
   ************************************************************************* */



/**
 * Compare elements in 2 character vectors,
 * possibly with collation
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param collator_opts passed to stri__ucol_open()
 * @param type [internal] vector of length 2,
 * type[0]: 0 for ==, -1 for < and 1 for >,
 * type[1]: 0 or 1 (whether to negate the results)
 * 
 * @return logical vector
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-19)
 */
SEXP stri_cmp_logical(SEXP e1, SEXP e2, SEXP collator_opts, SEXP type)
{
   UCollator* col = NULL;
   col = stri__ucol_open(collator_opts);
   
   // we'll perform a collator-based cmp
   // type is an internal arg, check manually, error() allowed here
   if (!Rf_isInteger(type) || LENGTH(type) != 2)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG);
   int _type = INTEGER(type)[0];
   int _negate = INTEGER(type)[1];
   if (_type > 1 || _type < -1 || _negate < 0 || _negate > 1)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG);
      
   e1 = stri_prepare_arg_string(e1, "e1"); // prepare string argument
   e2 = stri_prepare_arg_string(e2, "e2"); // prepare string argument
   
   STRI__ERROR_HANDLER_BEGIN

   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));

   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_int = INTEGER(ret);

   for (R_len_t i = 0; i < vectorize_length; ++i)
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         ret_int[i] = NA_LOGICAL;
         continue;
      }

      R_len_t     cur1_n = e1_cont.get(i).length();
      const char* cur1_s = e1_cont.get(i).c_str();
      R_len_t     cur2_n = e2_cont.get(i).length();
      const char* cur2_s = e2_cont.get(i).c_str();

      if (col) {
         // with collation
         UErrorCode status = U_ZERO_ERROR;
         ret_int[i] = (_type == (int)ucol_strcollUTF8(col,
            cur1_s, cur1_n, cur2_s, cur2_n, &status
         ));
         if (U_FAILURE(status))
            throw StriException(status);
      }
      else {
         // codepoint-based cmp
         if (_type == 0) // eq/neq: very fast
            ret_int[i] = stri__cmp_eq_codepoints(cur1_s, cur1_n, cur2_s, cur2_n);
         else
            ret_int[i] = (_type == stri__cmp_codepoints(cur1_s, cur1_n, cur2_s, cur2_n));
      }
         
      if (_negate)
         ret_int[i] = !ret_int[i];
   }

   if (col) {
      ucol_close(col);
      col = NULL;
   }
   UNPROTECT(1);
   return ret;

   STRI__ERROR_HANDLER_END({
      if (col) { ucol_close(col); col = NULL; }
   })
}
/* *************************************************************************
                                  STRI_CMP
   ************************************************************************* */


/**
 * Compare character vectors, possibly with collation
 *
 * @param e1 character vector
 * @param e2 character vector
 * @param collator_opts passed to stri__ucol_open()
 * 
 * @return integer vector, like strcmp in C
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException friendly
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-27)
 *          moved to UTF16, as ucol_strcollUTF8 is DRAFT
 * 
 * @version 0.2-1  (Marek Gagolewski, 2014-03-16)
 *          using ucol_strcollUTF8 again, as we now require ICU >= 50
 *          [4x speedup utf8, 2x slowdown 8bit]
 * 
 * @version 0.2-1 (Marek Gagolewski, 2014-03-19)
 *          one function for cmp with and without collation
 */
SEXP stri_cmp(SEXP e1, SEXP e2, SEXP collator_opts)
{
   UCollator* col = NULL;
   col = stri__ucol_open(collator_opts);

   e1 = stri_prepare_arg_string(e1, "e1");
   e2 = stri_prepare_arg_string(e2, "e2");

   STRI__ERROR_HANDLER_BEGIN

   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));

   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);


   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, vectorize_length));
   int* ret_int = INTEGER(ret);

   for (R_len_t i = 0; i < vectorize_length; ++i)
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         ret_int[i] = NA_INTEGER;
         continue;
      }
      
      R_len_t     cur1_n = e1_cont.get(i).length();
      const char* cur1_s = e1_cont.get(i).c_str();
      R_len_t     cur2_n = e2_cont.get(i).length();
      const char* cur2_s = e2_cont.get(i).c_str();

      if (col) {
         // cmp with collation
         UErrorCode status = U_ZERO_ERROR;
         ret_int[i] = (int)ucol_strcollUTF8(col,
            cur1_s, cur1_n, cur2_s, cur2_n, &status
         );
         if (U_FAILURE(status))
            throw StriException(status);
      }
      else {
         // codepoint-wise cmp
         ret_int[i] = stri__cmp_codepoints(cur1_s, cur1_n, cur2_s, cur2_n);
         
         // possible slowdown due to the fact that whole vectors are possibly
         // re-encoded, and the comparison result may be determined by
         // comparing e.g. the first codepoint
         // ?? TO DO: try with ucnv_getNextUChar ??
      }
   }

   if (col) {
      ucol_close(col);
      col = NULL;
   }
   UNPROTECT(1);
   return ret;

   STRI__ERROR_HANDLER_END({
      if (col) { ucol_close(col); col = NULL; }
   })
}





/** help struct for stri_order **/
struct StriSortCollator {
   StriContainerUTF16* ss;
   bool decreasing;
   UCollator* col;
   StriSortCollator(StriContainerUTF16* _ss, UCollator* _col, bool _decreasing)
   { this->ss = _ss; this->col = _col; this->decreasing = _decreasing; }

   bool operator() (int a, int b) const
   {
      int ret = (int)ucol_strcoll(col,
         ss->get(a-1).getBuffer(), ss->get(a-1).length(),
         ss->get(b-1).getBuffer(), ss->get(b-1).length());
      if (decreasing) return (ret > 0);
      else return (ret < 0);
   }
};



/* *************************************************************************
                                  STRI_ORDER
   ************************************************************************* */

/** help struct for stri_order **/
struct StriSortCodepoints {
   StriContainerUTF8* ss;
   bool decreasing;
   StriSortCodepoints(StriContainerUTF8* _ss, bool _decreasing)
   { this->ss = _ss; this->decreasing = _decreasing; }

   bool operator() (int a, int b) const
   {
      int ret = (int)stri__cmp_codepoints(
         ss->get(a-1).c_str(), ss->get(a-1).length(),
         ss->get(b-1).c_str(), ss->get(b-1).length()
      );
      if (decreasing) return (ret > 0);
      else return (ret < 0);
   }
};


/** Generate the ordering permutation, with collation
 *
 * @param str character vector
 * @param decreasing single logical value
 * @param collator_opts passed to stri__ucol_open()
 * @return integer vector (permutation)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *                 make StriException friendly
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-27)
 *                 Use UTF16 as ucol_strcollUTF8 is DRAFT
 */
SEXP stri_order(SEXP str, SEXP decreasing, SEXP collator_opts)
{
   bool decr = stri__prepare_arg_logical_1_notNA(decreasing, "decreasing");
   str = stri_prepare_arg_string(str, "str"); // prepare string argument

   UCollator* col = NULL;
   col = stri__ucol_open(collator_opts);
   if (!col)
      return stri_order_codepoints(str, decreasing);

   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = LENGTH(str);
   StriContainerUTF16 str_cont(str, vectorize_length);
   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, vectorize_length));

   // count NA values
   R_len_t countNA = 0;
   for (R_len_t i=0; i<vectorize_length; ++i)
      if (str_cont.isNA(i))
         ++countNA;

   // NAs must be put at end (note the stable sort behavior!)
   // TO DO: let the user decide how to play with NAs [end, begin, remove]
   int* order = INTEGER(ret);
   R_len_t k1 = 0;
   R_len_t k2 = vectorize_length-countNA;
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (str_cont.isNA(i))
         order[k2++] = i+1;
      else
         order[k1++] = i+1;
   }


   // TO DO: think of using sort keys...
   // however, now it's quite fast...

   // check if already sorted - if not - sort!
   for (R_len_t i = 0; i<vectorize_length-countNA-1; ++i) {
      int val = (int)ucol_strcoll(col,
            str_cont.get(order[i]-1).getBuffer(),   str_cont.get(order[i]-1).length(),
            str_cont.get(order[i+1]-1).getBuffer(), str_cont.get(order[i+1]-1).length());

      if ((decr && val < 0) || (!decr && val > 0)) {
         // sort!
         std::vector<int> data;
         data.assign(order, order+vectorize_length-countNA);
            StriSortCollator comp(&str_cont, col, decr);
            std::stable_sort(data.begin(), data.end(), comp);
         R_len_t j = 0;
         for (std::vector<int>::iterator it=data.begin(); it!=data.end(); ++it, ++j)
            order[j] = *it;
         break; // sorted, finish
      }
   }


   if (col) {
      ucol_close(col);
      col = NULL;
   }
   UNPROTECT(1);
   return ret;

   STRI__ERROR_HANDLER_END({
      if (col) ucol_close(col);
   })
}



/** Generate the ordering permutation, codepoint-wise
 *
 * @param str character vector
 * @param decreasing single logical value
 * @return integer vector (permutation)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-27)
 */
SEXP stri_order_codepoints(SEXP str, SEXP decreasing)
{
   bool decr = stri__prepare_arg_logical_1_notNA(decreasing, "decreasing");
   str = stri_prepare_arg_string(str, "str"); // prepare string argument

   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = LENGTH(str);
   StriContainerUTF8 str_cont(str, vectorize_length);
   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, vectorize_length));

   // count NA values
   R_len_t countNA = 0;
   for (R_len_t i=0; i<vectorize_length; ++i)
      if (str_cont.isNA(i))
         ++countNA;

   // NAs must be put at end (note the stable sort behavior!)
   // TO DO: let the user decide how to play with NAs [end, begin, remove]
   int* order = INTEGER(ret);
   R_len_t k1 = 0;
   R_len_t k2 = vectorize_length-countNA;
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (str_cont.isNA(i))
         order[k2++] = i+1;
      else
         order[k1++] = i+1;
   }


   // TO DO: think of using sort keys...
   // however, now it's quite fast...

   // check if already sorted - if not - sort!
   for (R_len_t i = 0; i<vectorize_length-countNA-1; ++i) {
      int val = stri__cmp_codepoints(
            str_cont.get(order[i]-1).c_str(),   str_cont.get(order[i]-1).length(),
            str_cont.get(order[i+1]-1).c_str(), str_cont.get(order[i+1]-1).length()
         );

      if ((decr && val < 0) || (!decr && val > 0)) {
         // sort!
         std::vector<int> data;
         data.assign(order, order+vectorize_length-countNA);
         StriSortCodepoints comp(&str_cont, decr);
         std::stable_sort(data.begin(), data.end(), comp);
         R_len_t j=0;
         for (std::vector<int>::iterator it=data.begin(); it!=data.end(); ++it, ++j)
            order[j] = *it;
         break; // sorted, finish
      }
   }


   UNPROTECT(1);
   return ret;

   STRI__ERROR_HANDLER_END( ; /*nothing special on error*/)
}
