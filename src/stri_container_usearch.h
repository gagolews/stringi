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


#ifndef __stri_container_usearch_h
#define __stri_container_usearch_h

#include "stri_container_utf16.h"
#include <unicode/coll.h>
#include <unicode/ucol.h>
#include <unicode/stsearch.h>


/**
 * A class to handle UStringSearch searches
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-23)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-18)
 *          BUGFIX: memleaks on StriException
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-05-27)
 *          BUGFIX: invalid matcher reuse on empty search string
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-01)
 *          getMatcher() now also accepts UChar*
 */
class StriContainerUStringSearch : public StriContainerUTF16 {

   private:

      UCollator* col; ///< collator, owned by creator
      UStringSearch* lastMatcher; ///< recently used \code{UStringSearch}
      R_len_t lastMatcherIndex;  ///< used by vectorize_getMatcher


   public:

      StriContainerUStringSearch();
      StriContainerUStringSearch(SEXP rstr, R_len_t nrecycle, UCollator* col);
      StriContainerUStringSearch(StriContainerUStringSearch& container);
      ~StriContainerUStringSearch();
      StriContainerUStringSearch& operator=(StriContainerUStringSearch& container);
      UStringSearch* getMatcher(R_len_t i, const UnicodeString& searchStr);
      UStringSearch* getMatcher(R_len_t i, const UChar* searchStr, int32_t searchStr_len);
};

#endif
