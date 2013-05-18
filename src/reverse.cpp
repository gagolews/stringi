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

/** 
 * Reverse Each String 
 * @param str character vector
 * @return character vector with every string reversed
 * 
 *  
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8
 */
SEXP stri_reverse(SEXP str)
{
   str = stri_prepare_arg_string(str);    // prepare string argument
   
   StriContainerUTF16* ss = new StriContainerUTF16(str, LENGTH(str), false); // writable, no recycle

   for (R_len_t i = ss->vectorize_init();
         i != ss->vectorize_end();
         i = ss->vectorize_next(i))
   {
      if (!ss->isNA(i)) {
         UErrorCode status = U_ZERO_ERROR;
         ss->getWritable(i).reverse(); // Use ICU facilities
      }
   }
   
   SEXP ret;
   PROTECT(ret = ss->toR());
   delete ss;
   UNPROTECT(1);
   return ret;
}

