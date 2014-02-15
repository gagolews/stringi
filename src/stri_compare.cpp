/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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


#include "stri_stringi.h"



/** compare 2 strings in UTF8, Unicode codepoint comparison-only [internal]
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
 * @version 0.2 (Marek Gagolewski, 2013-06-16) make StriException friendly
 */
SEXP stri__compare_codepoints(SEXP e1, SEXP e2)
{
   e1 = stri_prepare_arg_string(e1, "e1"); // prepare string argument
   e2 = stri_prepare_arg_string(e2, "e2"); // prepare string argument

   STRI__ERROR_HANDLER_BEGIN
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));

   StriContainerUTF8 e1_cont(e1, vectorize_length);
   StriContainerUTF8 e2_cont(e2, vectorize_length);


   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, vectorize_length));
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
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
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
 * @version 0.2 (Marek Gagolewski, 2013-06-16) make StriException friendly
 * @version 0.3 (Marek Gagolewski, 2013-06-27) moved to UTF16, as ucol_strcollUTF8 is DRAFT
 */
SEXP stri_compare(SEXP e1, SEXP e2, SEXP collator_opts)
{
   e1 = stri_prepare_arg_string(e1, "e1");
   e2 = stri_prepare_arg_string(e2, "e2");

   UCollator* col = NULL;
   col = stri__ucol_open(collator_opts);
   if (!col)
      return stri__compare_codepoints(e1, e2);

   STRI__ERROR_HANDLER_BEGIN

   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(e1), LENGTH(e2));

   StriContainerUTF16 e1_cont(e1, vectorize_length);
   StriContainerUTF16 e2_cont(e2, vectorize_length);


   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, vectorize_length));
   int* ret_int = INTEGER(ret);

   for (R_len_t i = e1_cont.vectorize_init();
         i != e1_cont.vectorize_end();
         i = e1_cont.vectorize_next(i))
   {
      if (e1_cont.isNA(i) || e2_cont.isNA(i)) {
         ret_int[i] = NA_INTEGER;
         continue;
      }

//      UErrorCode status = U_ZERO_ERROR;
//      StringPiece s1(e1_cont.get(i).c_str(), e1_cont.get(i).length());
//      StringPiece s2(e2_cont.get(i).c_str(), e2_cont.get(i).length());
//      ret_int[i] = (int)collator.compareUTF8(s1, s2, status);

      ret_int[i] = (int)ucol_strcoll(col,
         e1_cont.get(i).getBuffer(), e1_cont.get(i).length(),
         e2_cont.get(i).getBuffer(), e2_cont.get(i).length());
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







/** help struct for stri_order **/
struct StriSortCodepoints {
   StriContainerUTF8* ss;
   bool decreasing;
   StriSortCodepoints(StriContainerUTF8* _ss, bool _decreasing)
   { this->ss = _ss; this->decreasing = _decreasing; }

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


/** Ordering Permutation (string comparison with collation)
 *
 * @param str character vector
 * @param decreasing single logical value
 * @param collator_opts passed to stri__ucol_open()
 * @return integer vector (permutation)
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski, 2013-06-16) make StriException friendly
 * @version 0.3 (Marek Gagolewski, 2013-06-27) Use UTF16 as strcollutf8 is DRAFT
 */
SEXP stri_order(SEXP str, SEXP decreasing, SEXP collator_opts)
{
   bool decr = stri__prepare_arg_logical_1_notNA(decreasing, "decreasing");
   str = stri_prepare_arg_string(str, "str"); // prepare string argument

   UCollator* col = NULL;
   col = stri__ucol_open(collator_opts);
   if (!col)
      return stri__order_codepoints(str, decreasing);

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



/** Ordering Permutation (string comparison by unicode codepoints)
 *
 * @param str character vector
 * @param decreasing single logical value
 * @return integer vector (permutation)
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-27)
 */
SEXP stri__order_codepoints(SEXP str, SEXP decreasing)
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
      int val = stri__compare_codepoints(
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
