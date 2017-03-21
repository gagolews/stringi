/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2017, Marek Gagolewski and other contributors.
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
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
 *          new field: m_isASCII
 */
class String8  {

   private:

      char* m_str;      ///< character data in UTF-8, NULL denotes NA
      R_len_t m_n;      ///< string length (in bytes), not including NUL
      bool m_memalloc;  ///< should the memory be freed at the end
      bool m_isASCII;   ///< ASCII or UTF-8?


   public:

      /** default constructor
       *
       */
      String8() {
         this->m_str = NULL; // a missing value
         this->m_n = 0;
         this->m_memalloc = false;
         this->m_isASCII = false;
      }


      /** used to set data (construct already created,
       * but NA-initialized object)
       *
       * @param str character buffer
       * @param n buffer length (not including NUL)
       * @param memalloc should a deep copy of the buffer be done?
       * @param killbom whether to detect and delete UTF-8 BOMs
       * @param isASCII
       */
      void initialize(const char* str, R_len_t n, bool memalloc, bool killbom, bool isASCII)
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
            this->m_isASCII = isASCII;
            this->m_str = new char[this->m_n+1];
            if (!this->m_str) throw StriException(MSG__MEM_ALLOC_ERROR);
            memcpy(this->m_str, str+3, (size_t)this->m_n);
            this->m_str[this->m_n] = '\0';
         }
         else {
            this->m_memalloc = memalloc;
            this->m_n = n;
            this->m_isASCII = isASCII;
            if (memalloc) {
               this->m_str = new char[this->m_n+1];
               if (!this->m_str) throw StriException(MSG__MEM_ALLOC_ERROR);
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
       * @param killbom whether to detect and delete UTF-8 BOMs
       * @param isASCII
       */
      String8(const char* str, R_len_t n, bool memalloc, bool killbom, bool isASCII)
      {
         this->m_str = NULL; // a missing value
         initialize(str, n, memalloc, killbom, isASCII);
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
      inline void setNA()
      {
         if (this->m_str) {
            if (this->m_memalloc) {
               delete [] this->m_str;
            }
            this->m_str = NULL;
         }
      }


      /** copy constructor */
      String8(const String8& s)
      {
         this->m_memalloc = s.m_memalloc;
         this->m_n = s.m_n;
         this->m_isASCII = s.m_isASCII;
         if (s.m_memalloc) {
            this->m_str = new char[this->m_n+1];
            if (!this->m_str) throw StriException(MSG__MEM_ALLOC_ERROR);
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
         this->m_isASCII = s.m_isASCII;
         if (s.m_memalloc) {
            this->m_str = new char[this->m_n+1];
            if (!this->m_str) throw StriException(MSG__MEM_ALLOC_ERROR);
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

      /** does this String8 is in ASCII? */
      inline bool isASCII() const {
         return this->m_isASCII;
      }

      /** does this String8 is in UTF-8? */
      inline bool isUTF8() const {
         return !this->m_isASCII;
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
         if (m_isASCII)
            return m_n;

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


      /**
       *
       * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
       *
       * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
       *    moved from StriContainerByteSearch to String8
       */
      bool endsWith(R_len_t byteindex, const char* patternStr, R_len_t patternLen, bool caseInsensitive) const
      {
         if (caseInsensitive) {
            R_len_t k = patternLen;
            UChar32 c1;
            UChar32 c2;
            while (k > 0) {
               if (byteindex <= 0) return false;
               U8_PREV(m_str, 0, byteindex, c1);
               U8_PREV(patternStr, 0, k, c2);
               if (u_toupper(c1) != u_toupper(c2))
                  return false;
            }
            return true;
         }
         else {
            if (byteindex-patternLen < 0) return false;

            for (R_len_t k=0; k < patternLen; ++k)
               if (m_str[byteindex-k-1] != patternStr[patternLen-k-1])
                  return false;

            return true; // found
         }
      }


      /**
       *
       * @version 0.4-1 (Marek Gagolewski, 2014-12-07)
       *
       * @version 0.5-1 (Marek Gagolewski, 2015-02-14)
       * moved from StriContainerByteSearch to String8
       */
      bool startsWith(R_len_t byteindex, const char* patternStr, R_len_t patternLen, bool caseInsensitive) const
      {
         if (caseInsensitive) {
            R_len_t k = 0;
            UChar32 c1;
            UChar32 c2;

            while (k < patternLen) {
               if (byteindex >= m_n) return false;
               U8_NEXT(m_str,      byteindex, m_n,        c1);
               U8_NEXT(patternStr, k,         patternLen, c2);
               if (u_toupper(c1) != u_toupper(c2))
                  return false;
            }
            return true;
         }
         else {
            if (byteindex+patternLen > m_n) return false;

            for (R_len_t k=0; k < patternLen; ++k)
               if (m_str[byteindex+k] != patternStr[k])
                  return false;

            return true; // found
         }
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
         this->m_isASCII = true; /* TO DO */

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
