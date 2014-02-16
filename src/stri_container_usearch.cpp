/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
