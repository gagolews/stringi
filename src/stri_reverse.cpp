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

/**
 * Reverse Each String
 * @param str character vector
 * @return character vector with every string reversed
 *
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - use StriContainerUTF16
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly + StriContainerUTF8 (bug fix, do reversing manually)
 */
SEXP stri_reverse(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");    // prepare string argument

   STRI__ERROR_HANDLER_BEGIN
   R_len_t str_len = LENGTH(str);
   StriContainerUTF8 str_cont(str, str_len); // writable, no recycle

   // STEP 1.
   // Calculate the required buffer length
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<str_len; ++i) {
      if (str_cont.isNA(i))
         continue;

      R_len_t cursize = str_cont.get(i).size();
      if (cursize > bufsize)
         bufsize = cursize;
   }

   // STEP 2.
   // Alloc buffer & result vector
   String8 buf(bufsize);
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, str_len));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      R_len_t str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();

      R_len_t j, k;
      UChar32 chr;
      UBool isError = FALSE;

      for (j=str_cur_n, k=0; j>0; ) {
         U8_PREV(str_cur_s, 0, j, chr); // go backwards
         U8_APPEND((uint8_t*)buf.data(), k, str_cur_n, chr, isError);
      }

      if (isError)
         throw StriException(MSG__INTERNAL_ERROR);

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), str_cur_n, CE_UTF8));
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
