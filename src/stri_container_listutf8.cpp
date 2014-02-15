/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * 'stringi' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'stringi' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.
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
