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


#ifndef __stri_container_charclass_h
#define __stri_container_charclass_h

#include "stri_container_base.h"
#include "stri_container_utf8.h"
#include <unicode/uniset.h>


/**
 * A container handling charclass searches
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-15)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-05)
 *          Use StriContainerUTF8 to convert pattern strings in a constructor;
 *          Use UnicodeSet instead of stringi::CharClass
 */
class StriContainerCharClass : public StriContainerBase {

   private:

      UnicodeSet* data; // array

   public:

      StriContainerCharClass() : StriContainerBase()
      {
         data = NULL;
      }

      StriContainerCharClass(SEXP rvec, R_len_t _nrecycle)
      {
#ifndef NDEBUG
         if (!isString(rvec))
            throw StriException("DEBUG: !isString in StriContainerCharClass::StriContainerCharClass(SEXP rvec)");
#endif
         int _n = LENGTH(rvec);
         this->init_Base(_n, _nrecycle, true);

         this->data = NULL;
         if (_n > 0) {
            StriContainerUTF8 rvec_cont(rvec, _n, true);
            this->data = new UnicodeSet[_n];
            for (int i=0; i<_n; ++i) {
               if (rvec_cont.isNA(i))
                  this->data[i].setToBogus();
               else {
                  UErrorCode status = U_ZERO_ERROR;
                  this->data[i].applyPattern(
                     UnicodeString::fromUTF8(rvec_cont.get(i).c_str()), status);
                  if (U_FAILURE(status)) {
                     delete [] data;
                     data = NULL;
                     throw StriException(status);
                  }
                  this->data[i].freeze();
               }
            }
         }
      }

      StriContainerCharClass(StriContainerCharClass& container)
         :StriContainerBase((StriContainerBase&)container)
      {
         if (container.data) {
            this->data = new UnicodeSet[container.n];
            for (int i=0; i<container.n; ++i)
               this->data[i] = container.data[i];
         }
         else
            this->data = NULL;
      }

      ~StriContainerCharClass() {
         if (data) delete [] data;
      }

      StriContainerCharClass& operator=(StriContainerCharClass& container)
      {
         this->~StriContainerCharClass();
         (StriContainerBase&) (*this) = (StriContainerBase&)container;
         if (container.data) {
            this->data = new UnicodeSet[container.n];
            for (int i=0; i<container.n; ++i)
               this->data[i] = container.data[i];
         }
         else
            this->data = NULL;
         return *this;
      }


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerCharClass::isNA(): INDEX OUT OF BOUNDS");
#endif
         return data[i%n].isBogus();
      }


      /** get the vectorized ith element
       * @param i index
       * @return integer
       */
      inline const UnicodeSet& get(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerCharClass::get(): INDEX OUT OF BOUNDS");
         if (data[i%n].isBogus())
            throw StriException("StriContainerCharClass::get(): isNA");
#endif
         return (data[i%n]);
      }
};

#endif
