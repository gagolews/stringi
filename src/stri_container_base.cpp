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
