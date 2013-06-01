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
StriContainerUTF8::StriContainerUTF8()
   : StriContainerUTF_Base()
{
   this->str = NULL;
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param nrecycle extend length [vectorization]
 * @param shallowrecycle will \code{this->str} be ever modified?
 */
StriContainerUTF8::StriContainerUTF8(SEXP rstr, R_len_t nrecycle, bool shallowrecycle)
{
   this->str = NULL;
#ifndef NDEBUG 
   if (!isString(rstr))
      error("DEBUG: !isString in StriContainerUTF8::StriContainerUTF8(SEXP rstr)");
#endif
   R_len_t nrstr = LENGTH(rstr);
   this->init_Base(nrstr, nrecycle, shallowrecycle); // calling LENGTH(rstr) fails on constructor call
   
   if (this->n > 0) {
      this->str = new String8*[this->n];
      for (R_len_t i=0; i<this->n; ++i)
         this->str[i] = NULL; // in case it fails during conversion (this is NA)
         
      UConverter* ucnvLatin1 = NULL;
      UConverter* ucnvNative = NULL;
      int bufsize = -1;
      char* buf = NULL;
         
      for (R_len_t i=0; i<nrstr; ++i) {
         SEXP curs = STRING_ELT(rstr, i);
         if (curs == NA_STRING) {
            continue; // keep NA
         }
         else {
            if (IS_ASCII(curs)) { // ASCII - ultra fast 
               this->str[i] = new String8(CHAR(curs), LENGTH(curs), !shallowrecycle);
            }
            else if (IS_UTF8(curs)) { // UTF-8 - ultra fast 
               this->str[i] = new String8(CHAR(curs), LENGTH(curs), !shallowrecycle);
            }
            else if (IS_BYTES(curs)) 
               error(MSG__BYTESENC);
            else {
//             LATIN1 ------- OR ------ Any encoding - detection needed  
//             Assume it's Native; this assumes the user working in an 8-bit environment
//             would convert strings to UTF-8 manually if needed - I think is's
//             a more reasonable approach (Native --> input via keyboard)


// version 0.1 - through UnicodeString & std::string
//               if (!ucnvNative) ucnvNative = stri__ucnv_open((char*)NULL);
//               UErrorCode status = U_ZERO_ERROR;
//               UnicodeString tmp(CHAR(curs), LENGTH(curs), ucnvNative, status);
//               if (U_FAILURE(status))
//                  error(MSG__ENC_ERROR_CONVERT); 
//               std::string tmp2;
//               tmp.toUTF8String(tmp2);
//               this->str[i] = new String8(tmp2.c_str(), tmp2.size(), true);
//               this->enc[i] = STRI_ENC_NATIVE; 

// version 0.2 - faster - through UnicodeString & u_strToUTF8
               UConverter* ucnvCurrent;
               if (IS_LATIN1(curs)) {
                  if (!ucnvLatin1) ucnvLatin1 = stri__ucnv_open("ISO-8859-1");
                  ucnvCurrent = ucnvLatin1;
               }
               else {
                  if (!ucnvNative) ucnvNative = stri__ucnv_open((char*)NULL);
                  ucnvCurrent = ucnvNative;
               }
               UErrorCode status = U_ZERO_ERROR;
               UnicodeString tmp(CHAR(curs), LENGTH(curs), ucnvCurrent, status);
               if (!U_SUCCESS(status))
                  error(MSG__ENC_ERROR_CONVERT);
               
               if (!buf) {
                  // calculate max string length
                  R_len_t maxlen = 0;
                  for (R_len_t z=i; z<nrstr; ++z) { // start from current string (this wasn't needed before)
                     SEXP tmps = STRING_ELT(rstr, z);
                     if ((tmps != NA_STRING) && (maxlen < LENGTH(tmps))) 
                        maxlen = LENGTH(tmps);
                  }
                  bufsize = maxlen*3+1; // 1 UChar -> max 3 UTF8 bytes
                  buf = new char[bufsize];
               }
               int realsize = 0;
               
               u_strToUTF8(buf, bufsize, &realsize,
               		tmp.getBuffer(), tmp.length(), &status);
               if (!U_SUCCESS(status))
                  error(MSG__ENC_ERROR_CONVERT);
                  
               this->str[i] = new String8(buf, realsize, true);
            }
         }
      }
      
      if (ucnvLatin1) ucnv_close(ucnvLatin1);
      if (ucnvNative) ucnv_close(ucnvNative);
      if (buf) delete [] buf;


      if (!shallowrecycle) {
         for (R_len_t i=nrstr; i<this->n; ++i) {
            if (this->str[i%nrstr] == NULL)
               this->str[i] = NULL;
            else
               this->str[i] = new String8(*this->str[i%nrstr]);
         }
      }
   }
}


StriContainerUTF8::StriContainerUTF8(StriContainerUTF8& container)
   :    StriContainerUTF_Base((StriContainerUTF_Base&)container)
{
   if (container.str) {
      this->str = new String8*[this->n];
      for (int i=0; i<this->n; ++i) {
         if (container.str[i])
            this->str[i] = new String8(*(container.str[i]));
         else
            this->str[i] = NULL;
      }
   }
   else {
      this->str = NULL;
   }
}




StriContainerUTF8& StriContainerUTF8::operator=(StriContainerUTF8& container)
{
   this->~StriContainerUTF8();
   (StriContainerUTF_Base&) (*this) = (StriContainerUTF_Base&)container;

   if (container.str) {
      this->str = new String8*[this->n];
      for (int i=0; i<this->n; ++i) {
         if (container.str[i])
            this->str[i] = new String8(*(container.str[i]));
         else
            this->str[i] = NULL;
      }
   }
   else {
      this->str = NULL;
   }
   return *this;
}



StriContainerUTF8::~StriContainerUTF8()
{
   if (str) {
      for (int i=0; i<n; ++i) {
         if (str[i])
            delete str[i];
      }
      delete [] str;
      str = NULL;
   }
}




/** Export character vector to R
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *  Recycle rule is applied, so length == nrecycle
 * @return STRSXP
 */
SEXP StriContainerUTF8::toR() const
{
   SEXP ret;   
   PROTECT(ret = allocVector(STRSXP, nrecycle));
   
   for (R_len_t i=0; i<nrecycle; ++i) {
      if (!str[i%n])
         SET_STRING_ELT(ret, i, NA_STRING);
      else {
         SET_STRING_ELT(ret, i,
            mkCharLenCE(str[i%n]->c_str(), str[i%n]->length(), CE_UTF8));
      }
   }
   
   UNPROTECT(1);
   return ret;
}



/** Export string to R
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *  @param i index [with recycle]
 * @return CHARSXP
 */
SEXP StriContainerUTF8::toR(R_len_t i) const
{
#ifndef NDEBUG
   if (i < 0 || i >= nrecycle) error("StriContainerUTF8::toR(): INDEX OUT OF BOUNDS");
#endif

   if (str[i%n] == NULL)
      return NA_STRING;
   else
      // This is already in UTF-8
      return mkCharLenCE(str[i%n]->c_str(), str[i%n]->length(), CE_UTF8);
}
 