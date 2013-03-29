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
 *  Calculate the lenght of the output vector when applying a vectorized
 *  operation on two vectors
 * 
 *  For nonconforming lengths, a warning is given
 * 
 *  @param ns1 length of some vector
 *  @param ns2 length of another vector
 *  @return max of the two given lengths
 * 
 * @version 0.1 (Marek Gagolewski)
*/
R_len_t stri__recycling_rule(R_len_t ns1, R_len_t ns2)
{
   R_len_t nsm = max(ns1, ns2);
   if (nsm % ns1 != 0 || nsm % ns2 != 0)
      warning(MSG__WARN_RECYCLING_RULE);
   return nsm;
}


/** 
 *  Calculate the lenght of the output vector when applying a vectorized
 *  operation on three vectors
 * 
 *  For nonconforming lengths, a warning is given
 * 
 *  @param ns1 length of some vector
 *  @param ns2 length of another vector
 *  @param ns3 length of last vector
 *  @return max of the three given lengths
 * 
 * @version 0.1 (Bartek Tartanus)
*/
R_len_t stri__recycling_rule3(R_len_t ns1, R_len_t ns2, R_len_t ns3)
{
   R_len_t nsm = max(ns1, ns2);
   nsm = max(nsm, ns3);
   if (nsm % ns1 != 0 || nsm % ns2 != 0 || nsm % ns3 != 0)
      warning(MSG__WARN_RECYCLING_RULE);
   return nsm;
}


/** 
 *  Calculate the lenght of the output vector when applying a vectorized
 *  operation on four vectors
 * 
 *  For nonconforming lengths, a warning is given
 * 
 *  @param ns1 length of some vector
 *  @param ns2 length of another vector
 *  @param ns3 length of next vector
 *  @param ns4 length of last vector
 *  @return max of the three given lengths
 * 
 * @version 0.1 (Bartek Tartanus)
*/
R_len_t stri__recycling_rule4(R_len_t ns1, R_len_t ns2, R_len_t ns3, R_len_t ns4)
{
   R_len_t nsm = max(ns1, ns2);
   nsm = max(nsm, ns3);
   nsm = max(nsm, ns4);
   if (nsm % ns1 != 0 || nsm % ns2 != 0 || nsm % ns3 != 0 || nsm % ns4 != 0)
      warning(MSG__WARN_RECYCLING_RULE);
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
   if (howmany < 0)
      error(MSG__EXPECTED_NONNEGATIVE);
   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, howmany));
   for (R_len_t i=0; i<howmany; ++i)
      SET_STRING_ELT(ret, i, NA_STRING);
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
   if (howmany < 0)
      error(MSG__EXPECTED_NONNEGATIVE);
   
   SEXP ret;
   PROTECT(ret = allocVector(STRSXP, howmany));
   for (R_len_t i=0; i<howmany; ++i)
      SET_STRING_ELT(ret, i, mkCharLen(NULL, 0));
   UNPROTECT(1);
   
   return ret;   
}


/** Copies one string to another, converting each ASCII lower case letter to upper case
 * 
 *  Useful for checking options.
 *  If non-ASCII string is given, an error is generated.
 * 
 *  @param dest destination buffer
 *  @param src NULL-terminated string
 *  @return \code{dest}
 * 
 * @version 0.1 (Marek Gagolewski)
 */
char* stri__asciiCopyToUpperCase(char* dest, const char* src)
{
   int i;
   for (i=0; src[i] != '\0'; ++i) {
      if (src[i] > 127)
         error(MSG__EXPECTED_ASCII);
      else if (src[i] >= 'a' && src[i] <= 'z')
         dest[i] = src[i] - ('a'-'A');
      else
         dest[i] = src[i];
   }
   dest[i] = '\0';
   return dest;
}


/** Copies one string to another, converting each ASCII upper case letter to lower case
 * 
 *  Useful for checking options.
 *  If non-ASCII string is given, an error is generated.
 * 
 *  @param dest destination buffer
 *  @param src NULL-terminated string
 *  @return \code{dest}
 * 
 * @version 0.1 (Marek Gagolewski)
 */
char* stri__asciiCopyToLowerCase(char* dest, const char* src)
{
   int i;
   for (i=0; src[i] != '\0'; ++i) {
      if (src[i] > 127)
         error(MSG__EXPECTED_ASCII);
      else if (src[i] >= 'A' && src[i] <= 'Z')
         dest[i] = src[i] + ('a'-'A');
      else
         dest[i] = src[i];
   }
   dest[i] = '\0';
   return dest;
}


/** Creates an empty R list
 * 
 * @return the same as a call to \code{list()} in R
 * 
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri__emptyList()
{
   SEXP ret = allocVector(VECSXP, 0);
   return ret;
}
