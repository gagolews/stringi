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
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-02)
 */
CharClass::CharClass(SEXP charclass)
{
#ifndef NDEBUG
   if (TYPEOF(charclass) != CHARSXP)
      error(MSG__INCORRECT_INTERNAL_ARG);
#endif

   binprop = (UProperty)-1;
   gencat = (UCharCategory)-1;
   complement = false;
   
   if (charclass == NA_STRING)
      return; // leave (-1, -1) == NA
   
   R_len_t n = LENGTH(charclass);
   const char* name = CHAR(charclass);
   
   if (name[0] == '^') { // if n==0, then name[0] == '\0'
      complement = true;
      name++;
      n--;
   }

   if (n == 0) {
      warning(MSG__CHARCLASS_INCORRECT);
   }
   else if (n <= 2) { // it's possibly a general category
      gencat = CharClass::getGeneralCategoryFromName(name, n);
   }
   else { // it's possibly a binary property
      binprop = CharClass::getBinaryPropertyFromName(name, n);
   }
}


/**
 * Get unicode general category mask from name
 * 
 * @param name character string
 * @param n \code{name}'s length
 * @return general category mask
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-02)
 */
UCharCategory CharClass::getGeneralCategoryFromName(const char* name, R_len_t n)
{
   UCharCategory id = (UCharCategory)(-1);
   
   if (n >= 1 && n <= 2) {
      
      UChar32 name1_32 = u_toupper((UChar32)name[0]);
      UChar32 name2_32 = (name[1]!=0)?u_toupper((UChar32)name[1]):0;
      char name1 = (name1_32>127)?ASCII_SUBSTITUTE:(name1_32);
      char name2 = (name2_32>127)?ASCII_SUBSTITUTE:(name2_32);
   
      switch(name1) {
         case 'C':
            switch (name2) {
               case 'N':  id = (UCharCategory)U_GC_CN_MASK; break;
               case 'C':  id = (UCharCategory)U_GC_CC_MASK; break;
               case 'F':  id = (UCharCategory)U_GC_CF_MASK; break;
               case 'O':  id = (UCharCategory)U_GC_CO_MASK; break;
               case 'S':  id = (UCharCategory)U_GC_CS_MASK; break;
               case '\0': id = (UCharCategory)U_GC_C_MASK;  break;
            }
            break;
            
         case 'L':
            switch (name2) {
               case 'U':  id = (UCharCategory)U_GC_LU_MASK; break;
               case 'L':  id = (UCharCategory)U_GC_LL_MASK; break;
               case 'T':  id = (UCharCategory)U_GC_LT_MASK; break;
               case 'M':  id = (UCharCategory)U_GC_LM_MASK; break;
               case 'O':  id = (UCharCategory)U_GC_LO_MASK; break;
               case 'C':  id = (UCharCategory)U_GC_LC_MASK; break;
               case '\0': id = (UCharCategory)U_GC_L_MASK;  break;
            }
            break;
            
         case 'M':
            switch (name2) {
               case 'N':  id = (UCharCategory)U_GC_MN_MASK; break;
               case 'E':  id = (UCharCategory)U_GC_ME_MASK; break;
               case 'C':  id = (UCharCategory)U_GC_MC_MASK; break;
               case '\0': id = (UCharCategory)U_GC_M_MASK;  break;
            }
            break;
            
         case 'N':
            switch (name2) {
               case 'D':  id = (UCharCategory)U_GC_ND_MASK; break;
               case 'L':  id = (UCharCategory)U_GC_NL_MASK; break;
               case 'O':  id = (UCharCategory)U_GC_NO_MASK; break;
               case '\0': id = (UCharCategory)U_GC_N_MASK;  break;
            }
            break;
            
         case 'P':
            switch (name2) {
               case 'D':  id = (UCharCategory)U_GC_PD_MASK; break;
               case 'S':  id = (UCharCategory)U_GC_PS_MASK; break;
               case 'E':  id = (UCharCategory)U_GC_PE_MASK; break;
               case 'C':  id = (UCharCategory)U_GC_PC_MASK; break;
               case 'O':  id = (UCharCategory)U_GC_PO_MASK; break;
               case 'I':  id = (UCharCategory)U_GC_PI_MASK; break;
               case 'F':  id = (UCharCategory)U_GC_PF_MASK; break;
               case '\0': id = (UCharCategory)U_GC_P_MASK;  break;
            }
            break;
            
         case 'S':
            switch (name2) {
               case 'M':  id = (UCharCategory)U_GC_SM_MASK; break;
               case 'C':  id = (UCharCategory)U_GC_SC_MASK; break;
               case 'K':  id = (UCharCategory)U_GC_SK_MASK; break;
               case 'O':  id = (UCharCategory)U_GC_SO_MASK; break;
               case '\0': id = (UCharCategory)U_GC_S_MASK;  break;
            }
            break;
            
         case 'Z':
            switch (name2) {
               case 'S':  id = (UCharCategory)U_GC_ZS_MASK; break;
               case 'L':  id = (UCharCategory)U_GC_ZL_MASK; break;
               case 'P':  id = (UCharCategory)U_GC_ZP_MASK; break;
               case '\0': id = (UCharCategory)U_GC_Z_MASK;  break;
            }
            break;
      }
   }
   
   if (id == (UCharCategory)-1)
      warning(MSG__CHARCLASS_INCORRECT);
      
   return id;
}


/**
 * Get binary property code from name
 * 
 * @param name character string
 * @param n \code{name}'s length
 * @return general category mask
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-02)
 */
UProperty CharClass::getBinaryPropertyFromName(const char* name, R_len_t n)
{
   UProperty id = (UProperty)(-1);
   
   error("TO DO");
 
   if (id == (UProperty)-1)
      warning(MSG__CHARCLASS_INCORRECT);
      
   return id;
}



/** Test if a character falls into a given charclass
 * 
 * @param c UTF-32 char code
 * @return TRUE (1) or FALSE (0)
 * 
 * @version 0.1 (Marek Gagolewski, 2013-06-02)
 */
int CharClass::test(UChar32 c)
{
   if (binprop != (UProperty)-1) {
      int res = (u_hasBinaryProperty(c, binprop) != 0);
      if (complement) return !(res);
      else            return  (res);
   }
   else if (gencat != (UCharCategory)-1) {
      int res = ((U_GET_GC_MASK(c) & gencat) != 0);
      if (complement) return !(res);
      else            return  (res);
   }
   else
      return FALSE;
}
