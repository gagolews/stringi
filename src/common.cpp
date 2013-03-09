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
 *  Create a character vector filled with NA_character_
 * 
 *  Useful when something goes wrong
 * 
 *  @param how_many length of the vector
 *  @return a character vector of length how_many
*/
SEXP stri__mkStringNA(R_len_t howmany)
{
   if (howmany <= 0) return R_NilValue;
   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, howmany));
   for (R_len_t i=0; i<howmany; ++i)
      SET_STRING_ELT(ret, i, NA_STRING);
   UNPROTECT(1);
   return ret;   
}


/** 
 *  Create a character vector filled with empty strings
 * 
 *  @param how_many length of the vector
 *  @return a character vector of length how_many
*/
SEXP stri__mkStringEmpty(R_len_t howmany)
{
   if (howmany <= 0) return R_NilValue;
   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, howmany));
   for (R_len_t i=0; i<howmany; ++i)
      SET_STRING_ELT(ret, i, mkCharLen(NULL, 0));
   UNPROTECT(1);
   return ret;   
}


/** Convert each ascii lower case letter to upper case
 *  Useful for checking options.
 *  If non-ASCII string is given, an error is generated.
 *  @param x string [IN/OUT], null-terminated
 */
void stri__asciiUpperCase(char* x)
{
   for (int i=0; x[i] != '\0'; ++i) {
      if (x[i] > 127)
         error(MSG__EXPECTED_ASCII);
      else if (x[i] >= 'a' && x[i] <= 'z')
         x[i] -= 'a'-'A';
   }
}


/** Creates an empty R list
 *  @return list()
 */
SEXP stri__emptyList()
{
   SEXP ret = allocVector(VECSXP, 0);
   return ret;
}


/** Converts an R character vector with arbitrary encoding to UTF-8
 *  @param x CHARSXP (R marked encoding)
 *  @param outenc guide for stri__convertOutputFromUtf8()
 *  @return CHARSXP (converted)
 */
SEXP stri__convertInputToUtf8(SEXP x, cetype_t& outenc)
{
////    CE_NATIVE = 0,
////    CE_UTF8   = 1,
////    CE_LATIN1 = 2,
////    CE_BYTES  = 3,
////    CE_SYMBOL = 5,
////    CE_ANY
   outenc = CE_UTF8; // tmp
   return x; // tmp
}


/** Converts an R character vector from UTF-8 to an encoding suggested by outenc
 *  @param x CHARSXP in UTF-8
 *  @param outenc guide from stri__convertInputToUtf8()
 *  @return CHARSXP (converted)
 */
SEXP stri__convertOutputFromUtf8(SEXP x, cetype_t outenc)
{
   if (outenc == CE_UTF8)
      return x;
   else {
      return x; // tmp  
   }
}


