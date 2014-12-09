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
   this->patternLenCaseInsensitive = 0;
   this->patternStrCaseInsensitive = NULL;
   this->searchPos = -1;
   this->searchEnd = -1;
   this->searchStr = NULL;
   this->searchLen = 0;
   this->flags = 0;
#ifndef NDEBUG
   this->debugMatcherIndex = -1;
#endif
//#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->kmpMaxSize = 0;
   this->patternPos = -1;
   this->kmpNext = NULL;
//#endif
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param _nrecycle extend length [vectorization]
 */
StriContainerByteSearch::StriContainerByteSearch(SEXP rstr, R_len_t _nrecycle, uint32_t _flags)
   : StriContainerUTF8(rstr, _nrecycle, true)
{
   this->flags = _flags;

   this->patternLen = 0;
   this->patternStr = NULL;

   this->searchPos = -1;
   this->searchEnd = -1;
   this->searchStr = NULL;
   this->searchLen = 0;

#ifndef NDEBUG
   this->debugMatcherIndex = -1;
#endif

//#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->patternPos = -1;
   this->kmpMaxSize = getMaxNumBytes()+1;
   this->kmpNext = new int[kmpMaxSize];
   if (!this->kmpNext) throw StriException(MSG__MEM_ALLOC_ERROR);
//#endif

   this->patternLenCaseInsensitive = 0;
   if (flags&BYTESEARCH_CASE_INSENSITIVE) {
      this->patternStrCaseInsensitive = new UChar32[this->kmpMaxSize];
      if (!this->patternStrCaseInsensitive) throw StriException(MSG__MEM_ALLOC_ERROR);
   }
   else
      this->patternStrCaseInsensitive = NULL;
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
   this->searchEnd = -1;
   this->searchStr = NULL;
   this->searchLen = 0;
   this->flags = container.flags;
#ifndef NDEBUG
   this->debugMatcherIndex = -1;
#endif
//#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->patternPos = -1;
   this->kmpMaxSize = container.kmpMaxSize;
   this->kmpNext = new int[kmpMaxSize];
   if (!this->kmpNext) throw StriException(MSG__MEM_ALLOC_ERROR);

   this->patternLenCaseInsensitive = 0;
   if (flags&BYTESEARCH_CASE_INSENSITIVE) {
      this->patternStrCaseInsensitive = new UChar32[this->kmpMaxSize];
      if (!this->patternStrCaseInsensitive) throw StriException(MSG__MEM_ALLOC_ERROR);
   }
   else
      this->patternStrCaseInsensitive = NULL;
//#endif
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
   this->searchEnd = -1;
   this->searchStr = NULL;
   this->searchLen = 0;
   this->flags = container.flags;
#ifndef NDEBUG
   this->debugMatcherIndex = -1;
#endif
//#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->patternPos = -1;
   this->kmpMaxSize = container.kmpMaxSize;
   this->kmpNext = new int[kmpMaxSize];
   if (!this->kmpNext) throw StriException(MSG__MEM_ALLOC_ERROR);

   this->patternLenCaseInsensitive = 0;
   if (flags&BYTESEARCH_CASE_INSENSITIVE) {
      this->patternStrCaseInsensitive = new UChar32[this->kmpMaxSize];
      if (!this->patternStrCaseInsensitive) throw StriException(MSG__MEM_ALLOC_ERROR);
   }
   else
      this->patternStrCaseInsensitive = NULL;
//#endif
   return *this;
}


/** Destructor
 *
 */
StriContainerByteSearch::~StriContainerByteSearch()
{
   // nothing to clean
//#ifndef STRI__BYTESEARCH_DISABLE_KMP
   if (kmpNext) {
      delete [] kmpNext;
      kmpNext = NULL;
   }

   if (patternStrCaseInsensitive) {
      delete [] patternStrCaseInsensitive;
      patternStrCaseInsensitive = NULL;
   }
//#endif
}


/** Create KMP table for rev iteration [case insensitive search]
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
*/
void StriContainerByteSearch::createKMPtableBackCaseInsensitive()
{
   kmpNext[0] = -1;
   for (R_len_t i=0; i<patternLenCaseInsensitive; ++i) {
      kmpNext[i+1] = kmpNext[i]+1;
      while (kmpNext[i+1] > 0 &&
            patternStrCaseInsensitive[patternLen-i-1] != patternStrCaseInsensitive[patternLenCaseInsensitive-(kmpNext[i+1]-1)-1])
         kmpNext[i+1] = kmpNext[kmpNext[i+1]-1]+1;
   }
}


/** Create KMP table for rev iteration
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *          KMP upgrade
*/
void StriContainerByteSearch::createKMPtableBack()
{
   kmpNext[0] = -1;
   for (R_len_t i=0; i<patternLen; ++i) {
      kmpNext[i+1] = kmpNext[i]+1;
      while (kmpNext[i+1] > 0 &&
            patternStr[patternLen-i-1] != patternStr[patternLen-(kmpNext[i+1]-1)-1])
         kmpNext[i+1] = kmpNext[kmpNext[i+1]-1]+1;
   }
}


/** Create KMP table for fwd iteration [case insensitive]
 *
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
*/
void StriContainerByteSearch::createKMPtableFwdCaseInsensitive()
{
   kmpNext[0] = -1;
   for (R_len_t i=0; i<patternLenCaseInsensitive; ++i) {
      kmpNext[i+1] = kmpNext[i]+1;
      while (kmpNext[i+1] > 0 &&
            patternStrCaseInsensitive[i] != patternStrCaseInsensitive[kmpNext[i+1]-1])
         kmpNext[i+1] = kmpNext[kmpNext[i+1]-1]+1;
   }
}


/** Create KMP table for fwd iteration
 *
 * @version 0.1-?? (Bartek Tartanus, 2013-08-15)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *          KMP upgrade; special procedure for patternLen <= 4
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *          KMP upgrade
*/
void StriContainerByteSearch::createKMPtableFwd()
{
   kmpNext[0] = -1;
   for (R_len_t i=0; i<patternLen; ++i) {
      kmpNext[i+1] = kmpNext[i]+1;
      while (kmpNext[i+1] > 0 &&
            patternStr[i] != patternStr[kmpNext[i+1]-1])
         kmpNext[i+1] = kmpNext[kmpNext[i+1]-1]+1;
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
   if (i >= n && this->patternStr == get(i).c_str()) {
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

      if (flags & BYTESEARCH_CASE_INSENSITIVE) {
         upgradePatternCaseInsensitive();
         createKMPtableBackCaseInsensitive();
      }
      else {
#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
         if (this->patternLen > 4) // a short pattern => don't use KMP
            createKMPtableBack();
#endif
      }
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
   if (i >= n && this->patternStr == get(i).c_str()) {
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

      if (flags & BYTESEARCH_CASE_INSENSITIVE) {
         upgradePatternCaseInsensitive();
         createKMPtableFwdCaseInsensitive();
      }
      else {
#ifndef STRI__BYTESEARCH_DISABLE_SHORTPAT
         if (this->patternLen > 4) // a short pattern => don't use KMP
            createKMPtableFwd();
#endif
      }
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
   this->searchEnd = -1;
   this->patternPos = -1;
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
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-30)
 *          BUGFIX: ret USEARCH_DONE immediately if startPos is too far away
 */
R_len_t StriContainerByteSearch::findFromPosFwd_short(R_len_t startPos)
{
   if (startPos > searchLen-patternLen) { // this check is OK, we do a case-sensitive search
      searchPos = searchEnd = searchLen;
      return USEARCH_DONE;
   }

   if (patternLen == 1) {
         // else not found
      unsigned char pat = (unsigned char)patternStr[0];
      for (searchPos = startPos; searchPos<searchLen-1+1; ++searchPos) {
         if (pat == (unsigned char)searchStr[searchPos]) {
            searchEnd = searchPos + 1;
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
            searchEnd = searchPos + 2;
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
            searchEnd = searchPos + 3;
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
            searchEnd = searchPos + 4;
            return searchPos;
         }
      }
   }
   // else not found
   searchPos = searchEnd = searchLen;
   return USEARCH_DONE;
}


///** find first match - naive search
// *
// * @param startPos where to start
// * @return USEARCH_DONE on no match, otherwise start index
// *
// * @version 0.1-?? (Marek Gagolewski)
// *
// * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
// *          separate method
// */
//R_len_t StriContainerByteSearch::findFromPosFwd_naive(R_len_t startPos)
//{
//   // Naive search algorithm
//   for (searchPos = startPos; searchPos<searchLen-patternLen+1; ++searchPos) {
//      R_len_t k=0;
//      while (k<patternLen && searchStr[searchPos+k] == patternStr[k])
//         k++;
//      if (k == patternLen) {
//         // found!
//         return searchPos;
//      }
//   }
//   // not found
//   searchPos = searchLen;
//   return USEARCH_DONE;
//}


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
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    use BYTESEARCH_CASE_INSENSITIVE
 */
R_len_t StriContainerByteSearch::findFromPosFwd_KMP(R_len_t startPos)
{
   int j = startPos;
   patternPos = 0;
   if (flags&BYTESEARCH_CASE_INSENSITIVE) {
      UChar32 c = 0;
      while (j < searchLen) {
         U8_NEXT(searchStr, j, searchLen, c);
         c = u_toupper(c);
         while (patternPos >= 0 && patternStrCaseInsensitive[patternPos] != c)
            patternPos = kmpNext[patternPos];
         patternPos++;
         if (patternPos == patternLenCaseInsensitive) {
            searchEnd = j;

            // we need to go back by patternLenCaseInsensitive code points
            R_len_t k = patternLenCaseInsensitive;
            searchPos = j;
            while (k > 0) {
               U8_BACK_1((const uint8_t*)searchStr, 0, searchPos);
               k--;
            }
            return searchPos;
         }
      }
   }
   else {
      while (j < searchLen) {
         while (patternPos >= 0 && patternStr[patternPos] != searchStr[j])
            patternPos = kmpNext[patternPos];
         patternPos++;
         j++;
         if (patternPos == patternLen) {
            searchEnd = j;
            searchPos = j-patternLen;
            return searchPos;
         }
      }
   }
   // else not found
   searchPos = searchEnd = searchLen;
   return USEARCH_DONE;
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
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-30)
 *          BUGFIX: ret USEARCH_DONE immediately if startPos indicates no match
 *
 */
R_len_t StriContainerByteSearch::findFromPosBack_short(R_len_t startPos)
{
   if (startPos+1 < patternLen) { // check OK, case-sensitive search
      searchPos = searchEnd = searchLen;
      return USEARCH_DONE;
   }

   if (patternLen == 1) {
      unsigned char pat = (unsigned char)patternStr[0];
      for (searchPos = startPos-0; searchPos>=0; --searchPos) {
         if (pat == (unsigned char)searchStr[searchPos]) {
            searchEnd = searchPos + 1;
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
            searchEnd = searchPos + 2;
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
            searchEnd = searchPos + 3;
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
            searchEnd = searchPos + 4;
            return searchPos;
         }
      }
   }
   // else not found
   searchPos = searchEnd = searchLen;
   return USEARCH_DONE;
}


///** find last match - naive search
// *
// * @param startPos where to start
// * @return USEARCH_DONE on no match, otherwise start index
// *
// * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
// */
//R_len_t StriContainerByteSearch::findFromPosBack_naive(R_len_t startPos)
//{
//   // Naive search algorithm
//   for (searchPos = startPos-patternLen+1; searchPos>=0; --searchPos) {
//      R_len_t k=0;
//      while (k<patternLen && searchStr[searchPos+k] == patternStr[k])
//         k++;
//      if (k == patternLen) {
//         // found!
//         return searchPos;
//      }
//   }
//   // not found
//   searchPos = searchLen;
//   return USEARCH_DONE;
//}


/** find last match - KMP
 *
 * @param startPos where to start
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-11)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *    use BYTESEARCH_CASE_INSENSITIVE
 */
R_len_t StriContainerByteSearch::findFromPosBack_KMP(R_len_t startPos)
{
   int j = startPos;
   patternPos = 0;
   if (flags&BYTESEARCH_CASE_INSENSITIVE) {
      while (j > 0) {
         UChar32 c;
         U8_PREV(searchStr, 0, j, c);
         c = u_toupper(c);
         while (patternPos >= 0 &&
               patternStrCaseInsensitive[patternLenCaseInsensitive-1-patternPos] != c)
            patternPos = kmpNext[patternPos];
         patternPos++;
         if (patternPos == patternLenCaseInsensitive) {
            searchPos = j;

            // we need to go forward by patternLenCaseInsensitive code points
            R_len_t k = patternLenCaseInsensitive;
            searchEnd = j;
            while (k > 0) {
               U8_FWD_1((const uint8_t*)searchStr, searchEnd, searchLen);
               k--;
            }

            return searchPos;
         }
      }
   }
   else {
      while (j > 0) {
         j--;
         while (patternPos >= 0 && patternStr[patternLen-1-patternPos] != searchStr[j])
            patternPos = kmpNext[patternPos];
         patternPos++;
         if (patternPos == patternLen) {
            searchEnd = j+patternLen;
            searchPos = j;
            return searchPos;
         }
      }
   }

   // else not found
   searchPos = searchEnd = searchLen;
   return USEARCH_DONE;
}


/** Read settings flags from a list
 *
 * may call Rf_error
 *
 * @param opts_fixed list
 * @param allow_overlap
 * @return flags
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-08)
 *    add `overlap` option
 */
uint32_t StriContainerByteSearch::getByteSearchFlags(SEXP opts_fixed, bool allow_overlap)
{
   uint32_t flags = 0;
   if (!isNull(opts_fixed) && !Rf_isVectorList(opts_fixed))
      Rf_error(MSG__ARG_EXPECTED_LIST, "opts_fixed"); // error() call allowed here

   R_len_t narg = isNull(opts_fixed)?0:LENGTH(opts_fixed);

   if (narg > 0) {

      SEXP names = Rf_getAttrib(opts_fixed, R_NamesSymbol);
      if (names == R_NilValue || LENGTH(names) != narg)
         Rf_error(MSG__FIXED_CONFIG_FAILED); // error() call allowed here

      for (R_len_t i=0; i<narg; ++i) {
         if (STRING_ELT(names, i) == NA_STRING)
            Rf_error(MSG__FIXED_CONFIG_FAILED); // error() call allowed here

         const char* curname = CHAR(STRING_ELT(names, i));

         if  (!strcmp(curname, "case_insensitive")) {
            bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_fixed, i), "case_insensitive");
            if (val) flags |= BYTESEARCH_CASE_INSENSITIVE;
         } else if  (!strcmp(curname, "overlap") && allow_overlap) {
            bool val = stri__prepare_arg_logical_1_notNA(VECTOR_ELT(opts_fixed, i), "overlap");
            if (val) flags |= BYTESEARCH_OVERLAP;
         } else {
            Rf_warning(MSG__INCORRECT_FIXED_OPTION, curname);
         }
      }
   }

   return flags;
}


/**
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 */
void StriContainerByteSearch::upgradePatternCaseInsensitive()
{
   UChar32 c = 0;
   R_len_t j = 0;
   patternLenCaseInsensitive = 0;
   while (j < patternLen) {
      U8_NEXT(patternStr, j, patternLen, c);
#ifndef NDEBUG
      if (patternLenCaseInsensitive >= this->kmpMaxSize)
         throw StriException("!NDEBUG: StriContainerByteSearch::upgradePatternCaseInsensitive()");
#endif
      patternStrCaseInsensitive[patternLenCaseInsensitive++] = u_toupper(c);
   }
   patternStrCaseInsensitive[patternLenCaseInsensitive] = 0;
}


/**
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 */
bool StriContainerByteSearch::endsWith(R_len_t byteindex)
{
   if (flags&BYTESEARCH_CASE_INSENSITIVE) {
      for (R_len_t k = 0; k < patternLenCaseInsensitive; ++k) {
         UChar32 c;
         U8_PREV(searchStr, 0, byteindex, c);
         c = u_toupper(c);
         if (patternStrCaseInsensitive[patternLenCaseInsensitive-k-1] != c)
            return false;
      }
   }
   else {
      for (R_len_t k=0; k < patternLen; ++k)
         if (searchStr[byteindex-k-1] != patternStr[patternLen-k-1])
            return false;
   }

   return true; // found
}


/**
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
 */
bool StriContainerByteSearch::startsWith(R_len_t byteindex)
{
   if (flags&BYTESEARCH_CASE_INSENSITIVE) {
      for (R_len_t k = 0; k < patternLenCaseInsensitive; ++k) {
         UChar32 c;
         U8_NEXT(searchStr, byteindex, searchLen, c);
         c = u_toupper(c);
         if (patternStrCaseInsensitive[k] != c)
            return false;
      }
   }
   else {
      for (R_len_t k=0; k < patternLen; ++k)
         if (searchStr[byteindex+k] != patternStr[k])
            return false;
   }

   return true; // found
}
