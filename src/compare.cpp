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


/** 
 * Compare character vectors, with collation
 * 
 * @param e1 character vector
 * @param e2 character vector
 * @param strength single integer
 * @param locale single string identifying the locale ("" or NULL for default locale)
 * @return integer vector
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_compare(SEXP e1, SEXP e2, SEXP strength, SEXP locale)
{
   const char* qloc = stri__prepare_arg_locale(locale, true);
   Locale loc = Locale::createFromName(qloc);
   
   strength = stri_prepare_arg_integer(strength);
   if (LENGTH(strength) == 0) error(MSG__INCORRECT_INTERNAL_ARG);
   else if (LENGTH(strength) > 1) warning(MSG__STRENGTH_EXPECTED1);
   
   e1 = stri_prepare_arg_string(e1); // prepare string argument
   e2 = stri_prepare_arg_string(e2); // prepare string argument
   R_len_t ne1 = LENGTH(e1);
   R_len_t ne2 = LENGTH(e2);
   R_len_t nout = stri__recycling_rule(true, 2, ne1, ne2);
   
   UErrorCode err = U_ZERO_ERROR;
   Collator* col = Collator::createInstance(loc, err);
   if (!U_SUCCESS(err)) {
      error(MSG__RESOURCE_ERROR_GET);
   }
   
   err = U_ZERO_ERROR;
   col->setAttribute(UCOL_STRENGTH, (UColAttributeValue)(INTEGER(strength)[0]-1), err);
   if (!U_SUCCESS(err)) {
      delete col;
      error(MSG__RESOURCE_ERROR_GET);
   }
   
   
   StriContainerUTF16* se1 = new StriContainerUTF16(e1, nout);
   StriContainerUTF16* se2 = new StriContainerUTF16(e2, nout);
   
   
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nout));
   
   for (R_len_t i = se1->vectorize_init();
         i != se1->vectorize_end();
         i = se1->vectorize_next(i))
   {
      if (se1->isNA(i) || se2->isNA(i)) {
         INTEGER(ret)[i] = NA_INTEGER;
         continue;
      }
      
      INTEGER(ret)[i] = (int)col->compare(se1->get(i), se2->get(i));
   }
   
   delete col;
   delete se1;
   delete se2;
   UNPROTECT(1);
   return ret;
}





/** help struct for stri_order **/
struct StriSort {
   StriContainerUTF16* ss;
   bool decreasing;
   Collator* col;
   StriSort(StriContainerUTF16* ss, Collator* col, bool decreasing)
   { this->ss = ss; this->col = col; this->decreasing = decreasing; }
   
   bool operator() (int a, int b) const
   {
      int ret = ((int)col->compare(ss->get(a-1), ss->get(b-1)));
      if (decreasing) return (ret > 0);
      else return (ret < 0);
   }
};
   
   
/** Ordering Permutation (string comparison with collation)
 * 
 * @param str character vector
 * @param decreasing single logical value
 * @param strength single integer
 * @param locale single string identifying the locale ("" or NULL for default locale)
 * @return integer vector (permutation)
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_order(SEXP str, SEXP decreasing, SEXP strength, SEXP locale)
{
   const char* qloc = stri__prepare_arg_locale(locale, true);
   Locale loc = Locale::createFromName(qloc);
   
   decreasing = stri_prepare_arg_logical(decreasing);
   if (LENGTH(decreasing) == 0) error(MSG__INCORRECT_INTERNAL_ARG);
   else if (LENGTH(decreasing) > 1) warning(MSG__DECREASING_EXPECTED1);
   
   strength = stri_prepare_arg_integer(strength);
   if (LENGTH(strength) == 0) error(MSG__INCORRECT_INTERNAL_ARG);
   else if (LENGTH(strength) > 1) warning(MSG__STRENGTH_EXPECTED1);
   
   str = stri_prepare_arg_string(str); // prepare string argument
   R_len_t nout = LENGTH(str);
   
   UErrorCode err = U_ZERO_ERROR;
   Collator* col = Collator::createInstance(loc, err);
   if (!U_SUCCESS(err)) {
      error(MSG__RESOURCE_ERROR_GET);
   }

   err = U_ZERO_ERROR;
   col->setAttribute(UCOL_STRENGTH, (UColAttributeValue)(INTEGER(strength)[0]-1), err);
   if (!U_SUCCESS(err)) {
      delete col;
      error(MSG__RESOURCE_ERROR_GET);
   }
   
   StriContainerUTF16* ss = new StriContainerUTF16(str, nout);
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, nout));
   
   // count NA values
   R_len_t countNA = 0;
   for (R_len_t i=0; i<nout; ++i)
      if (ss->isNA(i))
         ++countNA;
   
   // NAs must be put at end (note the stable sort behavior!)
   int* order = INTEGER(ret);
   R_len_t k1 = 0;
   R_len_t k2 = nout-countNA;
   for (R_len_t i=0; i<nout; ++i) {
      if (ss->isNA(i))
         order[k2++] = i+1;
      else
         order[k1++] = i+1;
   }
   
   
   // TO DO: use sort keys...
   
   bool decr = (LOGICAL(decreasing)[0]==true);
   
   // check if already sorted - if not - sort!
   for (R_len_t i = 0; i<nout-countNA-1; ++i) {
      int val = ((int)col->compare(ss->get(i), ss->get(i+1)));
      if ((decr && val < 0) || (!decr && val > 0)) {
         // sort! 
         StriSort comp(ss, col, decr);
         std::vector<int> data;
         data.assign(order, order+nout-countNA);
         std::stable_sort(data.begin(), data.end(), comp);
         R_len_t i=0;
         for (std::vector<int>::iterator it=data.begin(); it!=data.end(); ++it, ++i)
            order[i] = *it;
         break;
      }
   }

  
   delete col;
   delete ss;
   UNPROTECT(1);
   return ret;
}
