/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "stri_stringi.h"


/** dummy fun to measure the performance of .Call
 *
 */
SEXP stri_test_returnasis(SEXP x)
{
#ifndef NDEBUG
   return x;
#else
   Rf_error("This function is enabled only if NDEBUG is undef.");
   return x;  // x here avoids compiler warning
#endif
}


/** Check R encoding marking *for testing only*
 *  This function should not be exported
 *
 *  @param s character vector
 *
 *  Results are printed on STDERR
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_test_Rmark(SEXP s)
{
#ifndef NDEBUG
   s = stri_prepare_arg_string(s, "str");
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
   return R_NilValue;
#else
   Rf_error("This function is enabled only if NDEBUG is undef.");
   return s;  // s here avoids compiler warning
#endif
}


/** for testing efficiency of StriContainerUTF16 [internal]
 * @param str character vector
 * @return R_NilValue
 */
SEXP stri_test_UnicodeContainer16(SEXP str)
{
#ifndef NDEBUG
   str = stri_prepare_arg_string(str, "str");
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF16 ss(str, LENGTH(str));
   return R_NilValue;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
#else
   Rf_error("This function is enabled only if NDEBUG is undef.");
   return str; // str here avoids compiler warning
#endif
}


/** for testing efficiency of StriContainerUTF8  [internal]
 * @param str character vector
 * @return R_NilValue
 */
SEXP stri_test_UnicodeContainer8(SEXP str)
{
#ifndef NDEBUG
   str = stri_prepare_arg_string(str, "str");
   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 ss(str, LENGTH(str));
   return R_NilValue;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
#else
   Rf_error("This function is enabled only if NDEBUG is undef.");
   return str;  // str here avoids compiler warning
#endif
}
