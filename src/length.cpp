/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus
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
 * 
 * @param s R character vector
 * @return maximal number of bytes
 */
R_len_t stri__numbytes_max(SEXP s)
{
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return -1;
   
   int maxlen = -1;
   for (R_len_t i=0; i<ns; ++i) {
      SEXP cs = STRING_ELT(s, i);
      if (cs == NA_STRING) continue;
      R_len_t cns = LENGTH(cs);
      if (cns > maxlen) maxlen = cns;
   }
   return maxlen;
}

/** 
 * Get number of bytes in a string
 * @param s R object coercible to a character vector
 * @return integer vector
 */
SEXP stri_numbytes(SEXP s)
{
   s = stri_prepare_arg_string(s); // prepare string argument
   
   int n = LENGTH(s); // XLENGTH - LENGTH with long vector support
   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, n));
   for (int i=0; i<n; ++i) {
      SEXP curs = STRING_ELT(s, i);
      if (curs == NA_STRING)
         INTEGER(ret)[i] = NA_INTEGER;
      else
         INTEGER(ret)[i] = LENGTH(curs);
   }
   UNPROTECT(1);
   return ret;
}
