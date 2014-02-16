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
