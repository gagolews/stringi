/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#ifndef __stri_container_base_h
#define __stri_container_base_h


/**
 * Base class for all StriContainers
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          removed ucnvNative, ucnvLatin1 (not needed per-object)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          removed enc array
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-22)
 *          added sexp field
 */
class StriContainerBase {

   protected:

      R_len_t n;                 ///< number of strings (size of \code{str})
      R_len_t nrecycle;          ///< number of strings for the recycle rule (can be > \code{n})
      SEXP sexp;                 ///<

#ifndef NDEBUG
      bool isShallow;            ///< have we made only shallow copy of the strings? (=> read only)
#endif

      StriContainerBase();
      // StriContainerBase(StriContainerBase& container); // use default (shallow copy)
      //~StriContainerBase(); // use default

      void init_Base(R_len_t n, R_len_t nrecycle, bool shallowrecycle, SEXP sexp=NULL);


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
