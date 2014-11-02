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


#ifndef __stri_string8_h
#define __stri_string8_h


/**
 * A class to represent an UTF-8 string
 *
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-13)
 *          added resize() method and m_size field
 *
 * @version 0.1-24 (Marek Gagolewski, 2014-03-11)
 *          Fixed array over-runs detected with valgrind
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-15)
 *          m_str == NULL now denotes a missing value,
 *          isNA(), initialize() methods added
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-23)
 *          initialize() now can kill UTF8 BOMs.
 *          separated String8buf
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-20)
 *          new method: countCodePoints()
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
 *          BUGFIX?: Added explicit zero bytes at the end of each array;
 *          new methods: replaceAllAtPos(), setNA()
 */
class String8  {

   private:

      char* m_str;      ///< character data in UTF-8, NULL denotes NA
      R_len_t m_n;      ///< string length (in bytes), not including NUL
      bool m_memalloc;  /// < should the memory be freed at the end


   public:

      /** default constructor
       *
       */
      String8() {
         this->m_str = NULL; // a missing value
         this->m_n = 0;
         this->m_memalloc = false;
      }


      /** used to set data (construct already created,
       * but NA-initialized object)
       *
       * @param str character buffer
       * @param n buffer length (not including NUL)
       * @param memalloc should a deep copy of the buffer be done?
       * @param killbom whether to detect and delete UTF-8 BOMs
       */
      void initialize(const char* str, R_len_t n, bool memalloc=false, bool killbom=false)
      {
#ifndef NDEBUG
         if (!isNA())
            throw StriException("string8::!isNA() in initialize()");
#endif
         if (killbom && n >= 3 &&
            (uint8_t)(str[0]) == UTF8_BOM_BYTE1 &&
            (uint8_t)(str[1]) == UTF8_BOM_BYTE2 &&
            (uint8_t)(str[2]) == UTF8_BOM_BYTE3) {
            // has BOM - get rid of it
            this->m_memalloc = true; // ignore memalloc val
            this->m_n = n-3;
            this->m_str = new char[this->m_n+1];
            memcpy(this->m_str, str+3, (size_t)this->m_n);
            this->m_str[this->m_n] = '\0';
         }
         else {
            this->m_memalloc = memalloc;
            this->m_n = n;
            if (memalloc) {
               this->m_str = new char[this->m_n+1];
               // memcpy may be very fast in some libc implementations
               memcpy(this->m_str, str, (size_t)this->m_n);
               this->m_str[this->m_n] = '\0';
            }
            else {
               this->m_str = (char*)(str); // we know what we're doing
               // str is zero-terminated
            }
         }
      }


      /** constructor
       * @param str character buffer
       * @param n buffer length (not including NUL)
       * @param memalloc should a deep copy of the buffer be done?
       */
      String8(const char* str, R_len_t n, bool memalloc=false)
      {
         this->m_str = NULL; // a missing value
         initialize(str, n, memalloc);
      }


      /** destructor */
      ~String8()
      {
         if (this->m_str && this->m_memalloc) {
            delete [] this->m_str;
         }
         this->m_str = NULL;
      }


      /** destructor */
      void setNA()
      {
         if (this->m_str && this->m_memalloc) {
            delete [] this->m_str;
         }
         this->m_str = NULL;
      }


      /** copy constructor */
      String8(const String8& s)
      {
         this->m_memalloc = s.m_memalloc;
         this->m_n = s.m_n;
         if (s.m_memalloc) {
            this->m_str = new char[this->m_n+1];
            memcpy(this->m_str, s.m_str, (size_t)this->m_n);
            this->m_str[this->m_n] = '\0';
         }
         else {
            this->m_str = s.m_str;
         }
      }

      /** copy */
      String8& operator=(const String8& s)
      {
         if (this->m_str && this->m_memalloc)
            delete [] this->m_str;

         this->m_memalloc = s.m_memalloc;
         this->m_n = s.m_n;
         if (s.m_memalloc) {
            this->m_str = new char[this->m_n+1];
            memcpy(this->m_str, s.m_str, (size_t)this->m_n);
            this->m_str[this->m_n] = '\0';
         }
         else {
            this->m_str = s.m_str;
         }

         return *this;
      }

      /** does this String8 represent a missing value? */
      inline bool isNA() const {
         return !this->m_str;
      }

      /** misleading name: did we allocate mem in String8
       *  or is this string a shallow copy of some "external" resource?
       */
      inline bool isReadOnly() const {
         return !this->m_memalloc;
      }

      /** return the char buffer */
      inline const char* c_str() const
      {
#ifndef NDEBUG
         if (isNA())
            throw StriException("String8::isNA() in c_str()");
#endif
         return this->m_str;
      }

      /** string length in bytes */
      inline R_len_t length() const
      {
#ifndef NDEBUG
         if (isNA())
            throw StriException("String8::isNA() in length()");
#endif
         return this->m_n;
      }


      /** number of utf-8 code points */
      inline R_len_t countCodePoints() const
      {
#ifndef NDEBUG
         if (isNA())
            throw StriException("String8::isNA() in countCodePoints()");
#endif
         UChar32 c = 0;
         R_len_t j = 0;
         R_len_t i = 0;
         while (j < m_n) {
            U8_NEXT(m_str, j, m_n, c); // faster that U8_FWD_1 & gives bad UChar32s
            i++;

            if (c < 0)
               Rf_warning(MSG__INVALID_UTF8);
         }

         return i;
      }


      /** Replace substrings with a given replacement string
       *
       *
       * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
       */
      void replaceAllAtPos(R_len_t buf_size,
         const char* replacement_cur_s, R_len_t replacement_cur_n,
         std::deque< std::pair<R_len_t, R_len_t> >& occurrences)
      {
#ifndef NDEBUG
         if (isNA()) throw StriException("String8::isNA() in replaceAllAtPos()");
#endif
         char* old_str = this->m_str;
         int old_n = this->m_n;
         bool old_memalloc = this->m_memalloc;
         this->m_str = new char[buf_size+1];
         this->m_n = buf_size;
         this->m_memalloc = true;

         R_len_t buf_used = 0;
         R_len_t jlast = 0;

         std::deque< std::pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
         for (; iter != occurrences.end(); ++iter) {
            pair<R_len_t, R_len_t> match = *iter;
            memcpy(m_str+buf_used, old_str+jlast, (size_t)(match.first-jlast));
            buf_used += match.first-jlast;
#ifndef NDEBUG
            if (buf_used > buf_size)
               throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif

            jlast = match.second;
            memcpy(m_str+buf_used, replacement_cur_s, (size_t)(replacement_cur_n));
            buf_used += replacement_cur_n;
#ifndef NDEBUG
            if (buf_used > buf_size)
               throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif
         }

         memcpy(m_str+buf_used, old_str+jlast, (size_t)(old_n-jlast));
         buf_used += (old_n-jlast);
#ifndef NDEBUG
         if (buf_used > buf_size)
            throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif

#ifndef NDEBUG
         if (buf_used != this->m_n)
            throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif
         this->m_str[this->m_n] = '\0';

         if (old_str && old_memalloc)
            delete [] old_str;
      }

};

#endif
