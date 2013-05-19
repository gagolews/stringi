/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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
 
#ifndef __unicoder8_h
#define __unicoder8_h





/**
 * A class to handle conversion between R character vectors and UTF-8 string vectors
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) Improved performance for Native enc->UTF-8 (through u_strToUTF8)
 */
class StriContainerUTF8 : public StriContainerUTF_Base {

   private:
   
      String8** str;  ///< data - \code{string}s 
      
      
   public:
      
      StriContainerUTF8();
      StriContainerUTF8(SEXP rstr, R_len_t nrecycle, bool shallowrecycle=true);
      StriContainerUTF8(StriContainerUTF8& container);
      ~StriContainerUTF8();
      StriContainerUTF8& operator=(StriContainerUTF8& container);
      SEXP toR(R_len_t i) const;
      SEXP toR() const;

      
      
      /** get the vectorized ith element
       */
      const String8& get(int i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle) error("get: INDEX OUT OF BOUNDS");
#endif
         return (*(this->str[i%n]));
      }
      
      /** get the vectorized ith element
       */
/*      String8& getWritable(int i) {
#ifndef NDEBUG
         if (this->isShallow) error("getWritable: shallow StriContainerUTF8");
         if (n != nrecycle)   error("getWritable: n!=nrecycle");
         if (i < 0 || i >= n) error("getWritable: INDEX OUT OF BOUNDS");
#endif
         return (*(this->str[i%n]));
      }
  */
  
      /** set the vectorized ith element
       */
  /*    void set(int i, const std::string& s) {
#ifndef NDEBUG
         if (this->isShallow) error("set: shallow StriContainerUTF8");
         if (n != nrecycle)   error("set: n!=nrecycle");
         if (i < 0 || i >= n) error("set: INDEX OUT OF BOUNDS");
#endif
         *(this->str[i]) = s;
      } 
      */
};

#endif
