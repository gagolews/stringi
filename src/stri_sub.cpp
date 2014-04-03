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
#include "stri_container_utf8_indexable.h"
#include "stri_string8buf.h"


/** Prepare args for stri_sub* [internal]
 *
 * @param from
 * @param to
 * @param length
 * @param from_len
 * @param to_len
 * @param length_len
 * @param from_tab
 * @param to_tab
 * @param length_tab
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-03)
 */
void stri__sub_prepare_from_to_length(SEXP& from, SEXP& to, SEXP& length,
   R_len_t& from_len, R_len_t& to_len, R_len_t& length_len,
   int*& from_tab, int*& to_tab, int*& length_tab)
{
   bool from_ismatrix = Rf_isMatrix(from);
   if (from_ismatrix) {
      SEXP t = Rf_getAttrib(from, R_DimSymbol);
      if (INTEGER(t)[1] == 1)
         from_ismatrix = false; // it's a column vector
      else if (INTEGER(t)[1] > 2) {
         // error() is allowed here
         Rf_error(MSG__ARG_EXPECTED_MATRIX_WITH_GIVEN_COLUMNS, "from", 2);
      }
   }
   from = stri_prepare_arg_integer(from, "from"); // may remove R_DimSymbol

   if (from_ismatrix) {
      from_len      = LENGTH(from)/2;
      to_len        = from_len;
      from_tab      = INTEGER(from);
      to_tab        = from_tab+from_len;
   }
   else if (isNull(length)) {
      to            = stri_prepare_arg_integer(to, "to");
      from_len      = LENGTH(from);
      from_tab      = INTEGER(from);
      to_len        = LENGTH(to);
      to_tab        = INTEGER(to);
   }
   else { // length is NULL
      length        = stri_prepare_arg_integer(length, "length");
      from_len      = LENGTH(from);
      from_tab      = INTEGER(from);
      length_len    = LENGTH(length);
      length_tab    = INTEGER(length);
   }
}


#define STRI__SUB_GET_INDICES(cur_from, cur_to, cur_from2, cur_to2) \
                                                                    \
   if (cur_from >= 0) {                                             \
      cur_from--; /* 1-based -> 0-based index */                    \
      cur_from2 = str_cont.UChar32_to_UTF8_index_fwd(i, cur_from);  \
   }                                                                \
   else {                                                           \
      cur_from  = -cur_from;                                        \
      cur_from2 = str_cont.UChar32_to_UTF8_index_back(i, cur_from); \
   }                                                                \
   if (cur_to >= 0) {                                               \
      ; /* do nothing with cur_to ; 1-based -> 0-based index */     \
        /* but +1 as we need the next one (bound) */                \
      cur_to2 = str_cont.UChar32_to_UTF8_index_fwd(i, cur_to);      \
   }                                                                \
   else {                                                           \
      cur_to  = -cur_to - 1;                                        \
      cur_to2 = str_cont.UChar32_to_UTF8_index_back(i, cur_to);     \
   }


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
 * @version 0.1-?? (Bartek Tartanus)
 *          stri_sub
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF8 and stri__UChar32_to_UTF8_index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-01)
 *          use StriContainerUTF8's UChar32-to-UTF8 index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          Use StriContainerUTF8_indexable
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-03)
 *          Use stri__sub_prepare_from_to_length()
 */
SEXP stri_sub(SEXP str, SEXP from, SEXP to, SEXP length)
{
   str = stri_prepare_arg_string(str, "str");

   R_len_t str_len       = LENGTH(str);
   R_len_t from_len      = 0;
   R_len_t to_len        = 0;
   R_len_t length_len    = 0;
   int* from_tab         = 0;
   int* to_tab           = 0;
   int* length_tab       = 0;

   stri__sub_prepare_from_to_length(from, to, length,
      from_len, to_len, length_len,
      from_tab, to_tab, length_tab);

   R_len_t vectorize_len = stri__recycling_rule(true, 4,
      str_len, from_len,
      (to_len>0)?to_len:1, (length_len>0)?length_len:1);


   if (vectorize_len <= 0)
      return Rf_allocVector(STRSXP, 0);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8_indexable str_cont(str, vectorize_len);
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_len));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      R_len_t cur_from     = from_tab[i % from_len];
      R_len_t cur_to       = (to_tab)?to_tab[i % to_len]:length_tab[i % length_len];
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

      STRI__SUB_GET_INDICES(cur_from, cur_to, cur_from2, cur_to2)

      if (cur_to2 > cur_from2) { // just copy
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(str_cur_s+cur_from2, cur_to2-cur_from2, CE_UTF8));
      }
      else {
         // maybe a warning here?
         SET_STRING_ELT(ret, i, Rf_mkCharLen(NULL, 0));
      }
   }

   STRI__UNPROTECT_ALL
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
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF8 and stri__UChar32_to_UTF8_index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-01)
 *          use StriContainerUTF8's UChar32-to-UTF8 index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          Use StriContainerUTF8_indexable
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-03)
 *          Use stri__sub_prepare_from_to_length()
 */
SEXP stri_sub_replacement(SEXP str, SEXP from, SEXP to, SEXP length, SEXP value)
{
   str   = stri_prepare_arg_string(str, "str");
   value = stri_prepare_arg_string(value, "value");

   R_len_t value_len     = LENGTH(value);
   R_len_t str_len       = LENGTH(str);
   R_len_t from_len      = 0; // see below
   R_len_t to_len        = 0; // see below
   R_len_t length_len    = 0; // see below
   int* from_tab         = 0; // see below
   int* to_tab           = 0; // see below
   int* length_tab       = 0; // see below

   stri__sub_prepare_from_to_length(from, to, length,
      from_len, to_len, length_len,
      from_tab, to_tab, length_tab);

   R_len_t vectorize_len = stri__recycling_rule(true, 5,
      str_len, value_len, from_len,
      (to_len>0)?to_len:1, (length_len>0)?length_len:1);


   if (vectorize_len <= 0)
      return Rf_allocVector(STRSXP, 0);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8_indexable str_cont(str, vectorize_len);
   StriContainerUTF8 value_cont(value, vectorize_len);
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_len));
   String8buf buf(0); // @TODO: estimate bufsize a priori

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      R_len_t cur_from     = from_tab[i % from_len];
      R_len_t cur_to       = (to_tab)?to_tab[i % to_len]:length_tab[i % length_len];
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

      const char* str_cur_s   = str_cont.get(i).c_str();
      R_len_t str_cur_n       = str_cont.get(i).length();
      const char* value_cur_s = value_cont.get(i).c_str();
      R_len_t value_cur_n     = value_cont.get(i).length();

      R_len_t cur_from2; // UTF-8 byte incices
      R_len_t cur_to2;   // UTF-8 byte incices

      STRI__SUB_GET_INDICES(cur_from, cur_to, cur_from2, cur_to2)

      R_len_t buflen = str_cur_n-(cur_to2-cur_from2)+value_cur_n;
      buf.resize(buflen, false/*destroy contents*/);
      memcpy(buf.data(), str_cur_s, (size_t)cur_from2);
      memcpy(buf.data()+cur_from2, value_cur_s, (size_t)value_cur_n);
      memcpy(buf.data()+cur_from2+value_cur_n, str_cur_s+cur_to2, (size_t)str_cur_n-cur_to2);
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), buflen, CE_UTF8));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
