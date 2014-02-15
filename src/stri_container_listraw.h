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

#ifndef __stri_container_listraw_h
#define __stri_container_listraw_h





/**
 * Contains R lists of raw vectors, single raw vectors,
 * or character strings treated as "byte"-encoded.
 * Useful for encoding conversion or detection.
 * Each string is represented by the String8 class,
 * with shallow copy of byte data.
 *
 * @version 0.1 (Marek Gagolewski, 2013-08-08)
 */
class StriContainerListRaw : public StriContainerBase {

   private:

      String8** data; // vectors [NULL for NA]


   public:

      StriContainerListRaw();
      StriContainerListRaw(SEXP rlist);
      StriContainerListRaw(StriContainerListRaw& container);
      ~StriContainerListRaw();
      StriContainerListRaw& operator=(StriContainerListRaw& container);


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerListRaw::isNA(): INDEX OUT OF BOUNDS");
#endif
         return (data[i%n] == NULL);
      }


      /** get the vectorized ith element
       * @param i index
       * @return string, read only
       */
      const String8& get(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerListRaw::get(): INDEX OUT OF BOUNDS");
         if (data[i%n] == NULL)
            throw StriException("StriContainerListRaw::get(): isNA");
#endif
         return (*(data[i%n]));
      }
};

#endif
