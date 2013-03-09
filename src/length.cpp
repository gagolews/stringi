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
 * Get the largest number of bytes in its strings
 * (useful for allocating temporary buffers)
 * 
 * if all strings are NA or an empty character vector is given, -1 is returned
 * Prior to memory allocation, you should check for < 0!
 * 
 * Note that ICU permits only strings of length < 2^31.
 * @param s R character vector
 * @return maximal number of bytes
 */
R_len_t stri__numbytes_max(SEXP s)
{
   R_xlen_t ns = XLENGTH(s);
   if (ns <= 0) return -1;
   R_len_t maxlen = -1;
   for (R_xlen_t i=0; i<ns; ++i) {
      SEXP cs = STRING_ELT(s, i);
      if (cs != NA_STRING) {
         /* INPUT ENCODING CHECK: this function does not need this. */
         R_len_t cns = LENGTH(cs);
         if (cns > maxlen) maxlen = cns;
      }
   }
   return maxlen;
}



/** 
 * Get number of bytes in each string
 * 
 * Note that ICU permits only strings of length < 2^31.
 * @param s R object coercible to a character vector
 * @return integer vector
 */
SEXP stri_numbytes(SEXP s)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   R_xlen_t n = XLENGTH(s);
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, n));
   int* retint = INTEGER(ret);
   for (R_xlen_t i=0; i<n; ++i) {
      SEXP curs = STRING_ELT(s, i);
      /* INPUT ENCODING CHECK: this function does not need this. */
      if (curs == NA_STRING)
         retint[i] = NA_INTEGER;
      else
         retint[i] = LENGTH(curs);
   }
   UNPROTECT(1);
   return ret;
}



/**
 * Count the number of characters in a string
 * 
 * Note that ICU permits only strings of length < 2^31.
 * @param s R character vector
 * @return integer vector
 */
SEXP stri_length(SEXP s)
{
   s = stri_prepare_arg_string(s);
   R_xlen_t ns = XLENGTH(s);
   UChar32 c;
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, ns));
   int* retint = INTEGER(ret);   
   for (R_xlen_t k = 0; k < ns; k++) {
     SEXP q = STRING_ELT(s, k);
     if (q == NA_STRING)
         retint[k] = NA_INTEGER;
     else {
         R_xlen_t j = 0;      // number of detected code points
         R_len_t nq = LENGTH(q);
         /* Note: ICU50 permits only int-size strings in U8_NEXT */
         const char* qc = CHAR(q); /* INPUT ENCODING CHECK: @TODO. */
         for (R_len_t i = 0; i < nq; j++)
             U8_NEXT(qc, i, nq, c);
         retint[k] = j;
     }
   }
   UNPROTECT(1);
   return ret;
}


/**
 * Check whether a string is empty
 * 
 * Note that ICU permits only strings of length < 2^31.
 * @param s R character vector
 * @return integer vector
 */
SEXP stri_isempty(SEXP s)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   R_xlen_t n = XLENGTH(s);
   SEXP ret;
   PROTECT(ret = allocVector(LGLSXP, n));
   int* retlog = LOGICAL(ret);
   for (R_xlen_t i=0; i<n; ++i) {
      SEXP curs = STRING_ELT(s, i);
      /* INPUT ENCODING CHECK: this function does not need this. */
      if (curs == NA_STRING)
         retlog[i] = NA_LOGICAL;
      else
         retlog[i] = (CHAR(curs)[0] == '\0');
   }
   UNPROTECT(1);
   return ret;  
}


/**
 * Determine the width of the strint
 * e.g. some chinese chars have width > 1.
 * 
 * Note that ICU permits only strings of length < 2^31.
 * @param s R character vector
 * @return integer vector
 */
SEXP stri_width(SEXP s)
{
   s = stri_prepare_arg_string(s);
   R_xlen_t ns = XLENGTH(s);
   UChar32 c;
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, ns));
   int* retint = INTEGER(ret);   
   
   // @TODO ------------------------------------------------------------------------------------------------------
   error("TODO: the function has not yet been implemented.");
   
   UNPROTECT(1);
   return ret;
}