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
 * A class to represent an UTF-8 string, or a temporary UTF-8 string buffer
 *
 * quite similar to std::string and/or  Vector<char>
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
 */
class String8  {

   private:

      char* m_str;      ///< character data in UTF-8, NULL denotes NA
      R_len_t m_n;      ///< string length (in bytes), not including NUL [[may be invalid]]
      R_len_t m_size;   ///< buffer size
      bool m_memalloc;  /// < should the memory be freed at the end


   public:

      /** default constructor
       *
       * does nothing
       */
      String8() {
         this->m_str = NULL; // a missing value
         this->m_n = 0;
         this->m_size = 0;
         this->m_memalloc = false;
      }


      /** allocate string buffer
       * @param size buffer length-1
       */
      String8(R_len_t size) {
         this->m_n = 0;
         this->m_size = size+1;
         this->m_memalloc = true;
         this->m_str = new char[this->m_size];
         this->m_str[0] = '\0';
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
            this->m_size = this->m_n+1;
            this->m_str = new char[this->m_size];
            memcpy(this->m_str, str+3, (size_t)this->m_size);
         }
         else {
            this->m_memalloc = memalloc;
            this->m_n = n;
            this->m_size = n+1;
            if (memalloc) {
   //            cerr << "DEBUG: String8: memalloc!" << endl;
               this->m_str = new char[this->m_size];
               memcpy(this->m_str, str, (size_t)this->m_size);
            }
            else {
               this->m_str = (char*)(str); // we know what we're doing
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
//            cerr << "~String8()" << endl;
         }
      }

      /** copy constructor */
      String8(const String8& s)
      {
         this->m_memalloc = s.m_memalloc;
         this->m_n = s.m_n;
         this->m_size = s.m_size;
         if (s.m_memalloc) {
//            cerr << "DEBUG: String8: memalloc!" << endl;
            this->m_str = new char[this->m_size];
            memcpy(this->m_str, s.m_str, (size_t)this->m_size);
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
         this->m_size = s.m_size;
         if (s.m_memalloc) {
//            cerr << "DEBUG: String8: memalloc!" << endl;
            this->m_str = new char[this->m_size];
            memcpy(this->m_str, s.m_str, (size_t)this->m_size);
         }
         else {
            this->m_str = s.m_str;
         }

         return *this;
      }
      
      inline bool isNA() const {
         return !this->m_str;
      }

      inline bool isReadOnly() const {
         return !this->m_memalloc;
      }

      /** return the char buffer */
      inline const char* c_str() const
      {
#ifndef NDEBUG
         if (isNA())
            throw StriException("string8::isNA() in c_str()");
#endif
         return this->m_str;
      }

      inline char* data()
      {
#ifndef NDEBUG
         if (!this->m_memalloc)
            throw StriException("String8: data(): string is read only.");
         if (isNA())
            throw StriException("string8::isNA() in data()");
#endif
         return this->m_str;
      }

      /** string length in bytes */
      inline R_len_t length() const
      {
#ifndef NDEBUG
         if (isNA())
            throw StriException("string8::isNA() in length()");
#endif
         return this->m_n; // !!!!! May be invalid if we use String8 as a writebuf :(
      }

      /** buffer size in bytes */
      inline R_len_t size() const
      {
#ifndef NDEBUG
         if (isNA())
            throw StriException("string8::isNA() in size()");
#endif
         return this->m_size;
      }


      /** increase buffer size;
       * existing buffer content will be retained
       * @param size new size-1
       */
      inline void resize(R_len_t size, bool copy=true)
      {
         if (this->m_size >= size)
            return; // do nothing (the requested buffer size is available)

         size_t oldsize = this->m_size;
         this->m_size = size+1;
         char* newstr = new char[this->m_size];
         if (this->m_str) {
            if (copy) {
               memcpy(newstr, this->m_str, (size_t)oldsize);
               //this->n = this->n;
            }
            else {
               newstr[0] = 0;
               this->m_n = 0;
            }
            if (this->m_memalloc) delete[] this->m_str;
         }
         else {
            newstr[0] = 0;
            this->m_n = 0;
         }

         this->m_str = newstr;
         this->m_memalloc = true;
      }

};

#endif
