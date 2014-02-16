/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#ifndef __stri_charclass_h
#define __stri_charclass_h





/**
 * Class for testing whether a character falls into a given character class
 * (i.e. has a given binary property or is in general unicode category).
 *
 * @version 0.1 (Marek Gagolewski, 2013-06-02)
 */
struct CharClass {

   private:

      UProperty     binprop;    ///< Unicode Binary Property, UCHAR_INVALID_CODE if not used
      UCharCategory gencat;     ///< Unicode General Category, U_CHAR_CATEGORY_COUNT if not used
      bool complement;          ///< Are we interested in the complement of a char class?


      static const char* binprop_names[];             ///< textual identifiers binary properties
      static const char* binprop_names_normalized[];  ///< normalized identifiers binary properties (only uppercase ascii)
      static const UProperty binprop_code[];          ///< corresponding codes for \code{binprop_names}
      static const R_len_t binprop_length;            ///< length of \code{binprop_*} arrays
      static const R_len_t binprop_maxchars;          ///< maximal number of characters in \code{binprop_*} arrays

   public:

      CharClass() {
         binprop = UCHAR_INVALID_CODE;
         gencat = U_CHAR_CATEGORY_COUNT;
         complement = false;
      }

      CharClass(SEXP charclass);

      inline bool isNA() {
         return (binprop == UCHAR_INVALID_CODE && gencat == U_CHAR_CATEGORY_COUNT );
      }

      int test(UChar32 c);



      static UCharCategory getGeneralCategoryFromName(const char* name, R_len_t n);
      static UProperty getBinaryPropertyFromName(const char* name, R_len_t n);
};

#endif
