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
 * Prepare list of raw vectors argument, single raw vector,
 * or character vector argument
 *
 * Useful when dealing with raw data, like in string encoding
 * conversion or detection.
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 * @param x a list
 * @param argname argument name (message formatting)
 * @return coercion is only done on character vector input. otherwise
 * check only is performed
 *
 * @version 0.1 (Marek Gagolewski, 2013-08-08)
 */
SEXP stri_prepare_arg_list_raw(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (isNull(x) || isRaw(x)) {
       return x; // single character string (byte data)
   }
   else if (Rf_isVectorList(x)) {
      R_len_t nv = LENGTH(x);
      for (R_len_t i=0; i<nv; ++i) {
         SEXP cur = VECTOR_ELT(x, i);
         if (isNull(cur))
            continue; // NA
         if (!isRaw(cur))  // this cannot be treated with stri_prepare_arg*, as str may be a mem-shared object
            Rf_error(MSG__ARG_EXPECTED_RAW_NO_COERCION, argname);  // error() allowed here
      }
      return x;
   }
   else
      return stri_prepare_arg_string(x, argname);
}


/**
 * Prepare list of character vectors argument
 *
 * This is used by functions like stri_join, which allows
 * for passing strings as "...".
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 * @param x a list
 * @param argname argument name (message formatting)
 * @return a list vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-16)
 */
SEXP stri_prepare_arg_list_string(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (!Rf_isVectorList(x))
      Rf_error(MSG__ARG_EXPECTED_LIST_STRING, argname); // error() allowed here

   R_len_t narg = LENGTH(x);
   if (narg <= 0) return x;

   if (NAMED(x) > 0) {
      // the object should be copied
      SEXP xold = x;
      PROTECT(x = Rf_allocVector(VECSXP, narg));
      for (R_len_t i=0; i<narg; ++i)
         SET_VECTOR_ELT(x, i, stri_prepare_arg_string(VECTOR_ELT(xold, i), argname));
      UNPROTECT(1);
   }
   else {
      // the object may be modified in place
      for (R_len_t i=0; i<narg; ++i)
         SET_VECTOR_ELT(x, i, stri_prepare_arg_string(VECTOR_ELT(x, i), argname));
   }
   return x;
}


/**
 * Prepare character vector argument
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
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
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (isString(x))
      return x; // return as-is
   else if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
   	x = Rf_eval(call, R_GlobalEnv); // this will mark it's encoding manually
   	UNPROTECT(1);
      return x;
   }
   else if (Rf_isVectorAtomic(x))
      return Rf_coerceVector(x, STRSXP);
   else if (isSymbol(x))
      return Rf_ScalarString(PRINTNAME(x));

   Rf_error(MSG__ARG_EXPECTED_STRING, argname); // allowed here
   return x; // avoid compiler warning
}



/**
 * Prepare numeric vector argument
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
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
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      x = Rf_eval(call, R_GlobalEnv); // this will mark it's encoding manually
   	UNPROTECT(1);
      return Rf_coerceVector(x, REALSXP);
   }
   else if(isReal(x))
      return x; //return as-is
   else if (Rf_isVectorAtomic(x))
      return Rf_coerceVector(x, REALSXP);

   Rf_error(MSG__ARG_EXPECTED_NUMERIC, argname); // allowed here
   return x; // avoid compiler warning
}


/**
 * Prepare integer vector argument
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
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
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x)) // factors must be checked first (as they are currently represented as integer vectors)
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
   	x = Rf_eval(call, R_GlobalEnv); // this will mark it's encoding manually
   	UNPROTECT(1);
      return Rf_coerceVector(x, INTSXP);
   }
   else if (Rf_isInteger(x))
      return x; // return as-is
   else if (Rf_isVectorAtomic(x))
      return Rf_coerceVector(x, INTSXP);

   Rf_error(MSG__ARG_EXPECTED_INTEGER, argname); //allowed here
   return x; // avoid compiler warning
}


/**
 * Prepare logical vector argument
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
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
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      x = Rf_eval(call, R_GlobalEnv); // this will mark it's encoding manually
   	UNPROTECT(1);
      return Rf_coerceVector(x, LGLSXP);
   }
   else if (isLogical(x))
      return x; // return as-is
   else if (Rf_isVectorAtomic(x))
      return Rf_coerceVector(x, LGLSXP);

   Rf_error(MSG__ARG_EXPECTED_LOGICAL, argname); // allowed here
   return x; // avoid compiler warning
}




/**
 * Prepare raw vector argument
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param x a raw vector or an object that can be coerced to a raw vector
 * @param argname argument name (message formatting)
 * @return raw vector
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_raw(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      x = Rf_eval(call, R_GlobalEnv); // this will mark it's encoding manually
   	UNPROTECT(1);
      return Rf_coerceVector(x, RAWSXP);
   }
   else if (TYPEOF(x) == RAWSXP)
      return x; // return as-is
   else if (Rf_isVectorAtomic(x))
      return Rf_coerceVector(x, RAWSXP);

   Rf_error(MSG__ARG_EXPECTED_RAW, argname); // allowed here
   return x; // avoid compiler warning
}





/** Prepare string argument - one string
 *
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return always an R character vector with >=1 element
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_string_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   x = stri_prepare_arg_string(x, argname);
   R_len_t nx = LENGTH(x);

   if (nx <= 0)
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here

   if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_STRING, argname);
      SEXP xold = x;
      PROTECT(x = Rf_allocVector(STRSXP, 1));
      SET_STRING_ELT(x, 0, STRING_ELT(xold, 0));
      UNPROTECT(1);
   }

   return x;
}


/** Prepare double argument - one value
 *
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return always an R double vector with >=1 element
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_double_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   x = stri_prepare_arg_double(x, argname);
   R_len_t nx = LENGTH(x);

   if (nx <= 0)
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here

   if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_NUMERIC, argname);
      double x0 = REAL(x)[0];
      PROTECT(x = Rf_allocVector(REALSXP, 1));
      REAL(x)[0] = x0;
      UNPROTECT(1);
   }

   return x;
}


/** Prepare integer argument - one value
 *
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return always an R integer vector with >=1 element
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_integer_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   x = stri_prepare_arg_integer(x, argname);
   R_len_t nx = LENGTH(x);

   if (nx <= 0)
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here

   if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_INTEGER, argname);
      int x0 = INTEGER(x)[0];
      PROTECT(x = Rf_allocVector(INTSXP, 1));
      INTEGER(x)[0] = x0;
      UNPROTECT(1);
   }

   return x;
}


/** Prepare logical argument - one value
 *
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param x R object to be checked/coerced
 * @param argname argument name (message formatting)
 * @return always an R logical vector with >=1 element
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_prepare_arg_logical_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   x = stri_prepare_arg_logical(x, argname);
   R_len_t nx = LENGTH(x);

   if (nx <= 0)
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here

   if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_LOGICAL, argname);
      int x0 = LOGICAL(x)[0];
      PROTECT(x = Rf_allocVector(LGLSXP, 1));
      LOGICAL(x)[0] = x0;
      UNPROTECT(1);
   }

   return x;
}



/** Prepare logical argument - one value, not NA
 *
 * If there are 0 elements -> error
 * If there are >1 elements -> warning
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
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
      Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // allowed here
   return (bool)xval;
}


/**
 * Prepare character vector argument that will be used to choose a locale
 *
 * If the \code{loc} argument is incorrect, the an error is generated.
 * If something goes wrong, a warning is given.
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param loc generally, a single character string
 * @param allowdefault do we allow \code{R_NilValue} or a single empty string
 *    to work as a default locale selector?
 * @param allowna do we allow \code{NA} in \code{loc}?
 *    This will return \code{NULL} as result
 * @param argname argument name (message formatting)
 * @return string a \code{C} string with extracted locale name
 *
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - argname added
 */
const char* stri__prepare_arg_locale(SEXP loc, const char* argname, bool allowdefault, bool allowna)
{
   if (allowdefault && isNull(loc))
      return uloc_getDefault();
   else {
      loc = stri_prepare_arg_string_1(loc, argname);
      if (STRING_ELT(loc, 0) == NA_STRING) {
         if (allowna)
            return NULL;
         else
            Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // Rf_error allowed here
      }

      if (LENGTH(STRING_ELT(loc, 0)) == 0) {
         if (allowdefault)
            return uloc_getDefault();
         else
            Rf_error(MSG__LOCALE_INCORRECT_ID); // allowed here
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
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param enc generally, a single character string
 * @param allowdefault do we allow \code{R_NilValue} or a single empty string
 *    to work as a default charset selector? (defaults \code{true})
 * @param argname argument name (message formatting)
 * @return a \code{C} string with extracted locale name
 * (NULL for default charset so that it can be passed to ICU's \code{ucnv_open()})
 * Do not delete.
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
         Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // allowed here
      }

      if (LENGTH(STRING_ELT(enc, 0)) == 0) {
         if (allowdefault)
            return (const char*)NULL;
         else
            Rf_error(MSG__ENC_INCORRECT_ID); // allowed here
      }
      else
         return (const char*)CHAR(STRING_ELT(enc, 0));
   }

   // won't come here anyway
   return NULL; // avoid compiler warning
}
