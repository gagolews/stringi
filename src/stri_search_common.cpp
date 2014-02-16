/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "stri_stringi.h"


/**
 * Set colnames for matrix returned by stri_locate_first_* or stri_locate_last_*
 * @param matrix R matrix with two columns
 * @version 0.1 (Marek Gagolewski)
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
 * @version 0.1 (Marek Gagolewski)
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
