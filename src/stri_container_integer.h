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

#ifndef __stri_container_integer_h
#define __stri_container_integer_h





/**
 * A wrapper-class for R integer vectors
 * @version 0.1 (Marek Gagolewski, 2013-06-15)
 */
class StriContainerInteger : public StriContainerBase {

   private:

      int* data;

   public:

      StriContainerInteger() : StriContainerBase()
      {
         data = NULL;
      }

      StriContainerInteger(SEXP rvec, R_len_t _nrecycle)
      {
         this->data = NULL;
#ifndef NDEBUG
         if (!Rf_isInteger(rvec))
            throw StriException("DEBUG: !isInteger in StriContainerInteger");
#endif
         R_len_t ndata = LENGTH(rvec);
         this->init_Base(ndata, _nrecycle, true);
         this->data = INTEGER(rvec);
      }

      //  StriContainerInteger(StriContainerInteger& container); // default-shallow
      // ~StriContainerInteger(); // default-shallow
      //  StriContainerInteger& operator=(StriContainerInteger& container); // default-shallow


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerInteger::isNA(): INDEX OUT OF BOUNDS");
#endif
         return (data[i%n] == NA_INTEGER);
      }


      /** get the vectorized ith element
       * @param i index
       * @return integer
       */
      inline int get(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerInteger::get(): INDEX OUT OF BOUNDS");
         if (data[i%n] == NA_INTEGER)
            throw StriException("StriContainerInteger::get(): isNA");
#endif
         return (data[i%n]);
      }
};

#endif
