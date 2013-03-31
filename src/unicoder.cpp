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
 

#include "stringi.h"


/** 
 * Default constructor
 * 
 */
StriContainerUTF16::StriContainerUTF16()
{
   this->n = 0;
   this->nrecycle = 0;
   this->enc = NULL;
   this->str = NULL;
   this->lastMatcher = NULL;
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param nrecycle extend length [vectorization]
 * @param shallowrecycle will \code{this->str} be ever modified?
 */
StriContainerUTF16::StriContainerUTF16(SEXP rstr, R_len_t n2, bool shallowrecycle)
{
#ifndef NDEBUG 
   if (!isString(rstr))
      error("DEBUG: !isString in StriContainerUTF16::StriContainerUTF16(SEXP rstr)");
#endif
   this->n = LENGTH(rstr);
   this->lastMatcher = NULL;
   
#ifndef NDEBUG 
   if (this->n > n2) error("DEBUG: n>nrecycle");
#endif
   this->nrecycle = n2;
   
   if (!shallowrecycle) error("TO DO shallow!");
   
   if (this->n <= 0) {
      this->enc = NULL;
      this->str = NULL;
   }
   else {
      this->enc = new StriEnc[this->n];
      this->str = new UnicodeString*[this->n];
      for (R_len_t i=0; i<this->n; ++i) {
         SEXP curs = STRING_ELT(rstr, i);
         if (curs == NA_STRING) {
            this->enc[i] = STRI_NA; 
            this->str[i] = NULL;
         }
         else {
            if (IS_ASCII(curs)) {
               this->str[i] = new UnicodeString(UnicodeString::fromUTF8(CHAR(curs)));
               this->enc[i] = STRI_ENC_ASCII; 
            }
            else if (IS_UTF8(curs)) {
               this->str[i] = new UnicodeString(UnicodeString::fromUTF8(CHAR(curs)));
               this->enc[i] = STRI_ENC_UTF8; 
            }
            else if (IS_LATIN1(curs)) {
               error(".... TO DO ....");
               this->str[i] = NULL; // this->str[i] = new UnicodeString(UnicodeString::fromUTF8(CHAR(curs)))
               this->enc[i] = STRI_ENC_LATIN1; 
            }
            else if (IS_BYTES(curs)) 
               error(MSG__BYTESENC);
            else {
//             Any encoding - detection needed
//             Assume it's Native; this assumes the user working in an 8-bit environment
//             would convert strings to UTF-8 manually if needed - I think is's
//             a more reasonable approach (Native --> input via keyboard)
               error(".... TO DO ....");
               this->str[i] = NULL; // this->str[i] = new UnicodeString(UnicodeString::fromUTF8(CHAR(curs)))
               this->enc[i] = STRI_ENC_NATIVE; 
            }
         }
      }      
   }
}


StriContainerUTF16::StriContainerUTF16(StriContainerUTF16& container)
{
   this->n = container.n;
   this->nrecycle = container.nrecycle;
   this->lastMatcher = NULL;
   if (this->n > 0) {
      this->enc = new StriEnc[this->n];
      this->str = new UnicodeString*[this->n];
      for (int i=0; i<this->n; ++i) {
         this->enc[i] = container.enc[i];
         if (this->str[i])
            this->str[i] = new UnicodeString(*(container.str[i]));
         else
            this->str[i] = NULL;
      }
   }
   else {
      this->enc = NULL;
      this->str = NULL;
   }
}




StriContainerUTF16& StriContainerUTF16::operator=(StriContainerUTF16& container)
{
   this->n = container.n;
   this->nrecycle = container.nrecycle;
   this->lastMatcher = NULL;
   if (this->n > 0) {
      this->enc = new StriEnc[this->n];
      this->str = new UnicodeString*[this->n];
      for (int i=0; i<this->n; ++i) {
         this->enc[i] = container.enc[i];
         if (this->str[i])
            this->str[i] = new UnicodeString(*(container.str[i]));
         else
            this->str[i] = NULL;
      }
   }
   else {
      this->enc = NULL;
      this->str = NULL;
   }
   return *this;
}


/** Export contents of this container to R character vector
 *  The number of exported strings is equal to \code{n}, not \code{nrecycle}
 */
SEXP StriContainerUTF16::toR() const
{
   SEXP e;
   PROTECT(e = allocVector(STRSXP, this->n));
   for (R_len_t i=0; i<this->n; ++i) {
      switch (this->enc[i]) {
         case STRI_NA:
            SET_STRING_ELT(e, i, NA_STRING);
            break;
            
         case STRI_ENC_ASCII:
         case STRI_ENC_UTF8:
            error(".... TO DO ....");
            break;
            
         case STRI_ENC_LATIN1:
            error(".... TO DO ....");
            break;
            
         case STRI_ENC_NATIVE:
            error(".... TO DO ....");
            break;
            
         default: // this shouldn't happen
            error(MSG__ENC_ERROR_SET);
      }
   }   
   UNPROTECT(1);
   return e;
}
 
 

StriContainerUTF16::~StriContainerUTF16()
{
   if (this->n > 0) {
      for (int i=0; i<this->n; ++i) {
         if (this->str[i])
            delete this->str[i];
      }
      delete [] this->enc;  
      delete [] this->str;
   }
   if (this->lastMatcher)
      delete this->lastMatcher;
      
   this->enc = NULL;
   this->str = NULL;
   this->lastMatcher = NULL;
   this->n = 0;
   this->nrecycle = 0;
}



/** the returned matcher shall not be deleted by the user 
 * 
 * it is assumed that \code{vectorize_next()} is used:
 * for \code{i >= this->n} the last matcher is returned
 * 
 * @param i index
 */
RegexMatcher* StriContainerUTF16::vectorize_getMatcher(R_len_t i)
{
   if (this->lastMatcher) {
      if (i >= this->n) {
//         cerr << "Matcher reuse" << endl; // tmp, test only
         return lastMatcher; // reuse
      }
      else {
         delete this->lastMatcher;
         this->lastMatcher = NULL;
      }
   }
   
   UErrorCode status = U_ZERO_ERROR;
   this->lastMatcher = new RegexMatcher(this->get(i), 0, status);
   if (U_FAILURE(status)) {
      this->~StriContainerUTF16();
      error(u_errorName(status));
   }
   
   return lastMatcher;
}
