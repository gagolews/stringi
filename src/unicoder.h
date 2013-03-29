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
   STRI_ENC_ASCII,
   STRI_ENC_LATIN1,
   STRI_ENC_UTF8,
   STRI_ENC_NATIVE,
   STRI_ENC_BYTES
};


/**
 * ...
 */
class StriContainerUTF16 {
   
   private:
      
      StriEnc enc;         ///< ...
      R_len_t n;           ///< ...
      UnicodeString* str;  ///< ...
      
      
      
   public:
      
      StriContainerUTF16(SEXP rstr);
      StriContainerUTF16(StriContainerUTF16& container);
      ~StriContainerUTF16();
      StriContainerUTF16& operator=(StriContainerUTF16& container);
      SEXP toR() const;
      inline R_len_t length() const { return this->n; }


};




//SEXP    stri__convertToUtf8(SEXP x, cetype_t& outenc);              // ...
//SEXP    stri__convertFromUtf8(SEXP x, cetype_t outenc);             // ...

#endif
