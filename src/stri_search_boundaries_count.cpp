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
#include "stri_container_utf8_indexable.h"
#include "stri_container_integer.h"
#include "stri_brkiter.h"


/** Count the number of BreakIterator boundaries
 *
 * @param str character vector
 * @param opts_brkiter identifier
 * @return character vector
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-30)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-02)
 *          use StriRuleBasedBreakIterator
 */
SEXP stri_count_boundaries(SEXP str, SEXP opts_brkiter)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   StriBrkIterOptions opts_brkiter2(opts_brkiter, "line_break");

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_length = LENGTH(str);
   StriContainerUTF8_indexable str_cont(str, str_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_length));
   StriRuleBasedBreakIterator brkiter(opts_brkiter2);

   for (R_len_t i = 0; i < str_length; ++i)
   {
      if (str_cont.isNA(i)) {
         INTEGER(ret)[i] = NA_INTEGER;
         continue;
      }

      brkiter.setupMatcher(str_cont.get(i).c_str(), str_cont.get(i).length());
      brkiter.first();

      R_len_t cur_count = 0;
      while (brkiter.next())
         ++cur_count;

      INTEGER(ret)[i] = cur_count;
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({ /* no action */  })
}
