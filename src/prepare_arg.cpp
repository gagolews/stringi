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
 * Prepare character vector argument
 * 
 * If the object cannot be coerced, then an error will be generated
 * 
 * @param x a character vector or an object that can be coerced to a character vector
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_string(SEXP x)
{
   if (isString(x))
      return x; // return as-is
   else if (isFactor(x))
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
		x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
		UNPROTECT(1);
      return x;
   }
   else if (isVectorAtomic(x))
      return coerceVector(x, STRSXP);
   else if (isSymbol(x))
      return ScalarString(PRINTNAME(x));
      
   error(MSG__EXPECTED_CHARACTER);
   return x; // avoid compiler warning
}



/**
 * Prepare numeric vector argument
 * 
 * If the object cannot be coerced, then an error will be generated
 * 
 * @param x a numeric vector or an object that can be coerced to a numeric vector
 * @return numeric vector
 * 
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_prepare_arg_double(SEXP x)
{
   if (isFactor(x)) 
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
      x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
		UNPROTECT(1);
      return coerceVector(x, REALSXP);
   }
   else if(isReal(x))
      return x; //return as-is
   else if (isVectorAtomic(x))
      return coerceVector(x, REALSXP);
      
   error(MSG__EXPECTED_DOUBLE);
   return x; // avoid compiler warning
}


/**
 * Prepare integer vector argument
 * 
 * If the object cannot be coerced, then an error will be generated
 * 
 * @param x an integer vector or an object that can be coerced to an integer vector
 * @return integer vector
 * 
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_prepare_arg_integer(SEXP x)
{
   if (isFactor(x)) // factors must be checked first (as they are currently represented as integer vectors)
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
   	x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
		UNPROTECT(1);
      return coerceVector(x, INTSXP);
   }
   else if (isInteger(x))
      return x; // return as-is
   else if (isVectorAtomic(x))
      return coerceVector(x, INTSXP);
      
   error(MSG__EXPECTED_INTEGER);
   return x; // avoid compiler warning
}


/**
 * Prepare logical vector argument
 * 
 * If the object cannot be coerced, then an error will be generated
 * 
 * @param x a logical vector or an object that can be coerced to a logical vector
 * @return logical vector
 * 
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_prepare_arg_logical(SEXP x)
{
   if (isFactor(x))
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
      x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
		UNPROTECT(1);
      return coerceVector(x, LGLSXP);
   }
   else if (isLogical(x))
      return x; // return as-is
   else if (isVectorAtomic(x))
      return coerceVector(x, LGLSXP);
      
   error(MSG__EXPECTED_LOGICAL);
   return x; // avoid compiler warning
}



/**
 * Prepare character vector argument that will be used to choose a locale
 *
 * If the \code{loc} argument is incorrect, the an error is generated.
 * If something goes wrong, a warning is given.
 * 
 * @param loc generally, a single character string
 * @param allowdefault do we allow \code{R_NilValue} or a single empty string
 *    to work as a default locale selector? (defaults \code{true})
 * @return string a \code{C} string with extracted locale name
 * 
 * 
 * @version 0.1 (Marek Gagolewski)
 */
const char* stri__prepare_arg_locale(SEXP loc, bool allowdefault)
{
   if (allowdefault && isNull(loc))
      return uloc_getDefault();
   else {
      loc = stri_prepare_arg_string(loc);
      if (LENGTH(loc) >= 1 && STRING_ELT(loc, 0) != NA_STRING) {
         if (LENGTH(loc) > 1) // only one string is expected
            warning(MSG__LOCALE_ATTEMPT_SET_GE1);
   
         if (LENGTH(STRING_ELT(loc, 0)) == 0) {
            if (allowdefault)
               return uloc_getDefault();
            else
               error(MSG__LOCALE_INCORRECT_ID);
         }
         else
            return (const char*)CHAR(STRING_ELT(loc, 0));
      }
      else
         error(MSG__LOCALE_INCORRECT_ID);
   }
   
   // won't come here anyway
   return NULL; // avoid compiler warning
}


/**
 * Prepare character vector argument that will be used to choose a character encoding
 *
 * If the \code{enc} argument is incorrect, the an error is generated.
 * If something goes wrong, a warning is given.
 * 
 * @param enc generally, a single character string
 * @param allowdefault do we allow \code{R_NilValue} or a single empty string
 *    to work as a default charset selector? (defaults \code{true})
 * @return string a \code{C} string with extracted locale name
 * (NULL for default charset so that it can be passed to ICU's \code{ucnv_open()}
 * 
 * @version 0.1 (Marek Gagolewski)
 */
const char* stri__prepare_arg_enc(SEXP enc, bool allowdefault)
{
   if (allowdefault && isNull(enc))
      return (const char*)NULL;
   else {
      enc = stri_prepare_arg_string(enc);
      if (LENGTH(enc) >= 1 && STRING_ELT(enc, 0) != NA_STRING) {
         if (LENGTH(enc) > 1) // only one string is expected
            warning(MSG__ENC_ATTEMPT_SET_GE1);
   
         if (LENGTH(STRING_ELT(enc, 0)) == 0) {
            if (allowdefault)
               return (const char*)NULL;
            else
               error(MSG__ENC_INCORRECT_ID);
         }
         else
            return (const char*)CHAR(STRING_ELT(enc, 0));
      }
      else
         error(MSG__ENC_INCORRECT_ID);
   }
   
   // won't come here anyway
   return NULL; // avoid compiler warning
}

