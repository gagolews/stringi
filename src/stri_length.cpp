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
#include "stri_ucnv.h"


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
 *
 * @version 0.1-?? (Marek Gagolewski)
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
   // @TODO: overload this function for StriContainers.....
}


/**
 * Count the number of characters in a string
 *
 * Note that ICU permits only strings of length < 2^31.
 * @param s R character vector
 * @return integer vector
 *
 * @version 0.1-?? (Marcin Bujarski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          Multiple input encoding support
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-27)
 *          using StriUcnv;
 *          warn on invalid utf-8 sequences
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_length(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));

   STRI__ERROR_HANDLER_BEGIN(1)

   R_len_t str_n = LENGTH(str);
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_n));
   int* retint = INTEGER(ret);

   StriUcnv ucnvNative(NULL);

   for (R_len_t k = 0; k < str_n; k++) {
      SEXP curs = STRING_ELT(str, k);
      if (curs == NA_STRING) {
         retint[k] = NA_INTEGER;
         continue;
      }

      R_len_t curs_n = LENGTH(curs);  // O(1) - stored by R
      if (IS_ASCII(curs) || IS_LATIN1(curs)) {
         retint[k] = curs_n;
      }
      else if (IS_BYTES(curs)) {
         throw StriException(MSG__BYTESENC);
      }
      else if (IS_UTF8(curs) || ucnvNative.isUTF8()) { // utf8 or native-utf8
         UChar32 c = 0;
         const char* curs_s = CHAR(curs);
         R_len_t j = 0;
         R_len_t i = 0;
         while (c >= 0 && j < curs_n) {
            U8_NEXT(curs_s, j, curs_n, c); // faster that U8_FWD_1 & gives bad UChar32s
            i++;
         }

         if (c < 0) { // invalid utf-8 sequence
            Rf_warning(MSG__INVALID_UTF8);
            retint[k] = NA_INTEGER;
         }
         else
            retint[k] = i;
      }
      else if (ucnvNative.is8bit()) { // native-8bit
         retint[k] = curs_n;
      }
      else { // native encoding, not 8 bit

         UConverter* uconv = ucnvNative.getConverter();

         // native encoding which is neither 8-bit, nor UTF-8 (e.g. 'Big5')
         // this is weird, but we'll face it
         UErrorCode status = U_ZERO_ERROR;
         const char* source = CHAR(curs);
         const char* sourceLimit = source + curs_n;
         R_len_t j;
         for (j = 0; source != sourceLimit; j++) {
            /*ignore_retval=*/ucnv_getNextUChar(uconv, &source, sourceLimit, &status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
         }
         retint[k] = j; // all right, we got it!
      }
   }

   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({ /* no special action on error */ })
}


/**
 * Get number of bytes in each string
 *
 * Note that ICU permits only strings of length < 2^31.
 *
 * @param s R object coercible to a character vector
 * @return integer vector
 *
 * @version 0.1-?? (Marcin Bujarski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *          StriException-friendly
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_numbytes(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str")); // prepare string argument
   R_len_t str_n = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN(1)
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_n));
   int* retint = LOGICAL(ret);
   for (R_len_t i=0; i<str_n; ++i) {
      SEXP curs = STRING_ELT(str, i);
      /* INPUT ENCODING CHECK: this function does not need this. */
      retint[i] = (curs == NA_STRING)?NA_INTEGER:LENGTH(curs); // O(1) - stored by R
   }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({ /* no special action on error */ })
}


/**
 * Determine which strings are of length 0
 *
 * Note that ICU permits only strings of length < 2^31.
 *
 * @param s R character vector
 * @return logical vector
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *          StriException-friendly
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_isempty(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str")); // prepare string argument
   R_len_t str_n = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN(1)
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, str_n));
   int* retlog = LOGICAL(ret);
   for (R_len_t i=0; i<str_n; ++i) {
      SEXP curs = STRING_ELT(str, i);
      /* INPUT ENCODING CHECK: this function does not need this. */
      retlog[i] = (curs == NA_STRING)?NA_LOGICAL:(LENGTH(curs) <= 0);
   }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({ /* no special action on error */ })
}


///**
// * Determine the width of the string
// * e.g. some chinese chars have width > 1.
// *
// * Note that ICU permits only strings of length < 2^31.
// * @param s R character vector
// * @return integer vector
// *
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
//   STRI__PROTECT(ret = allocVector(INTSXP, ns));
//   //int* retint = INTEGER(ret);
//
//
//
//   STRI__UNPROTECT_ALL
//   return ret;
//}
