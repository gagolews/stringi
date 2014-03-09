/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#include "stri_stringi.h"





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
 * @version 0.3 (Marek Gagolewski, 2013-06-01) use StriContainerUTF8's UChar32-to-UTF8 index
 * @version 0.4 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_sub(SEXP str, SEXP from, SEXP to, SEXP length)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);

   int* from_tab                = 0;
   int* to_tab                  = 0;
   int* length_tab              = 0;
   R_len_t from_length          = 0;
   R_len_t to_length            = 0;
   R_len_t length_length        = 0;
   R_len_t vectorize_length     = 0;

   bool from_ismatrix = Rf_isMatrix(from);
   if (from_ismatrix) {
      SEXP t = Rf_getAttrib(from, R_DimSymbol);
      if (INTEGER(t)[1] == 1) from_ismatrix = false; // don't treat this as matrix
      else if (INTEGER(t)[1] > 2)
         Rf_error(MSG__ARG_EXPECTED_MATRIX_WITH_GIVEN_COLUMNS, "from", 2); // error() is allowed here
   }
   from = stri_prepare_arg_integer(from, "from");

   if (from_ismatrix) {
      from_length = to_length = LENGTH(from)/2;
      from_tab = INTEGER(from);
      to_tab = from_tab+from_length;
      vectorize_length = stri__recycling_rule(true, 2, str_length, from_length);
   }
   else if (isNull(length)) {
      to = stri_prepare_arg_integer(to, "to");
      from_length = LENGTH(from);
      from_tab = INTEGER(from);
      to_length = LENGTH(to);
      to_tab = INTEGER(to);
      vectorize_length = stri__recycling_rule(true, 3, str_length, from_length, to_length);
   }
   else {
      length = stri_prepare_arg_integer(length, "length");
      from_length = LENGTH(from);
      from_tab = INTEGER(from);
      length_length = LENGTH(length);
      length_tab = INTEGER(length);
      vectorize_length = stri__recycling_rule(true, 3, str_length, from_length, length_length);
   }


   if (vectorize_length <= 0)
      return Rf_allocVector(STRSXP,0);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);

   // args prepared, let's go
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      R_len_t cur_from     = from_tab[i % from_length];
      R_len_t cur_to       = (to_tab)?to_tab[i % to_length]:length_tab[i % length_length];
      if (str_cont.isNA(i) || cur_from == NA_INTEGER || cur_to == NA_INTEGER) {
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

      const char* str_cur_s = str_cont.get(i).c_str();


      R_len_t cur_from2; // UTF-8 byte incices
      R_len_t cur_to2;   // UTF-8 byte incices

      if (cur_from >= 0) {
         cur_from--; // 1-based -> 0-based index
         cur_from2 = str_cont.UChar32_to_UTF8_index_fwd(i, cur_from);
      }
      else {
         cur_from = -cur_from;
         cur_from2 = str_cont.UChar32_to_UTF8_index_back(i, cur_from);
      }

      if (cur_to >= 0) {
         ; // do nothing with cur_to // 1-based -> 0-based index but +1 as we need the next one (bound)
         cur_to2 = str_cont.UChar32_to_UTF8_index_fwd(i, cur_to);
      }
      else {
         cur_to = -cur_to - 1;
         cur_to2 = str_cont.UChar32_to_UTF8_index_back(i, cur_to);
      }

      if (cur_to2 > cur_from2) { // just copy
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cur_s+cur_from2, cur_to2-cur_from2, CE_UTF8));
      }
      else {
         // maybe a warning here?
         SET_STRING_ELT(ret, i, Rf_mkCharLen(NULL, 0));
      }
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
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
 * @version 0.3 (Marek Gagolewski, 2013-06-01) use StriContainerUTF8's UChar32-to-UTF8 index
 * @version 0.4 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_sub_replacement(SEXP str, SEXP from, SEXP to, SEXP length, SEXP value)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);
   value = stri_prepare_arg_string(value, "value");
   R_len_t value_length = LENGTH(value);

   int* from_tab    = 0;
   int* to_tab      = 0;
   int* length_tab  = 0;
   R_len_t from_length   = 0;
   R_len_t to_length     = 0;
   R_len_t length_length = 0;
   R_len_t vectorize_length     = 0;

   bool from_ismatrix = Rf_isMatrix(from);
   if (from_ismatrix) {
      SEXP t = Rf_getAttrib(from, R_DimSymbol);
      if (INTEGER(t)[1] == 1) from_ismatrix = false; // don't treat this as matrix
      else if (INTEGER(t)[1] > 2)
         Rf_error(MSG__ARG_EXPECTED_MATRIX_WITH_GIVEN_COLUMNS, "from", 2); // error() is allowed here
   }
   from = stri_prepare_arg_integer(from, "from");

   if (from_ismatrix) {
      from_length = to_length = LENGTH(from)/2;
      from_tab = INTEGER(from);
      to_tab = from_tab+from_length;
      vectorize_length = stri__recycling_rule(true, 3, str_length, from_length, value_length);
   }
   else if (isNull(length)) {
      to = stri_prepare_arg_integer(to, "to");
      from_length = LENGTH(from);
      from_tab = INTEGER(from);
      to_length = LENGTH(to);
      to_tab = INTEGER(to);
      vectorize_length = stri__recycling_rule(true, 4, str_length, from_length, to_length, value_length);
   }
   else {
      length = stri_prepare_arg_integer(length, "length");
      from_length = LENGTH(from);
      from_tab = INTEGER(from);
      length_length = LENGTH(length);
      length_tab = INTEGER(length);
      vectorize_length = stri__recycling_rule(true, 4, str_length, from_length, length_length, value_length);
   }


   if (vectorize_length <= 0)
      return Rf_allocVector(STRSXP, 0);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, vectorize_length);
   StriContainerUTF8 value_cont(value, vectorize_length);

   // args prepared, let's go
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));
   String8 buf(0); // @TODO consider calculating bufsize a priori

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      R_len_t cur_from     = from_tab[i % from_length];
      R_len_t cur_to       = (to_tab)?to_tab[i % to_length]:length_tab[i % length_length];
      if (str_cont.isNA(i) || cur_from == NA_INTEGER || cur_to == NA_INTEGER || value_cont.isNA(i)) {
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

      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_n = str_cont.get(i).length();



      R_len_t cur_from2; // UTF-8 byte incices
      R_len_t cur_to2;   // UTF-8 byte incices

      if (cur_from >= 0) {
         cur_from--; // 1-based -> 0-based index
         cur_from2 = str_cont.UChar32_to_UTF8_index_fwd(i, cur_from);
      }
      else {
         cur_from = -cur_from;
         cur_from2 = str_cont.UChar32_to_UTF8_index_back(i, cur_from);
      }

      if (cur_to >= 0) {
         ; // do nothing with cur_to // 1-based -> 0-based index but +1 as we need the next one (bound)
         cur_to2 = str_cont.UChar32_to_UTF8_index_fwd(i, cur_to);
      }
      else {
         cur_to = -cur_to - 1;
         cur_to2 = str_cont.UChar32_to_UTF8_index_back(i, cur_to);
      }

      const char* value_cur_s = value_cont.get(i).c_str();
      R_len_t value_cur_n = value_cont.get(i).length();

      R_len_t buflen = str_cur_n-(cur_to2-cur_from2)+value_cur_n;
      buf.resize(buflen);
      memcpy(buf.data(), str_cur_s, (size_t)cur_from2);
      memcpy(buf.data()+cur_from2, value_cur_s, (size_t)value_cur_n);
      memcpy(buf.data()+cur_from2+value_cur_n, str_cur_s+cur_to2, (size_t)str_cur_n-cur_to2);
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), buflen, CE_UTF8));
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
