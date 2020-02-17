/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
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
 * Prepare list argument
 *
 * @param x a list or NULL
 * @param argname argument name (message formatting)
 * @return a list
 *
 * @version 1.3.2 (Marek Gagolewski, 2019-02-21)
 */
SEXP stri_prepare_arg_list(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (!isNull(x) && !Rf_isVectorList(x))
      Rf_error(MSG__ARG_EXPECTED_LIST, argname); // error() allowed here

   return x;
}


/**
 * Prepare list of raw vectors argument, single raw vector,
 * or character vector argument
 *
 * Useful when dealing with raw data, like in string encoding
 * conversion or detection. For use, e.g., with StriContainerListRaw.
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
 *  For use, e.g., with StriContainerListInt.
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
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-05-01)
 *        #154 - the class attribute set fires up an as.xxxx call
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_string(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      UNPROTECT(2);
      return x;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      UNPROTECT(2);
      return x;
   }
   else if ((bool)isString(x))
      return x; // return as-is
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
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-05-01)
 *        #154 - the class attribute set fires up an as.xxxx call
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_double(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      PROTECT(x = Rf_coerceVector(x, REALSXP));
      UNPROTECT(3);
      return x;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.double"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      UNPROTECT(2);
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
 * POSIXt
 *
 * If the object cannot be coerced, then an error will be generated
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param x a numeric vector with class POSIXct
 * @param argname argument name (message formatting)
 * @return numeric vector
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-30)
 * @version 1.1.6 (Marek Gagolewski, 2020-02-17) bugfix #370
 *
 */
SEXP stri_prepare_arg_POSIXct(SEXP x, const char* argname)
{
   int num_protect = 0;
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_inherits(x, "POSIXlt") || Rf_inherits(x, "Date")) {
      SEXP tmp1;
      PROTECT(tmp1 = Rf_lang2(Rf_install("as.POSIXct"), x));
      PROTECT(x = Rf_eval(tmp1, R_GlobalEnv));
      num_protect += 2;
   }

   if (!Rf_inherits(x, "POSIXct")) {
      Rf_error(MSG__ARG_EXPECTED_POSIXct, argname);
   }

   SEXP attrib_class, attrib_tzone, robj_class, robj_tzone;
   PROTECT(robj_class = Rf_ScalarString(Rf_mkChar("class")));
   PROTECT(robj_tzone = Rf_ScalarString(Rf_mkChar("tzone")));
   PROTECT(attrib_class = Rf_getAttrib(x, robj_class));
   PROTECT(attrib_tzone = Rf_getAttrib(x, robj_tzone));
   PROTECT(x = stri_prepare_arg_double(x, argname));
   Rf_setAttrib(x, robj_class, attrib_class);
   Rf_setAttrib(x, robj_tzone, attrib_tzone);
   UNPROTECT(num_protect+5);
   return x;
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
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-05-01)
 *        #154 - the class attribute set fires up an as.xxxx call
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_integer(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x)) // factors must be checked first (as they are currently represented as integer vectors)
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      PROTECT(x = Rf_coerceVector(x, INTSXP));
      UNPROTECT(3);
      return x;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.integer"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      UNPROTECT(2);
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
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-05-01)
 *        #154 - the class attribute set fires up an as.xxxx call
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_logical(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      PROTECT(x = Rf_coerceVector(x, LGLSXP));
      UNPROTECT(3);
      return x;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.logical"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      UNPROTECT(2);
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
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-05-01)
 *        #154 - the class attribute set fires up an as.xxxx call
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_raw(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      PROTECT(x = Rf_coerceVector(x, RAWSXP));
      UNPROTECT(3);
      return x;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.raw"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      UNPROTECT(2);
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
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_string_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   int nprotect = 0;
   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      nprotect = 2;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      nprotect = 2;
   }
   else if ((bool)isString(x))
      nprotect = 0;
   else if (Rf_isVectorAtomic(x) || isNull(x)) {
      PROTECT(x = Rf_coerceVector(x, STRSXP));
      nprotect = 1;
   }
   else if ((bool)isSymbol(x)) {
      PROTECT(x = Rf_ScalarString(PRINTNAME(x)));
      nprotect = 1;
   }
   else {
      Rf_error(MSG__ARG_EXPECTED_STRING, argname); // allowed here
      return x; // avoid compiler warning
   }


   R_len_t nx = LENGTH(x);

   if (nx <= 0) {
      UNPROTECT(nprotect);
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here
      // won't come here anyway
      return x; // avoid compiler warning
   }
   else if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_STRING, argname);
      SEXP xold = x;
      PROTECT(x = Rf_allocVector(STRSXP, 1));
      nprotect++;
      SET_STRING_ELT(x, 0, STRING_ELT(xold, 0));
      UNPROTECT(nprotect);
      return x;
   }
   else { // if (nx == 1)
      UNPROTECT(nprotect);
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
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_double_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   int nprotect = 0;
   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      PROTECT(x = Rf_coerceVector(x, REALSXP));
      nprotect = 3;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.double"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      nprotect = 2;
   }
   else if ((bool)isReal(x))
      nprotect = 0;
   else if (Rf_isVectorAtomic(x) || isNull(x)) {
      PROTECT(x = Rf_coerceVector(x, REALSXP));
      nprotect = 1;
   }
   else {
      Rf_error(MSG__ARG_EXPECTED_NUMERIC, argname); // allowed here
      return x; // avoid compiler warning
   }

   R_len_t nx = LENGTH(x);

   if (nx <= 0) {
      UNPROTECT(nprotect);
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here
      // won't come here anyway
      return x; // avoid compiler warning
   }
   else if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_NUMERIC, argname);
      double x0 = REAL(x)[0];
      PROTECT(x = Rf_allocVector(REALSXP, 1));
      nprotect++;
      REAL(x)[0] = x0;
      UNPROTECT(nprotect);
      return x;
   }
   else {// if (nx == 1)
      UNPROTECT(nprotect);
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
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_integer_1(SEXP x, const char* argname)
{
   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   int nprotect = 0;
   if (Rf_isFactor(x)) // factors must be checked first (as they are currently represented as integer vectors)
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      PROTECT(x = Rf_coerceVector(x, INTSXP));
      nprotect = 3;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.integer"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      nprotect = 2;
   }
   else if (Rf_isInteger(x))
      nprotect = 0;
   else if (Rf_isVectorAtomic(x) || isNull(x)) {
      PROTECT(x = Rf_coerceVector(x, INTSXP));
      nprotect = 1;
   }
   else {
      Rf_error(MSG__ARG_EXPECTED_INTEGER, argname); //allowed here
      return x; // avoid compiler warning
   }

   R_len_t nx = LENGTH(x);

   if (nx <= 0) {
      UNPROTECT(nprotect);
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here
      // won't come here anyway
      return x; // avoid compiler warning
   }
   else if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_INTEGER, argname);
      int x0 = INTEGER(x)[0];
      PROTECT(x = Rf_allocVector(INTSXP, 1));
      nprotect++;
      INTEGER(x)[0] = x0;
      UNPROTECT(nprotect);
      return x;
   }
   else { // if (nx == 1)
      UNPROTECT(nprotect);
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
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-21)
 *    #285: warn if coercing from a non-trivial list
 */
SEXP stri_prepare_arg_logical_1(SEXP x, const char* argname)
{
   int nprotect = 0;

   if ((SEXP*)argname == (SEXP*)R_NilValue)
      argname = "<noname>";

   if (Rf_isFactor(x))
   {
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.character"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      PROTECT(x = Rf_coerceVector(x, LGLSXP));
      nprotect = 3;
   }
   else if (Rf_isVectorList(x) || isObject(x))
   {
      if (Rf_isVectorList(x)) {
         R_len_t nv = LENGTH(x);
         for (R_len_t i=0; i<nv; ++i) {
            SEXP cur = VECTOR_ELT(x, i);
            if (!(Rf_isVectorAtomic(cur) && LENGTH(cur) == 1)) {
               Rf_warning(MSG__WARN_LIST_COERCION);
               break;
            }
         }
      }
      SEXP call;
      PROTECT(call = Rf_lang2(Rf_install("as.logical"), x));
      PROTECT(x = Rf_eval(call, R_GlobalEnv)); // this will mark its encoding manually
      nprotect = 2;
   }
   else if ((bool)isLogical(x)) {
      nprotect = 0;
      // do nothing
   }
   else if (Rf_isVectorAtomic(x) || isNull(x)) {
      PROTECT(x = Rf_coerceVector(x, LGLSXP));
      nprotect = 1;
   }
   else {
      Rf_error(MSG__ARG_EXPECTED_LOGICAL, argname); // allowed here
      return x; // avoid compiler warning
   }

   R_len_t nx = LENGTH(x);

   if (nx <= 0) {
      UNPROTECT(nprotect);
      Rf_error(MSG__ARG_EXPECTED_NOT_EMPTY, argname); // allowed here
      // won't come here anyway
      return x; // avoid compiler warning
   }
   else if (nx > 1) {
      Rf_warning(MSG__ARG_EXPECTED_1_LOGICAL, argname);
      int x0 = LOGICAL(x)[0];
      PROTECT(x = Rf_allocVector(LGLSXP, 1));
      nprotect++;
      LOGICAL(x)[0] = x0;
      UNPROTECT(nprotect);
      return x;
   }
   else { // if (nx == 1)
      UNPROTECT(nprotect);
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
 * This is a helper function to avoid UNPROTECTED var names warning
 * when playing with CHARSXP directly
 *
 * @param x an R STRING object (from STRING_ELT(charactervector, index))
 * @return an Ralloc'd character string
 *
 * @version 1.1.6 (Marek Gagolewski, 2017-11-10)
 */
const char* stri__copy_string_Ralloc(SEXP x, const char* argname)
{
   PROTECT(x);
   if (x == NA_STRING) {
      UNPROTECT(1);
      Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // allowed here
   }

   const char* ret_tmp = (const char*)CHAR(x); // ret may be gc'ed
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

/** Prepare double argument - one value, not NA [no re-encoding done!!!]
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
 * @return a character string
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-25)
 */
const char* stri__prepare_arg_string_1_notNA(SEXP x, const char* argname)
{
   PROTECT(x = stri_prepare_arg_string_1(x, argname));
   if (STRING_ELT(x, 0) == NA_STRING)
      Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // allowed here
   const char* ret_tmp = (const char*)CHAR(STRING_ELT(x, 0)); // ret may be gc'ed
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
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-01-01)
 *    "@keyword=value" may use default locale from now; also, loc is trimmed
 */
const char* stri__prepare_arg_locale(SEXP loc, const char* argname, bool allowdefault, bool allowna)
{
   if (allowdefault && isNull(loc))
      return uloc_getDefault();
   else {
      PROTECT(loc = stri_prepare_arg_string_1(loc, argname));
      if (STRING_ELT(loc, 0) == NA_STRING) {
         UNPROTECT(1);
         if (allowna) return NULL;
         else Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // Rf_error allowed here
      }

      UErrorCode err = U_ZERO_ERROR;
      char buf[ULOC_FULLNAME_CAPACITY];
      uloc_canonicalize((const char*)CHAR(STRING_ELT(loc, 0)), buf, ULOC_FULLNAME_CAPACITY, &err);
      STRI__CHECKICUSTATUS_RFERROR(err, {;})

      R_len_t ret_n = strlen(buf);
      char* ret = R_alloc(ret_n+1, (int)sizeof(char));
      memcpy(ret, buf, ret_n+1);

      // right-trim
      while (ret_n > 0 && (ret[ret_n-1] == ' ' || ret[ret_n-1] == '\t' || ret[ret_n-1] == '\n' || ret[ret_n-1] == '\r'))
         ret[--ret_n] = '\0';

      // left-trim
      while (ret[0] == ' ' || ret[0] == '\t' || ret[0] == '\n' || ret[0] == '\r') {
         ++ret;
         --ret_n;
      }

      if (ret_n == 0) {
         UNPROTECT(1);
         if (allowdefault) return uloc_getDefault();
         else Rf_error(MSG__LOCALE_INCORRECT_ID); // Rf_error allowed here
      }

      if (ret[0] == ULOC_KEYWORD_SEPARATOR) { // length is > 0
         // no locale specifier, just keywords
         if (!allowdefault) { UNPROTECT(1); Rf_error(MSG__LOCALE_INCORRECT_ID); }
         const char* ret_default = uloc_getDefault();
         R_len_t ret_detault_n = strlen(ret_default);
         const char* ret_tmp2 = ret;
         ret = R_alloc(ret_detault_n+ret_n+1, (int)sizeof(char));
         memcpy(ret, ret_default, ret_detault_n);
         memcpy(ret+ret_detault_n, ret_tmp2, ret_n+1);
      }

      UNPROTECT(1);
      return ret;
   }

   // won't come here anyway
   return NULL; // avoid compiler warning
}


/**
 * Prepare character vector argument that will be used to choose a time zone
 *
 * If the \code{tz} argument is incorrect, then an error is generated.
 * If something goes wrong, a warning is given.
 *
 * WARNING: this fuction is allowed to call the error() function.
 * Use before STRI__ERROR_HANDLER_BEGIN (with other prepareargs).
 *
 *
 * @param tz generally, a single character string or NULL
 * @param defaulttz default time zone to be used here
 * @return TimeZone object - owned by the caller
 *
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-24)
 */
TimeZone* stri__prepare_arg_timezone(SEXP tz, const char* argname, bool allowdefault)
{
   UnicodeString tz_val("");

   if (!isNull(tz)) {
      PROTECT(tz = stri_prepare_arg_string_1(tz, argname));
      if (STRING_ELT(tz, 0) == NA_STRING) {
         UNPROTECT(1);
         Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // Rf_error allowed here
      }
      tz_val.setTo(UnicodeString((const char*)CHAR(STRING_ELT(tz, 0))));
      UNPROTECT(1);
   }

//   if (tz_val.length() == 0 && !isNull(defaulttz)) {
//      PROTECT(defaulttz = stri_prepare_arg_string_1(defaulttz, argname));
//      if (STRING_ELT(defaulttz, 0) == NA_STRING) {
//         UNPROTECT(1);
//         Rf_error(MSG__ARG_EXPECTED_NOT_NA, argname); // Rf_error allowed here
//      }
//      tz_val.setTo(UnicodeString((const char*)CHAR(STRING_ELT(defaulttz, 0))));
//      UNPROTECT(1);
//   }

   if (tz_val.length() == 0) {
      if (!allowdefault) Rf_error(MSG__TIMEZONE_INCORRECT_ID);
      return TimeZone::createDefault();
   }
   else {
      TimeZone* ret = TimeZone::createTimeZone(tz_val);
      if (*ret == TimeZone::getUnknown()) {
         delete ret;
         Rf_error(MSG__TIMEZONE_INCORRECT_ID); // allowed here
      }
      else
         return ret;
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
