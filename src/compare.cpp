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



/** compare 2 strings in UTF8, Unicode codepoint comparison-only
 * @param str1 string in UTF8
 * @param str2 string in UTF8
 * @param n1 length of str1
 * @param n2 length of str2
 * @return -1, 0, or 1, like in strcmp
 */
int stri__compare_codepoints(const char* str1, R_len_t n1, const char* str2, R_len_t n2)
{
   int i1 = 0;
   int i2 = 0;
   UChar32 c1;
   UChar32 c2;
   while (i1 < n1 && i2 < n2) {
      U8_NEXT(str1, i1, n1, c1);
      U8_NEXT(str2, i2, n2, c2);
      if (c1 < c2)
         return -1;
      else if (c1 > c2)
         return 1;
//    else move on
   }
   
   // reached here => i1==i2 first codepoints are the same
   // result is based on length
   if (n1 < n2) return -1;
   else if (n1 > n2) return 1;
   else return 0;
}


/** 
 * Compare character vectors (by unicode codepoints)
 * 
 * @param e1 character vector
 * @param e2 character vector
 * @return integer vector
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_compare_codepoints(SEXP e1, SEXP e2)
{
   e1 = stri_prepare_arg_string(e1, "e1"); // prepare string argument
   e2 = stri_prepare_arg_string(e2, "e2"); // prepare string argument
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));
   
   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);
   
   
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, vectorize_length));
   int* ret_int = INTEGER(ret);
   
   for (R_len_t i = e1_cont.vectorize_init();
         i != e1_cont.vectorize_end();
         i = e1_cont.vectorize_next(i))
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         ret_int[i] = NA_INTEGER;
      }
      else {
         ret_int[i] = stri__compare_codepoints(
            e1_cont.get(i).c_str(), e1_cont.get(i).length(),
            e2_cont.get(i).c_str(), e2_cont.get(i).length()
         );
      }
   }

   UNPROTECT(1);
   return ret;
}



/** 
 * Compare character vectors, with collation
 * 
 * @param e1 character vector
 * @param e2 character vector
 * @param collator_opts passed to stri__ucol_open()
 * @return integer vector
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_compare(SEXP e1, SEXP e2, SEXP collator_opts)
{
   UCollator* col = stri__ucol_open(collator_opts);
   if (!col)
      return stri_compare_codepoints(e1, e2);
      
   e1 = stri_prepare_arg_string(e1, "e1"); // prepare string argument
   e2 = stri_prepare_arg_string(e2, "e2"); // prepare string argument
   
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));
   
   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);
   
   
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, vectorize_length));
   int* ret_int = INTEGER(ret);
   
   for (R_len_t i = e1_cont.vectorize_init();
         i != e1_cont.vectorize_end();
         i = e1_cont.vectorize_next(i))
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         ret_int[i] = NA_INTEGER;
         continue;
      }
      
      UErrorCode err = U_ZERO_ERROR;
      ret_int[i] = (int)ucol_strcollUTF8(col,
         e1_cont.get(i).c_str(), e1_cont.get(i).length(),
         e2_cont.get(i).c_str(), e2_cont.get(i).length(),
         &err);
   }
   
   if (col) ucol_close(col);
   UNPROTECT(1);
   return ret;
}





/** help struct for stri_order **/
struct StriSortCollator {
   StriContainerUTF8* ss;
   bool decreasing;
   UCollator* col;
   StriSortCollator(StriContainerUTF8* ss, UCollator* col, bool decreasing)
   { this->ss = ss; this->col = col; this->decreasing = decreasing; }
   
   bool operator() (int a, int b) const
   {
      UErrorCode err = U_ZERO_ERROR;
      int ret = (int)ucol_strcollUTF8(col,
         ss->get(a-1).c_str(), ss->get(a-1).length(),
         ss->get(b-1).c_str(), ss->get(b-1).length(),
         &err);
      if (decreasing) return (ret > 0);
      else return (ret < 0);
   }
};
   
   
   
   



/** help struct for stri_order **/
struct StriSortCodepoints {
   StriContainerUTF8* ss;
   bool decreasing;
   StriSortCodepoints(StriContainerUTF8* ss, bool decreasing)
   { this->ss = ss; this->decreasing = decreasing; }
   
   bool operator() (int a, int b) const
   {
      int ret = (int)stri__compare_codepoints(
         ss->get(a-1).c_str(), ss->get(a-1).length(),
         ss->get(b-1).c_str(), ss->get(b-1).length()
      );
      if (decreasing) return (ret > 0);
      else return (ret < 0);
   }
};
   
   
/** Ordering Permutation (string comparison with collation or by unicode codepoints)
 * 
 * @param str character vector
 * @param decreasing single logical value
 * @param collator_opts passed to stri__ucol_open()
 * @return integer vector (permutation)
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_order(SEXP str, SEXP decreasing, SEXP collator_opts)
{
   UCollator* col = stri__ucol_open(collator_opts);      
   bool decr = stri__prepare_arg_logical_1_notNA(decreasing, "decreasing");
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   R_len_t vectorize_length = LENGTH(str);
   
   StriContainerUTF8 str_cont(str, vectorize_length);
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, vectorize_length));
   
   // count NA values
   R_len_t countNA = 0;
   for (R_len_t i=0; i<vectorize_length; ++i)
      if (str_cont.isNA(i))
         ++countNA;
   
   // NAs must be put at end (note the stable sort behavior!)
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
      UErrorCode err = U_ZERO_ERROR;
      
      int val;
      if (col) {
         val = (int)ucol_strcollUTF8(col,
            str_cont.get(order[i]-1).c_str(),   str_cont.get(order[i]-1).length(),
            str_cont.get(order[i+1]-1).c_str(), str_cont.get(order[i+1]-1).length(),
            &err);
      }
      else {
         val = stri__compare_codepoints(
            str_cont.get(order[i]-1).c_str(),   str_cont.get(order[i]-1).length(),
            str_cont.get(order[i+1]-1).c_str(), str_cont.get(order[i+1]-1).length()
         );
      }
         
      if ((decr && val < 0) || (!decr && val > 0)) {
         // sort! 
         std::vector<int> data;
         data.assign(order, order+vectorize_length-countNA);
         if (col) {
            StriSortCollator comp(&str_cont, col, decr);
            std::stable_sort(data.begin(), data.end(), comp);
         } else {
            StriSortCodepoints comp(&str_cont, decr);
            std::stable_sort(data.begin(), data.end(), comp);
         }
         R_len_t i=0;
         for (std::vector<int>::iterator it=data.begin(); it!=data.end(); ++it, ++i)
            order[i] = *it;
         break; // sorted, finish
      }
   }

  
   if (col) ucol_close(col);
   UNPROTECT(1);
   return ret;
}


