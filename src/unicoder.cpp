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




StriContainerUTF16::StriContainerUTF16(SEXP rstr)
{
#ifndef NDEBUG 
   if (!isString(rstr))
      error("DEBUG: !isString in StriContainerUTF16::StriContainerUTF16(SEXP rstr)");
#endif
   R_len_t nr = LENGTH(rstr);
   if (nr <= 0) {
      this->enc = NULL;
      this->str = NULL;
   }
   else {
      this->enc = new StriEnc[n];
      this->str = new UnicodeString[n];
      for (R_len_t i=0; i<n; ++i) {
         SEXP curs = STRING_ELT(rstr, i);
         if (curs == NA_STRING) {
            this->enc[i] = STRI_NA; 
            // this->str[i] = >>LEAVE EMPTY<<
         }
         else {
            if (IS_ASCII(curs)) {
               this->str[i] = UnicodeString::fromUTF8(CHAR(curs));
               this->enc[i] = STRI_ENC_ASCII; 
            }
            else if (IS_UTF8(curs)) {
               this->str[i] = UnicodeString::fromUTF8(CHAR(curs));
               this->enc[i] = STRI_ENC_UTF8; 
            }
            else if (IS_LATIN1(curs)) {
               error(".... TO DO ....");
//               this->str[i] = UnicodeString::fromUTF8(CHAR(curs));
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
//               this->str[i] = UnicodeString::fromUTF8(CHAR(curs));
               this->enc[i] = STRI_ENC_NATIVE; 
            }
         }
      }      
   }
}


StriContainerUTF16::StriContainerUTF16(StriContainerUTF16& container)
{
   this->n = container.n;
   if (n > 0) {
      this->enc = new StriEnc[n];
      this->str = new UnicodeString[n];
      for (int i=0; i<this->n; ++i) {
         this->enc[i] = container.enc[i];
         this->str[i] = container.str[i];
      }
   }
   else {
      this->enc = NULL;
      this->str = NULL;
   }
}


StriContainerUTF16::~StriContainerUTF16()
{
   if (n > 0) {
      delete [] this->enc;  
      delete [] this->str;
   }
}


StriContainerUTF16& StriContainerUTF16::operator=(StriContainerUTF16& container)
{
   this->n = container.n;
   if (n > 0) {
      this->enc = new StriEnc[n];
      this->str = new UnicodeString[n];
      for (int i=0; i<this->n; ++i) {
         this->enc[i] = container.enc[i];
         this->str[i] = container.str[i];
      }
   }
   else {
      this->enc = NULL;
      this->str = NULL;
   }
   return *this;
}


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
 
 
///** Converts an R character vector with arbitrary encoding to UTF-8
// * 
// *  @param x character vector = CHARSXP (with marked encoding)
// *  @param outenc guide for stri__convertFromUtf8()
// *  @return CHARSXP (converted)
// * 
// * @version 0.1 (Marek Gagolewski)
// */
//SEXP stri__convertToUtf8(SEXP x, cetype_t& outenc)
//{
//      
//      
////   SEXP s1 = STRING_ELT(s, 0);
////   cerr << "B=" << IS_BYTES(s1) << endl;
////   cerr << "U=" << IS_UTF8(s1) << endl;
////   cerr << "L=" << IS_LATIN1(s1) << endl;
////   cerr << "A=" << IS_ASCII(s1) << endl;
////   cout << IS_UTF8(s1) << endl;
////   cout << IS_LATIN1(s1) << endl;
////   cout << IS_ASCII(s1) << endl;
////   cout << IS_BYTES(s1) << endl;
//   //ENC_KNOWN    (         x   )       ((x)->sxpinfo.gp & (LATIN1_MASK | UTF8_MASK))
////IS_UTF8    ( 	  	x	) 	   ((x)->sxpinfo.gp & UTF8_MASK)
////IS_LATIN1    ( 	  	x	) 	   ((x)->sxpinfo.gp & LATIN1_MASK)
////
//// IS_ASCII    ( 	  	x	) 	   ((x)->sxpinfo.gp & ASCII_MASK)
////  IS_BYTES    ( 	  	x	) 	   ((x)->sxpinfo.gp & BYTES_MASK)
//   
//////    CE_NATIVE = 0,
//////    CE_UTF8   = 1,
//////    CE_LATIN1 = 2,
//////    CE_BYTES  = 3,
//////    CE_SYMBOL = 5,
//////    CE_ANY
//
//// sepASCII = strIsASCII(csep);
////sepKnown = ENC_KNOWN(sep) > 0; # LATIN1 or UTF8
////sepUTF8 = IS_UTF8(sep);
////sepBytes = IS_BYTES(sep);
////
////Rboolean strIsASCII    ( 	const char *  	str	) 	
////
////ENC_KNOWN    ( 	  	x	) 	   ((x)->sxpinfo.gp & (LATIN1_MASK | UTF8_MASK))
////IS_UTF8    ( 	  	x	) 	   ((x)->sxpinfo.gp & UTF8_MASK)
////IS_LATIN1    ( 	  	x	) 	   ((x)->sxpinfo.gp & LATIN1_MASK)
////
//// IS_ASCII    ( 	  	x	) 	   ((x)->sxpinfo.gp & ASCII_MASK)
////  IS_BYTES    ( 	  	x	) 	   ((x)->sxpinfo.gp & BYTES_MASK)
//
////STRSXP - character vector
////TYPEOF(x) != CHARSXP
////mkCharLenCE    ( 	const char *  	name,
////		int  	len,
////		cetype_t  	enc 
////	) 	
//   
//   outenc = CE_UTF8; // tmp
//   return x; // tmp
//}
//
//
///** Converts an R character vector from UTF-8 to an encoding suggested by outenc
// * 
// *  @param x character vector = CHARSXP (with marked encoding)
// *  @param outenc guide from stri__convertToUtf8()
// *  @return CHARSXP (converted)
// * 
// * @version 0.1 (Marek Gagolewski)
// */
//SEXP stri__convertFromUtf8(SEXP x, cetype_t outenc)
//{
//   if (outenc == CE_UTF8)
//      return x;
//   else {
//      return x; // tmp  
//   }
//}

