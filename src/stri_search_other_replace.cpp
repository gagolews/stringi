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


/**
 * Replace NAs with a given string
 *
 *
 * @param str character vector
 * @param replacement single string
 * @return character vector
 *
 * @version 0.2-1 (Bartek Tartanus, 2014-03-15)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-02)
 *          Use StriContainerUTF8 for replacement
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_replace_na(SEXP str, SEXP replacement) {
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   PROTECT(replacement = stri_prepare_arg_string_1(replacement, "replacement"));
   R_len_t str_len = LENGTH(str);

   // @TODO: stri_replace_na(str, character(0)) returns a char vect with no NAs

   STRI__ERROR_HANDLER_BEGIN(2)
   StriContainerUTF8 str_cont(str, str_len);
   StriContainerUTF8 replacement_cont(replacement, 1);

   SEXP ret;
   STRI__PROTECT(ret = str_cont.toR()); // to UTF-8

   SEXP na;
   STRI__PROTECT(na = replacement_cont.toR(0));

   for (R_len_t i=0; i<str_len; ++i) {
      if (STRING_ELT(ret, i) == NA_STRING)
         SET_STRING_ELT(ret, i, na);
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
