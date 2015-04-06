/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2015, Marek Gagolewski and Bartek Tartanus
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
#include <deque>


/**
 * fill a deque with CHARSXPs == individual code points in s of length n
 */
void stri__split_codepoints(deque<SEXP>& out, const char* s, int n) {
   UChar32 c = 0;
   R_len_t j = 0; // current pos
   R_len_t i = 0; // last pos
   while (j < n) {
      U8_NEXT(s, j, n, c);
      out.push_back(Rf_mkCharLenCE(s+i, j-i, CE_UTF8));

      if (c < 0)
         Rf_warning(MSG__INVALID_UTF8);
      i = j;
   }
}


/**
 *  Translate characters
 *
 *
 *  @param str character vector
 *  @param pattern character vector
 *  @param replacement character vector
 *  @return character vector
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-04-06)
 *
 *
 */
SEXP stri_trans_char(SEXP str, SEXP pattern, SEXP replacement) {
   PROTECT(str          = stri_prepare_arg_string(str, "str"));
   PROTECT(pattern      = stri_prepare_arg_string_1(pattern, "pattern"));
   PROTECT(replacement  = stri_prepare_arg_string_1(replacement, "replacement"));

   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerUTF8 replacement_cont(replacement, 1);
   StriContainerUTF8 pattern_cont(pattern, 1);

   if (replacement_cont.isNA(0) || pattern_cont.isNA(0)) {
      STRI__UNPROTECT_ALL
      return stri__vector_NA_strings(LENGTH(str));
   }

   const String8* s_pat = &pattern_cont.get(0);
   const String8* s_rep = &replacement_cont.get(0);

   deque<SEXP> d_pat;
   stri__split_codepoints(d_pat, s_pat->c_str(), s_pat->length());

   deque<SEXP> d_rep;
   stri__split_codepoints(d_rep, s_rep->c_str(), s_rep->length());

   R_len_t m = std::min(d_rep.size(), d_pat.size());
   if (d_pat.size() != d_rep.size()) {
      Rf_warning(MSG__WARN_RECYCLING_RULE);
   }

   if (m == 0) { // nothing to do
      StriContainerUTF8 str_cont(str, LENGTH(str));
      STRI__UNPROTECT_ALL
      return str_cont.toR(); // assure UTF-8
   }


   SEXP new_pattern;
   SEXP new_replacement;
   STRI__PROTECT(new_pattern = Rf_allocVector(STRSXP, m));
   STRI__PROTECT(new_replacement = Rf_allocVector(STRSXP, m));
   deque<SEXP>::iterator it1 = d_pat.begin();
   deque<SEXP>::iterator it2 = d_rep.begin();
   for (R_len_t i=0; i<m; ++i) {
      SET_STRING_ELT(new_pattern,     i, *it1++);
      SET_STRING_ELT(new_replacement, i, *it2++);
   }


   SEXP ret;
   STRI__PROTECT(ret = stri_replace_all_fixed(str, new_pattern, new_replacement,
      /*vectorize_all*/Rf_ScalarLogical(FALSE), /*opts_fixed*/R_NilValue)
   )


   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
