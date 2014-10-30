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


#ifndef __stri_container_bytesearch_h
#define __stri_container_bytesearch_h

#include "stri_container_utf8.h"


// #define STRI__BYTESEARCH_DISABLE_KMP
// #define STRI__BYTESEARCH_DISABLE_SHORTPAT

#ifndef USEARCH_DONE
#define  USEARCH_DONE   -1
#endif


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
 */
class StriContainerByteSearch : public StriContainerUTF8 {

   private:

      R_len_t patternLen;
      const char* patternStr;
      R_len_t searchPos; // -1 after reset, searchLen on no further matches
      const char* searchStr; // owned by caller
      R_len_t searchLen; // in bytes

#ifndef NDEBUG
      R_len_t debugMatcherIndex;  ///< used by vectorize_getMatcher (internally - check)
#endif

#ifndef STRI__BYTESEARCH_DISABLE_KMP
      int* kmpNext;
      int patternPos;
      R_len_t kmpMaxSize;
#endif

      void createKMPtableFwd();
      R_len_t findFromPosFwd_short(R_len_t startPos);
      R_len_t findFromPosFwd_naive(R_len_t startPos);
      R_len_t findFromPosFwd_KMP(R_len_t startPos);

      void createKMPtableBack();
      R_len_t findFromPosBack_short(R_len_t startPos);
      R_len_t findFromPosBack_naive(R_len_t startPos);
      R_len_t findFromPosBack_KMP(R_len_t startPos);

   public:

      StriContainerByteSearch();
      StriContainerByteSearch(SEXP rstr, R_len_t nrecycle);
      StriContainerByteSearch(StriContainerByteSearch& container);
      ~StriContainerByteSearch();
      StriContainerByteSearch& operator=(StriContainerByteSearch& container);

      void setupMatcherFwd(R_len_t i, const char* searchStr, R_len_t searchLen);
      void setupMatcherBack(R_len_t i, const char* searchStr, R_len_t searchLen);
      void resetMatcher();
      R_len_t findFirst();
      R_len_t findNext();
      R_len_t findLast();
      R_len_t getMatchedStart();
      R_len_t getMatchedLength();
};

#endif
