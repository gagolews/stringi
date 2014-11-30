/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
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


#include "stri_stringi.h"


///** Get character types
// * @param s character vector
// * @return list of integer vectors
// * @TODO other encodings..................
// */
//SEXP stri_chartype(SEXP s)
//{
//   s = stri_prepare_arg_string(s, "str");
//   R_len_t ns = LENGTH(s);
//   if (ns <= 0) return R_NilValue;
//
//   R_len_t bufsize = stri__numbytes_max(s);
//   int* buf = 0;
//   if (bufsize > 0) buf = new int[bufsize]; // to do: use R_alloc
//
//   SEXP ret;
//   PROTECT(ret = allocVector(VECSXP, ns));
//   for (R_len_t i=0; i<ns; ++i) {
//      SEXP ns = STRING_ELT(s, i);
//      if (ns == NA_STRING)
//         SET_VECTOR_ELT(ret, i, ScalarInteger(NA_INTEGER)); // hmmmm..... integer(0)?
//      else {
//         R_len_t cns = LENGTH(ns);
//         int ncodes;
//         stri__uchar_charType(CHAR(ns), cns, buf, ncodes);
//         SEXP codes;
//         PROTECT(codes = allocVector(INTSXP, ncodes));
//         int* int_codes = INTEGER(codes);
//         for (int j=0; j<ncodes; ++j)
//            int_codes[j] = buf[j];
//         UNPROTECT(1);
//         SET_VECTOR_ELT(ret, i, codes);
//      }
//   }
//   if (buf) delete [] buf;
//   UNPROTECT(1);
//   return ret;
//}


///** Get general character categories
// * Based on ICU4C/uchar.h
// * U_UNASSIGNED (id=0) is omitted
// * @return list of 3 vectors (integer, character, character)
// */
//SEXP stri_charcategories()
//{
//   const R_len_t numcolumns = 3;
//   const R_len_t numcategories = U_CHAR_CATEGORY_COUNT-1;
//
//   SEXP id;
//   SEXP cat;
//   SEXP cat2;
//   PROTECT(id   = allocVector(INTSXP, numcategories));
//   PROTECT(cat  = allocVector(STRSXP, numcategories));
//   PROTECT(cat2 = allocVector(STRSXP, numcategories));
//
// #define STRI_CHARCATEGORIES_CREATE(x, y, z)
//   INTEGER(id)[x-1] = x;
//   SET_STRING_ELT(cat,  x-1, mkChar(y));
//   SET_STRING_ELT(cat2, x-1, mkChar(z));
//
//
////STRI_CHARCATEGORIES_CREATE( U_UNASSIGNED,             "UNASSIGNED",               "Cn" )
//STRI_CHARCATEGORIES_CREATE( U_UPPERCASE_LETTER,       "UPPERCASE_LETTER",         "Lu" )
//STRI_CHARCATEGORIES_CREATE( U_LOWERCASE_LETTER,       "LOWERCASE_LETTER",         "Ll" )
//STRI_CHARCATEGORIES_CREATE( U_TITLECASE_LETTER,       "TITLECASE_LETTER",         "Lt" )
//STRI_CHARCATEGORIES_CREATE( U_MODIFIER_LETTER,        "MODIFIER_LETTER",          "Lm" )
//STRI_CHARCATEGORIES_CREATE( U_OTHER_LETTER,           "OTHER_LETTER",             "Lo" )
//STRI_CHARCATEGORIES_CREATE( U_NON_SPACING_MARK,       "NON_SPACING_MARK",         "Mn" )
//STRI_CHARCATEGORIES_CREATE( U_ENCLOSING_MARK,         "ENCLOSING_MARK",           "Me" )
//STRI_CHARCATEGORIES_CREATE( U_COMBINING_SPACING_MARK, "COMBINING_SPACING_MARK",   "Mc" )
//STRI_CHARCATEGORIES_CREATE( U_DECIMAL_DIGIT_NUMBER,   "DECIMAL_DIGIT_NUMBER",     "Nd" )
//STRI_CHARCATEGORIES_CREATE( U_LETTER_NUMBER,          "LETTER_NUMBER",            "Nl" )
//STRI_CHARCATEGORIES_CREATE( U_OTHER_NUMBER,           "OTHER_NUMBER",             "No" )
//STRI_CHARCATEGORIES_CREATE( U_SPACE_SEPARATOR,        "SPACE_SEPARATOR",          "Zs" )
//STRI_CHARCATEGORIES_CREATE( U_LINE_SEPARATOR,         "LINE_SEPARATOR",           "Zl" )
//STRI_CHARCATEGORIES_CREATE( U_PARAGRAPH_SEPARATOR,    "PARAGRAPH_SEPARATOR",      "Zp" )
//STRI_CHARCATEGORIES_CREATE( U_CONTROL_CHAR,           "CONTROL_CHAR",             "Cc" )
//STRI_CHARCATEGORIES_CREATE( U_FORMAT_CHAR,            "FORMAT_CHAR",              "Cf" )
//STRI_CHARCATEGORIES_CREATE( U_PRIVATE_USE_CHAR,       "PRIVATE_USE_CHAR",         "Co" )
//STRI_CHARCATEGORIES_CREATE( U_SURROGATE,              "SURROGATE",                "Cs" )
//STRI_CHARCATEGORIES_CREATE( U_DASH_PUNCTUATION,       "DASH_PUNCTUATION",         "Pd" )
//STRI_CHARCATEGORIES_CREATE( U_START_PUNCTUATION,      "START_PUNCTUATION",        "Ps" )
//STRI_CHARCATEGORIES_CREATE( U_END_PUNCTUATION,        "END_PUNCTUATION",          "Pe" )
//STRI_CHARCATEGORIES_CREATE( U_CONNECTOR_PUNCTUATION,  "CONNECTOR_PUNCTUATION",    "Pc" )
//STRI_CHARCATEGORIES_CREATE( U_OTHER_PUNCTUATION,      "OTHER_PUNCTUATION",        "Po" )
//STRI_CHARCATEGORIES_CREATE( U_MATH_SYMBOL,            "MATH_SYMBOL",              "Sm" )
//STRI_CHARCATEGORIES_CREATE( U_CURRENCY_SYMBOL,        "CURRENCY_SYMBOL",          "Sc" )
//STRI_CHARCATEGORIES_CREATE( U_MODIFIER_SYMBOL,        "MODIFIER_SYMBOL",          "Sk" )
//STRI_CHARCATEGORIES_CREATE( U_OTHER_SYMBOL,           "OTHER_SYMBOL",             "So" )
//STRI_CHARCATEGORIES_CREATE( U_INITIAL_PUNCTUATION,    "INITIAL_PUNCTUATION",      "Pi" )
//STRI_CHARCATEGORIES_CREATE( U_FINAL_PUNCTUATION,      "FINAL_PUNCTUATION",        "Pf" )
//
//   SEXP vals;
//   PROTECT(vals = allocVector(VECSXP, numcolumns));
//   SET_VECTOR_ELT(vals, 0, id);
//   SET_VECTOR_ELT(vals, 1, cat);
//   SET_VECTOR_ELT(vals, 2, cat2);
//
//   stri__set_names(vals, numcolumns, "Identifier", "CategoryFull", "Category");
//   UNPROTECT(4);
//   return vals;
//}
