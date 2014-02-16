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




/** Get curent-default ICU locale and charset information
 *
 *  @return an R named list with 4 components:
 *  \code{Unicode.version} == ICU Unicode version,
 *  \code{ICU.version} == U_ICU_VERSION
 *  \code{Locale} == \code{stri_locale_info()},
 *  \code{Charset.internal} == \code{"UTF-8", "UTF-16"},
 *  \code{Charset.native} == \code{stri_enc_info()})
 *
 *  @version 0.1 (Marek Gagolewski)
 *  @version 0.2 (Marek Gagolewski, 2013-06-16) make StriException friendly
 *  @version 0.3 (Marek Gagolewski, 2013-11-17) added U_ICU_VERSION
*/
SEXP stri_info()
{
   STRI__ERROR_HANDLER_BEGIN
   const R_len_t infosize = 5;
   SEXP vals;

   PROTECT(vals = Rf_allocVector(VECSXP, infosize));
   SET_VECTOR_ELT(vals, 0, Rf_mkString(U_UNICODE_VERSION));
   SET_VECTOR_ELT(vals, 1, Rf_mkString(U_ICU_VERSION ));
   SET_VECTOR_ELT(vals, 2, stri_locale_info(R_NilValue));
   SET_VECTOR_ELT(vals, 3,
      stri__make_character_vector(2, "UTF-8", "UTF-16")); // this is fixed
   SET_VECTOR_ELT(vals, 4, stri_enc_info(R_NilValue));

   stri__set_names(vals, infosize,
      "Unicode.version", "ICU.version", "Locale",
      "Charset.internal", "Charset.native");

   UNPROTECT(1);
   return vals;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
