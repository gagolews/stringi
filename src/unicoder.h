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


/**
 * ...
 */
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
 * @version 0.2 (Marek Gagolewski) - lastMatcher cache, supports auto-vectorization
 */
class StriContainerUTF16 {
   
   private:
      
      R_len_t n;            ///< number of strings (size of \code{enc} and \code{str})
      R_len_t nrecycle;     ///< number of strings for the recycle rule (can be > \code{n})
      StriEnc* enc;              ///< original encoding of each string
      UnicodeString** str;       ///< data - \code{UnicodeString}s 
      RegexMatcher* lastMatcher; ///< recently used \code{RegexMatcher}
      UConverter* ucnvNative;    ///< recently used Native encoder
      UConverter* ucnvLatin1;    ///< recently used Latin1 encoder
      bool isShallow;            ///< have we made only shallow copy of the strings (=> read only)
#ifndef NDEBUG
      R_len_t debugMatcherIndex;  ///< used by vectorize_getMatcher (internally - check)
#endif

   public:
      
      StriContainerUTF16();
      StriContainerUTF16(SEXP rstr, R_len_t nrecycle, bool shallowrecycle=true);
      StriContainerUTF16(StriContainerUTF16& container);
      ~StriContainerUTF16();
      StriContainerUTF16& operator=(StriContainerUTF16& container);
      SEXP toR(R_len_t i) const;
//      inline R_len_t length() const { return this->n; }

      
      /** check if the vectorized ith element is NA
       */
      inline bool isNA(int i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle) error("isNA: INDEX OUT OF BOUNDS");
#endif
         return (this->enc[i%n] == STRI_NA);
      }
      
      /** get the vectorized ith element
       */
      const UnicodeString& get(int i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle) error("get: INDEX OUT OF BOUNDS");
#endif
         return (*(this->str[i%n]));
      }
      
      /** set the vectorized ith element
       */
      void set(int i, const UnicodeString& s) const {
#ifndef NDEBUG
         if (this->isShallow) error("set: shallow StriContainerUTF16");
         if (n != nrecycle)   error("set: n!=nrecycle");
         if (i < 0 || i >= n) error("set: INDEX OUT OF BOUNDS");
#endif
         *(this->str[i]) = s;
      }
      
      RegexMatcher* vectorize_getMatcher(R_len_t i);
      
      /** Loop over vectorized container - init */
      inline R_len_t vectorize_init() const {
         if (this->n <= 0) return this->nrecycle;
         else return 0;
      }
      
      /** Loop over vectorized container - end iterator */
      inline R_len_t vectorize_end() const {
         return this->nrecycle;  
      }
      
      /** Loop over vectorized container - next iteration */
      inline R_len_t vectorize_next(R_len_t i) const {
         if (i == this->nrecycle-1) return this->nrecycle; // this is the end
         i = i + this->n;
         if (i >= this->nrecycle)
            return ((i+1) % this->nrecycle);  
         else
            return i;
      }
};

#endif
