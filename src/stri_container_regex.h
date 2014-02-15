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

#ifndef __stri_container_regex_h
#define __stri_container_regex_h





/**
 * A class to handle regex patterns
 * @version 0.1 (Marek Gagolewski, 2013-06-17)
 */
class StriContainerRegexPattern : public StriContainerUTF16 {

   private:

      uint32_t flags; ///< RegexMatcher flags
      RegexMatcher* lastMatcher; ///< recently used \code{RegexMatcher}
#ifndef NDEBUG
      R_len_t debugMatcherIndex;  ///< used by vectorize_getMatcher (internally - check)
#endif


   public:

      static uint32_t getRegexFlags(SEXP opts_regex);

      StriContainerRegexPattern();
      StriContainerRegexPattern(SEXP rstr, R_len_t nrecycle, uint32_t flags);
      StriContainerRegexPattern(StriContainerRegexPattern& container);
      ~StriContainerRegexPattern();
      StriContainerRegexPattern& operator=(StriContainerRegexPattern& container);
      RegexMatcher* getMatcher(R_len_t i);
};

#endif
