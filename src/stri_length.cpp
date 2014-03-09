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
 * Get the largest number of bytes in its strings
 * (useful for allocating temporary buffers)
 *
 * if all strings are NA or an empty character vector is given, -1 is returned
 * Prior to memory allocation, you should check for < 0!
 *
 * Note that ICU permits only strings of length < 2^31.
 * @param s R character vector
 * @return maximal number of bytes
 * @version 0.1 (Marek Gagolewski)
 */
R_len_t stri__numbytes_max(SEXP str)
{
   R_len_t ns = LENGTH(str);
   if (ns <= 0) return -1;
   R_len_t maxlen = -1;
   for (R_len_t i=0; i<ns; ++i) {
      SEXP cs = STRING_ELT(str, i);
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
 * @version 0.1 (Marcin Bujarski)
 */
SEXP stri_numbytes(SEXP str)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   R_len_t n = LENGTH(str);
   SEXP ret;
   PROTECT(ret = Rf_allocVector(INTSXP, n));
   int* retint = INTEGER(ret);
   for (R_len_t i=0; i<n; ++i) {
      SEXP curs = STRING_ELT(str, i);
      /* INPUT ENCODING CHECK: this function does not need this. */
      if (curs == NA_STRING)
         retint[i] = NA_INTEGER;
      else
         retint[i] = LENGTH(curs); // O(1) - stored by R
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
 * @version 0.1 (Marcin Bujarski)
 * @version 0.2 (Marek Gagolewski) Multiple input encoding support
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_length(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t ns = LENGTH(str);
   SEXP ret;

   UConverter* uconv = NULL;
   bool uconv_8bit = false;
   bool uconv_utf8 = false;

   STRI__ERROR_HANDLER_BEGIN

/* Note: ICU50 permits only int-size strings in U8_NEXT and U8_FWD_1 */
#define STRI_LENGTH_CALCULATE_UTF8  \
   const char* qc = CHAR(q);        \
   R_len_t j = 0;                   \
   for (R_len_t i = 0; i < nq; j++) \
      U8_FWD_1(qc, i, nq);          \
   retint[k] = j;

   PROTECT(ret = Rf_allocVector(INTSXP, ns));
   int* retint = INTEGER(ret);
   for (R_len_t k = 0; k < ns; k++) {
      SEXP q = STRING_ELT(str, k);
      if (q == NA_STRING)
         retint[k] = NA_INTEGER;
      else {
         R_len_t nq = LENGTH(q);  // O(1) - stored by R

         // We trust (is that a wise assumption?)
         // R encoding marks; However, it there is no mark,
         // the string may have any encoding (ascii, latin1, utf8, native)
         if (IS_ASCII(q) || IS_LATIN1(q))
            retint[k] = nq;
         else if (IS_BYTES(q))
            throw StriException(MSG__BYTESENC);
         else if (IS_UTF8(q)) {
            STRI_LENGTH_CALCULATE_UTF8
         }
         else { // Any encoding - detection needed
//            UTF-8 strings can be fairly reliably recognized as such by a
//            simple algorithm, i.e., the probability that a string of
//            characters in any other encoding appears as valid UTF-8 is low,
//            diminishing with increasing string length.
//            We have two possibilities here:
//            1. Auto detect encoding: Is this ASCII or UTF-8? If not => use Native
//                This won't work correctly in some cases.
//                e.g. (c4,85) represents ("Polish a with ogonek") in UTF-8
//                and ("A umlaut", "Ellipsis") in WINDOWS-1250
//            2. Assume it's Native; this assumes the user working in an 8-bit environment
//                would convert strings to UTF-8 manually if needed - I think is's
//                a more reasonable approach (Native --> input via keyboard)

            if (!uconv) { // open ucnv on demand
               uconv = stri__ucnv_open((const char*)NULL); // native decoder
               if (!uconv) {
                  retint[k] = NA_INTEGER;
                  continue;
               }
               uconv_8bit = ((int)ucnv_getMaxCharSize(uconv) == 1);
               if (!uconv_8bit) {
                  UErrorCode err = U_ZERO_ERROR;
                  const char* name = ucnv_getName(uconv, &err);
                  if (U_FAILURE(err))
                     throw StriException("could not query default converter");
                  uconv_utf8 = !strncmp("UTF-8", name, 5);
               }
            }

            if (uconv_8bit) {
               retint[k] = nq; // it's an 8-bit encoding :-)
            }
            else if (uconv_utf8) { // it's UTF-8
               STRI_LENGTH_CALCULATE_UTF8
            }
            else {  // native encoding which is neither 8-bit, nor UTF-8 (e.g. 'Big5')
               UErrorCode err = U_ZERO_ERROR;
               const char* source = CHAR(q);
               const char* sourceLimit = source + nq;
               R_len_t j;
               for (j = 0; source != sourceLimit; j++) {
                  if (U_FAILURE(err)) break; // error from previous iteration
                  // iterate through each native-encoded character:
                  ucnv_getNextUChar(uconv, &source, sourceLimit, &err);
               }
               if (U_FAILURE(err)) {  // error from last iteration
                  Rf_warning("error determining length for native, neither 8-bit- nor UTF-8-encoded string.");
                  retint[k] = NA_INTEGER;
               }
               else
                  retint[k] = j; // all right, we got it!
            }
         }
      }
   }
   UNPROTECT(1);

   if (uconv) {
      ucnv_close(uconv);
      uconv = NULL;
   }

   return ret;
   STRI__ERROR_HANDLER_END({
      if (uconv)
        ucnv_close(uconv);
   })
}


/**
 * Check whether a string is empty
 *
 * Note that ICU permits only strings of length < 2^31.
 * @param s R character vector
 * @return integer vector
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_isempty(SEXP str)
{
   str = stri_prepare_arg_string(str, "str"); // prepare string argument
   R_len_t n = LENGTH(str);
   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, n));
   int* retlog = LOGICAL(ret);
   for (R_len_t i=0; i<n; ++i) {
      SEXP curs = STRING_ELT(str, i);
      /* INPUT ENCODING CHECK: this function does not need this. */
      if (curs == NA_STRING)
         retlog[i] = NA_LOGICAL;
      else
         retlog[i] = (CHAR(curs)[0] == '\0'); // (LENGTH(curs) == 0); // slower?
   }
   UNPROTECT(1);
   return ret;
}


///**
// * Determine the width of the string
// * e.g. some chinese chars have width > 1.
// *
// * Note that ICU permits only strings of length < 2^31.
// * @param s R character vector
// * @return integer vector
// * @version 0.1 (WHO?) TO BE DONE
// * @todo THIS FUNCTION HAS NOT YET BEEN IMPLEMENTED
// */
//SEXP stri_width(SEXP str)
//{
//   str = stri_prepare_arg_string(str, "str");
//   R_len_t ns = LENGTH(str);
//
//
//   ///< @TODO ------------------------------------------------------------------------------------------------------
//   error("TODO: the function has not yet been implemented.");
//
//   //UChar32 c;
//   SEXP ret;
//   PROTECT(ret = allocVector(INTSXP, ns));
//   //int* retint = INTEGER(ret);
//
//
//
//   UNPROTECT(1);
//   return ret;
//}
