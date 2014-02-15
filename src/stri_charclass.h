/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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
