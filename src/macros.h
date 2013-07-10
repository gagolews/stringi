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



// undef R's length macro (conflicts with std::string.length())
// use LENGTH instead
#undef length


#define STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont, naset, zeroset)        \
      if ((str_cont).isNA(i) || (pattern_cont).isNA(i) || (pattern_cont).get(i).length() <= 0) { \
         if (!(pattern_cont).isNA(i) && (pattern_cont).get(i).length() <= 0)                     \
            Rf_warning(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);                                   \
         naset;                                                                                  \
         continue;                                                                               \
      }                                                                                          \
      else if ((str_cont).get(i).length() <= 0) {                                                \
         zeroset;                                                                                \
         continue;                                                                               \
      }                                                                                          \




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

#define isRaw(x) (TYPEOF(x) == RAWSXP)

/**
 * ...
 */
enum StriEnc {
   STRI_ENC_UNDEFINED=0,
   STRI_ENC_ASCII,
   STRI_ENC_LATIN1,
   STRI_ENC_UTF8,
   STRI_ENC_NATIVE,
   STRI_ENC_BYTES,
   STRI_NA
};


/**
 * ...
 */
enum StriNormalizationForm {
   STRI_NFC = 10,
   STRI_NFD = 20,
   STRI_NFKC = 11,
   STRI_NFKD = 21,
   STRI_NFKC_CASEFOLD = 12
};



/// Unicode replacement character
#define UCHAR_REPLACEMENT 0xFFFD
#define ASCII_SUBSTITUTE  0x1A
#define ASCII_MAXCHARCODE 127
#define UCHAR_REPLACEMENT_UTF8_BYTE1 0xef
#define UCHAR_REPLACEMENT_UTF8_BYTE2 0xbf
#define UCHAR_REPLACEMENT_UTF8_BYTE3 0xbd


#endif
