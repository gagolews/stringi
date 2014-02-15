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
