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
#include "stri_string8buf.h"


/**
 * Reverse Each String
 * @param str character vector
 * @return character vector with every string reversed
 *
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          use StriContainerUTF16
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly + StriContainerUTF8 (bug fix, do reversing manually)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *          detect incorrect utf8 byte stream
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_reverse(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));    // prepare string argument

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_len = LENGTH(str);
   StriContainerUTF8 str_cont(str, str_len); // writable, no recycle

   // STEP 1.
   // Calculate the required buffer length
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<str_len; ++i) {
      if (str_cont.isNA(i))
         continue;

      R_len_t cursize = str_cont.get(i).length();
      if (cursize > bufsize)
         bufsize = cursize;
   }

   // STEP 2.
   // Alloc buffer & result vector
   String8buf buf(bufsize);
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, str_len));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i))
   {
      if (str_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      R_len_t str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();

      R_len_t j, k;
      UChar32 chr;
      UBool isError = FALSE;

      for (j=str_cur_n, k=0; !isError && j>0; ) {
         U8_PREV(str_cur_s, 0, j, chr); // go backwards
         if (chr < 0) {
            throw StriException(MSG__INVALID_UTF8);
         }
         U8_APPEND((uint8_t*)buf.data(), k, str_cur_n, chr, isError);
      }

      if (isError)
         throw StriException(MSG__INTERNAL_ERROR);

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), str_cur_n, CE_UTF8));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
