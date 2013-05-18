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
 * Convert case (TitleCase, lowercase, UPPERCASE, etc.)
 * 
 * 
 *  @param str character vector
 *  @param type internal code of case conversion type 
 *  @return character vector
 *  
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF8
*/
SEXP stri_casefold(SEXP str, SEXP type)
{
   str = stri_prepare_arg_string(str); // prepare string argument
   
   if (!isInteger(type) || LENGTH(type) != 1)
      error(MSG__INCORRECT_INTERNAL_ARG);
      
   int _type = INTEGER(type)[0];
   
   StriContainerUTF16* ss = new StriContainerUTF16(str, LENGTH(str), false); // writable, no recycle
   
   for (R_len_t i = ss->vectorize_init();
         i != ss->vectorize_end();
         i = ss->vectorize_next(i))
   {
      if (!ss->isNA(i)) {
         switch (_type) {
            case 1:
               ss->getWritable(i).toLower();
               break;
            case 2:
               ss->getWritable(i).toUpper();
               break;
            case 3:
               ss->getWritable(i).toTitle(NULL); // use default ICU's BreakIterator
               break;
            case 4:
               ss->getWritable(i).foldCase(U_FOLD_CASE_DEFAULT);
               break;
            case 5:
               ss->getWritable(i).foldCase(U_FOLD_CASE_EXCLUDE_SPECIAL_I);
               break;
            default:
               error("stri_casefold: incorrect case conversion type");
         }
      }
   }
   
   SEXP ret;
   PROTECT(ret = ss->toR());
   delete ss;
   // normalizer shall not be deleted at all
   UNPROTECT(1);
   return ret;
}
