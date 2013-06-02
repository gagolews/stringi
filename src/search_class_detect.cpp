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
 * Detect if a character class occurs in a string
 * 
 * @param str character vector
 * @param pattern character vector
 * @return logical vector
 * 
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski, 2013-06-02) Use StrContainerUTF8 and CharClass classes
 */
SEXP stri_detect_class(SEXP str, SEXP pattern)
{
   str = stri_prepare_arg_string(str, "str");
   pattern = stri_prepare_arg_string(pattern, "pattern");
   R_len_t nmax = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
   
   StriContainerUTF8* ss = new StriContainerUTF8(str, nmax);
   
   SEXP ret;
   PROTECT(ret = allocVector(LGLSXP, nmax));
   int* ret_tab = LOGICAL(ret);
   
   CharClass cc;
   const char* last_pattern = 0;
   for (R_len_t i=0; i<nmax; ++i) {
      SEXP cur_pattern = STRING_ELT(pattern, i%nmax);
      
      if (ss->isNA(i) || cur_pattern == NA_STRING) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }
      
      if (last_pattern != CHAR(cur_pattern)) {
         last_pattern = CHAR(cur_pattern);
         cc = CharClass(cur_pattern); // it's a simple struct => fast copy
      }
      
      if (cc.isNA()) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }
      
      R_len_t curn = ss->get(i).length();
      const char* curs = ss->get(i).c_str();
            ret_tab[i] = FALSE;
      R_len_t j;
      UChar32 chr;
      
      for (j=0; j<curn; ) {
         U8_NEXT(curs, j, curn, chr);
         if (cc.test(chr)) {
            ret_tab[i] = TRUE;
            break;
         } 
      }
   }

   delete ss;
   UNPROTECT(1);
   return ret;
}



