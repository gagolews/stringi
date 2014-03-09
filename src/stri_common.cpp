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


/**
 *  Set names attribute for an R object
 *
 * @param object an R object
 * @param numnames number of names to set
 * @param ... variable number of C strings
 *
 * @version 0.1 (Marek Gagolewski)
*/
void stri__set_names(SEXP object, R_len_t numnames, ...)
{
   va_list arguments;
   SEXP names;
   PROTECT(names = Rf_allocVector(STRSXP, numnames));

   va_start(arguments, numnames);
   for (R_len_t i = 0; i < numnames; ++i)
      SET_STRING_ELT(names, i, Rf_mkChar(va_arg(arguments, char*)));
   va_end(arguments);

   Rf_setAttrib(object, R_NamesSymbol, names);
   UNPROTECT(1);
}



/**
 * Create a character vector with given C strings
 *
 * @param numnames number of strings
 * @param ... variable number of C strings
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-16)
*/
SEXP stri__make_character_vector(R_len_t numnames, ...)
{
   va_list arguments;
   SEXP names;
   PROTECT(names = Rf_allocVector(STRSXP, numnames));

   va_start(arguments, numnames);
   for (R_len_t i = 0; i < numnames; ++i)
      SET_STRING_ELT(names, i, Rf_mkChar(va_arg(arguments, char*)));
   va_end(arguments);

   UNPROTECT(1);
   return names;
}



/**
 *  Calculate the length of the output vector when applying a vectorized
 *  operation on >= 2  vectors
 *
 *  For nonconforming lengths, a warning is given
 *
 *  @param enableWarning enable warning in case of multiple calls to this function
 *  @param n number of vectors to recycle
 *  @param ... vector lengths
 *  @return max of the given lengths or 0 iff any ns* is <= 0
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - variable args length
*/
R_len_t stri__recycling_rule(bool enableWarning, int n, ...)
{
   R_len_t nsm = 0;
   va_list arguments;

   va_start(arguments, n);
   for (R_len_t i = 0; i < n; ++i) {
      R_len_t curlen = va_arg(arguments, R_len_t);
      if (curlen <= 0)
         return 0;
      if (curlen > nsm)
         nsm = curlen;
   }
   va_end(arguments);

   if (enableWarning) {
      va_start(arguments, n);
      for (R_len_t i = 0; i < n; ++i) {
         R_len_t curlen = va_arg(arguments, R_len_t);
         if (nsm % curlen != 0) {
            Rf_warning(MSG__WARN_RECYCLING_RULE);
            break;
         }
      }
      va_end(arguments);
   }

   return nsm;
}


/**
 *  Creates a character vector filled with \code{NA_character_}
 *
 *  @param howmany length of the vector, \code{howmany >= 0}
 *  @return a character vector of length \code{howmany}
 *
 * @version 0.1 (Marek Gagolewski)
*/
SEXP stri__vector_NA_strings(R_len_t howmany)
{
   if (howmany < 0) {
      Rf_warning(MSG__EXPECTED_NONNEGATIVE);
      howmany = 0;
   }

   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, howmany));
   for (R_len_t i=0; i<howmany; ++i)
      SET_STRING_ELT(ret, i, NA_STRING);
   UNPROTECT(1);

   return ret;
}


/**
 *  Creates a character vector filled with \code{NA_integer_}
 *
 *  @param howmany length of the vector, \code{howmany >= 0}
 *  @return a character vector of length \code{howmany}
 *
 * @version 0.1 (Marek Gagolewski)
*/
SEXP stri__vector_NA_integers(R_len_t howmany)
{
   if (howmany < 0) {
      Rf_warning(MSG__EXPECTED_NONNEGATIVE);
      howmany = 0;
   }

   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, howmany));
   for (R_len_t i=0; i<howmany; ++i)
      INTEGER(ret)[i] = NA_INTEGER;
   UNPROTECT(1);

   return ret;
}


/**
 *  Creates a character vector filled with empty strings
 *
 *  @param howmany length of the vector, \code{howmany >= 0}
 *  @return a character vector of length \code{howmany}
 *
 * @version 0.1 (Marek Gagolewski)
*/
SEXP stri__vector_empty_strings(R_len_t howmany)
{
   if (howmany < 0) {
      Rf_warning(MSG__EXPECTED_NONNEGATIVE);
      howmany = 0;
   }

   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, howmany));
   for (R_len_t i=0; i<howmany; ++i)
      SET_STRING_ELT(ret, i, R_BlankString);
   UNPROTECT(1);

   return ret;
}



/** Creates an empty R list
 *
 * @return the same as a call to \code{list()} in R
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri__emptyList()
{
   SEXP ret = Rf_allocVector(VECSXP, 0);
   return ret;
}


/** Creates an integer matrix filled with \code{NA_INTEGER}
 *
 * @param nrow number of rows
 * @param ncol number of columns
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri__matrix_NA_INTEGER(R_len_t nrow, R_len_t ncol)
{
   SEXP x;
   PROTECT(x = Rf_allocMatrix(INTSXP, nrow, ncol));
   int* ians = INTEGER(x);
   for (R_len_t i=0; i<nrow*ncol; ++i)
      ians[i] = NA_INTEGER;
   UNPROTECT(1);
   return x;
}


/** Creates a character matrix filled with \code{NA_STRING}
 *
 * @param nrow number of rows
 * @param ncol number of columns
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-22)
 */
SEXP stri__matrix_NA_STRING(R_len_t nrow, R_len_t ncol)
{
   SEXP x;
   PROTECT(x = Rf_allocMatrix(STRSXP, nrow, ncol));
   for (R_len_t i=0; i<nrow*ncol; ++i)
      SET_STRING_ELT(x, i, NA_STRING);
   UNPROTECT(1);
   return x;
}
