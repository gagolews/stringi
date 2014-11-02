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


#ifndef __stri_string8buf_h
#define __stri_string8buf_h


/**
 * A class to represent a temporary string buffer
 *
 * Quite similar to std::string and/or  Vector<char>
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-24)
 *          Separated from String8
 */
class String8buf  {

   private:

      char* m_str;
      R_len_t m_size;   ///< buffer size in bytes


   public:


      /** allocate string buffer
       *
       * @param size buffer length-1
       */
      String8buf(R_len_t size=0) {
         this->m_size = size+1;
         this->m_str = new char[this->m_size];
         this->m_str[0] = '\0';
      }


      /** destructor */
      ~String8buf()
      {
         if (this->m_str)
            delete [] this->m_str;
         this->m_str = NULL;
      }

      /** copy constructor */
      String8buf(const String8buf& s)
      {
         this->m_size = s.m_size;
         this->m_str = new char[this->m_size];
         memcpy(this->m_str, s.m_str, (size_t)this->m_size);
      }

      /** copy */
      String8buf& operator=(const String8buf& s)
      {
         if (this->m_str)
            delete [] this->m_str;

         this->m_size = s.m_size;
         this->m_str = new char[this->m_size];
         memcpy(this->m_str, s.m_str, (size_t)this->m_size);

         return *this;
      }


      /* return data */
      inline char* data()
      {
         return this->m_str;
      }


      /** buffer size in bytes */
      inline R_len_t size() const
      {
         return this->m_size;
      }


      /** increase buffer size;
       *
       * @param size new size-1
       * @param copy should the existing buffer content be retained?
       */
      inline void resize(R_len_t size, bool copy=true)
      {
         if (this->m_size >= size)
            return; // do nothing (the requested buffer size is available)

         size_t oldsize = this->m_size;
         this->m_size = size+1;
         char* newstr = new char[this->m_size];
         if (this->m_str && copy) {
            memcpy(newstr, this->m_str, (size_t)oldsize);
         }
         else {
            newstr[0] = 0;
         }

         delete[] this->m_str;
         this->m_str = newstr;
      }

      /** Replace substrings with a given replacement string
       *
       * @return number of bytes written
       *
       * @version 0.3-1 (Marek Gagolewski, 2014-11-02)
       */
      int replaceAllAtPos(const char* str_cur_s, R_len_t str_cur_n,
         const char* replacement_cur_s, R_len_t replacement_cur_n,
         std::deque< std::pair<R_len_t, R_len_t> >& occurrences)
      {
         R_len_t buf_used = 0;
         R_len_t jlast = 0;

         std::deque< std::pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
         for (; iter != occurrences.end(); ++iter) {
            pair<R_len_t, R_len_t> match = *iter;
            memcpy(m_str+buf_used, str_cur_s+jlast, (size_t)(match.first-jlast));
            buf_used += match.first-jlast;
#ifndef NDEBUG
            if (buf_used > m_size)
               throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif

            jlast = match.second;
            memcpy(m_str+buf_used, replacement_cur_s, (size_t)(replacement_cur_n));
            buf_used += replacement_cur_n;
#ifndef NDEBUG
            if (buf_used > m_size)
               throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif
         }

         memcpy(m_str+buf_used, str_cur_s+jlast, (size_t)(str_cur_n-jlast));
         buf_used += (str_cur_n-jlast);
#ifndef NDEBUG
         if (buf_used > m_size)
            throw StriException("!NDEBUG: String8::replaceAllAtPos: buf_used > buf_size");
#endif

         return buf_used;
      }

};

#endif
