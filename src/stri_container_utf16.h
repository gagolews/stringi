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


#ifndef __stri_container_utf16_h
#define __stri_container_utf16_h





/**
 * A class to handle conversion between R character vectors and UTF-16 string vectors
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - lastMatcher cache, supports auto-vectorization
 * @version 0.3 (Marek Gagolewski) - improved ASCII performance (seperate ucnv)
 * @version 0.4 (Marek Gagolewski) - now NAs are marked as NULLs in str
 */
class StriContainerUTF16 : public StriContainerBase {

   protected:

      UnicodeString** str;       ///< data - \code{UnicodeString}s


   public:

      StriContainerUTF16();
      StriContainerUTF16(R_len_t nrecycle);
      StriContainerUTF16(SEXP rstr, R_len_t nrecycle, bool shallowrecycle=true);
      StriContainerUTF16(StriContainerUTF16& container);
      ~StriContainerUTF16();
      StriContainerUTF16& operator=(StriContainerUTF16& container);
      SEXP toR(R_len_t i) const;
      SEXP toR() const;


      /** check if the vectorized ith element is NA
       * @param i index
       * @return true if is NA
       */
      inline bool isNA(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerUTF16::isNA(): INDEX OUT OF BOUNDS");
#endif
         return (str[i%n] == NULL);
      }


      /** get the vectorized ith element
       * @param i index
       * @return string
       */
      const UnicodeString& get(R_len_t i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle)
            throw StriException("StriContainerUTF16::get(): INDEX OUT OF BOUNDS");
         if (str[i%n] == NULL)
            throw StriException("StriContainerUTF16::get(): isNA");
#endif
         return (*(str[i%n]));
      }

      /** get the vectorized ith element
       * @param i index
       * @return string
       */
      UnicodeString& getWritable(R_len_t i) {
#ifndef NDEBUG
         if (isShallow)
            throw StriException("StriContainerUTF16::getWritable(): shallow StriContainerUTF16");
         if (n != nrecycle)
            throw StriException("StriContainerUTF16::getWritable(): n!=nrecycle");
         if (i < 0 || i >= n)
            throw StriException("StriContainerUTF16::getWritable(): INDEX OUT OF BOUNDS");
         if (str[i%n] == NULL)
            throw StriException("StriContainerUTF16::getWritable(): isNA");
#endif
         return (*(str[i%n])); // in fact, "%n" is not necessary
      }


      /** set NA
       * @param i index
       */
      void setNA(R_len_t i) {
#ifndef NDEBUG
         if (isShallow)
            throw StriException("StriContainerUTF16::getWritable(): shallow StriContainerUTF16");
         if (n != nrecycle)
            throw StriException("StriContainerUTF16::getWritable(): n!=nrecycle");
         if (i < 0 || i >= n)
            throw StriException("StriContainerUTF16::getWritable(): INDEX OUT OF BOUNDS");
#endif
         if (str[i%n] != NULL) { // if not already NULL
            delete str[i%n]; // in fact, "%n" is not necessary
            str[i%n] = NULL;
         }
      }

      /** set the vectorized ith element
       * @param i index
       * @param s string to be copied
       */
      void set(R_len_t i, const UnicodeString& s) {
#ifndef NDEBUG
         if (isShallow)
            throw StriException("StriContainerUTF16::set(): shallow StriContainerUTF16");
         if (n != nrecycle)
            throw StriException("StriContainerUTF16::set(): n!=nrecycle");
         if (i < 0 || i >= n)
            throw StriException("StriContainerUTF16::set(): INDEX OUT OF BOUNDS");
         if (str[i%n] == NULL)
            throw StriException("StriContainerUTF16::set(): isNA");
#endif
         *(str[i%n]) = s; // in fact, "%n" is not necessary
      }

      void UChar16_to_UChar32_index(R_len_t i, int* i1, int* i2, const int ni, int adj1, int adj2);
};

#endif
