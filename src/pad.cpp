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
 * Pad a string
 * 
 * vectorized over s, length and pad
 *  if str or pad is NA the result will be NA
 *
 * @param str
 * @param length
 * @param pad
 * @return character vector
 * 
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus 21-06-2013) uses StriContainerUTF16
*/
SEXP stri_pad(SEXP str, SEXP length, SEXP pad)
{
   str   = stri_prepare_arg_string(str, "str"); // prepare string argument
   length= stri_prepare_arg_integer(length, "length");
   pad   = stri_prepare_arg_string(pad, "pad");
   
   R_len_t nmax = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(length), LENGTH(pad));
   
   SEXP ret, curs;
   PROTECT(ret = allocVector(STRSXP, nmax));
   
   StriContainerUTF16* ss = new StriContainerUTF16(str, nmax, false);
   StriContainerUTF16* pp = new StriContainerUTF16(pad, nmax);
   
   int* ilen = INTEGER(length);
   int  nlen = LENGTH(length);
   
   for (R_len_t i = 0; i < nmax; i++)
   {
      if (pp->isNA(i) || ss->isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      if(pp->get(i).length()){
         UChar32 cur_pad = (pp->get(i))[0];
         ss->getWritable(i).padLeading(ilen[i%nlen], cur_pad);
      }
      
      SET_STRING_ELT(ret, i, ss->toR(i));
   }
   
   UNPROTECT(1);
   return ret;
}

