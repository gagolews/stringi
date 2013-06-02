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


const char* CharClass::binprop_names[] = { // sorted by binprop_names
         "ALPHABETIC", "ASCII_HEX_DIGIT", "BIDI_CONTROL", "BIDI_MIRRORED", 
         "CASE_IGNORABLE", "CASE_SENSITIVE", "CASED", "CHANGES_WHEN_CASEFOLDED", 
         "CHANGES_WHEN_CASEMAPPED", "CHANGES_WHEN_LOWERCASED", 
         "CHANGES_WHEN_NFKC_CASEFOLDED", "CHANGES_WHEN_TITLECASED", 
         "CHANGES_WHEN_UPPERCASED", "DASH", "DEFAULT_IGNORABLE_CODE_POINT", 
         "DEPRECATED", "DIACRITIC", "EXTENDER", "FULL_COMPOSITION_EXCLUSION", 
         "GRAPHEME_BASE", "GRAPHEME_EXTEND", "GRAPHEME_LINK", "HEX_DIGIT", 
         "HYPHEN", "ID_CONTINUE", "ID_START", "IDEOGRAPHIC", "IDS_BINARY_OPERATOR",
         "IDS_TRINARY_OPERATOR", "JOIN_CONTROL", "LOGICAL_ORDER_EXCEPTION", 
         "LOWERCASE", "MATH", "NFC_INERT", "NFD_INERT", "NFKC_INERT", "NFKD_INERT",
         "NONCHARACTER_CODE_POINT", "PATTERN_SYNTAX", "PATTERN_WHITE_SPACE", 
         "POSIX_ALNUM", "POSIX_BLANK", "POSIX_GRAPH", "POSIX_PRINT", "POSIX_XDIGIT",
         "QUOTATION_MARK", "RADICAL", "S_TERM", "SEGMENT_STARTER", "SOFT_DOTTED", 
         "TERMINAL_PUNCTUATION", "UNIFIED_IDEOGRAPH", "UPPERCASE", 
         "VARIATION_SELECTOR", "WHITE_SPACE", "XID_CONTINUE", "XID_START"
      };


const UProperty CharClass::binprop_code[] = { // sorted by binprop_names
         UCHAR_ALPHABETIC, UCHAR_ASCII_HEX_DIGIT, UCHAR_BIDI_CONTROL, 
         UCHAR_BIDI_MIRRORED, UCHAR_CASE_IGNORABLE, UCHAR_CASE_SENSITIVE, 
         UCHAR_CASED, UCHAR_CHANGES_WHEN_CASEFOLDED, UCHAR_CHANGES_WHEN_CASEMAPPED,
         UCHAR_CHANGES_WHEN_LOWERCASED, UCHAR_CHANGES_WHEN_NFKC_CASEFOLDED, 
         UCHAR_CHANGES_WHEN_TITLECASED, UCHAR_CHANGES_WHEN_UPPERCASED, 
         UCHAR_DASH, UCHAR_DEFAULT_IGNORABLE_CODE_POINT, UCHAR_DEPRECATED, 
         UCHAR_DIACRITIC, UCHAR_EXTENDER, UCHAR_FULL_COMPOSITION_EXCLUSION, 
         UCHAR_GRAPHEME_BASE, UCHAR_GRAPHEME_EXTEND, UCHAR_GRAPHEME_LINK, 
         UCHAR_HEX_DIGIT, UCHAR_HYPHEN, UCHAR_ID_CONTINUE, UCHAR_ID_START, 
         UCHAR_IDEOGRAPHIC, UCHAR_IDS_BINARY_OPERATOR, UCHAR_IDS_TRINARY_OPERATOR,
         UCHAR_JOIN_CONTROL, UCHAR_LOGICAL_ORDER_EXCEPTION, UCHAR_LOWERCASE, 
         UCHAR_MATH, UCHAR_NFC_INERT, UCHAR_NFD_INERT, UCHAR_NFKC_INERT, 
         UCHAR_NFKD_INERT, UCHAR_NONCHARACTER_CODE_POINT, UCHAR_PATTERN_SYNTAX,
         UCHAR_PATTERN_WHITE_SPACE, UCHAR_POSIX_ALNUM, UCHAR_POSIX_BLANK, 
         UCHAR_POSIX_GRAPH, UCHAR_POSIX_PRINT, UCHAR_POSIX_XDIGIT, 
         UCHAR_QUOTATION_MARK, UCHAR_RADICAL, UCHAR_S_TERM, 
         UCHAR_SEGMENT_STARTER, UCHAR_SOFT_DOTTED, UCHAR_TERMINAL_PUNCTUATION,
         UCHAR_UNIFIED_IDEOGRAPH, UCHAR_UPPERCASE, UCHAR_VARIATION_SELECTOR, 
         UCHAR_WHITE_SPACE, UCHAR_XID_CONTINUE, UCHAR_XID_START
      };
      
/** Get desired character class code from given name
 * 
 * @param charclass CHARSXP, can be NA
 */
CharClass::CharClass(SEXP charclass)
{
#ifndef NDEBUG
   if (TYPEOF(charclass) != CHARSXP)
      error(MSG__INCORRECT_INTERNAL_ARG);
#endif

   binprop = (UProperty)-1;
   gencat = (UCharCategory)-1;
   
   if (charclass == NA_STRING)
      return; // leave (-1, -1) == NA
   
   error("TO DO");
}



/** Test if a character falls into given charclass
 * 
 * @param c UTF-32 char code
 * @return TRUE, FALSE, or NA_LOGICAL
 */
int CharClass::test(UChar32 c)
{
   if (binprop != (UProperty)-1) {
         //UBool    u_hasBinaryProperty (UChar32 c, UProperty which)
      error("TO DO");
   }
   else if (gencat != (UCharCategory)-1) {
      //(U_GET_GC_MASK(chr) & mask) != 0
      error("TO DO");
   }
   else
      return NA_LOGICAL;
}
