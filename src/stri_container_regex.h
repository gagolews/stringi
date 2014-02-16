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
