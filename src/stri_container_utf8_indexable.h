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


#ifndef __stri_container_utf8_indexable_h
#define __stri_container_utf8_indexable_h

#include "stri_container_utf8.h"


/**
 * A class to handle conversion between R character
 * vectors and UTF-8 string vectors,
 * with UChar32 to UTF-8 indices translation
 *
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-20)
 *          separated from StriContainerUTF8
 */
class StriContainerUTF8_indexable : public StriContainerUTF8 {

   private:

      // the following are used in UChar32_to_UTF8_index_back
      // and UChar32_to_UTF8_index_fwd to speed up computations
      // on the same strings
      R_len_t last_ind_fwd_codepoint;
      R_len_t last_ind_fwd_utf8;
      const char* last_ind_fwd_str;
      R_len_t last_ind_back_codepoint;
      R_len_t last_ind_back_utf8;
      const char* last_ind_back_str;

   public:

      StriContainerUTF8_indexable();
      StriContainerUTF8_indexable(SEXP rstr, R_len_t nrecycle, bool shallowrecycle=true);
      StriContainerUTF8_indexable(StriContainerUTF8_indexable& container);
      StriContainerUTF8_indexable& operator=(StriContainerUTF8_indexable& container);

      void UTF8_to_UChar32_index(R_len_t i, int* i1, int* i2, const int ni, int adj1, int adj2);
      R_len_t UChar32_to_UTF8_index_back(R_len_t i, R_len_t wh);
      R_len_t UChar32_to_UTF8_index_fwd(R_len_t i, R_len_t wh);
};

#endif
