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
#include "stri_container_utf8_indexable.h"


/**
 *  Default constructor
 *
 *  @version 0.2-1 (2014-03-20)
 *           separated StriContainerUTF8_indexable class
 */
StriContainerUTF8_indexable::StriContainerUTF8_indexable()
   : StriContainerUTF8()
{
   last_ind_back_str = NULL;
   last_ind_fwd_str = NULL;
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param nrecycle extend length [vectorization]
 * @param shallowrecycle will \code{this->str} be ever modified?
 *
 *  @version 0.2-1 (2014-03-20)
 *           separated StriContainerUTF8_indexable class
 */
StriContainerUTF8_indexable::StriContainerUTF8_indexable(SEXP rstr, R_len_t _nrecycle, bool _shallowrecycle)
   : StriContainerUTF8(rstr, _nrecycle, _shallowrecycle)
{
   last_ind_back_str = NULL;
   last_ind_fwd_str = NULL;
}


/** Copy constructor
 *
 *  @version 0.2-1 (2014-03-20)
 *           separated StriContainerUTF8_indexable class
 */
StriContainerUTF8_indexable::StriContainerUTF8_indexable(StriContainerUTF8_indexable& container)
   :    StriContainerUTF8((StriContainerUTF8&)container)
{
   last_ind_back_str = NULL;
   last_ind_fwd_str = NULL;
}


/**  Copy/assignment operator
 *
 *  @version 0.2-1 (2014-03-20)
 *           separated StriContainerUTF8_indexable class
 */
StriContainerUTF8_indexable& StriContainerUTF8_indexable::operator=(StriContainerUTF8_indexable& container)
{
   ((StriContainerUTF8*)this)->~StriContainerUTF8();
   (StriContainerUTF8&) (*this) = (StriContainerUTF8&)container;

   last_ind_back_str = NULL;
   last_ind_fwd_str = NULL;

   return *this;
}


/** Convert BACKWARD UChar32-based index to UTF-8 based
 *
 * @param i string index (in container)
 * @param wh UChar32 character's position to look for,
 * counting starts from 0 == byte after last character in the i-th string
 * @return UTF-8 (byte) index
 *
 *
 * @version 0.1-?? (Bartek Tartanus)
 *          stri_sub
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          stri__UChar32_to_UTF8_index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-01)
 *          moved to StriContainerUTF8
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          moved to StriContainerUTF8_indexable
 */
R_len_t StriContainerUTF8_indexable::UChar32_to_UTF8_index_back(R_len_t i, R_len_t wh)
{
   R_len_t cur_n = get(i).length();
   const char* cur_s = get(i).c_str();

   if (wh <= 0) return cur_n;

#ifndef NDEBUG
   if (!cur_s)
      throw StriException("StriContainerUTF8::UChar32_to_UTF8_index_back: NULL cur_s");
#endif

   if (last_ind_back_str != cur_s) {
      // starting search in a different string
      last_ind_back_codepoint = 0;
      last_ind_back_utf8 = cur_n;
      last_ind_back_str = cur_s;
   }


   R_len_t j = 0;
   R_len_t jres = cur_n;

   if (last_ind_back_codepoint > 0) {
      if (wh < last_ind_back_codepoint) {
         // check if it makes sense to go towards the end of the string
         // or maybe it will be better to start from the end and move backwards
         if ((last_ind_back_codepoint-wh) < (wh-0)) {
            // less code points will be considered when going backwards
            j    = last_ind_back_codepoint;
            jres = last_ind_back_utf8;
            while (j > wh && jres < cur_n) {
               U8_FWD_1((const uint8_t*)cur_s, jres, cur_n);
               --j;
            }

            last_ind_back_codepoint = wh;
            last_ind_back_utf8 = jres;
            return jres; // stop right now
         }
         // else
      }
      else { //if (wh >= last_ind_back_codepoint)  // continue last search
         j    = last_ind_back_codepoint;
         jres = last_ind_back_utf8;
      }
   }

   // go backward
   while (j < wh && jres > 0) {
      U8_BACK_1((const uint8_t*)cur_s, 0, jres);
      ++j;
   }

   last_ind_back_codepoint = wh;
   last_ind_back_utf8 = jres;

   return jres;
}


/** Convert FORWARD UChar32-based index to UTF-8 based
 *
 * @param i string index (in container)
 * @param wh UChar32 character's position to look for,
 * counting starts from 0 == first character in i-th string
 * @return UTF-8 (byte) index
 *
 *
 * @version 0.1-?? (Bartek Tartanus)
 *          stri_sub
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          stri__UChar32_to_UTF8_index
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-01)
 *          moved to StriContainerUTF8
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          moved to StriContainerUTF8_indexable
 */
R_len_t StriContainerUTF8_indexable::UChar32_to_UTF8_index_fwd(R_len_t i, R_len_t wh)
{
   if (wh <= 0) return 0;

   R_len_t cur_n = get(i).length();
   const char* cur_s = get(i).c_str();

#ifndef NDEBUG
   if (!cur_s)
      throw StriException("StriContainerUTF8::UChar32_to_UTF8_index_fwd: NULL cur_s");
#endif


   if (last_ind_fwd_str != cur_s) {
      // starting search in a different string
      last_ind_fwd_codepoint = 0;
      last_ind_fwd_utf8 = 0;
      last_ind_fwd_str = cur_s;
   }

   R_len_t j = 0;
   R_len_t jres = 0;

   if (last_ind_fwd_codepoint > 0) {
      if (wh < last_ind_fwd_codepoint) {
         // check if it makes sense to go backwards from last position,
         // or it is better to start from scratch
         if ((last_ind_fwd_codepoint-wh) < (wh-0)) {
            // less code points will be considered when going backwards
            j    = last_ind_fwd_codepoint;
            jres = last_ind_fwd_utf8;
            while (j > wh && jres > 0) {
               U8_BACK_1((const uint8_t*)cur_s, 0, jres);
               --j;
            }

            last_ind_fwd_codepoint = wh;
            last_ind_fwd_utf8 = jres;
            return jres; // stop right now
         }
         // else
      }
      else { //if (wh >= last_ind_fwd_codepoint)  // continue last search
         j    = last_ind_fwd_codepoint;
         jres = last_ind_fwd_utf8;
      }
   }

   // go forward
   while (j < wh && jres < cur_n) {
      U8_FWD_1((const uint8_t*)cur_s, jres, cur_n);
      ++j;
   }

   last_ind_fwd_codepoint = wh;
   last_ind_fwd_utf8 = jres;
   return jres;
}


 /** Convert UTF8-byte indices to Unicode32 (code points)
 *
 * \code{i1} and \code{i2} must be sorted increasingly
 *
 * @param i element index
 * @param i1 indices, 1-based [in/out]
 * @param i2 indices, 1-based [in/out]
 * @param ni size of \code{i1} and \code{i2}
 * @param adj1 adjust for \code{i1}
 * @param adj2 adjust for \code{i2}
 *
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-20)
 *          moved to StriContainerUTF8_indexable
 */
void StriContainerUTF8_indexable::UTF8_to_UChar32_index(R_len_t i,
   int* i1, int* i2, const int ni, int adj1, int adj2)
{
   const char* cstr = get(i).c_str();
   const int nstr = get(i).length();

   int j1 = 0;
   int j2 = 0;

   int i8 = 0;
   int i32 = 0;
   while (i8 < nstr && (j1 < ni || j2 < ni)) {

      if (j1 < ni && i1[j1] <= i8) {
#ifndef NDEBUG
      if (j1 < ni-1 && i1[j1] >= i1[j1+1])
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index");
#endif
         i1[j1] = i32 + adj1;
         ++j1;
      }

      if (j2 < ni && i2[j2] <= i8) {
#ifndef NDEBUG
      if (j2 < ni-1 && i2[j2] >= i2[j2+1])
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index");
#endif
         i2[j2] = i32 + adj2;
         ++j2;
      }

      // Next UChar32
      U8_FWD_1(cstr, i8, nstr);
      ++i32;
   }

   // CONVERT LAST:
   if (j1 < ni && i1[j1] <= nstr) {
#ifndef NDEBUG
      if (j1 < ni-1 && i1[j1] >= i1[j1+1])
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index");
#endif
         i1[j1] = i32 + adj1;
         ++j1;
   }

   if (j2 < ni && i2[j2] <= nstr) {
#ifndef NDEBUG
      if (j2 < ni-1 && i2[j2] >= i2[j2+1])
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index");
#endif
         i2[j2] = i32 + adj2;
         ++j2;
   }

   // CHECK:
#ifndef NDEBUG
      if (i8 >= nstr && (j1 < ni || j2 < ni))
         throw StriException("DEBUG: stri__UTF8_to_UChar32_index()");
#endif
}
