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


#ifndef __stri_container_logical_h
#define __stri_container_logical_h


#include "stri_container_base.h"


/**
 * A wrapper-class for R logical vectors
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-15)
 */
class StriContainerLogical : public StriContainerBase {

   private:

      int* data;

   public:

      StriContainerLogical() : StriContainerBase()
      {
         data = NULL;
      }

      StriContainerLogical(SEXP rvec, R_len_t _nrecycle)
      {
         this->data = NULL;
#ifndef NDEBUG
         if (!isLogical(rvec))
            throw StriException("DEBUG: !isLogical in StriContainerLogical");
#endif
         R_len_t ndata = LENGTH(rvec);
         this->init_Base(ndata, _nrecycle, true);
         this->data = LOGICAL(rvec);
      }

      //  StriContainerLogical(StriContainerLogical& container); // default-shallow
      // ~StriContainerLogical(); // default-shallow
      //  StriContainerLogical& operator=(StriContainerLogical& container); // default-shallow


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerLogical::isNA(): INDEX OUT OF BOUNDS");
#endif
         return (data[i%n] == NA_LOGICAL);
      }


      /** get the vectorized ith element
       * @param i index
       * @return integer
       */
      inline int get(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerLogical::get(): INDEX OUT OF BOUNDS");
         if (data[i%n] == NA_LOGICAL)
            throw StriException("StriContainerLogical::get(): isNA");
#endif
         return (data[i%n]);
      }
};

#endif
