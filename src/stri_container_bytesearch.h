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
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *          getByteSearchFlags static method added,
 *          allow for case-insensitive search
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *          #23: add `overlap` option
 */
class StriContainerByteSearch : public StriContainerUTF8 {

   private:

      typedef enum ByteSearchFlag {
         BYTESEARCH_CASE_INSENSITIVE = 2,
         BYTESEARCH_OVERLAP = 4
      } ByteSearchFlag;

      R_len_t searchPos; // -1 after reset, searchLen on no further matches
      R_len_t searchEnd;
      const char* searchStr; // owned by caller
      R_len_t searchLen; // in bytes

      int* kmpNext;
      int patternPos;
      R_len_t kmpMaxSize;

      uint32_t flags; ///< ByteSearch flags
      R_len_t patternLen;
      const char* patternStr;
      R_len_t patternLenCaseInsensitive;
      UChar32* patternStrCaseInsensitive;

#ifndef NDEBUG
      R_len_t debugMatcherIndex;  ///< used by vectorize_getMatcher (internally - check)
#endif

      void upgradePatternCaseInsensitive();

      void createKMPtableFwd();
      void createKMPtableFwdCaseInsensitive();
      R_len_t findFromPosFwd_short(R_len_t startPos);
      R_len_t findFromPosFwd_KMP(R_len_t startPos);
//      R_len_t findFromPosFwd_naive(R_len_t startPos);

      void createKMPtableBack();
      void createKMPtableBackCaseInsensitive();
      R_len_t findFromPosBack_short(R_len_t startPos);
      R_len_t findFromPosBack_KMP(R_len_t startPos);
//      R_len_t findFromPosBack_naive(R_len_t startPos);

   public:

      static uint32_t getByteSearchFlags(SEXP opts_fixed, bool allow_overlap=false);

      StriContainerByteSearch();
      StriContainerByteSearch(SEXP rstr, R_len_t nrecycle, uint32_t flags);
      StriContainerByteSearch(StriContainerByteSearch& container);
      ~StriContainerByteSearch();
      StriContainerByteSearch& operator=(StriContainerByteSearch& container);

      void setupMatcherFwd(R_len_t i, const char* searchStr, R_len_t searchLen);
      void setupMatcherBack(R_len_t i, const char* searchStr, R_len_t searchLen);
      void resetMatcher();

      bool startsWith(R_len_t byteindex);
      bool endsWith(R_len_t byteindex);


      /** find first match
       *
       * resets the matcher
       *
       * @return USEARCH_DONE on no match, otherwise start index
       *
       * @version 0.1-?? (Marek Gagolewski)
       *
       * @version 0.1-?? (Bartek Tartanus, 2013-08-15)
       *          uses KMP
       *
       * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
       *          KMP upgraded and now used by default;
       *          special procedure for patternLen <= 4
       *
       * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
       *    use BYTESEARCH_CASE_INSENSITIVE
       */
      inline R_len_t findFirst()
      {
         // "Any byte oriented string searching algorithm can be used with
         // UTF-8 data, since the sequence of bytes for a character cannot
         // occur anywhere else."
#ifndef NDEBUG
         if (!this->searchStr || !this->patternStr)
            throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
         if (!(flags&BYTESEARCH_CASE_INSENSITIVE) && patternLen <= 4)
            return findFromPosFwd_short(0);
#endif

         return findFromPosFwd_KMP(0);
      }


      /** find next match
       *
       * continues previous search
       *
       * @return USEARCH_DONE on no match, otherwise start index
       *
       * @version 0.1-?? (Marek Gagolewski)
       *
       * @version 0.1-?? (Bartek Tartanus, 2013-08-15)
       *          uses KMP
       *
       * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
       *          KMP upgraded and now used by default;
       *          use findFromPosFwd
       *
       * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
       *    use BYTESEARCH_CASE_INSENSITIVE
       */
      inline R_len_t findNext()
      {
#ifndef NDEBUG
         if (!this->searchStr || !this->patternStr)
            throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

         if (searchPos < 0) return findFirst();

         int pos;
         if (flags&BYTESEARCH_OVERLAP) {
            pos = searchPos;
            U8_FWD_1(searchStr, pos, searchLen);
         }
         else
            pos = searchEnd;

#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
         if (!(flags&BYTESEARCH_CASE_INSENSITIVE) && patternLen <= 4)
            return findFromPosFwd_short(pos);
#endif

         return findFromPosFwd_KMP(pos);
      }


      /** find last match
       *
       * resets the matcher
       *
       * @return USEARCH_DONE on no match, otherwise start index
       *
       * @version 0.1-?? (Marek Gagolewski)
       *
       * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
       *          Using KNP
       *
       * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
       *    use BYTESEARCH_CASE_INSENSITIVE
       */
      inline R_len_t findLast()
      {
#ifndef NDEBUG
         if (!this->searchStr || !this->patternStr)
            throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
         if (!(flags&BYTESEARCH_CASE_INSENSITIVE) && patternLen <= 4)
            return findFromPosBack_short(searchLen);
#endif

         return findFromPosBack_KMP(searchLen);
      }


      /** get start index of pattern match from the last search
       *
       * @return byte index in searchStr
       */
      inline R_len_t getMatchedStart()
      {
#ifndef NDEBUG
         if (!this->searchStr || !this->patternStr)
            throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
         if (searchPos < 0 || searchEnd-searchPos <= 0 || searchPos >= searchLen)
            throw StriException("StriContainerByteSearch: no match at current position! This is a BUG.");
#endif

         return searchPos;
      }


      /** get length of pattern match from the last search
       *
       * @return byte index in searchStr
       */
      inline R_len_t getMatchedLength()
      {
#ifndef NDEBUG
         if (!this->searchStr || !this->patternStr)
            throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
         if (searchPos < 0 || searchEnd-searchPos <= 0 || searchEnd > searchLen)
            throw StriException("StriContainerByteSearch: no match at current position! This is a BUG.");
#endif

         return searchEnd-searchPos;
      }
};

#endif
