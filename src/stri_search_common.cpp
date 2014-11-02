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
#include "stri_stringi.h"
#include "stri_container_utf8.h"
#include "stri_container_usearch.h"
#include <unicode/uregex.h>
#include "stri_string8buf.h"
#include <deque>
using namespace std;


/**
 * Set colnames for matrix returned by stri_locate_first_* or stri_locate_last_*
 * @param matrix R matrix with two columns
 *
 * @version 0.1-?? (Marek Gagolewski)
 */
void stri__locate_set_dimnames_matrix(SEXP matrix) {
   SEXP dimnames;
   SEXP colnames;
   PROTECT(dimnames = Rf_allocVector(VECSXP, 2));
   PROTECT(colnames = Rf_allocVector(STRSXP, 2));
   SET_STRING_ELT(colnames, 0, Rf_mkChar(MSG__LOCATE_DIM_START));
   SET_STRING_ELT(colnames, 1, Rf_mkChar(MSG__LOCATE_DIM_END));
   SET_VECTOR_ELT(dimnames, 0, R_NilValue);
   SET_VECTOR_ELT(dimnames, 1, colnames);
   Rf_setAttrib(matrix, R_DimNamesSymbol, dimnames);
   UNPROTECT(2);
}


/**
 * Set colnames for matrices stored in a list returned by stri_locate_all_* or stri_locate_all_*
 * @param matrix R matrix with two columns
 *
 * @version 0.1-?? (Marek Gagolewski)
 */
void stri__locate_set_dimnames_list(SEXP list) {
   SEXP dimnames;
   SEXP colnames;
   PROTECT(dimnames = Rf_allocVector(VECSXP, 2));
   PROTECT(colnames = Rf_allocVector(STRSXP, 2));
   SET_STRING_ELT(colnames, 0, Rf_mkChar(MSG__LOCATE_DIM_START));
   SET_STRING_ELT(colnames, 1, Rf_mkChar(MSG__LOCATE_DIM_END));
   SET_VECTOR_ELT(dimnames, 1, colnames);

   R_len_t n = LENGTH(list);
   for (R_len_t i = 0; i < n; ++i)
      Rf_setAttrib(VECTOR_ELT(list, i), R_DimNamesSymbol, dimnames);
   UNPROTECT(2);
}


// I really love macros /MG/ :)
#define stri__subset_by_logical__MACRO \
   SEXP ret; \
   PROTECT(ret = Rf_allocVector(STRSXP, result_counter)); \
   for (R_len_t j=0, i=0; i<result_counter; ++j) { \
      if (which[j] == NA_LOGICAL) \
         SET_STRING_ELT(ret, i++, NA_STRING); \
      else if (which[j]) \
         SET_STRING_ELT(ret, i++, str_cont.toR(j)); \
   } \
   UNPROTECT(1); \
   return ret;


/**
 * Subset str_cont to SEXP by logical table ret_tab
 *
 * @param str_cont
 * @param which logical
 * @param result_counter
 * @return character vector
 *
 * @version 0.3-1 (Bartlomiej Tartanus, 2014-07-25)
 * @version 0.3-1 (Marek Gagolewski, 2014-10-17)
 *                using std::vector<int> to avoid mem-leaks, and
 *                const StriContainer& for increased performance
 */
SEXP stri__subset_by_logical(const StriContainerUTF8& str_cont,
   const std::vector<int>& which, int result_counter)
{
   stri__subset_by_logical__MACRO
}


/**
 * Subset str_cont to SEXP by logical table ret_tab
 *
 * @param str_cont
 * @param which logical
 * @param result_counter
 * @return character vector
 *
 * @version 0.3-1 (Bartlomiej Tartanus, 2014-07-25)
 * @version 0.3-1 (Marek Gagolewski, 2014-10-17)
 *                using std::vector<int> to avoid mem-leaks, and
 *                const StriContainer& for increased performance
 */
SEXP stri__subset_by_logical(const StriContainerUTF16& str_cont,
   const std::vector<int>& which, int result_counter)
{
   stri__subset_by_logical__MACRO
}
