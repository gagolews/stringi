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


/** Get curent-default ICU locale and charset information
 *
 *  @return an R named list with 4 components:
 *  \code{Unicode.version} == ICU Unicode version,
 *  \code{ICU.version} == U_ICU_VERSION
 *  \code{Locale} == \code{stri_locale_info()},
 *  \code{Charset.internal} == \code{"UTF-8", "UTF-16"},
 *  \code{Charset.native} == \code{stri_enc_info()})
 *
 *  @version 0.1-?? (Marek Gagolewski)
 *
 *  @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *                   make StriException friendly
 *
 *  @version 0.1-?? (Marek Gagolewski, 2013-11-17)
 *                   added U_ICU_VERSION
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
*/
SEXP stri_info()
{
   STRI__ERROR_HANDLER_BEGIN(0)
   const R_len_t infosize = 5;
   SEXP vals;

   STRI__PROTECT(vals = Rf_allocVector(VECSXP, infosize));
   SET_VECTOR_ELT(vals, 0, Rf_mkString(U_UNICODE_VERSION));
   SET_VECTOR_ELT(vals, 1, Rf_mkString(U_ICU_VERSION));
   SET_VECTOR_ELT(vals, 2, stri_locale_info(R_NilValue)); // may call Rf_error
   SET_VECTOR_ELT(vals, 3,
      stri__make_character_vector(2, "UTF-8", "UTF-16")); // fixed strings
   SET_VECTOR_ELT(vals, 4, stri_enc_info(R_NilValue));  // may call Rf_error

   stri__set_names(vals, infosize,
      "Unicode.version", "ICU.version", "Locale",
      "Charset.internal", "Charset.native");

   STRI__UNPROTECT_ALL
   return vals;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
