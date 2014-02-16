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


#ifndef __stri_container_bytesearch_h
#define __stri_container_bytesearch_h


#define STRI__BYTESEARCH_DISABLE_KMP


/**
 * A class to handle StriByteSearch patterns
 * @version 0.1 (Marek Gagolewski, 2013-06-23)
 * @version 0.1 (Bartek Tartanus, 2013-08-15) added table T for KMP algorithm
 */
class StriContainerByteSearch : public StriContainerUTF8 {

   private:


      R_len_t patternLen;
      const char* patternStr;
      R_len_t searchPos; // -1 after reset, searchLen on no further matches
      const char* searchStr; // owned by caller
      R_len_t searchLen; // in bytes

#ifndef NDEBUG
      R_len_t debugMatcherIndex;  ///< used by vectorize_getMatcher (internally - check)
#endif

#ifndef STRI__BYTESEARCH_DISABLE_KMP
   int* T;
#endif

   public:

      StriContainerByteSearch();
      StriContainerByteSearch(SEXP rstr, R_len_t nrecycle);
      StriContainerByteSearch(StriContainerByteSearch& container);
      ~StriContainerByteSearch();
      StriContainerByteSearch& operator=(StriContainerByteSearch& container);

      void setupMatcher(R_len_t i, const char* searchStr, R_len_t searchLen);
      void resetMatcher();
      R_len_t findFirst();
      R_len_t findNext();
      R_len_t findLast();
      R_len_t getMatchedStart();
      R_len_t getMatchedLength();
};

#endif
