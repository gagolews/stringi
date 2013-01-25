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
 
 
#ifndef __rustring_h
#define __rustring_h


#include <unicode/uchar.h>
#include <unicode/utypes.h>
#include <unicode/ucnv.h>
#include <unicode/stringpiece.h>
#include <unicode/utf8.h>
#include <unicode/utf16.h>
#include <unicode/normalizer2.h>
#include <unicode/locid.h>
#include <unicode/uloc.h>


/** TODO: a class to represent a UTF-8 string
 *  Auto-convert natively-encoded STRSXPs 
 */
class RUstringUTF8 {
//   char* str;
//   R_len_t numbytes;
//   int enc_original;
};


/** TODO: a class to represent a UTF-16 string
 *  Auto-convert natively-encoded STRSXPs
 *  convert UTF16 char index to code point number
 */
class RUstringUTF16 {
//   UChar* str;
//   R_len_t numbytes;
//   int enc_original;
};

#endif
