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
 
#ifndef __unicoder_base_h
#define __unicoder_base_h





/**
 * Base class for StriContainerUTF8 and StriContainerUTF16
 * @version 0.1 (Marek Gagolewski)
 */
class StriContainerUTF_Base {
   
   protected:
      
      R_len_t n;                 ///< number of strings (size of \code{enc} and \code{str})
      R_len_t nrecycle;          ///< number of strings for the recycle rule (can be > \code{n})
      StriEnc* enc;              ///< original encoding of each string
      UConverter* ucnvNative;    ///< recently used Native encoder
      UConverter* ucnvLatin1;    ///< recently used Latin1 encoder
      bool isShallow;            ///< have we made only shallow copy of the strings (=> read only)
#ifndef NDEBUG
      R_len_t debugMatcherIndex;  ///< used by vectorize_getMatcher (internally - check)
#endif

   StriContainerUTF_Base();
   StriContainerUTF_Base(StriContainerUTF_Base& container);
   ~StriContainerUTF_Base();



   public:
      StriContainerUTF_Base& operator=(StriContainerUTF_Base& container);
         
//      SEXP toR(R_len_t i) const = 0;
//      SEXP toR() const = 0;
//      inline R_len_t length() const { return this->n; }

      
      /** check if the vectorized ith element is NA
       */
      inline bool isNA(int i) const {
#ifndef NDEBUG
         if (i < 0 || i >= nrecycle) error("isNA: INDEX OUT OF BOUNDS");
#endif
         return (this->enc[i%n] == STRI_NA);
      }
      
      
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
