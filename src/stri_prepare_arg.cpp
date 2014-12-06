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
 * Prepare list of raw vectors argument, single raw vector,
 * or character vector argument
 *
 * Useful when dealing with raw data, like in string encoding
 * conversion or detection. For use e.g. with StriContainerListRaw.
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 * @param x a list /  raw vector / character vector
 * @param argname argument name (message formatting)
 * @return coercion is only done on character vector input. otherwise
 * check only is performed
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-08)
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
         if ((bool)isNull(cur))
            continue; // NA
         if (!isRaw(cur))
            Rf_error(MSG__ARG_EXPECTED_RAW_IN_LIST_NO_COERCION, argname);  // error() allowed here
      }
      return x;
   }
   else
      return stri_prepare_arg_string(x, argname);
}


/**
 * Prepare list of integer vectors or an integer vector argument
 *
 *  For use e.g. with StriContainerListInt.
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 * @param x a list of integer vectors / integer vector
 * @param argname argument name (message formatting)
 * @return a list vector
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-25)
 */
SEXP stri_prepare_arg_list_integer(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if ((bool)isNull(x)) {
       return x;
   }
   else if (Rf_isVectorList(x)) {
      R_len_t narg = LENGTH(x);
      if (narg <= 0) return x;

      if (NAMED(x) > 0) {
         // the object should be copied
         SEXP xold = x;
         PROTECT(x = Rf_allocVector(VECSXP, narg));
         for (R_len_t i=0; i<narg; ++i) {
            if ((bool)isNull(VECTOR_ELT(xold, i)))
               SET_VECTOR_ELT(x, i, R_NilValue);
            // @TODO: stri_prepare_arg_integer may call Rf_error, no UNPROTECT
            else
               SET_VECTOR_ELT(x, i, stri_prepare_arg_integer(VECTOR_ELT(xold, i), argname));
         }
         UNPROTECT(1);
         return x;
      }
      else {
         // the object may be modified in place
         for (R_len_t i=0; i<narg; ++i)
            if (!isNull(VECTOR_ELT(x, i)))
               SET_VECTOR_ELT(x, i, stri_prepare_arg_integer(VECTOR_ELT(x, i), argname));
         return x;
      }
   }
   else
      return stri_prepare_arg_integer(x, argname);
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
 * @param x a list of strings
 * @param argname argument name (message formatting)
 * @return a list vector
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
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
      for (R_len_t i=0; i<narg; ++i) {
         // @TODO: stri_prepare_arg_string may call Rf_error, no UNPROTECT
         SET_VECTOR_ELT(x, i, stri_prepare_arg_string(VECTOR_ELT(xold, i), argname));
      }
      UNPROTECT(1);
      return x;
   }
   else {
      // the object may be modified in place
      for (R_len_t i=0; i<narg; ++i)
         SET_VECTOR_ELT(x, i, stri_prepare_arg_string(VECTOR_ELT(x, i), argname));
      return x;
   }
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          argname added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-19)
 *    BUGFIX: PROTECT mem from GC in factor object given
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *        treat NULLs as empty vectors
 */
SEXP stri_prepare_arg_string(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if ((bool)isString(x))
      return x; // return as-is
   else if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark it's encoding manually
      UNPROTECT(2);
      return x;
   }
   else if (Rf_isVectorAtomic(x) || isNull(x))
      return Rf_coerceVector(x, STRSXP);
   else if ((bool)isSymbol(x))
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
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          argname added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-19)
 *    BUGFIX: PROTECT mem from GC in factor object given
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *        treat NULLs as empty vectors
 */
SEXP stri_prepare_arg_double(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark it's encoding manually
      PROTECT(x = Rf_coerceVector(x, REALSXP));
      UNPROTECT(3);
      return x;
   }
   else if ((bool)isReal(x))
      return x; //return as-is
   else if (Rf_isVectorAtomic(x) || isNull(x))
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
 * @version 0.1?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          argname added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-19)
 *    BUGFIX: PROTECT mem from GC in factor object given
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *        treat NULLs as empty vectors
 */
SEXP stri_prepare_arg_integer(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x)) // factors must be checked first (as they are currently represented as integer vectors)
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark it's encoding manually
      PROTECT(x = Rf_coerceVector(x, INTSXP));
      UNPROTECT(3);
      return x;
   }
   else if (Rf_isInteger(x))
      return x; // return as-is
   else if (Rf_isVectorAtomic(x) || isNull(x))
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
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          argname added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-19)
 *    BUGFIX: PROTECT mem from GC in factor object given
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *        treat NULLs as empty vectors
 */
SEXP stri_prepare_arg_logical(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark it's encoding manually
      PROTECT(x = Rf_coerceVector(x, LGLSXP));
      UNPROTECT(3);
      return x;
   }
   else if ((bool)isLogical(x))
      return x; // return as-is
   else if (Rf_isVectorAtomic(x) || isNull(x))
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-19)
 *    BUGFIX: PROTECT mem from GC in factor object given
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *        treat NULLs as empty vectors
 */
SEXP stri_prepare_arg_raw(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark it's encoding manually
      PROTECT(x = Rf_coerceVector(x, RAWSXP));
      UNPROTECT(3);
      return x;
   }
   else if (TYPEOF(x) == RAWSXP)
      return x; // return as-is
   else if (Rf_isVectorAtomic(x) || isNull(x))
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_prepare_arg_string_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   PROTECT(x = stri_prepare_arg_string(x, argname));
   R_len_t nx = LENGTH(x);

   if (nx <= 0) {
      UNPROTECT(1);
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here
      // won't come here anyway
      return x; // avoid compiler warning
   }
   else if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_STRING, argname);
      SEXP xold = x;
      PROTECT(x = Rf_allocVector(STRSXP, 1));
      SET_STRING_ELT(x, 0, STRING_ELT(xold, 0));
      UNPROTECT(2);
      return x;
   }
   else { // if (nx == 1)
      UNPROTECT(1);
      return x;
   }
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_prepare_arg_double_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   PROTECT(x = stri_prepare_arg_double(x, argname));
   R_len_t nx = LENGTH(x);

   if (nx <= 0) {
      UNPROTECT(1);
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here
      // won't come here anyway
      return x; // avoid compiler warning
   }
   else if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_NUMERIC, argname);
      double x0 = REAL(x)[0];
      PROTECT(x = Rf_allocVector(REALSXP, 1));
      REAL(x)[0] = x0;
      UNPROTECT(2);
      return x;
   }
   else {// if (nx == 1)
      UNPROTECT(1);
      return x;
   }
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_prepare_arg_integer_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   PROTECT(x = stri_prepare_arg_integer(x, argname));
   R_len_t nx = LENGTH(x);

   if (nx <= 0) {
      UNPROTECT(1);
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here
      // won't come here anyway
      return x; // avoid compiler warning
   }
   else if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_INTEGER, argname);
      int x0 = INTEGER(x)[0];
      PROTECT(x = Rf_allocVector(INTSXP, 1));
      INTEGER(x)[0] = x0;
      UNPROTECT(2);
      return x;
   }
   else { // if (nx == 1)
      UNPROTECT(1);
      return x;
   }
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_prepare_arg_logical_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   PROTECT(x = stri_prepare_arg_logical(x, argname));
   R_len_t nx = LENGTH(x);

   if (nx <= 0) {
      UNPROTECT(1);
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here
      // won't come here anyway
      return x; // avoid compiler warning
   }
   else if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_LOGICAL, argname);
      int x0 = LOGICAL(x)[0];
      PROTECT(x = Rf_allocVector(LGLSXP, 1));
      LOGICAL(x)[0] = x0;
      UNPROTECT(2);
      return x;
   }
   else { // if (nx == 1)
      UNPROTECT(1);
      return x;
   }
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
bool stri__prepare_arg_logical_1_notNA(SEXP x, const char* argname)
{
   PROTECT(x = stri_prepare_arg_logical_1(x, argname));
   int xval = LOGICAL(x)[0];
   UNPROTECT(1);
   if (xval == NA_LOGICAL)
      Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // allowed here
   return (bool)xval;
}


/** Prepare integer argument - one value, not NA
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
 * @return an integer value
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
int stri__prepare_arg_integer_1_notNA(SEXP x, const char* argname)
{
   PROTECT(x = stri_prepare_arg_integer_1(x, argname));
   int xval = INTEGER(x)[0];
   UNPROTECT(1);
   if (xval == NA_INTEGER)
      Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // allowed here
   return (int)xval;
}


/** Prepare double argument - one value, not NA
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
 * @return a double value
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-26)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
double stri__prepare_arg_double_1_notNA(SEXP x, const char* argname)
{
   PROTECT(x = stri_prepare_arg_double_1(x, argname));
   double xval = REAL(x)[0];
   UNPROTECT(1);
   if (ISNA(xval))
      Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // allowed here
   return (double)xval;
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          argname added
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
  * @version 0.3-1 (Marek Gagolewski, 2014-11-06)
 *    Use R_alloc for the string returned
 */
const char* stri__prepare_arg_locale(SEXP loc, const char* argname, bool allowdefault, bool allowna)
{
   if (allowdefault && isNull(loc))
      return uloc_getDefault();
   else {
      PROTECT(loc = stri_prepare_arg_string_1(loc, argname));
      if (STRING_ELT(loc, 0) == NA_STRING) {
         UNPROTECT(1);
         if (allowna)
            return NULL;
         else
            Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // Rf_error allowed here
      }

      if (LENGTH(STRING_ELT(loc, 0)) == 0) {
         UNPROTECT(1);
         if (allowdefault)
            return uloc_getDefault();
         else
            Rf_error(MSG__LOCALE_INCORRECT_ID); // allowed here
      }
      else {
         const char* ret_tmp = (const char*)CHAR(STRING_ELT(loc, 0)); // ret may be gc'ed
         size_t ret_n = strlen(ret_tmp);
         /* R_alloc ==  Here R will reclaim the memory at the end of the call to .Call */
         char* ret = R_alloc(ret_n+1, (int)sizeof(char));
         if (!ret) {
            UNPROTECT(1);
            Rf_error(MSG__MEM_ALLOC_ERROR);
         }
         memcpy(ret, ret_tmp, ret_n+1);
         UNPROTECT(1);
         return ret;
      }
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          argname added
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-06)
 *    Use R_alloc for the string returned
 */
const char* stri__prepare_arg_enc(SEXP enc, const char* argname, bool allowdefault)
{
   if (allowdefault && isNull(enc))
      return (const char*)NULL;
   else {
      PROTECT(enc = stri_prepare_arg_string_1(enc, argname));
      if (STRING_ELT(enc, 0) == NA_STRING) {
         UNPROTECT(1);
         Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // allowed here
      }

      if (LENGTH(STRING_ELT(enc, 0)) == 0) {
         UNPROTECT(1);
         if (allowdefault)
            return (const char*)NULL;
         else
            Rf_error(MSG__ENC_INCORRECT_ID); // allowed here
      }
      else {
         const char* ret_tmp = (const char*)CHAR(STRING_ELT(enc, 0)); // ret may be gc'ed
         size_t ret_n = strlen(ret_tmp);
         /* R_alloc ==  Here R will reclaim the memory at the end of the call to .Call */
         char* ret = R_alloc(ret_n+1, (int)sizeof(char));
         if (!ret) {
            UNPROTECT(1);
            Rf_error(MSG__MEM_ALLOC_ERROR);
         }
         memcpy(ret, ret_tmp, ret_n+1);
         UNPROTECT(1);
         return ret;
      }
   }

   // won't come here anyway
   return NULL; // avoid compiler warning
}
