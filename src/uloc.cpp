/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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
 
#include "stringi.h"





/**
 * Sets current (default) ICU locale
 * No check done here! (analogous R version does that and generates warning if needed)
 * @param loc new locale
 * @return nothing
 */
SEXP stri_localeset(SEXP loc)
{
   const char* qloc = stri__prepare_arg_locale(loc, false);
   UErrorCode err = U_ZERO_ERROR;
   uloc_setDefault(qloc, &err);
   if (U_FAILURE(err))
      error(MSG__LOCALE_ERROR_SET);
   return R_NilValue;
}


/** Get list of available locales
 *  @return R character vector
 */
SEXP stri_localelist()
{
   R_len_t c = (R_len_t)uloc_countAvailable();
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, c));
   
   for (R_len_t i=0; i<c; ++i) {
      const char* name = uloc_getAvailable(i);
      SET_STRING_ELT(ret, i, mkChar(name));
   }
   
   UNPROTECT(1);
   return ret;
}


/** Get default (current) ICU locale
 *  @param loc either NULL or "" for default locale, or one string with locale name
 *  @return R list object
 */
SEXP stri_localeinfo(SEXP loc)
{
   const char* qloc = stri__prepare_arg_locale(loc, true);
   const R_len_t infosize = 4;
   SEXP vals;
   SEXP names;
   PROTECT(names = allocVector(STRSXP, infosize));
   
   SET_STRING_ELT(names, 0, mkChar("Language"));
   SET_STRING_ELT(names, 1, mkChar("Country"));  
   SET_STRING_ELT(names, 2, mkChar("Variant"));   
   SET_STRING_ELT(names, 3, mkChar("Name"));
    
   PROTECT(vals = allocVector(VECSXP, infosize));
   for (int i=0; i<infosize; ++i) 
      SET_VECTOR_ELT(vals, i, ScalarString(NA_STRING));
      
   
   UErrorCode err = U_ZERO_ERROR;
   char buf[ULOC_FULLNAME_CAPACITY]; // this is sufficient
   
   uloc_getLanguage(qloc, buf, ULOC_FULLNAME_CAPACITY, &err);
   if (U_FAILURE(err)) err = U_ZERO_ERROR;
   else SET_VECTOR_ELT(vals, 0, mkString(buf));
   
   uloc_getCountry(qloc, buf, ULOC_FULLNAME_CAPACITY, &err);
   if (U_FAILURE(err)) err = U_ZERO_ERROR;
   else SET_VECTOR_ELT(vals, 1, mkString(buf));
   
   uloc_getVariant(qloc, buf, ULOC_FULLNAME_CAPACITY, &err);
   if (U_FAILURE(err)) err = U_ZERO_ERROR;
   else SET_VECTOR_ELT(vals, 2, mkString(buf));
   
   uloc_canonicalize(qloc, buf, ULOC_FULLNAME_CAPACITY, &err);
   if (U_FAILURE(err)) err = U_ZERO_ERROR;
   else SET_VECTOR_ELT(vals, 3, mkString(buf));  

   setAttrib(vals, R_NamesSymbol, names);
   UNPROTECT(2);
   return vals;
}
