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
#include "stri_container_utf8.h"
#include "stri_container_listutf8.h"


/**
 * Convert list to a character matrix
 *
 * @param x a list
 * @param fill single string
 * @param byrow single logical value
 * @param n_min single integer
 * @return character matrix
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-23)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-04)
 *    new arg: n_min
 */
SEXP stri_list2matrix(SEXP x, SEXP byrow, SEXP fill, SEXP n_min)
{
   bool byrow2 = stri__prepare_arg_logical_1_notNA(byrow, "byrow");
   R_len_t n_min2 = stri__prepare_arg_integer_1_notNA(n_min, "n_min");
   if (n_min2 < 0) Rf_error(MSG__EXPECTED_NONNEGATIVE, "n_min");
   PROTECT(x = stri_prepare_arg_list_string(x, "x"));
   PROTECT(fill = stri_prepare_arg_string_1(fill, "fill")); // enc2utf8 called in R

   STRI__ERROR_HANDLER_BEGIN(2)
   R_len_t n = LENGTH(x);
   SEXP fill2 = STRING_ELT(fill, 0);

   R_len_t m = n_min2; // maximal vector length
   for (int i=0; i<n; ++i) {
      R_len_t k = LENGTH(VECTOR_ELT(x, i));
      if (k > m) m = k;
   }

   SEXP ret;
   if (!byrow2) {
      STRI__PROTECT(ret = Rf_allocMatrix(STRSXP, m, n));
      int ret_idx = 0;
      for (int i=0; i<n; ++i) {
         SEXP cur_str = VECTOR_ELT(x, i);
         R_len_t cur_len = LENGTH(cur_str);
         int j;
         for (j=0; j<cur_len; ++j)
            SET_STRING_ELT(ret, ret_idx++, STRING_ELT(cur_str, j));
         for (; j<m; ++j)
            SET_STRING_ELT(ret, ret_idx++, fill2);
      }
   }
   else {
      STRI__PROTECT(ret = Rf_allocMatrix(STRSXP, n, m));
      for (int i=0; i<n; ++i) {
         SEXP cur_str = VECTOR_ELT(x, i);
         R_len_t cur_len = LENGTH(cur_str);
         int j;
         for (j=0; j<cur_len; ++j)
            SET_STRING_ELT(ret, i+j*n, STRING_ELT(cur_str, j));
         for (; j<m; ++j)
            SET_STRING_ELT(ret, i+j*n, fill2);
      }
   }

   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({/* no-op on err */})
}
