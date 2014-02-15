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
 * Detect if a character class occurs in a string
 *
 * @param str character vector
 * @param pattern character vector
 * @return logical vector
 *
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-02) Use StrContainerUTF8 and CharClass classes
 * @version 0.3 (Marek Gagolewski, 2013-06-15) Use StrContainerCharClass
 * @version 0.4 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_detect_charclass(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerCharClass pattern_cont(pattern, vectorize_length);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, vectorize_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i = pattern_cont.vectorize_init();
         i != pattern_cont.vectorize_end();
         i = pattern_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i) || pattern_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      CharClass pattern_cur = pattern_cont.get(i);
      R_len_t     str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      ret_tab[i] = FALSE;
      R_len_t j;
      UChar32 chr;

      for (j=0; j<str_cur_n; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, chr);
         if (pattern_cur.test(chr)) {
            ret_tab[i] = TRUE;
            break;
         }
      }
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
