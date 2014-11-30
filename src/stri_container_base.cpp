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
#include "stri_container_base.h"


/**
 * Default constructor
 *
 */
StriContainerBase::StriContainerBase()
{
   this->n = 0;
   this->nrecycle = 0;
   this->sexp = (SEXP)NULL;
#ifndef NDEBUG
   this->isShallow = true;
#endif
}


/**
 * Initialize object data
 *
 */
void StriContainerBase::init_Base(R_len_t _n, R_len_t _nrecycle, bool _shallowrecycle, SEXP _sexp)
{
#ifndef NDEBUG
   if (this->n != 0 || this->nrecycle != 0 || this->sexp != (SEXP)NULL)
      throw StriException("StriContainerBase::init_Base(...): already initialized");
   this->isShallow = _shallowrecycle;
#endif

   if (_n == 0 || _nrecycle == 0) {
      this->nrecycle = 0;
      this->n = 0;
      this->sexp = _sexp;
   }
   else {
      this->nrecycle = _nrecycle;
      this->n = (_shallowrecycle)?_n:_nrecycle;
      this->sexp = _sexp;

#ifndef NDEBUG
   if (this->n < _n)
      throw StriException("StriContainerBase::init_Base(...): this->n < _n");
   if (this->n > this->nrecycle)
      throw StriException("StriContainerBase::init_Base(...): this->n > this->nrecycle");
#endif
   }
}
