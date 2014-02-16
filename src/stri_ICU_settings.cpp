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
