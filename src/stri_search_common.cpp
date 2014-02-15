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
