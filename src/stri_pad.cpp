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
#include "stri_container_utf8.h"
#include "stri_container_integer.h"
#include "stri_string8buf.h"
#include <cstring>
#include <vector>


/**
 * Pad a string
 *
 * vectorized over str, length and pad
 * if str or pad or length is NA the result will be NA
 *
 * @param str character vector
 * @param min_length integer vector
 * @param side [internal int]
 * @param pad character vector
 * @return character vector
 *
 * @version 0.1-?? (Bartlomiej Tartanus)
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-20)
 *          use stri_error_handler, pad should be a single code point, not byte
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
*/
SEXP stri_pad(SEXP str, SEXP min_length, SEXP side, SEXP pad)
{
   // this is an internal arg, check manually, error() allowed here
   if (!Rf_isInteger(side) || LENGTH(side) != 1)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG);
   int _side = INTEGER(side)[0];
   if (_side < 0 || _side > 2)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG);

   PROTECT(str        = stri_prepare_arg_string(str, "str"));
   PROTECT(min_length = stri_prepare_arg_integer(min_length, "min_length"));
   PROTECT(pad        = stri_prepare_arg_string(pad, "pad"));

//   side       = stri_prepare_arg_string(side, "side");
//   const char* side_opts[] = {"left", "right", "both", NULL};

   R_len_t str_length     = LENGTH(str);
   R_len_t length_length  = LENGTH(min_length);
//   R_len_t side_length    = LENGTH(side);
   R_len_t pad_length     = LENGTH(pad);

   R_len_t vectorize_length = stri__recycling_rule(true, 3,
      str_length, length_length, /*side_length, */ pad_length);

   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerUTF8       str_cont(str, vectorize_length);
   StriContainerInteger length_cont(min_length, vectorize_length);
//   StriContainerUTF8      side_cont(side, vectorize_length);
   StriContainerUTF8       pad_cont(pad, vectorize_length);

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

   String8buf buf(0); // TODO: prealloc
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (str_cont.isNA(i) || pad_cont.isNA(i)
          || /*side_cont.isNA(i) ||*/ length_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      // get the current string
      R_len_t str_cur_n = str_cont.get(i).length();
      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_len = str_cont.get(i).countCodePoints();

      // get the padding code point
      UChar32 pad_cur = 0;
      R_len_t pad_cur_n = pad_cont.get(i).length();
      const char* pad_cur_s = pad_cont.get(i).c_str();
      R_len_t k = 0;
      U8_NEXT(pad_cur_s, k, pad_cur_n, pad_cur);
      if (pad_cur <= 0 || k < pad_cur_n)
         throw StriException(MSG__NOT_EQ_N_CODEPOINTS, "pad", 1);

      // get the minimal length
      R_len_t length_cur = length_cont.get(i);


      if (str_cur_len >= length_cur)  {
         // no padding at all
         SET_STRING_ELT(ret, i, str_cont.toR(i));
         continue;
      }

      R_len_t padnum = length_cur-str_cur_len;
      buf.resize(str_cur_n+padnum*pad_cur_n, false);

      char* buftmp = buf.data();
      switch(_side) {

         case 0: // left
            for (k=0; k<padnum; ++k) {
               memcpy(buftmp, pad_cur_s, pad_cur_n);
               buftmp += pad_cur_n;
            }
            memcpy(buftmp, str_cur_s, str_cur_n);
            buftmp += str_cur_n;
            break;

         case 1: // right
            memcpy(buftmp, str_cur_s, str_cur_n);
            buftmp += str_cur_n;
            for (k=0; k<padnum; ++k) {
               memcpy(buftmp, pad_cur_s, pad_cur_n);
               buftmp += pad_cur_n;
            }
            break;

         case 2: // both
            for (k=0; k<padnum/2; ++k) {
               memcpy(buftmp, pad_cur_s, pad_cur_n);
               buftmp += pad_cur_n;
            }
            memcpy(buftmp, str_cur_s, str_cur_n);
            buftmp += str_cur_n;
            for (; k<padnum; ++k) {
               memcpy(buftmp, pad_cur_s, pad_cur_n);
               buftmp += pad_cur_n;
            }
            break;
      }

      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), (int)(buftmp-buf.data()), CE_UTF8));
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


// // Second version by BT: uses StriContainerUTF16 & ICU's padLeading
//{
//   str    = stri_prepare_arg_string(str, "str"); // prepare string argument
//   length = stri_prepare_arg_integer(length, "length");
//   pad    = stri_prepare_arg_string(pad, "pad");
//
//   R_len_t vectorize_length = stri__recycling_rule(true, 3, LENGTH(str), LENGTH(length), LENGTH(pad));
//
//   SEXP ret;
//   PROTECT(ret = allocVector(STRSXP, vectorize_length));
//
//   STRI__ERROR_HANDLER_BEGIN
//   StriContainerUTF16 str_cont(str, vectorize_length, false);
//   StriContainerUTF16 pad_cont(pad, vectorize_length);
//   StriContainerInteger length_cont(length, vectorize_length);
//
//   for (R_len_t i = 0; i < vectorize_length; i++)
//   {
//      if (pad_cont.isNA(i) || str_cont.isNA(i) || length_cont.isNA(i)) {
//         SET_STRING_ELT(ret, i, NA_STRING);
//         continue;
//      }
//
//      if (pad_cont.get(i).length() > 0) {
//         UChar cur_pad = (pad_cont.get(i))[0]; // This is Uchar - 16 bit.....
//         str_cont.getWritable(i).padLeading(length_cont.get(i), cur_pad);
//      }
//
//      SET_STRING_ELT(ret, i, str_cont.toR(i));
//   }
//
//   UNPROTECT(1);
//   return ret;
//   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
//}
