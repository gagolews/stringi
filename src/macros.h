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
 
#ifndef __macros_h
#define __macros_h


// taken from R's Defn.h - sorry, this is needed
// CHARSXP charset bits
#define BYTES_MASK (1<<1)
#define LATIN1_MASK (1<<2)
#define UTF8_MASK (1<<3)
#define ASCII_MASK (1<<6)
#define IS_BYTES(x) ((x)->sxpinfo.gp & BYTES_MASK)
#define IS_LATIN1(x) ((x)->sxpinfo.gp & LATIN1_MASK)
#define IS_ASCII(x) ((x)->sxpinfo.gp & ASCII_MASK)
#define IS_UTF8(x) ((x)->sxpinfo.gp & UTF8_MASK)
#define ENC_KNOWN(x) ((x)->sxpinfo.gp & (LATIN1_MASK | UTF8_MASK | ASCII_MASK))




// undef R's length macro (conflicts with std::string.length())
// use LENGTH instead
#undef length

/// Unicode replacement character
#define UCHAR_REPLACEMENT 0xFFFD
#define ASCII_SUBSTITUTE  0x1A


// uchar.cpp:
#define STRI__UCHAR_COMPLEMENT_MASK      0x40000000
#define STRI__UCHAR_NOTUSED_MASK         0xffffffff
#define STRI__UCHAR_CLASS_LENGTH         2

#define STRI__UCHAR_IS_ANY_BINPROP(x) \
   (((x)[0] == STRI__UCHAR_NOTUSED_MASK) && ((x)[1] != STRI__UCHAR_NOTUSED_MASK))
#define STRI__UCHAR_IS_MATCHING_BINPROP(x) \
   ((STRI__UCHAR_IS_ANY_BINPROP(x)) && (((x)[1] & (~STRI__UCHAR_COMPLEMENT_MASK)) == (x)[1]))
#define STRI__UCHAR_IS_COMPLEMENT_BINPROP(x) \
   ((STRI__UCHAR_IS_ANY_BINPROP(x)) && (((x)[1] & STRI__UCHAR_COMPLEMENT_MASK) == STRI__UCHAR_COMPLEMENT_MASK))
   
#define STRI__UCHAR_CREATE_MATCHING_BINPROP(x,c) \
   { (x)[0] = STRI__UCHAR_NOTUSED_MASK; (x)[1] = c; }
#define STRI__UCHAR_CREATE_COMPLEMENT_BINPROP(x,c) \
   { (x)[0] = STRI__UCHAR_NOTUSED_MASK; (x)[1] = (c | STRI__UCHAR_COMPLEMENT_MASK); }

#define STRI__UCHAR_GET_MATCHING_BINPROP(x)         ((x)[1])
#define STRI__UCHAR_GET_COMPLEMENT_BINPROP(x)       ((x)[1] & (~STRI__UCHAR_COMPLEMENT_MASK))


#define STRI__UCHAR_IS_ANY_GCMASK(x) \
   (((x)[1] == STRI__UCHAR_NOTUSED_MASK) && ((x)[0] != STRI__UCHAR_NOTUSED_MASK))
#define STRI__UCHAR_IS_MATCHING_GCMASK(x) \
   ((STRI__UCHAR_IS_ANY_GCMASK(x)) && (((x)[0] & (~STRI__UCHAR_COMPLEMENT_MASK)) == (x)[0]))
#define STRI__UCHAR_IS_COMPLEMENT_GCMASK(x) \
   ((STRI__UCHAR_IS_ANY_GCMASK(x)) && (((x)[0] & STRI__UCHAR_COMPLEMENT_MASK) == STRI__UCHAR_COMPLEMENT_MASK))
   
#define STRI__UCHAR_CREATE_MATCHING_GCMASK(x,c) \
   { (x)[1] = STRI__UCHAR_NOTUSED_MASK; (x)[0] = c; }
#define STRI__UCHAR_CREATE_COMPLEMENT_GCMASK(x,c) \
   { (x)[1] = STRI__UCHAR_NOTUSED_MASK; (x)[0] = (c | STRI__UCHAR_COMPLEMENT_MASK); }

#define STRI__UCHAR_GET_MATCHING_GCMASK(x)         ((x)[0])
#define STRI__UCHAR_GET_COMPLEMENT_GCMASK(x)       ((x)[0] & (~STRI__UCHAR_COMPLEMENT_MASK))

   

#endif
