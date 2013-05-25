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
 * @param argname argument name (message formatting)
 * @return character vector
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - argname added
 */
SEXP stri_prepare_arg_string(SEXP x, const char* argname)
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
      
   error(MSG__ARG_EXPECTED_STRING, argname);
   return x; // avoid compiler warning
}



/**
 * Prepare numeric vector argument
 * 
 * If the object cannot be coerced, then an error will be generated
 * 
 * @param x a numeric vector or an object that can be coerced to a numeric vector
 * @param argname argument name (message formatting)
 * @return numeric vector
 * 
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - argname added
 */
SEXP stri_prepare_arg_double(SEXP x, const char* argname)
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
      
   error(MSG__ARG_EXPECTED_NUMERIC, argname);
   return x; // avoid compiler warning
}


/**
 * Prepare integer vector argument
 * 
 * If the object cannot be coerced, then an error will be generated
 * 
 * @param x an integer vector or an object that can be coerced to an integer vector
 * @param argname argument name (message formatting)
 * @return integer vector
 * 
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - argname added
 */
SEXP stri_prepare_arg_integer(SEXP x, const char* argname)
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
      
   error(MSG__ARG_EXPECTED_INTEGER, argname);
   return x; // avoid compiler warning
}


/**
 * Prepare logical vector argument
 * 
 * If the object cannot be coerced, then an error will be generated
 * 
 * @param x a logical vector or an object that can be coerced to a logical vector
 * @param argname argument name (message formatting)
 * @return logical vector
 * 
 * @version 0.1 (Bartek Tartanus)
 * @version 0.2 (Marek Gagolewski) - argname added
 */
SEXP stri_prepare_arg_logical(SEXP x, const char* argname)
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
      
   error(MSG__ARG_EXPECTED_LOGICAL, argname);
   return x; // avoid compiler warning
}




/**
 * Prepare raw vector argument
 * 
 * If the object cannot be coerced, then an error will be generated
 * 
 * @param x a raw vector or an object that can be coerced to a raw vector
 * @param argname argument name (message formatting)
 * @return raw vector
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_raw(SEXP x, const char* argname)
{
   if (isFactor(x))
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
      x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
   	UNPROTECT(1);
      return coerceVector(x, RAWSXP);
   }
   else if ((TYPEOF(x) == RAWSXP))
      return x; // return as-is
   else if (isVectorAtomic(x))
      return coerceVector(x, RAWSXP);
      
   error(MSG__ARG_EXPECTED_RAW, argname);
   return x; // avoid compiler warning
}





/** Prepare string argument - one string
 * 
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 * 
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return always an R character vector with >=1 element
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_string_1(SEXP x, const char* argname)
{
   x = stri_prepare_arg_string(x, argname);
   R_len_t nx = LENGTH(x);
   
   if (nx <= 0)
      error(MSG__ARG_EXPECTED_NOT_EMPTY, argname);
   
   if (nx > 1) {
      warning(MSG__ARG_EXPECTED_1_STRING, argname);
//      SEXP xold = x;
//      PROTECT(x = allocVector(STRSXP, 1));
//      SET_STRING_ELT(x, 0, STRING_ELT(xold, 0));
//      UNPROTECT(1);      
   }
   
   return x;
}


/** Prepare double argument - one value
 * 
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 * 
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return always an R double vector with >=1 element
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_double_1(SEXP x, const char* argname)
{
   x = stri_prepare_arg_double(x, argname);
   R_len_t nx = LENGTH(x);
   
   if (nx <= 0)
      error(MSG__ARG_EXPECTED_NOT_EMPTY, argname);
   
   if (nx > 1) {
      warning(MSG__ARG_EXPECTED_1_NUMERIC, argname);
//      double x0 = REAL(x)[0];
//      PROTECT(x = allocVector(REALSXP, 1));
//      REAL(x)[0] = x0;
//      UNPROTECT(1);      
   }
   
   return x;
}


/** Prepare integer argument - one value
 * 
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 * 
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return always an R integer vector with >=1 element
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_integer_1(SEXP x, const char* argname)
{
   x = stri_prepare_arg_integer(x, argname);
   R_len_t nx = LENGTH(x);
   
   if (nx <= 0)
      error(MSG__ARG_EXPECTED_NOT_EMPTY, argname);
   
   if (nx > 1) {
      warning(MSG__ARG_EXPECTED_1_INTEGER, argname);
//      int x0 = INTEGER(x)[0];
//      PROTECT(x = allocVector(INTSXP, 1));
//      INTEGER(x)[0] = x0;
//      UNPROTECT(1);      
   }
   
   return x;   
}


/** Prepare logical argument - one value
 * 
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 * 
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return always an R logical vector with >=1 element
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_logical_1(SEXP x, const char* argname)
{
   x = stri_prepare_arg_logical(x, argname);
   R_len_t nx = LENGTH(x);
   
   if (nx <= 0)
      error(MSG__ARG_EXPECTED_NOT_EMPTY, argname);
   
   if (nx > 1) {
      warning(MSG__ARG_EXPECTED_1_LOGICAL, argname);
//      int x0 = LOGICAL(x)[0];
//      PROTECT(x = allocVector(LGLSXP, 1));
//      LOGICAL(x)[0] = x0;
//      UNPROTECT(1);      
   }
   
   return x;      
}



/** Prepare logical argument - one value, not NA
 * 
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 * 
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return a boolean value
 * 
 * @version 0.1 (Marek Gagolewski)
 */
bool stri__prepare_arg_logical_1_notNA(SEXP x, const char* argname)
{
   x = stri_prepare_arg_logical_1(x, argname);
   int xval = LOGICAL(x)[0];
   if (xval == NA_LOGICAL)
      error(MSG__ARG_EXPECTED_NOT_NA, argname);
   return (bool)xval;
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
 * @param argname argument name (message formatting)
 * @return string a \code{C} string with extracted locale name
 * 
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - argname added
 */
const char* stri__prepare_arg_locale(SEXP loc, const char* argname, bool allowdefault)
{
   if (allowdefault && isNull(loc))
      return uloc_getDefault();
   else {
      loc = stri_prepare_arg_string_1(loc, argname);
      if (STRING_ELT(loc, 0) == NA_STRING) {
         error(MSG__ARG_EXPECTED_NOT_NA, argname);
      }
      
      if (LENGTH(STRING_ELT(loc, 0)) == 0) {
         if (allowdefault)
            return uloc_getDefault();
         else
            error(MSG__LOCALE_INCORRECT_ID);
      }
      else
         return (const char*)CHAR(STRING_ELT(loc, 0));
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
 * @param argname argument name (message formatting)
 * @return string a \code{C} string with extracted locale name
 * (NULL for default charset so that it can be passed to ICU's \code{ucnv_open()}
 * 
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - argname added
 * 
 */
const char* stri__prepare_arg_enc(SEXP enc, const char* argname, bool allowdefault)
{
   if (allowdefault && isNull(enc))
      return (const char*)NULL;
   else {
      enc = stri_prepare_arg_string_1(enc, argname);
      if (STRING_ELT(enc, 0) == NA_STRING) {
         error(MSG__ARG_EXPECTED_NOT_NA, argname);
      }

      if (LENGTH(STRING_ELT(enc, 0)) == 0) {
         if (allowdefault)
            return (const char*)NULL;
         else
            error(MSG__ENC_INCORRECT_ID);
      }
      else
         return (const char*)CHAR(STRING_ELT(enc, 0));
   }
   
   // won't come here anyway
   return NULL; // avoid compiler warning
}

