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
StriContainerUStringSearch::StriContainerUStringSearch()
   : StriContainerUTF16()
{
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
   this->lastMatcher = NULL;
   this->col = _col;
}



/** Copy constructor
 *
 */
StriContainerUStringSearch::StriContainerUStringSearch(StriContainerUStringSearch& container)
   :    StriContainerUTF16((StriContainerUTF16&)container)
{
   this->lastMatcher = NULL;
   this->col = container.col;
}




StriContainerUStringSearch& StriContainerUStringSearch::operator=(StriContainerUStringSearch& container)
{
   this->~StriContainerUStringSearch();
   (StriContainerUTF16&) (*this) = (StriContainerUTF16&)container;
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
 * @param str string to search in
 */
UStringSearch* StriContainerUStringSearch::getMatcher(R_len_t i, const UnicodeString& searchStr)
{
   if (!lastMatcher) {
#ifndef NDEBUG
      debugMatcherIndex = (i % n);
#endif
      UErrorCode status = U_ZERO_ERROR;
      lastMatcher = usearch_openFromCollator(this->get(i).getBuffer(), this->get(i).length(),
            searchStr.getBuffer(), searchStr.length(), col, NULL, &status);
      if (U_FAILURE(status)) throw StriException(status);
      return lastMatcher;
   }

   if (i >= n) {
#ifndef NDEBUG
      if ((debugMatcherIndex % n) != (i % n)) {
         throw StriException("DEBUG: vectorize_getMatcher - matcher reuse failed!");
      }
#endif
   }
   else {
      UErrorCode status = U_ZERO_ERROR;
      usearch_setPattern(lastMatcher, this->get(i).getBuffer(), this->get(i).length(), &status);
      if (U_FAILURE(status)) throw StriException(status);
   }

   UErrorCode status = U_ZERO_ERROR;
   usearch_setText(lastMatcher, searchStr.getBuffer(), searchStr.length(), &status);
   if (U_FAILURE(status)) throw StriException(status);

#ifndef NDEBUG
   debugMatcherIndex = (i % n);
#endif

   return lastMatcher;
}
