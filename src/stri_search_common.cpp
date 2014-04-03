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
