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
#include <unicode/uloc.h>


/**
 * Sets current (default) ICU locale
 *
 * @param loc new locale (a single character string)
 * @return nothing (\code{R_NilValue})
 *
 * @version 0.1-?? (Marek Gagolewski)
 */
SEXP stri_locale_set(SEXP loc)
{
   const char* qloc = stri__prepare_arg_locale(loc, "locale", false); /* this is R_alloc'ed */
   UErrorCode status = U_ZERO_ERROR;
   uloc_setDefault(qloc, &status);
   STRI__CHECKICUSTATUS_RFERROR(status, {/* do nothing special on err */}) // error() allowed here
   return R_NilValue;
}


/** Get list of available locales
 *
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski)
 */
SEXP stri_locale_list()
{
   R_len_t c = (R_len_t)uloc_countAvailable();
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, c));

   for (R_len_t i=0; i<c; ++i) {
      const char* name = uloc_getAvailable(i);
      SET_STRING_ELT(ret, i, Rf_mkChar(name));
   }

   UNPROTECT(1);
   return ret;
}


/** Get info on default (current) ICU locale or on given locale
 *
 *  @param loc either \code{NULL} or \code{""} for default locale,
 *     or one string with locale name
 *  @return a named R list object: each item (\code{Language},
 *  \code{Country}, \code{Variant}, \code{Name}) consists of
 *  a single string
 *
 * @version 0.1-?? (Marek Gagolewski)
 */
SEXP stri_locale_info(SEXP loc)
{
   const char* qloc = stri__prepare_arg_locale(loc, "locale", true); /* this is R_alloc'ed */
   const R_len_t infosize = 4;
   SEXP vals;

   PROTECT(vals = Rf_allocVector(VECSXP, infosize));
   for (int i=0; i<infosize; ++i)
      SET_VECTOR_ELT(vals, i, Rf_ScalarString(NA_STRING));

   UErrorCode err = U_ZERO_ERROR;
   char buf[ULOC_FULLNAME_CAPACITY]; // this is sufficient

   uloc_getLanguage(qloc, buf, ULOC_FULLNAME_CAPACITY, &err);
   if (U_FAILURE(err)) err = U_ZERO_ERROR;
   else SET_VECTOR_ELT(vals, 0, Rf_mkString(buf));

   uloc_getCountry(qloc, buf, ULOC_FULLNAME_CAPACITY, &err);
   if (U_FAILURE(err)) err = U_ZERO_ERROR;
   else SET_VECTOR_ELT(vals, 1, Rf_mkString(buf));

   uloc_getVariant(qloc, buf, ULOC_FULLNAME_CAPACITY, &err);
   if (U_FAILURE(err)) err = U_ZERO_ERROR;
   else SET_VECTOR_ELT(vals, 2, Rf_mkString(buf));

   uloc_canonicalize(qloc, buf, ULOC_FULLNAME_CAPACITY, &err);
   if (U_FAILURE(err)) err = U_ZERO_ERROR;
   else SET_VECTOR_ELT(vals, 3, Rf_mkString(buf));

   stri__set_names(vals, 4, "Language", "Country", "Variant", "Name");
   UNPROTECT(1);
   return vals;
}
