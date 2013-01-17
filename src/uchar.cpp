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



/** get char types for each code point UTF-8 string
 * @param s UTF-8 encoded string
 * @param n number of bytes
 * @param codes [OUT] the char types/codes; array of length >= n
 * @param ncodes [OUT] number of code points found
 */
void stri__uchar_charType(const char* s, int n, int* codes, int& ncodes)
{
   UChar32 c;
   ncodes=0;
   for (int i=0; i<n; ) {
      U8_NEXT(s, i, n, c);
      codes[ncodes++] =  u_charType(c);
   }
}


/** Get character types
 * @param s character vector
 * @return list of integer vectors
 * @TODO other encodings..................
 */
SEXP stri_chartype(SEXP s)
{
   s = stri_prepare_arg_string(s);
   R_len_t ns = LENGTH(s);
   if (ns <= 0) return R_NilValue;
   
   R_len_t bufsize = stri__numbytes_max(s);
   int* buf = 0;
   if (bufsize > 0) buf = new int[bufsize];
   
   SEXP ret;
   PROTECT(ret = allocVector(VECSXP, ns));
   for (R_len_t i=0; i<ns; ++i) {
      SEXP ns = STRING_ELT(s, i);
      if (ns == NA_STRING)
         SET_VECTOR_ELT(ret, i, ScalarInteger(NA_INTEGER)); // hmmmm..... integer(0)?
      else {
         R_len_t cns = LENGTH(ns);
         int ncodes;
         stri__uchar_charType(CHAR(ns), cns, buf, ncodes);
         SEXP codes;
         PROTECT(codes = allocVector(INTSXP, ncodes));
         int* int_codes = INTEGER(codes);
         for (int j=0; j<ncodes; ++j)
            int_codes[j] = buf[j];
         UNPROTECT(1);
         SET_VECTOR_ELT(ret, i, codes);
      }
   }
   if (buf) delete [] buf;
   UNPROTECT(1);
   return ret;
}


/** Get general character categories
 * Based on ICU4C/uchar.h
 * U_UNASSIGNED (id=0) is omitted
 * @return list of 3 vectors (integer, character, character)
 */
SEXP stri_charcategories()
{
   const R_len_t numcolumns = 3;
   const R_len_t numcategories = U_CHAR_CATEGORY_COUNT-1;
   SEXP vals;
   SEXP names;
   PROTECT(names = allocVector(STRSXP, numcolumns));
   SET_STRING_ELT(names, 0, mkChar("Identifier"));
   SET_STRING_ELT(names, 1, mkChar("CategoryFull"));
   SET_STRING_ELT(names, 2, mkChar("Category"));
   
   SEXP id;
   SEXP cat;
   SEXP cat2;
   PROTECT(id   = allocVector(INTSXP, numcategories));
   PROTECT(cat  = allocVector(STRSXP, numcategories));
   PROTECT(cat2 = allocVector(STRSXP, numcategories));
   
#define STRI_CHARCATEGORIES_CREATE(x, y, z) \
   INTEGER(id)[x-1] = x; \
   SET_STRING_ELT(cat,  x-1, mkChar(y)); \
   SET_STRING_ELT(cat2, x-1, mkChar(z)); \

  
//STRI_CHARCATEGORIES_CREATE( U_UNASSIGNED,             "UNASSIGNED",               "Cn" )
STRI_CHARCATEGORIES_CREATE( U_UPPERCASE_LETTER,       "UPPERCASE_LETTER",         "Lu" )
STRI_CHARCATEGORIES_CREATE( U_LOWERCASE_LETTER,       "LOWERCASE_LETTER",         "Ll" )
STRI_CHARCATEGORIES_CREATE( U_TITLECASE_LETTER,       "TITLECASE_LETTER",         "Lt" )
STRI_CHARCATEGORIES_CREATE( U_MODIFIER_LETTER,        "MODIFIER_LETTER",          "Lm" )
STRI_CHARCATEGORIES_CREATE( U_OTHER_LETTER,           "OTHER_LETTER",             "Lo" )
STRI_CHARCATEGORIES_CREATE( U_NON_SPACING_MARK,       "NON_SPACING_MARK",         "Mn" )        
STRI_CHARCATEGORIES_CREATE( U_ENCLOSING_MARK,         "ENCLOSING_MARK",           "Me" )
STRI_CHARCATEGORIES_CREATE( U_COMBINING_SPACING_MARK, "COMBINING_SPACING_MARK",   "Mc" )
STRI_CHARCATEGORIES_CREATE( U_DECIMAL_DIGIT_NUMBER,   "DECIMAL_DIGIT_NUMBER",     "Nd" )
STRI_CHARCATEGORIES_CREATE( U_LETTER_NUMBER,          "LETTER_NUMBER",            "Nl" )
STRI_CHARCATEGORIES_CREATE( U_OTHER_NUMBER,           "OTHER_NUMBER",             "No" )
STRI_CHARCATEGORIES_CREATE( U_SPACE_SEPARATOR,        "SPACE_SEPARATOR",          "Zs" )
STRI_CHARCATEGORIES_CREATE( U_LINE_SEPARATOR,         "LINE_SEPARATOR",           "Zl" )
STRI_CHARCATEGORIES_CREATE( U_PARAGRAPH_SEPARATOR,    "PARAGRAPH_SEPARATOR",      "Zp" )
STRI_CHARCATEGORIES_CREATE( U_CONTROL_CHAR,           "CONTROL_CHAR",             "Cc" )
STRI_CHARCATEGORIES_CREATE( U_FORMAT_CHAR,            "FORMAT_CHAR",              "Cf" )
STRI_CHARCATEGORIES_CREATE( U_PRIVATE_USE_CHAR,       "PRIVATE_USE_CHAR",         "Co" )
STRI_CHARCATEGORIES_CREATE( U_SURROGATE,              "SURROGATE",                "Cs" )
STRI_CHARCATEGORIES_CREATE( U_DASH_PUNCTUATION,       "DASH_PUNCTUATION",         "Pd" )
STRI_CHARCATEGORIES_CREATE( U_START_PUNCTUATION,      "START_PUNCTUATION",        "Ps" )
STRI_CHARCATEGORIES_CREATE( U_END_PUNCTUATION,        "END_PUNCTUATION",          "Pe" )
STRI_CHARCATEGORIES_CREATE( U_CONNECTOR_PUNCTUATION,  "CONNECTOR_PUNCTUATION",    "Pc" )
STRI_CHARCATEGORIES_CREATE( U_OTHER_PUNCTUATION,      "OTHER_PUNCTUATION",        "Po" )
STRI_CHARCATEGORIES_CREATE( U_MATH_SYMBOL,            "MATH_SYMBOL",              "Sm" )
STRI_CHARCATEGORIES_CREATE( U_CURRENCY_SYMBOL,        "CURRENCY_SYMBOL",          "Sc" )
STRI_CHARCATEGORIES_CREATE( U_MODIFIER_SYMBOL,        "MODIFIER_SYMBOL",          "Sk" )
STRI_CHARCATEGORIES_CREATE( U_OTHER_SYMBOL,           "OTHER_SYMBOL",             "So" )
STRI_CHARCATEGORIES_CREATE( U_INITIAL_PUNCTUATION,    "INITIAL_PUNCTUATION",      "Pi" )
STRI_CHARCATEGORIES_CREATE( U_FINAL_PUNCTUATION,      "FINAL_PUNCTUATION",        "Pf" )

   PROTECT(vals = allocVector(VECSXP, numcolumns));
   SET_VECTOR_ELT(vals, 0, id);
   SET_VECTOR_ELT(vals, 1, cat);
   SET_VECTOR_ELT(vals, 2, cat2);
   
   setAttrib(vals, R_NamesSymbol, names);
   UNPROTECT(5);
   return vals;
}


/** Get Unicode character General Category Mask
 *  @param x One- or two-letter category name, possibly preceeded with '^'
 *  @return integer mask
 */
SEXP stri_char_getcategoryid(SEXP x)
{
   x = stri_prepare_arg_string(x);
   if (LENGTH(x) == 0) error("please provide category name");
   else if (LENGTH(x) > 1) warning("only one name supported. taking first");
   SEXP xf = STRING_ELT(x, 0);
   if (xf == NA_STRING || LENGTH(xf) == 0 || LENGTH(xf) > 3)
      error("incorrect category name");
   
   // convert to upper-case
   const char* name_int = CHAR(xf);
   char* name = new char[LENGTH(xf)+1];
   strncpy(name, name_int, LENGTH(xf)+1);
   stri__asciiUpperCase(name);
   
   int cmpl = 0;
   if (name[0] == '^')
      cmpl = 1;  
   
   int id = STRI__UCHAR_NOTUSED_MASK;
   switch(name[cmpl]) {
      case 'C':
         switch (name[cmpl+1]) {
            case 'N':  id = U_GC_CN_MASK; break;
            case 'C':  id = U_GC_CC_MASK; break;
            case 'F':  id = U_GC_CF_MASK; break;
            case 'O':  id = U_GC_CO_MASK; break;
            case 'S':  id = U_GC_CS_MASK; break;
            case '\0': id = U_GC_C_MASK;  break;
         }
         break;
         
      case 'L':
         switch (name[cmpl+1]) {
            case 'U':  id = U_GC_LU_MASK; break;
            case 'L':  id = U_GC_LL_MASK; break;
            case 'T':  id = U_GC_LT_MASK; break;
            case 'M':  id = U_GC_LM_MASK; break;
            case 'O':  id = U_GC_LO_MASK; break;
            case 'C':  id = U_GC_LC_MASK; break;
            case '\0': id = U_GC_L_MASK;  break;
         }
         break;
         
      case 'M':
         switch (name[cmpl+1]) {
            case 'N':  id = U_GC_MN_MASK; break;
            case 'E':  id = U_GC_ME_MASK; break;
            case 'C':  id = U_GC_MC_MASK; break;
            case '\0': id = U_GC_M_MASK;  break;
         }
         break;
         
      case 'N':
         switch (name[cmpl+1]) {
            case 'D':  id = U_GC_ND_MASK; break;
            case 'L':  id = U_GC_NL_MASK; break;
            case 'O':  id = U_GC_NO_MASK; break;
            case '\0': id = U_GC_N_MASK;  break;
         }
         break;
         
      case 'P':
         switch (name[cmpl+1]) {
            case 'D':  id = U_GC_PD_MASK; break;
            case 'S':  id = U_GC_PS_MASK; break;
            case 'E':  id = U_GC_PE_MASK; break;
            case 'C':  id = U_GC_PC_MASK; break;
            case 'O':  id = U_GC_PO_MASK; break;
            case 'I':  id = U_GC_PI_MASK; break;
            case 'F':  id = U_GC_PF_MASK; break;
            case '\0': id = U_GC_P_MASK;  break;
         }
         break;
         
      case 'S':
         switch (name[cmpl+1]) {
            case 'M':  id = U_GC_SM_MASK; break;
            case 'C':  id = U_GC_SC_MASK; break;
            case 'K':  id = U_GC_SK_MASK; break;
            case 'O':  id = U_GC_SO_MASK; break;
            case '\0': id = U_GC_S_MASK;  break;
         }
         break;
         
      case 'Z':
         switch (name[cmpl+1]) {
            case 'S':  id = U_GC_ZS_MASK; break;
            case 'L':  id = U_GC_ZL_MASK; break;
            case 'P':  id = U_GC_ZP_MASK; break;
            case '\0': id = U_GC_Z_MASK;  break;
         }
         break;
   }
   
   delete[] name;
   
   if (id == STRI__UCHAR_NOTUSED_MASK)
      error("incorrect category name");  
   
#ifndef NDEBUG
   if ((id & STRI__UCHAR_COMPLEMENT_MASK) != 0) error("DEBUG: STRI__UCHAR_COMPLEMENT_MASK check failed");
#endif

   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, 2));
   if (!cmpl)
      STRI__UCHAR_CREATE_MATCHING_GCMASK(INTEGER(ret), id)
   else
      STRI__UCHAR_CREATE_COMPLEMENT_GCMASK(INTEGER(ret), id)

#ifndef NDEBUG
   if (!STRI__UCHAR_IS_ANY_GCMASK(INTEGER(ret)))
      error("DEBUG: STRI__UCHAR_IS_ANY_GCMASK check failed");
#endif
   UNPROTECT(1);

   return ret;
}


/**
 *  Get Unicode character binary property identifier
 *  @param Binary property name, possibly with preceeding '^'
 *  @return
 */
SEXP stri_char_getpropertyid(SEXP x)
{
   x = stri_prepare_arg_string(x);
   if (LENGTH(x) == 0) error("please provide property name");
   else if (LENGTH(x) > 1) warning("only one property supported. taking first");
   SEXP xf = STRING_ELT(x, 0);
   if (xf == NA_STRING)
      error("incorrect property name");
   
   // convert name to upper case
   const char* name_int = CHAR(xf);
   char* name = new char[LENGTH(xf)+1];
   strncpy(name, name_int, LENGTH(xf)+1);
   stri__asciiUpperCase(name);
   
   int cmpl = 0;
   if (name[0] == '^')
      cmpl = 1;
   int id = STRI__UCHAR_NOTUSED_MASK;

#define STRI__BINPROP_TEST(x, y) \
   if (!strcmp(name+cmpl, x)) id = y;

        STRI__BINPROP_TEST("ALPHABETIC", UCHAR_ALPHABETIC)
   else STRI__BINPROP_TEST("ASCII_HEX_DIGIT", UCHAR_ASCII_HEX_DIGIT)
   else STRI__BINPROP_TEST("BIDI_CONTROL", UCHAR_BIDI_CONTROL)
   else STRI__BINPROP_TEST("BIDI_MIRRORED", UCHAR_BIDI_MIRRORED)
   else STRI__BINPROP_TEST("DASH", UCHAR_DASH)
   else STRI__BINPROP_TEST("DEFAULT_IGNORABLE_CODE_POINT", UCHAR_DEFAULT_IGNORABLE_CODE_POINT)
   else STRI__BINPROP_TEST("DEPRECATED", UCHAR_DEPRECATED)
   else STRI__BINPROP_TEST("DIACRITIC", UCHAR_DIACRITIC)
   else STRI__BINPROP_TEST("EXTENDER", UCHAR_EXTENDER)
   else STRI__BINPROP_TEST("FULL_COMPOSITION_EXCLUSION", UCHAR_FULL_COMPOSITION_EXCLUSION)
   else STRI__BINPROP_TEST("GRAPHEME_BASE", UCHAR_GRAPHEME_BASE)
   else STRI__BINPROP_TEST("GRAPHEME_EXTEND", UCHAR_GRAPHEME_EXTEND)
   else STRI__BINPROP_TEST("GRAPHEME_LINK", UCHAR_GRAPHEME_LINK)
   else STRI__BINPROP_TEST("HEX_DIGIT", UCHAR_HEX_DIGIT)
   else STRI__BINPROP_TEST("HYPHEN", UCHAR_HYPHEN)
   else STRI__BINPROP_TEST("ID_CONTINUE", UCHAR_ID_CONTINUE)
   else STRI__BINPROP_TEST("ID_START", UCHAR_ID_START)
   else STRI__BINPROP_TEST("IDEOGRAPHIC", UCHAR_IDEOGRAPHIC)
   else STRI__BINPROP_TEST("IDS_BINARY_OPERATOR", UCHAR_IDS_BINARY_OPERATOR)
   else STRI__BINPROP_TEST("IDS_TRINARY_OPERATOR", UCHAR_IDS_TRINARY_OPERATOR)
   else STRI__BINPROP_TEST("JOIN_CONTROL", UCHAR_JOIN_CONTROL)
   else STRI__BINPROP_TEST("LOGICAL_ORDER_EXCEPTION", UCHAR_LOGICAL_ORDER_EXCEPTION)
   else STRI__BINPROP_TEST("LOWERCASE", UCHAR_LOWERCASE)
   else STRI__BINPROP_TEST("MATH", UCHAR_MATH)
   else STRI__BINPROP_TEST("NONCHARACTER_CODE_POINT", UCHAR_NONCHARACTER_CODE_POINT)
   else STRI__BINPROP_TEST("QUOTATION_MARK", UCHAR_QUOTATION_MARK)
   else STRI__BINPROP_TEST("RADICAL", UCHAR_RADICAL)
   else STRI__BINPROP_TEST("SOFT_DOTTED", UCHAR_SOFT_DOTTED)
   else STRI__BINPROP_TEST("TERMINAL_PUNCTUATION", UCHAR_TERMINAL_PUNCTUATION)
   else STRI__BINPROP_TEST("UNIFIED_IDEOGRAPH", UCHAR_UNIFIED_IDEOGRAPH)
   else STRI__BINPROP_TEST("UPPERCASE", UCHAR_UPPERCASE)
   else STRI__BINPROP_TEST("WHITE_SPACE", UCHAR_WHITE_SPACE)
   else STRI__BINPROP_TEST("XID_CONTINUE", UCHAR_XID_CONTINUE)
   else STRI__BINPROP_TEST("XID_START", UCHAR_XID_START)
   else STRI__BINPROP_TEST("CASE_SENSITIVE", UCHAR_CASE_SENSITIVE)
   else STRI__BINPROP_TEST("S_TERM", UCHAR_S_TERM)
   else STRI__BINPROP_TEST("VARIATION_SELECTOR", UCHAR_VARIATION_SELECTOR)
   else STRI__BINPROP_TEST("NFD_INERT", UCHAR_NFD_INERT)
   else STRI__BINPROP_TEST("NFKD_INERT", UCHAR_NFKD_INERT)
   else STRI__BINPROP_TEST("NFC_INERT", UCHAR_NFC_INERT)
   else STRI__BINPROP_TEST("NFKC_INERT", UCHAR_NFKC_INERT)
   else STRI__BINPROP_TEST("SEGMENT_STARTER", UCHAR_SEGMENT_STARTER)
   else STRI__BINPROP_TEST("PATTERN_SYNTAX", UCHAR_PATTERN_SYNTAX)
   else STRI__BINPROP_TEST("PATTERN_WHITE_SPACE", UCHAR_PATTERN_WHITE_SPACE)
   else STRI__BINPROP_TEST("POSIX_ALNUM", UCHAR_POSIX_ALNUM)
   else STRI__BINPROP_TEST("POSIX_BLANK", UCHAR_POSIX_BLANK)
   else STRI__BINPROP_TEST("POSIX_GRAPH", UCHAR_POSIX_GRAPH)
   else STRI__BINPROP_TEST("POSIX_PRINT", UCHAR_POSIX_PRINT)
   else STRI__BINPROP_TEST("POSIX_XDIGIT", UCHAR_POSIX_XDIGIT)
   else STRI__BINPROP_TEST("CASED", UCHAR_CASED)
   else STRI__BINPROP_TEST("CASE_IGNORABLE", UCHAR_CASE_IGNORABLE)
   else STRI__BINPROP_TEST("CHANGES_WHEN_LOWERCASED", UCHAR_CHANGES_WHEN_LOWERCASED)
   else STRI__BINPROP_TEST("CHANGES_WHEN_UPPERCASED", UCHAR_CHANGES_WHEN_UPPERCASED)
   else STRI__BINPROP_TEST("CHANGES_WHEN_TITLECASED", UCHAR_CHANGES_WHEN_TITLECASED)
   else STRI__BINPROP_TEST("CHANGES_WHEN_CASEFOLDED", UCHAR_CHANGES_WHEN_CASEFOLDED)
   else STRI__BINPROP_TEST("CHANGES_WHEN_CASEMAPPED", UCHAR_CHANGES_WHEN_CASEMAPPED)
   else STRI__BINPROP_TEST("CHANGES_WHEN_NFKC_CASEFOLDED", UCHAR_CHANGES_WHEN_NFKC_CASEFOLDED)
   
   delete [] name;
   if (id == STRI__UCHAR_NOTUSED_MASK)
      error("incorrect property name");  
   

#ifndef NDEBUG
   if ((id & STRI__UCHAR_COMPLEMENT_MASK) != 0) error("DEBUG: STRI__UCHAR_COMPLEMENT_MASK check failed");
#endif

   SEXP ret;
   PROTECT(ret = allocVector(INTSXP, 2));
   if (!cmpl)
      STRI__UCHAR_CREATE_MATCHING_BINPROP(INTEGER(ret), id)
   else
      STRI__UCHAR_CREATE_COMPLEMENT_BINPROP(INTEGER(ret), id)
#ifndef NDEBUG
   if (!STRI__UCHAR_IS_ANY_BINPROP(INTEGER(ret)))
      error("DEBUG: STRI__UCHAR_IS_ANY_BINPROP check failed");
#endif
   UNPROTECT(1);

   return ret;
}
