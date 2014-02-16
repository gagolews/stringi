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
