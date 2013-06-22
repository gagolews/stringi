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
 * vectorized over str, length and pad
 * if str or pad or length is NA the result will be NA
 *
 * @param str character vector
 * @param length integer vector
 * @param pad character vector
 * @return character vector
 * 
 * @version 0.1 (Bartlomiej Tartanus)
 * @version 0.2 (Bartlomiej Tartanus, 2013-06-21) uses StriContainerUTF16 & ICU's padLeading
*/
SEXP stri_pad(SEXP str, SEXP length, SEXP pad)
{
   str    = stri_prepare_arg_string(str, "str"); // prepare string argument
   length = stri_prepare_arg_integer(length, "length");
   pad    = stri_prepare_arg_string(pad, "pad");
   
   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(length), LENGTH(pad));
   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, vectorize_length));
   
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF16 str_cont(str, vectorize_length, false);
   StriContainerUTF16 pad_cont(pad, vectorize_length);
   StriContainerInteger length_cont(length, vectorize_length);
   
   for (R_len_t i = 0; i < vectorize_length; i++)
   {
      if (pad_cont.isNA(i) || str_cont.isNA(i) || length_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      if (pad_cont.get(i).length() > 0) {
         UChar cur_pad = (pad_cont.get(i))[0]; // This is Uchar - 16 bit.....
         str_cont.getWritable(i).padLeading(length_cont.get(i), cur_pad);
      }
      
      SET_STRING_ELT(ret, i, str_cont.toR(i));
   }
   
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}

