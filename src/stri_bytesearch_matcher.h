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


#ifndef __stri_bytesearch_matcher_h
#define __stri_bytesearch_matcher_h


/**
 * Performs actual pattern matching on behalf of StriContainerByteSearch
 * 
 * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
 *    code taken from StriContainerByteSearch
 */
class StriByteSearchMatcher {
   protected:
   
      bool m_optOverlap;
      
      R_len_t m_searchPos; // -1 after reset, searchLen on no further matches
      R_len_t m_searchEnd;
      const char* m_searchStr; // owned by caller
      R_len_t m_searchLen; // in bytes
      
      R_len_t m_patternLen;
      const char* m_patternStr;
      
   public:
   
      StriByteSearchMatcher(const char* patternStr, R_len_t patternLen, bool optOverlap) {
         this->m_optOverlap = optOverlap;
         this->m_patternStr = patternStr;
         this->m_patternLen = patternLen;
         this->m_searchStr = NULL;
      }
      
      virtual void reset(const char* searchStr, R_len_t searchLen) {
         this->m_searchStr = searchStr;
         this->m_searchLen = searchLen;
         this->m_searchPos = -1;
         this->m_searchEnd = -1;
      }
   
      virtual R_len_t findFirst() = 0;
      virtual R_len_t findNext() = 0;
      virtual R_len_t findLast() = 0;
      
      /** get start index of pattern match from the last search
       *
       * @return byte index in searchStr
       */
      inline R_len_t getMatchedStart()
      {
#ifndef NDEBUG
         if (!this->m_searchStr || !this->m_patternStr)
            throw StriException("DEBUG: StriByteSearchMatcher: reset() hasn't been called yet");
         if (m_searchPos < 0 || m_searchEnd-m_searchPos <= 0 || m_searchPos >= m_searchLen)
            throw StriException("StriByteSearchMatcher: no match at current position! This is a BUG.");
#endif

         return m_searchPos;
      }


      /** get length of pattern match from the last search
       *
       * @return byte index in searchStr
       */
      inline R_len_t getMatchedLength()
      {
#ifndef NDEBUG
         if (!this->m_searchStr || !this->m_patternStr)
            throw StriException("DEBUG: StriByteSearchMatcher: reset() hasn't been called yet");
         if (m_searchPos < 0 || m_searchEnd-m_searchPos <= 0 || m_searchEnd > m_searchLen)
            throw StriException("StriByteSearchMatcher: no match at current position! This is a BUG.");
#endif

         return m_searchEnd-m_searchPos;
      }
};

class StriByteSearchMatcherKMP : public StriByteSearchMatcher {
   
   private:
   
      int* m_kmpNext;
      int m_patternPos;
      R_len_t m_kmpMaxSize;
   
   
   public:
   
      StriByteSearchMatcherKMP(const char* patternStr, R_len_t patternLen, bool optOverlap)
         : StriByteSearchMatcher(patternStr, patternLen, optOverlap)
      {
         // .....
      }
   
      virtual void reset(const char* searchStr, R_len_t searchLen) {
         StriByteSearchMatcher::reset(searchStr, searchLen);
         m_patternPos = -1;
      }
};

class StriByteSearchMatcherKMPci : public StriByteSearchMatcher {
   
   private:
   
      int* m_kmpNext;
      int m_patternPos;
      R_len_t m_kmpMaxSize;
      R_len_t m_patternLenCaseInsensitive;
      UChar32* m_patternStrCaseInsensitive;
   
   
   public:
   
      StriByteSearchMatcherKMPci(const char* patternStr, R_len_t patternLen, bool optOverlap)
         : StriByteSearchMatcher(patternStr, patternLen, optOverlap)
      {
         // .....
      }
   
      virtual void reset(const char* searchStr, R_len_t searchLen) {
         StriByteSearchMatcher::reset(searchStr, searchLen);
         m_patternPos = -1;
      }
};

#endif
