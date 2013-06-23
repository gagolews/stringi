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
   : StriContainerBase()
{
   this->str = NULL;
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param nrecycle extend length [vectorization]
 * @param shallowrecycle will \code{this->str} be ever modified?
 */
StriContainerUTF16::StriContainerUTF16(SEXP rstr, R_len_t nrecycle, bool shallowrecycle)
{
   this->str = NULL;
#ifndef NDEBUG 
   if (!isString(rstr))
      error("DEBUG: !isString in StriContainerUTF16::StriContainerUTF16(SEXP rstr)"); // TO DO: throw StriException
#endif
   R_len_t nrstr = LENGTH(rstr);
   this->init_Base(nrstr, nrecycle, shallowrecycle); // calling LENGTH(rstr) fails on constructor call
   

   if (this->n > 0) {
      this->str = new UnicodeString*[this->n];
      for (R_len_t i=0; i<this->n; ++i)
         this->str[i] = NULL; // in case it fails during conversion (this is NA)
      
      UConverter* ucnvASCII = NULL;
//      UConverter* ucnvUTF8 = NULL;
      UConverter* ucnvLatin1 = NULL;
      UConverter* ucnvNative = NULL;

      for (R_len_t i=0; i<nrstr; ++i) {
         SEXP curs = STRING_ELT(rstr, i);
         if (curs == NA_STRING) {
            continue; // keep NA
         }
         else {
            if (IS_ASCII(curs)) {         
               if (!ucnvASCII) ucnvASCII = stri__ucnv_open("ASCII");      
               UErrorCode status = U_ZERO_ERROR;
               this->str[i] = new UnicodeString(CHAR(curs), LENGTH(curs),
                  ucnvASCII, status);
               if (U_FAILURE(status))
                  error(MSG__ENC_ERROR_CONVERT);   // TO DO: throw StriException
                  
               // Performance improvement attempt #1:
               // this->str[i] = new UnicodeString(UnicodeString::fromUTF8(CHAR(curs))); // slower than the above
               
               // Performance improvement attempt #2:
               // Create UChar buf with LENGTH(curs) items, fill it with (CHAR(curs)[i], 0x00), i=1,...
               // This wasn't faster tham the ucnvASCII approach.
            }
            else if (IS_UTF8(curs)) {
               // the above ASCII-approach (but with ucnvUTF8) is slower for UTF-8
               this->str[i] = new UnicodeString(UnicodeString::fromUTF8(CHAR(curs)));
            }
            else if (IS_LATIN1(curs)) {
               if (!ucnvLatin1) ucnvLatin1 = stri__ucnv_open("ISO-8859-1");
               UErrorCode status = U_ZERO_ERROR;
               this->str[i] = new UnicodeString(CHAR(curs), LENGTH(curs),
                  ucnvLatin1, status);
               if (U_FAILURE(status))
                  error(MSG__ENC_ERROR_CONVERT);   // TO DO: throw StriException
            }
            else if (IS_BYTES(curs)) 
               error(MSG__BYTESENC); // TO DO: throw StriException
            else {
//             Any encoding - detection needed
//             Assume it's Native; this assumes the user working in an 8-bit environment
//             would convert strings to UTF-8 manually if needed - I think is's
//             a more reasonable approach (Native --> input via keyboard)
               if (!ucnvNative) ucnvNative = stri__ucnv_open((char*)NULL);
               UErrorCode status = U_ZERO_ERROR;
               this->str[i] = new UnicodeString(CHAR(curs), LENGTH(curs),
                  ucnvNative, status);
               if (U_FAILURE(status))
                  error(MSG__ENC_ERROR_CONVERT);   // TO DO: throw StriException
            }
         }
      }
      
      if (ucnvASCII) ucnv_close(ucnvASCII);
//      if (ucnvUTF8)  ucnv_close(ucnvUTF8);
      if (ucnvLatin1) ucnv_close(ucnvLatin1);
      if (ucnvNative) ucnv_close(ucnvNative);
      
      if (!shallowrecycle) {
         for (R_len_t i=nrstr; i<this->n; ++i) {
            if (this->str[i%nrstr] == NULL)
               this->str[i] = NULL;
            else
               this->str[i] = new UnicodeString(*this->str[i%nrstr]);
         }
      }
   }
}



/** Copy constructor
 * 
 */
StriContainerUTF16::StriContainerUTF16(StriContainerUTF16& container)
   :    StriContainerBase((StriContainerBase&)container)
{
   if (container.str) {
      this->str = new UnicodeString*[this->n];
      for (int i=0; i<this->n; ++i) {
         if (container.str[i])
            this->str[i] = new UnicodeString(*(container.str[i]));
         else
            this->str[i] = NULL;
      }
   }
   else {
      this->str = NULL;
   }
}




StriContainerUTF16& StriContainerUTF16::operator=(StriContainerUTF16& container)
{
   this->~StriContainerUTF16();
   (StriContainerBase&) (*this) = (StriContainerBase&)container;
   
   if (container.str) {
      this->str = new UnicodeString*[this->n];
      for (int i=0; i<this->n; ++i) {
         if (container.str[i])
            this->str[i] = new UnicodeString(*(container.str[i]));
         else
            this->str[i] = NULL;
      }
   }
   else {
      this->str = NULL;
   }
   return *this;
}


/** Destructor
 * 
 */
StriContainerUTF16::~StriContainerUTF16()
{
   if (str) {
      for (int i=0; i<this->n; ++i) {
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
SEXP StriContainerUTF16::toR() const
{
   SEXP ret;   
   PROTECT(ret = allocVector(STRSXP, nrecycle));
   std::string buf;
   
   for (R_len_t i=0; i<nrecycle; ++i) {
      if (!str[i%n])
         SET_STRING_ELT(ret, i, NA_STRING);
      else {
         buf.clear();
         str[i%n]->toUTF8String(buf);
         SET_STRING_ELT(ret, i,
            mkCharLenCE(buf.c_str(), buf.length(), CE_UTF8));
      }
   }
   
   UNPROTECT(1);
   return ret;
}



/** Export string to R
 *  THE OUTPUT IS ALWAYS IN UTF-8
 *  @param i index [with recycle]
 *  @return CHARSXP
 */
SEXP StriContainerUTF16::toR(R_len_t i) const
{
#ifndef NDEBUG
   if (i < 0 || i >= nrecycle) error("StriContainerUTF16::toR(): INDEX OUT OF BOUNDS"); // TO DO: throw StriException
#endif

   if (str[i%n] == NULL)
      return NA_STRING;
   else {
      std::string s;
      str[i%n]->toUTF8String(s);
      return mkCharLenCE(s.c_str(), s.length(), CE_UTF8);
   }
}
 
 



/** Convert Unicode16-Char indices to Unicode32 (code points)
 *
 * \code{i1} and \code{i2} must be sorted increasingly
 * 
 * @param i element index
 * @param i1 indices, 1-based [in/out]
 * @param i2 indices, 1-based [in/out]
 * @param ni size of \code{i1} and \code{i2}
 * @param adj1 adjust for \code{i1}
 * @param adj2 adjust for \code{i2}
 * 
 */
void StriContainerUTF16::UChar16_to_UChar32_index(R_len_t i,
   int* i1, int* i2, const int ni, int adj1, int adj2)
{
   const UnicodeString* str_data = &(this->get(i));
   const UChar* str = str_data->getBuffer();
   const int nstr = str_data->length();
   
   int j1 = 0;
   int j2 = 0;
   
   int i16 = 0;
   int i32 = 0;
   while (i16 < nstr && (j1 < ni || j2 < ni)) {
      
//      cerr << i16 << " " << i32 << " " << j1 << " " << j2 << " " << ((j1 < ni)?i1[j1]:-1) << " " << ((j2 < ni)?i2[j2]:-1) << endl;
      
      if (j1 < ni && i1[j1] <= i16) {
#ifndef NDEBUG
      if (j1 < ni-1 && i1[j1] >= i1[j1+1])
         error("DEBUG: stri__UChar16_to_UChar32_index"); // TO DO: throw StriException
#endif
         i1[j1] = i32 + adj1;
         ++j1;
      }
      
      if (j2 < ni && i2[j2] <= i16) {
#ifndef NDEBUG
      if (j2 < ni-1 && i2[j2] >= i2[j2+1])
         error("DEBUG: stri__UChar16_to_UChar32_index"); // TO DO: throw StriException
#endif
         i2[j2] = i32 + adj2;
         ++j2;
      }
      
      // Next UChar32
      U16_FWD_1(str, i16, nstr);
      ++i32;
   }
   
   // CONVERT LAST:
   if (j1 < ni && i1[j1] <= nstr) {
#ifndef NDEBUG
      if (j1 < ni-1 && i1[j1] >= i1[j1+1])
         error("DEBUG: stri__UChar16_to_UChar32_index"); // TO DO: throw StriException
#endif
         i1[j1] = i32 + adj1;
         ++j1;
   }
  
   if (j2 < ni && i2[j2] <= nstr) {
#ifndef NDEBUG
      if (j2 < ni-1 && i2[j2] >= i2[j2+1])
         error("DEBUG: stri__UChar16_to_UChar32_index"); // TO DO: throw StriException
#endif
         i2[j2] = i32 + adj2;
         ++j2;
   }
   
   // CHECK:
#ifndef NDEBUG
      if (i16 >= nstr && (j1 < ni || j2 < ni))
         error("DEBUG: stri__UChar16_to_UChar32_index()"); // TO DO: throw StriException
#endif
}

