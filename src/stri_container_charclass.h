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

#ifndef __stri_container_charclass_h
#define __stri_container_charclass_h





/**
 * A wrapper-class for R logical vectors
 * @version 0.1 (Marek Gagolewski, 2013-06-15)
 */
class StriContainerCharClass : public StriContainerBase {

   private:

      CharClass* data;

   public:

      StriContainerCharClass() : StriContainerBase()
      {
         data = NULL;
      }

      StriContainerCharClass(SEXP rvec, R_len_t _nrecycle)
      {
         this->data = NULL;
#ifndef NDEBUG
         if (!isString(rvec))
            throw StriException("DEBUG: !isString in StriContainerCharClass");
#endif
         R_len_t ndata = LENGTH(rvec);
         this->init_Base(ndata, _nrecycle, true);
         if (ndata > 0) {
            this->data = new CharClass[ndata];
            for (int i=0; i<ndata; ++i)
               this->data[i] = CharClass(STRING_ELT(rvec, i));
         }
      }

      StriContainerCharClass(StriContainerCharClass& container)
         :StriContainerBase((StriContainerBase&)container)
      {
         if (container.data) {
            this->data = new CharClass[container.n];
            for (int i=0; i<container.n; ++i)
               this->data[i] = container.data[i];
         }
         else
            this->data = NULL;
      }

      ~StriContainerCharClass() {
         if (data) delete [] data;
      }

      StriContainerCharClass& operator=(StriContainerCharClass& container)
      {
         this->~StriContainerCharClass();
         (StriContainerBase&) (*this) = (StriContainerBase&)container;
         if (container.data) {
            this->data = new CharClass[container.n];
            for (int i=0; i<container.n; ++i)
               this->data[i] = container.data[i];
         }
         else
            this->data = NULL;
         return *this;
      }


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerCharClass::isNA(): INDEX OUT OF BOUNDS");
#endif
         return data[i%n].isNA();
      }


      /** get the vectorized ith element
       * @param i index
       * @return integer
       */
      inline const CharClass& get(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerCharClass::get(): INDEX OUT OF BOUNDS");
         if (data[i%n].isNA())
            throw StriException("StriContainerCharClass::get(): isNA");
#endif
         return (data[i%n]);
      }
};

#endif
