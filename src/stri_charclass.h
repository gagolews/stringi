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


#ifndef __stri_charclass_h
#define __stri_charclass_h





/**
 * Class for testing whether a character falls into a given character class
 * (i.e. has a given binary property or is in general unicode category).
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-02)
 * @version 0.1-24 (Marek Gagolewski, 2014-03-11) gcmask is now uint32_t, not UCharCategory
 */
struct CharClass {

   private:

      static const UProperty NA_binprop;
      static const uint32_t NA_gcmask;

      UProperty binprop;    ///< Unicode Binary Property, NA_binprop if not used
      uint32_t  gcmask;     ///< Unicode General Category mask, NA_gcmask if not used
      bool complement;      ///< Are we interested in the complement of a char class?


      static const char* binprop_names[];             ///< textual identifiers binary properties
      static const char* binprop_names_normalized[];  ///< normalized identifiers binary properties (only uppercase ascii)
      static const UProperty binprop_code[];          ///< corresponding codes for \code{binprop_names}
      static const R_len_t binprop_length;            ///< length of \code{binprop_*} arrays
      static const R_len_t binprop_maxchars;          ///< maximal number of characters in \code{binprop_*} arrays

   public:

      CharClass() {
         binprop = NA_binprop;
         gcmask = NA_gcmask;
         complement = false;
      }

      CharClass(SEXP charclass);

      inline bool isNA() {
         return (binprop == NA_binprop && gcmask == NA_gcmask );
      }

      int test(UChar32 c);



      static uint32_t  getGeneralCategoryMaskFromName(const char* name, R_len_t n);
      static UProperty getBinaryPropertyFromName(const char* name, R_len_t n);
};

#endif
