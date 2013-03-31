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
 
#ifndef __unicoder_h
#define __unicoder_h


enum StriEnc {
   STRI_ENC_UNDEFINED=0,
   STRI_ENC_ASCII,
   STRI_ENC_LATIN1,
   STRI_ENC_UTF8,
   STRI_ENC_NATIVE,
   STRI_ENC_BYTES,
   STRI_NA
};


/**
 * A class to handle conversion between R character vectors and UTF-16 string vectors
 * @version 0.1 (Marek Gagolewski)
 */
class StriContainerUTF16 {
   
   private:
      
      R_len_t n;            ///< number of strings 
      StriEnc* enc;         ///< original encoding of each string
      UnicodeString** str;  ///< data - \code{UnicodeString}s
      
      
      
   public:
      
      StriContainerUTF16();
      StriContainerUTF16(SEXP rstr);
      StriContainerUTF16(StriContainerUTF16& container);
      ~StriContainerUTF16();
      StriContainerUTF16& operator=(StriContainerUTF16& container);
      SEXP toR() const;
      inline R_len_t length() const { return this->n; }
      
      inline bool isNA(int i) const {
#ifndef NDEBUG
         if (i < 0 || i >= n) error("isNA: INDEX OUT OF BOUNDS");
#endif
         return (this->enc[i] == STRI_NA);
      }
      
      UnicodeString& get(int i) {
#ifndef NDEBUG
         if (i < 0 || i >= n) error("get: INDEX OUT OF BOUNDS");
#endif
         return (*(this->str[i]));
      }
};




//SEXP    stri__convertToUtf8(SEXP x, cetype_t& outenc);              // ...
//SEXP    stri__convertFromUtf8(SEXP x, cetype_t outenc);             // ...

#endif
