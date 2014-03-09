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


/**
 * Default constructor
 *
 */
StriContainerListRaw::StriContainerListRaw()
   : StriContainerBase()
{
   data = NULL;
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 *
 * if you want nrecycle > n, call set_nrecycle
 */
StriContainerListRaw::StriContainerListRaw(SEXP rstr)
{
   this->data = NULL;

   if (isNull(rstr)) {
      this->init_Base(1, 1, true);
      this->data = new String8*[this->n];
      this->data[0] = NULL;
   }
   else if (isRaw(rstr)) {
      this->init_Base(1, 1, true);
      this->data = new String8*[this->n];
      this->data[0] = new String8((const char*)RAW(rstr), LENGTH(rstr), false); // shallow copy
   }
   else if (Rf_isVectorList(rstr)) {
      R_len_t nv = LENGTH(rstr);
      this->init_Base(nv, nv, true);
      this->data = new String8*[this->n];
      for (R_len_t i=0; i<this->n; ++i) {
         SEXP cur = VECTOR_ELT(rstr, i);
         if (isNull(cur))
            this->data[i] = NULL;
         else
            this->data[i] = new String8((const char*)RAW(cur), LENGTH(cur), false); // shallow copy
      }
   }
   else {
      R_len_t nv = LENGTH(rstr);
      this->init_Base(nv, nv, true);
      this->data = new String8*[this->n];
      for (R_len_t i=0; i<this->n; ++i) {
         SEXP cur = STRING_ELT(rstr, i);
         if (cur == NA_STRING)
            this->data[i] = NULL;
         else
            this->data[i] = new String8(CHAR(cur), LENGTH(cur), false); // shallow copy
      }
   }
}


StriContainerListRaw::StriContainerListRaw(StriContainerListRaw& container)
   :    StriContainerBase((StriContainerBase&)container)
{
   if (container.data) {
      this->data = new String8*[this->n];
      for (int i=0; i<this->n; ++i) {
         if (container.data[i])
            this->data[i] = new String8(*(container.data[i]));
         else
            this->data[i] = NULL;
      }
   }
   else {
      this->data = NULL;
   }
}




StriContainerListRaw& StriContainerListRaw::operator=(StriContainerListRaw& container)
{
   this->~StriContainerListRaw();
   (StriContainerBase&) (*this) = (StriContainerBase&)container;

   if (container.data) {
      this->data = new String8*[this->n];
      for (int i=0; i<this->n; ++i) {
         if (container.data[i])
            this->data[i] = new String8(*(container.data[i]));
         else
            this->data[i] = NULL;
      }
   }
   else {
      this->data = NULL;
   }
   return *this;
}



StriContainerListRaw::~StriContainerListRaw()
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
