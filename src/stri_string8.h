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


#ifndef __stri_string8_h
#define __stri_string8_h





/**
 * A class to represent an UTF-8 string, or a temporary UTF-8 string buffer
 *
 * quite similar to std::string and/or  Vector<char>
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski, 2013-06-13) added resize() method and m_size field
 */
class String8  {

   private:

      char* m_str;  ///< character data in UTF-8
      R_len_t m_n;      ///< string length (in bytes), not including NUL
      R_len_t m_size;   ///< buffer size
      bool m_memalloc;  /// < should the memory be freed at the end


   public:

      /** default constructor
       *
       * does nothing
       */
      String8() {
         this->m_str = NULL;
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


      /** constructor
       * @param str character buffer
       * @param n buffer length (not including NUL)
       * @param memalloc should a deep copy of the buffer be done?
       */
      String8(const char* str, R_len_t n, bool memalloc=false)
      {
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

      /** return the char buffer */
      inline const char* c_str() const
      {
         return this->m_str;
      }

      inline char* data()
      {
#ifndef NDEBUG
         if (!this->m_memalloc)
            throw StriException("String8: data(): string is read only.");
#endif
         return this->m_str;
      }

      /** string length in bytes */
      inline R_len_t length() const
      {
         return this->m_n;
      }

      /** buffer size in bytes */
      inline R_len_t size() const
      {
         return this->m_size;
      }


      /** increase buffer size
       * @param size new size-1
       */
      inline void resize(R_len_t size, bool copy=true)
      {
         if (this->m_size >= size)
            return;
         this->m_size = size+1;
         char* newstr = new char[this->m_size];
         if (this->m_str) {
            if (copy) {
               memcpy(newstr, this->m_str, (size_t)this->m_size);
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
