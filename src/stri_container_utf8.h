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


#ifndef __stri_container_utf8_h
#define __stri_container_utf8_h

#include "stri_container_base.h"


/**
 * A class to handle conversion between R character vectors
 * and UTF-8 string vectors
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          Improved performance for Native enc->UTF-8 (through u_strToUTF8)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-01)
 *          Now NAs are marked as NULLs in str
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-01)
 *          UChar32_to_UTF8_index_back, UChar32_to_UTF8_index_fwd added
 *
 * @version 0.1-24 (Marek Gagolewski, 2014-03-11)
 *          Fixed unitialized fields in constructors (thanks to valgrind detect)
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-15)
 *          Do not try to re-encode a string if native encoding is UTF-8;
 *          str as String8* and not String8** (performance gain)
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-20)
 *          BUGFIX: possible mem leaks in the constructor;
 *          separated StriContainerUTF8_indexable
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-23)
 *          UTF8 BOMs are now silently removed by one of the constructors
 *          (via String8)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-20)
 *          New methods: getMaxNumBytes, getMaxLength
 */
class StriContainerUTF8 : public StriContainerBase {

   private:

      String8* str;  ///< data - \code{string}


   public:

      StriContainerUTF8();
      StriContainerUTF8(SEXP rstr, R_len_t nrecycle, bool shallowrecycle=true);
      StriContainerUTF8(StriContainerUTF8& container);
      ~StriContainerUTF8();
      StriContainerUTF8& operator=(StriContainerUTF8& container);
      SEXP toR(R_len_t i) const;
      SEXP toR() const;


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerUTF8::isNA(): INDEX OUT OF BOUNDS");
#endif
         return (str[i%n].isNA());
      }


      /** get the vectorized ith element
       * @param i index
       * @return string, read only
       */
      const String8& get(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerUTF8::get(): INDEX OUT OF BOUNDS");
         if (str[i%n].isNA())
            throw StriException("StriContainerUTF8::get(): isNA");
#endif
         return str[i%n];
      }


      /** get the number of bytes used to represent the longest string */
      R_len_t getMaxNumBytes() const {
         R_len_t bufsize = 0;
         for (R_len_t i=0; i<n; ++i) {
            if (isNA(i)) continue;
            R_len_t cursize = get(i).length();
            if (cursize > bufsize)
               bufsize = cursize;
         }
         return bufsize;
      }


      /** get the length of the longest string */
      R_len_t getMaxLength() const {
         R_len_t bufsize = 0;
         for (R_len_t i=0; i<n; ++i) {
            if (isNA(i)) continue;
            UChar32 c = 0;
            R_len_t curs_n = get(i).length();
            const char* curs_s = get(i).c_str();

            R_len_t j = 0;
            R_len_t k = 0;
            while (j < curs_n) {
               U8_NEXT(curs_s, j, curs_n, c);
               k++;

               if (c < 0) { // invalid utf-8 sequence
                  Rf_warning(MSG__INVALID_UTF8);
               }
            }

            if (k > bufsize)
               bufsize = k;
         }
         return bufsize;
      }
};

#endif
