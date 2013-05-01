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
   this->enc = NULL;
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
   this->isShallow = true;
}




StriContainerUTF_Base::StriContainerUTF_Base(StriContainerUTF_Base& container)
{
   this->n = container.n;
   this->nrecycle = container.nrecycle;
   this->isShallow = container.isShallow;
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
   if (this->n > 0) {
      this->enc = new StriEnc[this->n];
      for (int i=0; i<this->n; ++i) {
         this->enc[i] = container.enc[i];
      }
   }
   else {
      this->enc = NULL;
   }
}



StriContainerUTF_Base& StriContainerUTF_Base::operator=(StriContainerUTF_Base& container)
{
   this->~StriContainerUTF_Base();
   
   this->n = container.n;
   this->nrecycle = container.nrecycle;
   this->isShallow = container.isShallow;
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
   if (this->n > 0) {
      this->enc = new StriEnc[this->n];
      for (int i=0; i<this->n; ++i) {
         this->enc[i] = container.enc[i];
      }
   }
   else {
      this->enc = NULL;
   }
}



StriContainerUTF_Base::~StriContainerUTF_Base()
{
   if (this->ucnvNative)
      ucnv_close(this->ucnvNative);
   if (this->ucnvLatin1)
      ucnv_close(this->ucnvLatin1);

   if (this->n > 0) {
      delete [] this->enc;  
   }

   this->enc = NULL;
   this->n = 0;
   this->nrecycle = 0;
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
}


