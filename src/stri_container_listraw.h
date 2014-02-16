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
