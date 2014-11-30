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
#include "stri_container_usearch.h"


/**
 * Default constructor
 *
 */
StriContainerUStringSearch::StriContainerUStringSearch()
   : StriContainerUTF16()
{
   this->lastMatcherIndex = -1;
   this->str = NULL;
   this->col = NULL;
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param nrecycle extend length [vectorization]
 * @param col Collator; owned by external caller
 */
StriContainerUStringSearch::StriContainerUStringSearch(SEXP rstr, R_len_t _nrecycle, UCollator* _col)
   : StriContainerUTF16(rstr, _nrecycle, true)
{
   this->lastMatcherIndex = -1;
   this->lastMatcher = NULL;
   this->col = _col;
}


/** Copy constructor
 *
 */
StriContainerUStringSearch::StriContainerUStringSearch(StriContainerUStringSearch& container)
   :    StriContainerUTF16((StriContainerUTF16&)container)
{
   this->lastMatcherIndex = -1;
   this->lastMatcher = NULL;
   this->col = container.col;
}


StriContainerUStringSearch& StriContainerUStringSearch::operator=(StriContainerUStringSearch& container)
{
   this->~StriContainerUStringSearch();
   (StriContainerUTF16&) (*this) = (StriContainerUTF16&)container;
   this->lastMatcherIndex = -1;
   this->lastMatcher = NULL;
   this->col = container.col;
   return *this;
}


/** Destructor
 *
 */
StriContainerUStringSearch::~StriContainerUStringSearch()
{
   if (lastMatcher) {
      usearch_close(lastMatcher);
      lastMatcher = NULL;
   }
   col = NULL;
   // col is owned by the caller
}


/** the returned matcher shall not be deleted by the user
 *
 * it is assumed that \code{vectorize_next()} is used:
 * for \code{i >= this->n} the last matcher is returned
 *
 *
 * @param i index
 * @param searchStr string to search in
 */
UStringSearch* StriContainerUStringSearch::getMatcher(R_len_t i, const UnicodeString& searchStr)
{
   return getMatcher(i, searchStr.getBuffer(), searchStr.length());
}


/** the returned matcher shall not be deleted by the user
 *
 * it is assumed that \code{vectorize_next()} is used:
 * for \code{i >= this->n} the last matcher is returned
 *
 *
 * @param i index
 * @param searchStr string to search in
 * @param searchStr_len string length in UChars
 */
UStringSearch* StriContainerUStringSearch::getMatcher(R_len_t i, const UChar* searchStr, int32_t searchStr_len)
{
   if (!lastMatcher) {
      this->lastMatcherIndex = (i % n);
      UErrorCode status = U_ZERO_ERROR;
      lastMatcher = usearch_openFromCollator(this->get(i).getBuffer(), this->get(i).length(),
            searchStr, searchStr_len, col, NULL, &status);
      STRI__CHECKICUSTATUS_THROW(status, {usearch_close(lastMatcher); lastMatcher = NULL;})
      return lastMatcher;
   }

   if (this->lastMatcherIndex == (i % n)) {
      // do nothing => matcher reuse
   }
   else {
      this->lastMatcherIndex = (i % n);
      UErrorCode status = U_ZERO_ERROR;
      usearch_setPattern(lastMatcher, this->get(i).getBuffer(), this->get(i).length(), &status);
      STRI__CHECKICUSTATUS_THROW(status, {usearch_close(lastMatcher); lastMatcher = NULL;})
   }

   UErrorCode status = U_ZERO_ERROR;
   usearch_setText(lastMatcher, searchStr, searchStr_len, &status);
   STRI__CHECKICUSTATUS_THROW(status, {usearch_close(lastMatcher); lastMatcher = NULL;})

   return lastMatcher;
}
