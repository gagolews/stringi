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


#ifndef __stri_container_utf16_h
#define __stri_container_utf16_h

#include "stri_container_base.h"

/**
 * A class to handle conversion between R character vectors
 * and UTF-16 string vectors
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          lastMatcher cache, supports auto-vectorization
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          improved ASCII performance (seperate ucnv)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          now NAs are marked as NULLs in str
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-15)
 *          If native encoding is UTF-8, then encode with
 *          UnicodeString::fromUTF8 (for speedup);
 *          str now is UnicodeString*, and not UnicodeString**;
 *          using UnicodeString::isBogus to represent NA
 */
class StriContainerUTF16 : public StriContainerBase {

   protected:

      UnicodeString* str;       ///< data - \code{UnicodeString}s


   public:

      StriContainerUTF16();
      StriContainerUTF16(R_len_t nrecycle);
      StriContainerUTF16(SEXP rstr, R_len_t nrecycle, bool shallowrecycle=true);
      StriContainerUTF16(StriContainerUTF16& container);
      ~StriContainerUTF16();
      StriContainerUTF16& operator=(StriContainerUTF16& container);
      SEXP toR(R_len_t i) const;
      SEXP toR() const;


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (!str)
            throw StriException("StriContainerUTF16::isNA(): !str");
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerUTF16::isNA(): INDEX OUT OF BOUNDS");
#endif
         return str[i%n].isBogus();
      }


      /** get the vectorized ith element
       * @param i index
       * @return string
       */
      const UnicodeString& get(R_len_t i) const {
#ifndef NDEBUG
         if (isNA(i))
            throw StriException("StriContainerUTF16::get(): isNA");
#endif
         return str[i%n];
      }

      /** get the vectorized ith element
       * @param i index
       * @return string
       */
      UnicodeString& getWritable(R_len_t i) {
#ifndef NDEBUG
         if (isShallow)
            throw StriException("StriContainerUTF16::getWritable(): shallow StriContainerUTF16");
         if (n != nrecycle)
            throw StriException("StriContainerUTF16::getWritable(): n!=nrecycle");
         if (i < 0 || i >= n)
            throw StriException("StriContainerUTF16::getWritable(): INDEX OUT OF BOUNDS");
         if (isNA(i))
            throw StriException("StriContainerUTF16::getWritable(): isNA");
#endif
         return str[i%n]; // in fact, "%n" is not necessary
      }


      /** set NA
       * @param i index
       */
      void setNA(R_len_t i) {
#ifndef NDEBUG
         if (isShallow)
            throw StriException("StriContainerUTF16::getWritable(): shallow StriContainerUTF16");
         if (n != nrecycle)
            throw StriException("StriContainerUTF16::getWritable(): n!=nrecycle");
         if (i < 0 || i >= n)
            throw StriException("StriContainerUTF16::getWritable(): INDEX OUT OF BOUNDS");
#endif
         str[i%n].setToBogus();
      }

      /** set the vectorized ith element
       * @param i index
       * @param s string to be copied
       */
      void set(R_len_t i, const UnicodeString& s) {
#ifndef NDEBUG
         if (isShallow)
            throw StriException("StriContainerUTF16::set(): shallow StriContainerUTF16");
         if (n != nrecycle)
            throw StriException("StriContainerUTF16::set(): n!=nrecycle");
         if (i < 0 || i >= n)
            throw StriException("StriContainerUTF16::set(): INDEX OUT OF BOUNDS");
         if (str[i%n].isBogus())
            throw StriException("StriContainerUTF16::set(): isNA");
#endif
         str[i%n].setTo(s); // in fact, "%n" is not necessary
      }

      // @QUESTION: separate StriContainerUTF16_indexable?
      void UChar16_to_UChar32_index(R_len_t i, int* i1, int* i2, const int ni, int adj1, int adj2);
};

#endif
