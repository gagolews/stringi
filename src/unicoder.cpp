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
   //.....
}


StriContainerUTF16::StriContainerUTF16(StriContainerUTF16& container)
{
   //.....
}


StriContainerUTF16::~StriContainerUTF16()
{
   //.....
}


StriContainerUTF16& StriContainerUTF16::operator=(StriContainerUTF16& container)
{
   //.....
   return *this;
}


SEXP StriContainerUTF16::toR() const
{
   //.....
   return R_NilValue;
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

