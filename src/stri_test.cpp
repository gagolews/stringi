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
#include "stri_container_utf8.h"
#include "stri_container_utf16.h"


/** dummy fun to measure the performance of .Call
 *
 * @version 0.1-?? (Marek Gagolewski)
 */
SEXP stri_test_returnasis(SEXP x)
{
   return x;
}


/** Check R encoding marking *for testing only*
 *  This function should not be exported
 *
 *  @param s character vector
 *
 *  Results are printed on STDERR
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_test_Rmark(SEXP s)
{
#ifndef NDEBUG
   PROTECT(s = stri_prepare_arg_string(s, "str"));
   int ns = LENGTH(s);
   for (int i=0; i < ns; ++i) {
      fprintf(stdout, "!NDEBUG: Element #%d:\n", i);
      SEXP curs = STRING_ELT(s, i);
      if (curs == NA_STRING){
         fprintf(stdout, "!NDEBUG: \tNA\n");
         continue;
      }
      //const char* string = CHAR(curs);
      fprintf(stdout, "!NDEBUG: \tMARK_ASCII = %d\n", (IS_ASCII(curs) > 0));
      fprintf(stdout, "!NDEBUG: \tMARK_UTF8  = %d\n", (IS_UTF8(curs) > 0));
      fprintf(stdout, "!NDEBUG: \tMARK_LATIN1= %d\n", (IS_LATIN1(curs) > 0));
      fprintf(stdout, "!NDEBUG: \tMARK_BYTES = %d\n", (IS_BYTES(curs) > 0));
      fprintf(stdout, "!NDEBUG: \n");
   }
   UNPROTECT(1);
   return R_NilValue;
#else
   Rf_error("This function is enabled only if NDEBUG is undef.");
   return s;  // s here avoids compiler warning
#endif
}


/** for testing efficiency of StriContainerUTF16 [internal]
 *
 * @param str character vector
 * @return R_NilValue
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_test_UnicodeContainer16(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerUTF16 ss(str, LENGTH(str));
   STRI__UNPROTECT_ALL
   return R_NilValue;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/** for testing efficiency of StriContainerUTF16 [internal]
 *
 * @param str character vector
 * @return R_NilValue
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-03)
 */
SEXP stri_test_UnicodeContainer16b(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerUTF16 ss(str, LENGTH(str));
   STRI__UNPROTECT_ALL
   return ss.toR();
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/** for testing efficiency of StriContainerUTF8  [internal]
 * @param str character vector
 * @return R_NilValue
 *
 * @version 0.1-?? (Marek Gagolewski)
 */
SEXP stri_test_UnicodeContainer8(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerUTF8 ss(str, LENGTH(str));
   STRI__UNPROTECT_ALL
   return R_NilValue;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
