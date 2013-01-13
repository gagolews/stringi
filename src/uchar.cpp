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


/** get char types for each code point UTF-8 string
 * @param s UTF-8 encoded string
 * @param n number of bytes
 * @param codes [OUT] the char types/codes; array of length >= n
 * @param ncodes [OUT] number of code points found
 */
void stri__uchar_charType(const char* s, int n, int* codes, int& ncodes)
{
   UChar32 c;
   ncodes=0;
   for (int i=0; i<n; ) {
      U8_NEXT(s, i, n, c);
      codes[ncodes++] =  u_charType(c);
   }
}


/** Get character types
 * @param s character vector
 * @return list of integer vectors
 * @TODO other encodings..................
 */
SEXP stri_chartype(SEXP s)
{
   s = stri_prepare_arg_string(s);
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return R_NilValue;
   
   R_len_t bufsize = stri__numbytes_max(s);
   int* buf = 0;
   if (bufsize > 0) buf = new int[bufsize];
   
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, ns));
   for (R_len_t i=0; i<ns; ++i) {
      SEXP ns = STRING_ELT(s, i);
      if (ns == NA_STRING)
         SET_VECTOR_ELT(ret, i, ScalarInteger(NA_INTEGER)); // hmmmm..... integer(0)?
      else {
         R_len_t cns = LENGTH(ns);
         int ncodes;
         stri__uchar_charType(CHAR(ns), cns, buf, ncodes);
         SEXP codes;
         PROTECT(codes = allocVector(INTSXP, ncodes));
         int* int_codes = INTEGER(codes);
         for (int j=0; j<ncodes; ++j)
            int_codes[j] = buf[j];
         UNPROTECT(1);
         SET_VECTOR_ELT(ret, i, codes);
      }
   }
   if (buf) delete [] buf;
   UNPROTECT(1);
   return ret;
}


/** Get character names
 * @param s character vector
 * @return list of character vectors
 * @TODO other encodings..................
 */
SEXP stri_charname(SEXP s)
{
   s = stri_prepare_arg_string(s);
   error("not implemented yet");
   return s;
}
