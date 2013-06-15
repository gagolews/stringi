/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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
 

#include "stringi.h"

   
   
/** 
 * Default constructor
 * 
 */
StriContainerUTF_Base::StriContainerUTF_Base()
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
void StriContainerUTF_Base::init_Base(R_len_t n, R_len_t nrecycle, bool shallowrecycle)
{
#ifndef NDEBUG 
   if (this->n != 0) error("StriContainerUTF_Base::init_Base(...): already initialized");
   this->isShallow = shallowrecycle;
#endif

   if (n == 0 || nrecycle == 0) {
      this->nrecycle = 0;
      this->n = 0;
   }
   else {
      this->nrecycle = nrecycle;
      this->n = (shallowrecycle)?n:nrecycle;
      
#ifndef NDEBUG 
   if (this->n < n)
      error("StriContainerUTF_Base::init_Base(...): this->n < n");
   if (this->n > this->nrecycle)
      error("StriContainerUTF_Base::init_Base(...): this->n > this->nrecycle");
#endif
   }
}




StriContainerUTF_Base::StriContainerUTF_Base(StriContainerUTF_Base& container)
{
   this->n = container.n;
   this->nrecycle = container.nrecycle;
#ifndef NDEBUG
   this->isShallow = container.isShallow;
#endif
}



StriContainerUTF_Base& StriContainerUTF_Base::operator=(StriContainerUTF_Base& container)
{
   this->~StriContainerUTF_Base();
   
   this->n = container.n;
   this->nrecycle = container.nrecycle;
#ifndef NDEBUG
   this->isShallow = container.isShallow;
#endif
   
   return *this;
}



StriContainerUTF_Base::~StriContainerUTF_Base()
{
   this->n = 0;
   this->nrecycle = 0;
}


