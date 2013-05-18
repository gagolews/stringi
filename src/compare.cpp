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
   
   e1 = stri_prepare_arg_string(e1); // prepare string argument
   e2 = stri_prepare_arg_string(e2); // prepare string argument
   strength = stri_prepare_arg_integer(strength);
   
   if (LENGTH(strength) == 0) error(MSG__INCORRECT_INTERNAL_ARG);
   else if (LENGTH(strength) > 1) warning(MSG__STRENGTH_EXPECTED1);
   
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
   error("to do");
   return R_NilValue;
}
