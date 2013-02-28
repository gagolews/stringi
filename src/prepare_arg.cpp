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
 * Prepare SEXP/character vector argument
 * 
 * If the object cannot be coerced, the execution is stopped
 * @param x a character vector or an object that can be coerced to a character vector
 * @return STRSXP
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
      return coerceVector(x,STRSXP);
   else if (isSymbol(x))
      return ScalarString(PRINTNAME(x));
      
   error(MSG__EXPECTED_CHARACTER);
   return x; // avoid compiler warning
}

/**
 * Prepare SEXP/double vector argument
 * 
 * If the object cannot be coerced, the execution is stopped
 * @param x a double vector or an object that can be coerced to a double vector
 * @return REALSXP
 */
SEXP stri_prepare_arg_double(SEXP x)
{
   if(isReal(x))
      return x; //return as-is
   else if (isFactor(x)) 
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
      x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
		UNPROTECT(1);
      return coerceVector(x,REALSXP);
   }
   else if (isVectorAtomic(x))
      return coerceVector(x,REALSXP);
      
   error(MSG__EXPECTED_DOUBLE);
   return x; // avoid compiler warning
}


/**
 * Prepare SEXP/integer vector argument
 * 
 * If the object cannot be coerced, the execution is stopped
 * @param x an integer vector or an object that can be coerced to an integer vector
 * @return INTSXP
 */
SEXP stri_prepare_arg_integer(SEXP x)
{
   if (isFactor(x)) // factors must be checked first
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
   	x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
		UNPROTECT(1);
      return coerceVector(x,INTSXP);
   }
   else if (isInteger(x))
      return x; // return as-is
   else if (isVectorAtomic(x))
      return coerceVector(x,INTSXP);
      
   error(MSG__EXPECTED_INTEGER);
   return x; // avoid compiler warning
}


/**
 * Prepare SEXP/logical vector argument
 * 
 * If the object cannot be coerced, the execution is stopped
 * @param x a logical vector or an object that can be coerced to a logical vector
 * @return LGLSXP
 */
SEXP stri_prepare_arg_logical(SEXP x)
{
   if (isLogical(x))
      return x; // return as-is
   else if (isFactor(x))
   {
      SEXP call;
      PROTECT(call = lang2(install("as.character"), x));
      x = eval(call, R_GlobalEnv); // this will mark it's encoding manually
		UNPROTECT(1);
      return coerceVector(x,LGLSXP);
   }
   else if (isVectorAtomic(x))
      return coerceVector(x,LGLSXP);
      
   error(MSG__EXPECTED_LOGICAL);
   return x; // avoid compiler warning
}



/**
 * Prepare SEXP/locale [character vector] argument 
 *
 * @param loc R_NilValue for default locale or....
 * @param allowdefault ...
 * @return string...
 */
const char* stri__prepare_arg_locale(SEXP loc, bool allowdefault)
{
   if (allowdefault && isNull(loc))
      return uloc_getDefault();
   else {
      loc = stri_prepare_arg_string(loc);
      if (LENGTH(loc) >= 1 && STRING_ELT(loc, 0) != NA_STRING) {
         if (LENGTH(loc) > 1) // this shouldn't happen
            warning(MSG__LOCALE_ATTEMPT_SET_GE1);
   
         if (LENGTH(STRING_ELT(loc, 0)) == 0)
            return uloc_getDefault();
         else
            return (const char*)CHAR(STRING_ELT(loc, 0));
      }
      else {
         error(MSG__LOCALE_INCORRECT_ID);
         return NULL; // avoid compiler warning
      }
   }
}
