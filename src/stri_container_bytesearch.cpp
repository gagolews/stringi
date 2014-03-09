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
   this->T = new int[0];
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
   this->T = new int[0];
#endif
}



/** Copy constructor
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
   this->T = new int[0];
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
   this->T = new int[0];
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
   delete T;
#endif
}




/** the returned matcher shall not be deleted by the user
 *
 * it is assumed that \code{vectorize_next()} is used:
 * for \code{i >= this->n} the last matcher is returned
 *
 *
 * @param i index
 * @param searchStr string to search in
 * @param searchLen string length in bytes
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Bartek Tartanus, 2013-08-15) uses KMP
 */
void StriContainerByteSearch::setupMatcher(R_len_t i, const char* _searchStr, R_len_t _searchLen)
{
   if (!this->searchStr || !this->patternStr) {
      // first call ever
      // setup [now nothing]
   }

   if (i >= n) {
#ifndef NDEBUG
      if ((debugMatcherIndex % n) != (i % n)) {
         throw StriException("DEBUG: vectorize_getMatcher - matcher reuse failed!");
      }
#endif
      // matcher reuse code [now nothing]
   }
   else {
      this->patternStr = get(i).c_str();
      this->patternLen = get(i).length();
   }

   this->searchStr = _searchStr;
   this->searchLen = _searchLen;
   this->resetMatcher();

#ifndef NDEBUG
   debugMatcherIndex = (i % n);
#endif
#ifndef STRI__BYTESEARCH_DISABLE_KMP
   this->T = new int[patternLen+1];
   int j = -1;
   T[0] = -1;
   for(int i=0; i < patternLen; i++){
      while (j>=0 && patternStr[i]!=patternStr[j])
         j = T[j];
      j++;
      T[i+1] = j;
   }
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
}


/** find first match
 *
 * resets the matcher
 *
 * @return USEARCH_DONE on no match, otherwise start index
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Bartek Tartanus, 2013-08-15) uses KMP
 */
R_len_t StriContainerByteSearch::findFirst()
{
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

#ifndef STRI__BYTESEARCH_DISABLE_KMP
   int j=0;
   for(int i=0; i < searchLen; i++){
      while (j>=0 && searchStr[i]!=patternStr[j])
         j = T[j];
      j++;
      if (j==patternLen)
      {
         searchPos = i-j+1;
         return searchPos;
      }
   }
   searchPos = searchLen;
   return USEARCH_DONE;
#else
   // Naive search algorithm
   for (searchPos = 0; searchPos<searchLen-patternLen+1; ++searchPos) {
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
#endif
}


/** find next match
 *
 * continues previous search
 *
 * @return USEARCH_DONE on no match, otherwise start index
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Bartek Tartanus, 2013-08-15) uses KMP
 */
R_len_t StriContainerByteSearch::findNext()
{
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

   if (searchPos < 0) return findFirst();

#ifndef STRI__BYTESEARCH_DISABLE_KMP
   int j=0;
   for(int i = searchPos + patternLen; i < searchLen; i++){
      while (j>=0 && searchStr[i]!=patternStr[j])
         j = T[j];
      j++;
      if (j==patternLen)
      {
         searchPos = i-j+1;
         return searchPos;
      }
   }
   searchPos = searchLen;
   return USEARCH_DONE;
#else
   // Naive search algorithm
   for (searchPos = searchPos + patternLen; searchPos<searchLen-patternLen+1; ++searchPos) {
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
#endif
}


/** find last match
 *
 * resets the matcher
 *
 * @return USEARCH_DONE on no match, otherwise start index
 */
R_len_t StriContainerByteSearch::findLast()
{
#ifndef NDEBUG
   if (!this->searchStr || !this->patternStr)
      throw StriException("DEBUG: StriContainerByteSearch: setupMatcher() hasn't been called yet");
#endif

#ifndef STRI__BYTESEARCH_DISABLE_KMP
   throw StriException("KMP: TO DO");
#else
   // Naive search algorithm
   for (searchPos = searchLen - patternLen; searchPos>=0; --searchPos) {
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
