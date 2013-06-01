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
 * Get substring
 * 
 * 
 * @param str character vector
 * @param from integer vector (possibly with negative indices)
 * @param to integer vector (possibly with negative indices) or NULL
 * @param length integer vector or NULL
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus)  stri_sub
 * @version 0.2 (Marek Gagolewski) use StriContainerUTF8 and stri__UChar32_to_UTF8_index
 * @version 0.3 (Marek Gagolewski, 2013-06-01) use StriContainerUTF8's UCha32-to-UTF8 index
 */
SEXP stri_sub(SEXP str, SEXP from, SEXP to, SEXP length)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_n = LENGTH(str);
   
   int* from_tab    = 0;
   int* to_tab      = 0;
   int* length_tab  = 0;
   R_len_t from_n   = 0;
   R_len_t to_n     = 0;
   R_len_t length_n = 0;
   R_len_t nmax     = 0; 
   
   bool from_ismatrix = isMatrix(from);
   if (from_ismatrix) {
      SEXP t = getAttrib(from, R_DimSymbol);
      if (INTEGER(t)[1] == 1) from_ismatrix = false; // don't treat this as matrix
      else if (INTEGER(t)[1] > 2)
         error(MSG__ARG_EXPECTED_MATRIX_WITH_GIVEN_COLUMNS, "from", 2);
   }
   from = stri_prepare_arg_integer(from, "from");
   
   if (from_ismatrix) {
      from_n = to_n = LENGTH(from)/2;
      from_tab = INTEGER(from);
      to_tab = from_tab+from_n;
      nmax = stri__recycling_rule(true, 2, str_n, from_n);
   }
   else if (isNull(length)) {
      to = stri_prepare_arg_integer(to, "to");
      from_n = LENGTH(from);
      from_tab = INTEGER(from);
      to_n = LENGTH(to);
      to_tab = INTEGER(to);
      nmax = stri__recycling_rule(true, 3, str_n, from_n, to_n);
   }
   else {
      length = stri_prepare_arg_integer(length, "length");
      from_n = LENGTH(from);
      from_tab = INTEGER(from);
      length_n = LENGTH(length);
      length_tab = INTEGER(length);
      nmax = stri__recycling_rule(true, 3, str_n, from_n, length_n);
   }

   
   if (nmax <= 0)
      return allocVector(STRSXP,0);
      
   StriContainerUTF8* se = new StriContainerUTF8(str, nmax);
   
   // args prepared, let's go
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
   
   for (R_len_t i = se->vectorize_init();
         i != se->vectorize_end();
         i = se->vectorize_next(i))
   {
      R_len_t cur_from     = from_tab[i % from_n];
      R_len_t cur_to       = (to_tab)?to_tab[i % to_n]:length_tab[i % length_n];
      if (se->isNA(i) || cur_from == NA_INTEGER || cur_to == NA_INTEGER) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      if (length_tab) {
         if (cur_to <= 0) {
            SET_STRING_ELT(ret, i, R_BlankString);
            continue;
         }
         cur_to = cur_from + cur_to - 1;
         if (cur_from < 0 && cur_to >= 0) cur_to = -1;
      }
      
      const char* cur_s = se->get(i).c_str();
      R_len_t cur_n = se->get(i).length();
      

      R_len_t cur_from2; // UTF-8 byte incices
      R_len_t cur_to2;   // UTF-8 byte incices
      
      if (cur_from >= 0) {
         cur_from--; // 1-based -> 0-based index
         cur_from2 = se->UChar32_to_UTF8_index_fwd(i, cur_from);
      }
      else {
         cur_from = -cur_from;
         cur_from2 = se->UChar32_to_UTF8_index_back(i, cur_from);
      }
         
      if (cur_to >= 0) {
         ; // do nothing with cur_to // 1-based -> 0-based index but +1 as we need the next one (bound)
         cur_to2 = se->UChar32_to_UTF8_index_fwd(i, cur_to);
      }
      else {
         cur_to = -cur_to - 1;
         cur_to2 = se->UChar32_to_UTF8_index_back(i, cur_to);
      }
      
      if (cur_to2 > cur_from2) { // just copy
         SET_STRING_ELT(ret, i, mkCharLenCE(cur_s+cur_from2, cur_to2-cur_from2, CE_UTF8));  
      }
      else {
         // maybe a warning here?
         SET_STRING_ELT(ret, i, mkCharLen(NULL, 0));
      }
   }
   
   delete se;
   UNPROTECT(1); 
   return ret;
}




/** 
 * Substring replacement function
 * 
 * 
 * @param str character vector
 * @param from integer vector (possibly with negative indices)
 * @param to integer vector (possibly with negative indices) or NULL
 * @param length integer vector or NULL
 * @param value character vector replacement
 * @return character vector
 * 
 * @version 0.1 (Bartek Tartanus)  
 * @version 0.2 (Marek Gagolewski) use StriContainerUTF8 and stri__UChar32_to_UTF8_index
 * @version 0.3 (Marek Gagolewski, 2013-06-01) use StriContainerUTF8's UCha32-to-UTF8 index
 */
SEXP stri_sub_replacement(SEXP str, SEXP from, SEXP to, SEXP length, SEXP value)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_n = LENGTH(str);
   value = stri_prepare_arg_string(value, "value");
   R_len_t value_n = LENGTH(value);
   
   int* from_tab    = 0;
   int* to_tab      = 0;
   int* length_tab  = 0;
   R_len_t from_n   = 0;
   R_len_t to_n     = 0;
   R_len_t length_n = 0;
   R_len_t nmax     = 0; 
   
   bool from_ismatrix = isMatrix(from);
   if (from_ismatrix) {
      SEXP t = getAttrib(from, R_DimSymbol);
      if (INTEGER(t)[1] == 1) from_ismatrix = false; // don't treat this as matrix
      else if (INTEGER(t)[1] > 2)
         error(MSG__ARG_EXPECTED_MATRIX_WITH_GIVEN_COLUMNS, "from", 2);
   }
   from = stri_prepare_arg_integer(from, "from");
   
   if (from_ismatrix) {
      from_n = to_n = LENGTH(from)/2;
      from_tab = INTEGER(from);
      to_tab = from_tab+from_n;
      nmax = stri__recycling_rule(true, 3, str_n, from_n, value_n);
   }
   else if (isNull(length)) {
      to = stri_prepare_arg_integer(to, "to");
      from_n = LENGTH(from);
      from_tab = INTEGER(from);
      to_n = LENGTH(to);
      to_tab = INTEGER(to);
      nmax = stri__recycling_rule(true, 4, str_n, from_n, to_n, value_n);
   }
   else {
      length = stri_prepare_arg_integer(length, "length");
      from_n = LENGTH(from);
      from_tab = INTEGER(from);
      length_n = LENGTH(length);
      length_tab = INTEGER(length);
      nmax = stri__recycling_rule(true, 4, str_n, from_n, length_n, value_n);
   }

   
   if (nmax <= 0)
      return allocVector(STRSXP,0);
      
   StriContainerUTF8* se = new StriContainerUTF8(str, nmax);
   StriContainerUTF8* sval = new StriContainerUTF8(value, nmax);
   
   // args prepared, let's go
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, nmax));
   
   const char* last_s = 0;

   
   for (R_len_t i = se->vectorize_init();
         i != se->vectorize_end();
         i = se->vectorize_next(i))
   {
      R_len_t cur_from     = from_tab[i % from_n];
      R_len_t cur_to       = (to_tab)?to_tab[i % to_n]:length_tab[i % length_n];
      if (se->isNA(i) || cur_from == NA_INTEGER || cur_to == NA_INTEGER || sval->isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      if (length_tab) {
         if (cur_to <= 0) {
            SET_STRING_ELT(ret, i, R_BlankString);
            continue;
         }
         cur_to = cur_from + cur_to - 1;
         if (cur_from < 0 && cur_to >= 0) cur_to = -1;
      }
      
      const char* cur_s = se->get(i).c_str();
      R_len_t cur_n = se->get(i).length();
      


      R_len_t cur_from2; // UTF-8 byte incices
      R_len_t cur_to2;   // UTF-8 byte incices
      
      if (cur_from >= 0) {
         cur_from--; // 1-based -> 0-based index
         cur_from2 = se->UChar32_to_UTF8_index_fwd(i, cur_from);
      }
      else {
         cur_from = -cur_from;
         cur_from2 = se->UChar32_to_UTF8_index_back(i, cur_from);
      }
         
      if (cur_to >= 0) {
         ; // do nothing with cur_to // 1-based -> 0-based index but +1 as we need the next one (bound)
         cur_to2 = se->UChar32_to_UTF8_index_fwd(i, cur_to);
      }
      else {
         cur_to = -cur_to - 1;
         cur_to2 = se->UChar32_to_UTF8_index_back(i, cur_to);
      }
      
      const char* val_s = sval->get(i).c_str();
      R_len_t val_n = sval->get(i).length();
      
      R_len_t buflen = cur_n-(cur_to2-cur_from2)+val_n+1;
      char* buf = new char[buflen];
      memcpy(buf, cur_s, cur_from2);
      memcpy(buf+cur_from2, val_s, val_n);
      memcpy(buf+cur_from2+val_n, cur_s+cur_to2, cur_n-cur_to2);
      SET_STRING_ELT(ret, i, mkCharLenCE(buf, cur_n+val_n-(cur_to2-cur_from2), CE_UTF8));  
   }
   
   delete se;
   UNPROTECT(1); 
   return ret;
}




