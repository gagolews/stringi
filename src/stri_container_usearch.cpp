/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * 'stringi' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'stringi' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.
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
