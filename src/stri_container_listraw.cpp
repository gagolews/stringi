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
