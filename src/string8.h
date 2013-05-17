/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus
 * 
 * 'stringi' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * 'stringi' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.
 */
 
#ifndef __string8_h
#define __string8_h





/**
 * A class to represent an UTF-8 string,
 * quite similar to std::string
 * @version 0.1 (Marek Gagolewski)
 */
class String8  {

   private:
   
      char* str;  ///< character data in UTF-8
      R_len_t n;      ///< string length (in bytes), not including NUL
      bool memalloc; /// < should the memory be freed at the end
      
      
   public:
   
      /** default constructor
       * 
       * does nothing
       */
      String8() {
         this->str = NULL;
         this->n = 0;
         this->memalloc = false;
      }
   
      
      /** constructor
       * @param str character buffer
       * @param n buffer length (not including NUL)
       * @param memalloc should a deep copy of the buffer be done?
       */      
      String8(const char* str, R_len_t n, bool memalloc=false)
      {
         this->memalloc = memalloc;
         this->n = n;
         if (memalloc) {
//            cerr << "DEBUG: String8: memalloc!" << endl;
            this->str = new char[n+1];
            memcpy(this->str, str, n+1);
         }
         else {
            this->str = (char*)(str); // we know what we're doing
         }
      }
      
      /** destructor */
      ~String8()
      {
         if (this->str && this->memalloc)
            delete [] this->str;
      }
      
      /** copy constructor */
      String8(const String8& s)
      {
         this->memalloc = s.memalloc;
         this->n = s.n;
         if (s.memalloc) {
//            cerr << "DEBUG: String8: memalloc!" << endl;
            this->str = new char[s.n+1];
            memcpy(this->str, s.str, s.n+1);
         }
         else {
            this->str = s.str;
         }
      }
      
      /** copy */
      String8& operator=(const String8& s)
      {
         if (this->str && this->memalloc)
            delete [] this->str;
         
         this->memalloc = s.memalloc;
         this->n = s.n;
         if (s.memalloc) {
//            cerr << "DEBUG: String8: memalloc!" << endl;
            this->str = new char[s.n+1];
            memcpy(this->str, s.str, s.n+1);
         }
         else {
            this->str = s.str;
         }
         
         return *this;
      }
      
      /** return the char buffer */
      inline const char* c_str() const
      {
         return this->str;
      }
      
      /** string length in bytes */
      inline R_len_t length() const
      {
         return this->n;  
      }
      
      /** string length in bytes (alias for \code{length()}) */
      inline R_len_t size() const
      {
         return this->n;  
      }
      
};

#endif
