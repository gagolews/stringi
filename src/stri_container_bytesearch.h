/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
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


#ifndef __stri_container_bytesearch_h
#define __stri_container_bytesearch_h

#include "stri_container_utf8.h"
#include "stri_bytesearch_matcher.h"

// #define STRI__BYTESEARCH_DISABLE_SHORTPAT


/**
 * A class to handle StriByteSearch patterns
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-23)
 *
 * @version 0.1-?? (Bartek Tartanus, 2013-08-15)
 *          KMP algorithm implemented
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *          KMP used by default;
 *          KMP_from back implemented;
 *          tweeks for short patterns
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-05-27)
 *          BUGFIX: invalid matcher reuse on empty search string
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *          getByteSearchFlags static method added,
 *          allow for case-insensitive search
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *          #23: add `overlap` option
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
 *          use StriByteSearchMatcher
 *
 * @version 1.3.1 (Marek Gagolewski, 2019-02-06)
 *          #337: warn on empty search pattern here
 */
class StriContainerByteSearch : public StriContainerUTF8 {

   private:

      typedef enum ByteSearchFlag {
         BYTESEARCH_CASE_INSENSITIVE = 2,
         BYTESEARCH_OVERLAP = 4
      } ByteSearchFlag;

      StriByteSearchMatcher* matcher;
      uint32_t flags; ///< ByteSearch flags


   public:

      static uint32_t getByteSearchFlags(SEXP opts_fixed, bool allow_overlap=false);

      StriContainerByteSearch();
      StriContainerByteSearch(SEXP rstr, R_len_t nrecycle, uint32_t flags);
      StriContainerByteSearch(StriContainerByteSearch& container);
      ~StriContainerByteSearch();
      StriContainerByteSearch& operator=(StriContainerByteSearch& container);

      StriByteSearchMatcher* getMatcher(R_len_t i);

      inline bool isCaseInsensitive() {
         return (bool)(flags&BYTESEARCH_CASE_INSENSITIVE);
      }

      inline bool isOverlap() {
         return (bool)(flags&BYTESEARCH_OVERLAP);
      }
};

#endif
