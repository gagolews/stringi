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
#include "stri_container_bytesearch.h"
#include <unicode/usearch.h>


/**
 * Default constructor
 *
 */
StriContainerByteSearch::StriContainerByteSearch()
   : StriContainerUTF8()
{
   this->patternLen = 0;
   this->patternStr = NULL;
   this->searchPos = -1;
   this->searchStr = NULL;
   this->searchLen = 0;
#ifndef NDEBUG
   this->debugMatcherIndex = -1;
#endif
#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->kmpMaxSize = 0;
   this->patternPos = -1;
   this->kmpNext = NULL;
#endif
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param _nrecycle extend length [vectorization]
 */
StriContainerByteSearch::StriContainerByteSearch(SEXP rstr, R_len_t _nrecycle)
   : StriContainerUTF8(rstr, _nrecycle, true)
{
   this->patternLen = 0;
   this->patternStr = NULL;
   this->searchPos = -1;
   this->searchStr = NULL;
   this->searchLen = 0;
#ifndef NDEBUG
   this->debugMatcherIndex = -1;
#endif
#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->patternPos = -1;
   this->kmpMaxSize = getMaxNumBytes()+1;
   this->kmpNext = new int[kmpMaxSize];
#endif
}


/** Copying constructor
 *
 */
StriContainerByteSearch::StriContainerByteSearch(StriContainerByteSearch& container)
   :    StriContainerUTF8((StriContainerUTF8&)container)
{
   this->patternLen = 0;
   this->patternStr = NULL;
   this->searchPos = -1;
   this->searchStr = NULL;
   this->searchLen = 0;
#ifndef NDEBUG
   this->debugMatcherIndex = -1;
#endif
#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->patternPos = -1;
   this->kmpMaxSize = container.kmpMaxSize;
   this->kmpNext = new int[kmpMaxSize];
#endif
}


/** Copy operator
 * @param container source
 * @return *this
 */
StriContainerByteSearch& StriContainerByteSearch::operator=(StriContainerByteSearch& container)
{
   this->~StriContainerByteSearch();
   (StriContainerUTF8&) (*this) = (StriContainerUTF8&)container;
   this->patternLen = 0;
   this->patternStr = NULL;
   this->searchPos = -1;
   this->searchStr = NULL;
   this->searchLen = 0;
#ifndef NDEBUG
   this->debugMatcherIndex = -1;
#endif
#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->patternPos = -1;
   this->kmpMaxSize = container.kmpMaxSize;
   this->kmpNext = new int[kmpMaxSize];
#endif
   return *this;
}


/** Destructor
 *
 */
StriContainerByteSearch::~StriContainerByteSearch()
{
   // nothing to clean
#ifndef STRI__BYTESEARCH_DISABLE_KMP
   if (kmpNext)
      delete [] kmpNext;
#endif
}


/** Create KMP table for rev iteration
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
*/
void StriContainerByteSearch::createKMPtableBack()
{
   int k = 0, j = -1;
   kmpNext[0] = -1;
   while (k < patternLen) {
      while (j > -1 && patternStr[patternLen-1-k] != patternStr[patternLen-1-j])
         j = kmpNext[j];
      k++;
      j++;
      if (patternStr[patternLen-1-k] == patternStr[patternLen-1-j])
         kmpNext[k] = kmpNext[j];
      else
         kmpNext[k] = j;
   }
}


/** Create KMP table for fwd iteration
 *
 * @version 0.1-?? (Bartek Tartanus, 2013-08-15)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *          KMP upgrade; special procedure for patternLen <= 4
*/
void StriContainerByteSearch::createKMPtableFwd()
{
   int k = 0, j = -1;
   kmpNext[0] = -1;
   while (k < patternLen) {
      while (j > -1 && patternStr[k] != patternStr[j])
         j = kmpNext[j];
      k++;
      j++;
      if (patternStr[k] == patternStr[j])
         kmpNext[k] = kmpNext[j];
      else
         kmpNext[k] = j;
   }
}


/** setup/reuse matcher for findLast
 *
 * @param i index
 * @param searchStr string to search in
 * @param searchLen string length in bytes
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 */
void StriContainerByteSearch::setupMatcherBack(R_len_t i, const char* _searchStr, R_len_t _searchLen)
{
   if (i >= n) {
#ifndef NDEBUG
      if ((debugMatcherIndex % n) != (i % n)) {
         throw StriException("DEBUG: vectorize_getMatcher - matcher reuse failed!");
      }
#endif
      // matcher reuse
   }
   else {
      this->patternStr = get(i).c_str();
      this->patternLen = get(i).length();

#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
      if (this->patternLen > 4) { // a short pattern => don't use KMP
#endif
#ifndef STRI__BYTESEARCH_DISABLE_KMP
         createKMPtableBack();
#endif
#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
      }
#endif
   }

   this->searchStr = _searchStr;
   this->searchLen = _searchLen;
   this->resetMatcher();

#ifndef NDEBUG
   debugMatcherIndex = (i % n);
#endif
}


/** setup/reuse matcher for findFirst/findNext
 *
 * @param i index
 * @param searchStr string to search in
 * @param searchLen string length in bytes
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Bartek Tartanus, 2013-08-15)
 *          uses KMP
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *          KMP upgrade;
 *          special procedure for patternLen <= 4
 */
void StriContainerByteSearch::setupMatcherFwd(R_len_t i, const char* _searchStr, R_len_t _searchLen)
{
   if (i >= n) {
#ifndef NDEBUG
      if ((debugMatcherIndex % n) != (i % n)) {
         throw StriException("DEBUG: vectorize_getMatcher - matcher reuse failed!");
      }
#endif
      // matcher reuse
   }
   else {
      this->patternStr = get(i).c_str();
      this->patternLen = get(i).length();

#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
      if (this->patternLen > 4) { // a short pattern => don't use KMP
#endif
#ifndef STRI__BYTESEARCH_DISABLE_KMP
         createKMPtableFwd();
#endif
#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
      }
#endif
   }

   this->searchStr = _searchStr;
   this->searchLen = _searchLen;
   this->resetMatcher();

#ifndef NDEBUG
   debugMatcherIndex = (i % n);
#endif
}


/** reset matcher
 *
 * will start search from the beginning next time
 */
void StriContainerByteSearch::resetMatcher()
{
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

   this->searchPos = -1;
#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->patternPos = -1;
#endif
}


/** find first match - case of short pattern
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *          special procedure for patternLen <= 4
 *
 * @version 0.2-4 (Marek Gagolewski, 2014-05-15)
 *          BUGFIX: load of misaligned adresses
 */
R_len_t StriContainerByteSearch::findFromPosFwd_short(R_len_t startPos)
{
   if (patternLen == 1) {
      unsigned char pat = (unsigned char)patternStr[0];
      for (searchPos = startPos; searchPos<searchLen-1+1; ++searchPos) {
         if (pat == (unsigned char)searchStr[searchPos]) {
            return searchPos;
         }
      }
   }
   else if (patternLen == 2) {
// /* v1: 17.67ms; BUG: loads misaligned addresses... */
//      uint16_t pat = *((uint16_t*)patternStr);
//      for (searchPos = startPos; searchPos<searchLen-2+1; ++searchPos) {
//         if (pat == *((uint16_t*)(searchStr+searchPos))) {
//            return searchPos;
//         }
//      }

/* v2: 21.62 ms */
      // be careful: little vs big endian!
      uint16_t pat  = ((uint16_t)((unsigned char)patternStr[0]));
               pat <<= 8;
               pat |= ((uint16_t)((unsigned char)patternStr[1]));
      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
      uint16_t cur  = ((uint16_t)(*curstr));
      ++curstr;
      for (searchPos = startPos; searchPos<searchLen-2+1; ++searchPos) {
         cur <<= 8;
         cur |= (uint16_t)(*curstr);
         ++curstr;
         if (pat == cur) {
            return searchPos;
         }
      }
   }
   else if (patternLen == 3) {
// /* v1: 25.52ms; BUG: loads misaligned addresses... */
//      uint8_t  pat1 = (uint8_t)patternStr[0];
//      uint16_t pat2 = *((uint16_t*)(patternStr+1));
//      for (searchPos = startPos; searchPos<searchLen-3+1; ++searchPos) {
//         if (pat1 == (uint8_t)searchStr[searchPos]
//             && pat2 == *((uint16_t*)(searchStr+searchPos+1))) {
//            return searchPos;
//         }
//      }

/* v2: 25.95 ms */
      uint32_t pat  = ((uint32_t)((unsigned char)patternStr[0]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[1]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[2]));

      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
      uint32_t cur  = ((uint32_t)(*curstr));
      ++curstr;
      cur <<= 8;
      cur |= (uint32_t)(*curstr);
      ++curstr;

      uint32_t mask = ~(((unsigned char)0xff)<<24);

      for (searchPos = startPos; searchPos<searchLen-3+1; ++searchPos) {
         cur <<= 8;
         cur |= (uint32_t)(*curstr);
         ++curstr;
         if ((pat&mask) == (cur&mask)) {
            return searchPos;
         }
      }
   }
   else if (patternLen == 4) {
// /* v1: 17.71ms; BUG: loads misaligned addresses... */
//      uint32_t pat = *((uint32_t*)patternStr);
//      for (searchPos = startPos; searchPos<searchLen-4+1; ++searchPos) {
//         if (pat == *((uint32_t*)(searchStr+searchPos))) {
//            return searchPos;
//         }
//      }

/* v2: 21.68 ms */
      uint32_t pat  = ((uint32_t)((unsigned char)patternStr[0]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[1]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[2]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[3]));

      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
      uint32_t cur  = ((uint32_t)(*curstr));
      ++curstr;
      cur <<= 8;
      cur |= (uint32_t)(*curstr);
      ++curstr;
      cur <<= 8;
      cur |= (uint32_t)(*curstr);
      ++curstr;


      for (searchPos = startPos; searchPos<searchLen-4+1; ++searchPos) {
         cur <<= 8;
         cur |= (uint32_t)(*curstr);
         ++curstr;
         if (pat == cur) {
            return searchPos;
         }
      }
   }
   // else not found
   searchPos = searchLen;
   return USEARCH_DONE;
}


/** find first match - naive search
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *          separate method
 */
R_len_t StriContainerByteSearch::findFromPosFwd_naive(R_len_t startPos)
{
   // Naive search algorithm
   for (searchPos = startPos; searchPos<searchLen-patternLen+1; ++searchPos) {
      R_len_t k=0;
      while (k<patternLen && searchStr[searchPos+k] == patternStr[k])
         k++;
      if (k == patternLen) {
         // found!
         return searchPos;
      }
   }
   // not found
   searchPos = searchLen;
   return USEARCH_DONE;
}


/** find first match - KMP
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.1-?? (Bartek Tartanus, 2013-08-15)
 *          KMP - first approach
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *          KMP upgraded; separate method
 */
R_len_t StriContainerByteSearch::findFromPosFwd_KMP(R_len_t startPos)
{
   int j = startPos;
   patternPos = 0;
   while (j < searchLen) {
      while (patternPos >= 0 && patternStr[patternPos] != searchStr[j])
         patternPos = kmpNext[patternPos];
      patternPos++;
      j++;
      if (patternPos >= patternLen) {
         searchPos = j-patternPos;
         return searchPos;
      }
   }
   // else not found
   searchPos = searchLen;
   return USEARCH_DONE;
}


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
 */
R_len_t StriContainerByteSearch::findFirst()
{
   // "Any byte oriented string searching algorithm can be used with
   // UTF-8 data, since the sequence of bytes for a character cannot
   // occur anywhere else."
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
   if (patternLen <= 4)
      return findFromPosFwd_short(0);
#endif

#ifndef STRI__BYTESEARCH_DISABLE_KMP
   return findFromPosFwd_KMP(0);
#else
   return findFromPosFwd_naive(0);
#endif
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
 */
R_len_t StriContainerByteSearch::findNext()
{
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

   if (searchPos < 0) return findFirst();

#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
   if (patternLen <= 4)
      return findFromPosFwd_short(searchPos+patternLen);
#endif

#ifndef STRI__BYTESEARCH_DISABLE_KMP
   return findFromPosFwd_KMP(searchPos+patternLen);
#else
   return findFromPosFwd_naive(searchPos+patternLen);
#endif
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
 */
R_len_t StriContainerByteSearch::findLast()
{
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
   if (patternLen <= 4)
      return findFromPosBack_short(searchLen-1);
#endif

#ifndef STRI__BYTESEARCH_DISABLE_KMP
   return findFromPosBack_KMP(searchLen-1);
#else
   return findFromPosBack_naive(searchLen-1);
#endif
}


/** get start index of pattern match from the last search
 *
 * @return byte index in searchStr
 */
R_len_t StriContainerByteSearch::getMatchedStart()
{
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

   if (searchPos < 0 || searchPos > searchLen-patternLen)
      throw StriException("StriContainerByteSearch: no match at current position! This is a BUG.");

   return searchPos;
}


/** get length of pattern match from the last search
 *
 * @return byte index in searchStr
 */
R_len_t StriContainerByteSearch::getMatchedLength()
{
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

   if (searchPos < 0 || searchPos > searchLen-patternLen)
      throw StriException("StriContainerByteSearch: no match at current position! This is a BUG.");

   return patternLen; // trivial :>
}


/** find last match - case of short pattern
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *
 * @version 0.2-4 (Marek Gagolewski, 2014-05-15)
 *          BUGFIX: load of misaligned adresses
 */
R_len_t StriContainerByteSearch::findFromPosBack_short(R_len_t startPos)
{
   if (patternLen == 1) {
      unsigned char pat = (unsigned char)patternStr[0];
      for (searchPos = startPos-0; searchPos>=0; --searchPos) {
         if (pat == (unsigned char)searchStr[searchPos]) {
            return searchPos;
         }
      }
   }
   else if (patternLen == 2) {
      // be careful: little vs big endian!
      uint16_t pat  = ((uint16_t)((unsigned char)patternStr[1]));
               pat <<= 8;
               pat |= ((uint16_t)((unsigned char)patternStr[0]));

      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
      uint16_t cur  = ((uint16_t)(*curstr));
      --curstr;
      for (searchPos = startPos-1; searchPos>=0; --searchPos) {
         cur <<= 8;
         cur |= (uint16_t)(*curstr);
         --curstr;
         if (pat == cur) {
            return searchPos;
         }
      }
   }
   else if (patternLen == 3) {
      uint32_t pat  = ((uint32_t)((unsigned char)patternStr[2]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[1]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[0]));

      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
      uint32_t cur  = ((uint32_t)(*curstr));
      --curstr;
      cur <<= 8;
      cur |= (uint32_t)(*curstr);
      --curstr;

      uint32_t mask = ~(((unsigned char)0xff)<<24);

      for (searchPos = startPos-2; searchPos>=0; --searchPos) {
         cur <<= 8;
         cur |= (uint32_t)(*curstr);
         --curstr;
         if ((pat&mask) == (cur&mask)) {
            return searchPos;
         }
      }
   }
   else if (patternLen == 4) {
      uint32_t pat  = ((uint32_t)((unsigned char)patternStr[3]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[2]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[1]));
               pat <<= 8;
               pat |= ((uint32_t)((unsigned char)patternStr[0]));

      unsigned char*  curstr = (unsigned char*)(searchStr+startPos);
      uint32_t cur  = ((uint32_t)(*curstr));
      --curstr;
      cur <<= 8;
      cur |= (uint32_t)(*curstr);
      --curstr;
      cur <<= 8;
      cur |= (uint32_t)(*curstr);
      --curstr;


      for (searchPos = startPos-3; searchPos>=0; --searchPos) {
         cur <<= 8;
         cur |= (uint32_t)(*curstr);
         --curstr;
         if (pat == cur) {
            return searchPos;
         }
      }
   }
   // else not found
   searchPos = searchLen;
   return USEARCH_DONE;
}


/** find last match - naive search
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 */
R_len_t StriContainerByteSearch::findFromPosBack_naive(R_len_t startPos)
{
   // Naive search algorithm
   for (searchPos = startPos-patternLen+1; searchPos>=0; --searchPos) {
      R_len_t k=0;
      while (k<patternLen && searchStr[searchPos+k] == patternStr[k])
         k++;
      if (k == patternLen) {
         // found!
         return searchPos;
      }
   }
   // not found
   searchPos = searchLen;
   return USEARCH_DONE;
}


/** find last match - KMP
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 */
R_len_t StriContainerByteSearch::findFromPosBack_KMP(R_len_t startPos)
{
   int j = startPos;
   patternPos = 0;
   while (j >= 0) {
      while (patternPos >= 0 && patternStr[patternLen-1-patternPos] != searchStr[j])
         patternPos = kmpNext[patternPos];
      patternPos++;
      j--;
      if (patternPos >= patternLen) {
         searchPos = j+1;
         return searchPos;
      }
   }
   // else not found
   searchPos = searchLen;
   return USEARCH_DONE;
}
