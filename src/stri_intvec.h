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


#ifndef __stri_intvec_h
#define __stri_intvec_h


/**
 * A class to represent an integer vector or NULL/NA
 *
 * Currently each int vector is read-only.
 * It may be used as a simple wrapper for R integer vectors.
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-25)
 */
class IntVec  {

   private:

      const int* m_data;
      R_len_t m_n;

   public:

      /** default constructor
       *
       */
      IntVec() {
         this->m_data = NULL;
         this->m_n = 0;
      }


      /** used to set data
       *
       * @param data
       * @param n
       */
      void initialize(const int* data, R_len_t n)
      {
         this->m_data = data;
         this->m_n = n;
      }


      /** constructor
       * @param str character buffer
       * @param n buffer length (not including NUL)
       * @param memalloc should a deep copy of the buffer be done?
       */
      IntVec(const int* data, R_len_t n)
      {
         initialize(data, n);
      }

      inline bool isNA() const
      {
         return m_data == NULL;
      }

      inline const int* data() const
      {
#ifndef NDEBUG
         if (isNA())
            throw StriException("IntVec::isNA() in data()");
#endif
         return this->m_data;
      }

      inline R_len_t size() const
      {
#ifndef NDEBUG
         if (isNA())
            throw StriException("IntVec::isNA() in size()");
#endif
         return this->m_n;
      }
};

#endif
