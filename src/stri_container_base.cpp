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
StriContainerBase::StriContainerBase()
{
   this->n = 0;
   this->nrecycle = 0;
#ifndef NDEBUG
   this->isShallow = true;
#endif
}



/**
 *
 *
 */
void StriContainerBase::init_Base(R_len_t _n, R_len_t _nrecycle, bool _shallowrecycle)
{
#ifndef NDEBUG
   if (this->n != 0)
      throw StriException("StriContainerBase::init_Base(...): already initialized");
   this->isShallow = _shallowrecycle;
#endif

   if (_n == 0 || _nrecycle == 0) {
      this->nrecycle = 0;
      this->n = 0;
   }
   else {
      this->nrecycle = _nrecycle;
      this->n = (_shallowrecycle)?_n:_nrecycle;

#ifndef NDEBUG
   if (this->n < _n)
      throw StriException("StriContainerBase::init_Base(...): this->n < n");
   if (this->n > this->nrecycle)
      throw StriException("StriContainerBase::init_Base(...): this->n > this->nrecycle");
#endif
   }
}




//StriContainerBase::StriContainerBase(StriContainerBase& container)
//{
//   this->n = container.n;
//   this->nrecycle = container.nrecycle;
//#ifndef NDEBUG
//   this->isShallow = container.isShallow;
//#endif
//}



//StriContainerBase& StriContainerBase::operator=(StriContainerBase& container)
//{
//   this->~StriContainerBase();
//
//   this->n = container.n;
//   this->nrecycle = container.nrecycle;
//#ifndef NDEBUG
//   this->isShallow = container.isShallow;
//#endif
//
//   return *this;
//}



//StriContainerBase::~StriContainerBase()
//{
//   this->n = 0;
//   this->nrecycle = 0;
//}
