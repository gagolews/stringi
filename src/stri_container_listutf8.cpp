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
      for (R_len_t i=0; i<this->n; ++i)
         this->data[i] = NULL; // in case it fails during conversion (this is "NA")

      for (R_len_t i=0; i<this->n; ++i)
         this->data[i] = new StriContainerUTF8(VECTOR_ELT(rvec, i), _nrecycle, _shallowrecycle);
   }
}


StriContainerListUTF8::StriContainerListUTF8(StriContainerListUTF8& container)
   :    StriContainerBase((StriContainerBase&)container)
{
   if (container.data) {
      this->data = new StriContainerUTF8*[this->n];
      for (int i=0; i<container.n; ++i) {
         if (container.data[i])
            this->data[i] = new StriContainerUTF8(*container.data[i]);
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
      for (int i=0; i<container.n; ++i) {
         if (container.data[i])
            this->data[i] = new StriContainerUTF8(*container.data[i]);
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
