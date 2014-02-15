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

#ifndef __stri_container_usearch_h
#define __stri_container_usearch_h





/**
 * A class to handle UStringSearch patterns
 * @version 0.1 (Marek Gagolewski, 2013-06-23)
 */
class StriContainerUStringSearch : public StriContainerUTF16 {

   private:

      UCollator* col; ///< collator, owned by creator
      UStringSearch* lastMatcher; ///< recently used \code{UStringSearch}
#ifndef NDEBUG
      R_len_t debugMatcherIndex;  ///< used by vectorize_getMatcher (internally - check)
#endif


   public:

      StriContainerUStringSearch();
      StriContainerUStringSearch(SEXP rstr, R_len_t nrecycle, UCollator* col);
      StriContainerUStringSearch(StriContainerUStringSearch& container);
      ~StriContainerUStringSearch();
      StriContainerUStringSearch& operator=(StriContainerUStringSearch& container);
      UStringSearch* getMatcher(R_len_t i, const UnicodeString& searchStr);
};

#endif
