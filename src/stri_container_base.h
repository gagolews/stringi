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


#ifndef __stri_container_base_h
#define __stri_container_base_h





/**
 * Base class for StriContainers
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) - removed ucnvNative, ucnvLatin1 (not needed per-object)
 * @version 0.3 (Marek Gagolewski) - removed enc array
 */
class StriContainerBase {

   protected:

      R_len_t n;                 ///< number of strings (size of \code{str})
      R_len_t nrecycle;          ///< number of strings for the recycle rule (can be > \code{n})

#ifndef NDEBUG
      bool isShallow;            ///< have we made only shallow copy of the strings? (=> read only)
#endif

      StriContainerBase();
      //StriContainerBase(StriContainerBase& container); // use default (shallow)
      //~StriContainerBase(); // use default (shallow)

      void init_Base(R_len_t n, R_len_t nrecycle, bool shallowrecycle);


   public:
      //StriContainerBase& operator=(StriContainerBase& container); // use default (shallow)

      inline R_len_t get_n() { return n; }
      inline R_len_t get_nrecycle() { return nrecycle; }
      inline void set_nrecycle(R_len_t nval) { nrecycle = nval; }


      /** Loop over vectorized container - init */
      inline R_len_t vectorize_init() const {
         if (n <= 0) return nrecycle;
         else return 0;
      }

      /** Loop over vectorized container - end iterator */
      inline R_len_t vectorize_end() const {
         return nrecycle;
      }

      /** Loop over vectorized container - next iteration */
      inline R_len_t vectorize_next(R_len_t i) const {
         if (i == nrecycle - 1 - (nrecycle%n))
            return nrecycle; // this is the end
         i = i + n;
         if (i >= nrecycle)
            return (i % n) + 1;
         else
            return i;
      }
};

#endif
