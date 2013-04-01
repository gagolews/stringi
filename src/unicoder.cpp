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
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
   this->isShallow = true;
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
   this->isShallow = shallowrecycle;
   this->lastMatcher = NULL;
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
   
#ifndef NDEBUG 
   if (this->n > n2) error("DEBUG: n>nrecycle");
#endif
   this->nrecycle = n2;
   
   if (this->n <= 0) {
      this->enc = NULL;
      this->str = NULL;
   }
   else {
      this->enc = new StriEnc[(this->isShallow)?this->n:this->nrecycle];
      this->str = new UnicodeString*[(this->isShallow)?this->n:this->nrecycle];
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
      if (!this->isShallow) {
         for (R_len_t i=this->n; i<this->nrecycle; ++i) {
            this->enc[i] = this->enc[i%this->n];
            if (this->enc[i] == STRI_NA)
               this->str[i] = NULL;
            else
               this->str[i] = new UnicodeString(*this->str[i%this->n]);
         }
         this->n = this->nrecycle;
      }
   }
}


StriContainerUTF16::StriContainerUTF16(StriContainerUTF16& container)
{
   this->n = container.n;
   this->nrecycle = container.nrecycle;
   this->isShallow = container.isShallow;
   this->lastMatcher = NULL;
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
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
   this->isShallow = container.isShallow;
   this->lastMatcher = NULL;
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
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


/** Export string
 */
SEXP StriContainerUTF16::toR(R_len_t i) const
{
   switch (this->enc[i]) {
      case STRI_NA:
         return NA_STRING;
         
      case STRI_ENC_ASCII:
      case STRI_ENC_UTF8: {
         std::string s;
         this->str[i]->toUTF8String(s);
         return mkCharLenCE(s.c_str(), s.length(), CE_UTF8);
      }
         
      case STRI_ENC_LATIN1:
         error(".... TO DO ....");
         break;
         
      case STRI_ENC_NATIVE:
         error(".... TO DO ....");
         break;
         
      default: // this shouldn't happen
         error(MSG__ENC_ERROR_SET);
   } 
   return mkChar("");
}
 
 

StriContainerUTF16::~StriContainerUTF16()
{
   if (this->lastMatcher)
      delete this->lastMatcher;
   if (this->ucnvNative)
      ucnv_close(this->ucnvNative);
   if (this->ucnvLatin1)
      ucnv_close(this->ucnvLatin1);

   if (this->n > 0) {
      for (int i=0; i<this->n; ++i) {
         if (this->str[i])
            delete this->str[i];
      }
      delete [] this->enc;  
      delete [] this->str;
   }

   this->enc = NULL;
   this->str = NULL;
   this->lastMatcher = NULL;
   this->n = 0;
   this->nrecycle = 0;
   this->ucnvNative = NULL;
   this->ucnvLatin1 = NULL;
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
#ifndef NDEBUG
      if ((this->debugMatcherIndex % this->n) != (i % this->n))
         error("DEBUG: vectorize_getMatcher - matcher reuse failed!");
      //         cerr << "Matcher reuse" << endl; // tmp, test only
#endif
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
#ifndef NDEBUG
   this->debugMatcherIndex = (i % this->n);
#endif

   return lastMatcher;
}
