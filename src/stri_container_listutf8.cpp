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


#include "stri_stringi.h"
#include "stri_container_listutf8.h"


/**
 * Default constructor
 *
 */
StriContainerListUTF8::StriContainerListUTF8()
   : StriContainerBase()
{
   data = NULL;
}


/**
 * Construct String Container from R character vector
 * @param rvec R list vector
 * @param nrecycle extend length of each character vector stored [vectorization]
 * @param shallowrecycle will stored character vectors be ever modified?
 */
StriContainerListUTF8::StriContainerListUTF8(SEXP rvec, R_len_t _nrecycle, bool _shallowrecycle)
{
   this->data = NULL;
#ifndef NDEBUG
   if (!Rf_isVectorList(rvec))
      throw StriException("DEBUG: !isVectorList in StriContainerListUTF8::StriContainerListUTF8(SEXP rvec)");
#endif
   R_len_t rvec_length = LENGTH(rvec);
   this->init_Base(rvec_length, rvec_length, true);

   if (this->n > 0) {
      this->data = new StriContainerUTF8*[this->n];
      if (!this->data) throw StriException(MSG__MEM_ALLOC_ERROR);
      for (R_len_t i=0; i<this->n; ++i)
         this->data[i] = NULL; // in case it fails during conversion (this is "NA")

      for (R_len_t i=0; i<this->n; ++i) {
         this->data[i] = new StriContainerUTF8(VECTOR_ELT(rvec, i), _nrecycle, _shallowrecycle);
         if (!this->data[i]) throw StriException(MSG__MEM_ALLOC_ERROR);
      }
   }
}


StriContainerListUTF8::StriContainerListUTF8(StriContainerListUTF8& container)
   :    StriContainerBase((StriContainerBase&)container)
{
   if (container.data) {
      this->data = new StriContainerUTF8*[this->n];
      if (!this->data) throw StriException(MSG__MEM_ALLOC_ERROR);
      for (int i=0; i<container.n; ++i) {
         if (container.data[i]) {
            this->data[i] = new StriContainerUTF8(*container.data[i]);
            if (!this->data[i]) throw StriException(MSG__MEM_ALLOC_ERROR);
         }
         else
            this->data[i] = NULL;
      }
   }
   else {
      this->data = NULL;
   }
}


StriContainerListUTF8& StriContainerListUTF8::operator=(StriContainerListUTF8& container)
{
   this->~StriContainerListUTF8();
   (StriContainerBase&) (*this) = (StriContainerBase&)container;

   if (container.data) {
      this->data = new StriContainerUTF8*[this->n];
      if (!this->data) throw StriException(MSG__MEM_ALLOC_ERROR);
      for (int i=0; i<container.n; ++i) {
         if (container.data[i]) {
            this->data[i] = new StriContainerUTF8(*container.data[i]);
            if (!this->data[i]) throw StriException(MSG__MEM_ALLOC_ERROR);
         }
         else
            this->data[i] = NULL;
      }
   }
   else {
      this->data = NULL;
   }

   return *this;
}


StriContainerListUTF8::~StriContainerListUTF8()
{
   if (data) {
      for (int i=0; i<n; ++i) {
         if (data[i])
            delete data[i];
      }
      delete [] data;
      data = NULL;
   }
}
