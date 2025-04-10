/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 * BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#ifndef __stri_macros_h
#define __stri_macros_h


// undef R's length macro (conflicts with std::string.length())
// use LENGTH instead
#undef length


#define STRI__CONTINUE_ON_EMPTY_OR_NA_PATTERN(str_cont, pattern_cont, naset)                     \
      if ((str_cont).isNA(i) || (pattern_cont).isNA(i) || (pattern_cont).get(i).length() <= 0) { \
         naset;                                                                                  \
         continue;                                                                               \
      }                                                                                          \


#define STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont, naset, zeroset)        \
      if ((str_cont).isNA(i) || (pattern_cont).isNA(i) || (pattern_cont).get(i).length() <= 0) { \
         naset;                                                                                  \
         continue;                                                                               \
      }                                                                                          \
      else if ((str_cont).get(i).length() <= 0) {                                                \
         zeroset;                                                                                \
         continue;                                                                               \
      }                                                                                          \


#define STRI__GET_INT32_BE(input, index) \
   uint32_t(((uint8_t*)input)[index+0] << 24 | ((uint8_t*)input)[index+1] << 16 | ((uint8_t*)input)[index+2] << 8 | ((uint8_t*)input)[index+3])

#define STRI__GET_INT32_LE(input, index) \
   uint32_t(((uint8_t*)input)[index+3] << 24 | ((uint8_t*)input)[index+2] << 16 | ((uint8_t*)input)[index+1] << 8 | ((uint8_t*)input)[index+0])

#define STRI__GET_INT16_BE(input, index) \
   uint16_t(((uint8_t*)input)[index+0] << 8 | ((uint8_t*)input)[index+1])

#define STRI__GET_INT16_LE(input, index) \
   uint16_t(((uint8_t*)input)[index+1] << 8 | ((uint8_t*)input)[index+0])


#define STRI__ENC_HAS_BOM_UTF8(s, n)   \
   bool(n >= 3 &&                      \
   (uint8_t)(s[0]) == (uint8_t)0xEF && \
   (uint8_t)(s[1]) == (uint8_t)0xBB && \
   (uint8_t)(s[2]) == (uint8_t)0xBF)


#define STRI__ENC_HAS_BOM_UTF16LE(s, n)           \
   bool(n >= 2 &&                                 \
   (uint8_t)(s[0]) == (uint8_t)0xFF &&            \
   (uint8_t)(s[1]) == (uint8_t)0xFE &&            \
   (n < 4 || ((uint8_t)(s[2]) != (uint8_t)0x00 || \
              (uint8_t)(s[3]) != (uint8_t)0x00)))


#define STRI__ENC_HAS_BOM_UTF16BE(s, n) \
   bool(n >= 2 &&                       \
   (uint8_t)(s[0]) == (uint8_t)0xFE &&  \
   (uint8_t)(s[1]) == (uint8_t)0xFF)


#define STRI__ENC_HAS_BOM_UTF32BE(s, n) \
   bool(n >= 4 &&                       \
   (STRI__GET_INT32_BE(str_cur_s, 0) == 0x0000FEFFUL))


#define STRI__ENC_HAS_BOM_UTF32LE(s, n) \
   bool(n >= 4 &&                       \
   (STRI__GET_INT32_LE(str_cur_s, 0) == 0x0000FEFFUL))


/* ************************************************************************
 * based on R's Defn.h
 * CHARSXP charset bits
*/
#ifndef BYTES_MASK
#define BYTES_MASK (1<<1)
#endif

#ifndef LATIN1_MASK
#define LATIN1_MASK (1<<2)
#endif

#ifndef UTF8_MASK
#define UTF8_MASK (1<<3)
#endif

#ifndef ASCII_MASK
#define ASCII_MASK (1<<6)
#endif

#ifndef IS_BYTES
#define IS_BYTES(x) (Rf_getCharCE(x) == CE_BYTES)
// #define IS_BYTES(x) (LEVELS(x) & BYTES_MASK)
#endif

#ifndef IS_LATIN1
#define IS_LATIN1(x) (Rf_getCharCE(x) == CE_LATIN1)
// #define IS_LATIN1(x) (LEVELS(x) & LATIN1_MASK)
#endif

#ifndef IS_ASCII
// #define IS_ASCII(x) (Rf_getCharCE(x) == CE_ANY) /* the function doesn't return this value... */
    #if R_VERSION >= R_Version(4, 5, 0)
    #define IS_ASCII(x) Rf_charIsASCII(x)
    #else
    #define IS_ASCII(x) (LEVELS(x) & ASCII_MASK)
    #endif
#endif

#ifndef IS_UTF8
#define IS_UTF8(x) (Rf_getCharCE(x) == CE_UTF8)
// #define IS_UTF8(x) (LEVELS(x) & UTF8_MASK)
#endif

//#ifndef ENC_KNOWN
//#define ENC_KNOWN(x) (LEVELS(x) & (LATIN1_MASK | UTF8_MASK | ASCII_MASK))
//#endif

#ifndef isRaw
#define isRaw(x) (TYPEOF(x) == RAWSXP)
#endif

/* ************************************************************************ */

/* Unicode replacement character */
#define UCHAR_REPLACEMENT 0xFFFD

#define ASCII_SUBSTITUTE  0x1A
#define ASCII_MAXCHARCODE 127
#define UCHAR_REPLACEMENT_UTF8_BYTE1 0xef
#define UCHAR_REPLACEMENT_UTF8_BYTE2 0xbf
#define UCHAR_REPLACEMENT_UTF8_BYTE3 0xbd
#define UTF8_BOM_BYTE1 ((uint8_t)0xef)
#define UTF8_BOM_BYTE2 ((uint8_t)0xbb)
#define UTF8_BOM_BYTE3 ((uint8_t)0xbf)
#define ASCII_CR 0x0D
#define ASCII_LF 0x0A
#define ASCII_FF 0x0C
#define ASCII_VT 0x0B
#define UCHAR_NEL 0x0085
#define UCHAR_LS  0x2028
#define UCHAR_PS  0x2029

#define POW_2_31_M_1 2147483647

#endif
