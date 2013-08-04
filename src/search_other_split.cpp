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
 * Split a string into text lines
 *
 * @param str character vector
 * @return list of character vectors
 *
 * @version 0.1 (Marek Gagolewski, 2013-08-04)
 */
SEXP stri_split_lines(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_n = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, str_n);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, str_n));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      throw StriException("TO DO");
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
