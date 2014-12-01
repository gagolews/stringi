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
#include "stri_container_utf16.h"
#include "stri_container_listraw.h"
#include "stri_container_listint.h"
#include "stri_string8buf.h"
#include "stri_ucnv.h"
#include <vector>


/** Convert from UTF-32
 *
 * @param vec integer vector or list with integer vectors
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-25)
 *          StriException friently;
 *          use StriContainerListInt
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_fromutf32(SEXP vec)
{
   PROTECT(vec = stri_prepare_arg_list_integer(vec, "vec"));

   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerListInt vec_cont(vec);
   R_len_t vec_n = vec_cont.get_n();

   // get required buf size
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<vec_n; ++i) {
      if (!vec_cont.isNA(i) && vec_cont.get(i).size() > bufsize)
         bufsize = vec_cont.get(i).size();
   }
   bufsize = U8_MAX_LENGTH*bufsize+1; // this will surely be sufficient
   String8buf buf(bufsize);
   char* bufdata = buf.data();

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vec_n));

   for (R_len_t i=0; i<vec_n; ++i) {
      if (vec_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      const int* cur_data = vec_cont.get(i).data();
      R_len_t    cur_n    = vec_cont.get(i).size();
      UChar32 c = (UChar32)0;
      R_len_t j = 0;
      R_len_t k = 0;
      UBool err = FALSE;
      while (!err && k < cur_n) {
         c = cur_data[k++];
         U8_APPEND((uint8_t*)bufdata, j, bufsize, c, err);

         // Rf_mkCharLenCE detects embedded nuls, but stops execution completely
         if (c == 0) err = TRUE;
      }

      if (err) {
         Rf_warning(MSG__INVALID_CODE_POINT, (int)c);
         SET_STRING_ELT(ret, i, NA_STRING);
      }
      else
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(bufdata, j, CE_UTF8));
   }

   STRI__UNPROTECT_ALL;
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/** Convert character vector to UTF-32
 *
 * @param str character vector
 * @return list with integer vectors
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-26)
 *          use vector<UChar32> buf instead of R_alloc;
 *          warn and set NULL on improper UTF-8 byte sequences
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-12)
 *          Use UChar32* instead of vector<UChar32> as ::data is C++11
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_toutf32(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   R_len_t n = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerUTF8 str_cont(str, n);

   R_len_t bufsize = 1; // to avoid allocating an empty buffer
   for (R_len_t i=0; i<n; ++i) {
      if (str_cont.isNA(i)) continue;
      R_len_t ni = str_cont.get(i).length();
      if (ni > bufsize) bufsize = ni;
   }

   UChar32* buf = (UChar32*)R_alloc((size_t)bufsize, (int)sizeof(UChar32)); // at most bufsize UChars32 (bufsize/4 min.)
   if (!buf) throw StriException(MSG__MEM_ALLOC_ERROR);
   // deque<UChar32> was slower than using a common, over-sized buf

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, n)); // all

   for (R_len_t i=0; i<n; ++i) {

      if (str_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, R_NilValue);
         continue;
      }

      UChar32 c = (UChar32)0;
      const char* s = str_cont.get(i).c_str();
      R_len_t sn = str_cont.get(i).length();
      R_len_t j = 0;
      R_len_t k = 0;
      while (c >= 0 && j < sn) {
         U8_NEXT(s, j, sn, c);
         buf[k++] = (int)c;
      }

      if (c < 0) {
         Rf_warning(MSG__INVALID_UTF8);
         SET_VECTOR_ELT(ret, i, R_NilValue);
         continue;
      }
      else {
         SEXP conv;
         STRI__PROTECT(conv = Rf_allocVector(INTSXP, k));
         memcpy(INTEGER(conv), buf, (size_t)sizeof(int)*k);
         SET_VECTOR_ELT(ret, i, conv);
         STRI__UNPROTECT(1);
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({ /* do nothing on error */ })
}


/** Convert character vector to UTF-8
 *
 * @param str character vector
 * @param is_unknown_8bit single logical value;
 * if TRUE, then in case of ENC_NATIVE or ENC_LATIN1, UTF-8
 * REPLACEMENT CHARACTERs (U+FFFD) are
 * put for codes > 127
 * @param validate single logical value (or NA)
 *
 * @return character vector
 *
 * @version 0.1-XX (Marek Gagolewski)
 *
 * @version 0.1-XX (Marek Gagolewski, 2013-06-16)
 *                  make StriException-friendly
 *
 * @version 0.2-1  (Marek Gagolewski, 2014-03-26)
 *                 Use one String8buf;
 *                 is_unknown_8bit_logical and UTF-8 tries now to remove BOMs
 *
 * @version 0.2-1  (Marek Gagolewksi, 2014-03-30)
 *                 added validate arg
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_toutf8(SEXP str, SEXP is_unknown_8bit, SEXP validate)
{
   PROTECT(validate = stri_prepare_arg_logical_1(validate, "validate"));
   bool is_unknown_8bit_logical =
      stri__prepare_arg_logical_1_notNA(is_unknown_8bit, "is_unknown_8bit");
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   R_len_t n = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN(2)
   SEXP ret;
   if (!is_unknown_8bit_logical) {
      // Trivial - everything we need is in StriContainerUTF8 :)
      // which removes BOMs silently
      StriContainerUTF8 str_cont(str, n);
      STRI__PROTECT(ret = str_cont.toR());
   }
   else {
      // get buf size
      R_len_t bufsize = 0;
      for (R_len_t i=0; i<n; ++i) {
         SEXP curs = STRING_ELT(str, i);
         if (curs == NA_STRING || IS_ASCII(curs) || IS_UTF8(curs))
            continue;

         R_len_t ni = LENGTH(curs);
         if (ni > bufsize) bufsize = ni;
      }
      String8buf buf(bufsize*3); // either 1 byte < 127 or U+FFFD == 3 bytes UTF-8
      char* bufdata = buf.data();

      STRI__PROTECT(ret = Rf_allocVector(STRSXP, n));
      for (R_len_t i=0; i<n; ++i) {
         SEXP curs = STRING_ELT(str, i);
         if (curs == NA_STRING) {
            SET_STRING_ELT(ret, i, NA_STRING);
            continue;
         }

         if (IS_ASCII(curs) || IS_UTF8(curs)) {
            R_len_t curs_n = LENGTH(curs);
            const char* curs_s = CHAR(curs);
            if (curs_n >= 3 &&
               (uint8_t)(curs_s[0]) == UTF8_BOM_BYTE1 &&
               (uint8_t)(curs_s[1]) == UTF8_BOM_BYTE2 &&
               (uint8_t)(curs_s[2]) == UTF8_BOM_BYTE3) {
               // has BOM - get rid of it
               SET_STRING_ELT(ret, i, Rf_mkCharLenCE(curs_s+3, curs_n-3, CE_UTF8));
            }
            else
               SET_STRING_ELT(ret, i, curs);

            continue;
         }

         // otherwise, we have an 8-bit encoding
         R_len_t curn = LENGTH(curs);
         const char* curs_tab = CHAR(curs);
         R_len_t k = 0;
         for (R_len_t j=0; j<curn; ++j) {
            if (U8_IS_SINGLE(curs_tab[j]))
               bufdata[k++] = curs_tab[j];
            else { // 0xEF 0xBF 0xBD
               bufdata[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE1;
               bufdata[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE2;
               bufdata[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE3;
            }
         }
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(bufdata, k, CE_UTF8));
      }

   }

   // validate utf8 byte stream
   if (LOGICAL(validate)[0] != FALSE) { // NA or TRUE
      R_len_t ret_n = LENGTH(ret);
      for (R_len_t i=0; i<ret_n; ++i) {
         SEXP curs = STRING_ELT(ret, i);
         if (curs == NA_STRING) continue;

         const char* s = CHAR(curs);
         R_len_t sn = LENGTH(curs);
         R_len_t j = 0;
         UChar32 c = 0;
         while (c >= 0 && j < sn) {
            U8_NEXT(s, j, sn, c);
         }

         if (c >= 0) continue; // valid, nothing to do

         if (LOGICAL(validate)[0] == NA_LOGICAL) {
            Rf_warning(MSG__INVALID_CODE_POINT_REPLNA);
            SET_STRING_ELT(ret, i, NA_STRING);
         }
         else {
            int bufsize = sn*3; // maximum: 1 byte -> U+FFFD (3 bytes)
            String8buf buf(bufsize); // maximum: 1 byte -> U+FFFD (3 bytes)
            char* bufdata = buf.data();

            j = 0;
            R_len_t k = 0;
            UBool err = FALSE;
            while (!err && j < sn) {
               U8_NEXT(s, j, sn, c);
               if (c >= 0) {
                  U8_APPEND((uint8_t*)bufdata, k, bufsize, c, err);
               } else {
                  Rf_warning(MSG__INVALID_CODE_POINT_FIXING);
                  bufdata[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE1;
                  bufdata[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE2;
                  bufdata[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE3;
               }
            }

            if (err) throw StriException(MSG__INTERNAL_ERROR);
            SET_STRING_ELT(ret, i, Rf_mkCharLenCE(bufdata, k, CE_UTF8));
         }
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


/** Convert character vector to ASCII
 *
 * All charcodes > 127 are replaced with subst chars (0x1A)
 *
 * @param str character vector
 * @return character vector
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-30)
 *          use single common buf;
 *          warn on invalid utf8 byte stream
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_toascii(SEXP str)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   R_len_t n = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN(1)

   // get buf size
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<n; ++i) {
      SEXP curs = STRING_ELT(str, i);
      if (curs == NA_STRING)
         continue;

      R_len_t ni = LENGTH(curs);
      if (ni > bufsize) bufsize = ni;
   }
   String8buf buf(bufsize); // no more bytes than this needed
   char* bufdata = buf.data();

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, n));
   for (R_len_t i=0; i<n; ++i) {
      SEXP curs = STRING_ELT(str, i);
      if (curs == NA_STRING || IS_ASCII(curs)) {
         // nothing to do
         SET_STRING_ELT(ret, i, curs);
         continue;
      }

      R_len_t curn = LENGTH(curs);
      const char* curs_tab = CHAR(curs);

      if (IS_UTF8(curs)) {
         R_len_t k = 0, j = 0;
         UChar32 c;
         while (j<curn) {
            U8_NEXT(curs_tab, j, curn, c);
            if (c < 0) {
               Rf_warning(MSG__INVALID_CODE_POINT_FIXING);
               bufdata[k++] = ASCII_SUBSTITUTE;
            }
            else if (c > ASCII_MAXCHARCODE)
               bufdata[k++] = ASCII_SUBSTITUTE;
            else
               bufdata[k++] = (char)c;
         }
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(bufdata, k, CE_UTF8));
         // the string will be marked as ASCII anyway by mkCharLenCE
      }
      else { // some 8-bit encoding
         R_len_t k = 0;
         for (R_len_t j=0; j<curn; ++j) {
            if (U8_IS_SINGLE(curs_tab[j]))
               bufdata[k++] = curs_tab[j];
            else {
               bufdata[k++] = (char)ASCII_SUBSTITUTE; // subst char in ascii
            }
         }
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(bufdata, k, CE_UTF8));
         // the string will be marked as ASCII anyway by mkCharLenCE
      }
   }

   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}


// ------------------------------------------------------------------------

/**
 * Convert character vector between marked encodings and the encoding provided
 *
 * @param str     input character vector or list of raw vectors
 * @param to    target encoding, \code{NULL} or \code{""} for default enc
 * @param to_raw single logical, should list of raw vectors be returned?
 * @return a converted character vector or list of raw vectors
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-11-12)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          use StriUcnv
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *          calc required buf size a priori
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_encode_from_marked(SEXP str, SEXP to, SEXP to_raw)
{
   PROTECT(str = stri_prepare_arg_string(str, "str"));
   const char* selected_to   = stri__prepare_arg_enc(to, "to", true); /* this is R_alloc'ed */
   bool to_raw_logical = stri__prepare_arg_logical_1_notNA(to_raw, "to_raw");

   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t str_n = LENGTH(str);
   StriContainerUTF16 str_cont(str, str_n);

   // get the number of strings to convert; if == 0, then you know what's the result
   if (str_n <= 0) return Rf_allocVector(to_raw_logical?VECSXP:STRSXP, 0);

   // Open converters
   StriUcnv ucnv(selected_to);
   UConverter* uconv_to = ucnv.getConverter(true /*register_callbacks*/);

   // Get target encoding mark
   cetype_t encmark_to = to_raw_logical?CE_BYTES:ucnv.getCE();

   // Prepare out val
   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(to_raw_logical?VECSXP:STRSXP, str_n));

   // calculate required buf size
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<str_n; ++i) {
      if (!str_cont.isNA(i) && str_cont.get(i).length() > bufsize)
         bufsize = str_cont.get(i).length();
   }
   bufsize = UCNV_GET_MAX_BYTES_FOR_STRING(bufsize, ucnv_getMaxCharSize(uconv_to));
   // "The calculated size is guaranteed to be sufficient for this conversion."
   String8buf buf(bufsize);

   for (R_len_t i=0; i<str_n; ++i) {
      if (str_cont.isNA(i)) {
         if (to_raw_logical) SET_VECTOR_ELT(ret, i, R_NilValue);
         else                SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      R_len_t curn_tmp = str_cont.get(i).length();
      const UChar* curs_tmp = str_cont.get(i).getBuffer(); // The buffer contents is (probably) not NUL-terminated.
      if (!curs_tmp)
         throw StriException(MSG__INTERNAL_ERROR);

      UErrorCode status = U_ZERO_ERROR;
      ucnv_resetFromUnicode(uconv_to);
      R_len_t bufneed = ucnv_fromUChars(uconv_to, buf.data(), buf.size(),
            curs_tmp, curn_tmp, &status);
      if (bufneed <= buf.size()) {
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }
      else {// larger buffer needed [this shouldn't happen?]
         buf.resize(bufneed, false/*destroy contents*/);
         status = U_ZERO_ERROR;
         bufneed = ucnv_fromUChars(uconv_to, buf.data(), buf.size(),
               curs_tmp, curn_tmp, &status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }

      if (to_raw_logical) {
         SEXP outobj;
         STRI__PROTECT(outobj = Rf_allocVector(RAWSXP, bufneed));
         memcpy(RAW(outobj), buf.data(), (size_t)bufneed);
         SET_VECTOR_ELT(ret, i, outobj);
         STRI__UNPROTECT(1);
      }
      else {
         SET_STRING_ELT(ret, i,
            Rf_mkCharLenCE(buf.data(), bufneed, encmark_to));
      }
   }

   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({/* nothing special on error */})
}


/**
 * Convert character vector between given encodings
 *
 * @param str     input character/raw vector or list of raw vectors
 * @param from  source encoding, \code{NULL} or \code{""} for default enc
 * @param to    target encoding, \code{NULL} or \code{""} for default enc
 * @param to_raw single logical, should list of raw vectors be returned?
 * @return a converted character vector or list of raw vectors
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          arg to_raw_added, encoding marking
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-08)
 *          use StriContainerListRaw
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-11-20)
 *          BUGFIX call stri_encode_from_marked if necessary
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          use StriUcnv
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *          estimate required buf size a priori
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_encode(SEXP str, SEXP from, SEXP to, SEXP to_raw)
{
   const char* selected_from = stri__prepare_arg_enc(from, "from", true); /* this is R_alloc'ed */
   if (!selected_from && Rf_isVectorAtomic(str))
      return stri_encode_from_marked(str, to, to_raw);
   const char* selected_to   = stri__prepare_arg_enc(to, "to", true); /* this is R_alloc'ed */
   bool to_raw_logical = stri__prepare_arg_logical_1_notNA(to_raw, "to_raw");

   // raw vector, character vector, or list of raw vectors:
   PROTECT(str = stri_prepare_arg_list_raw(str, "str"));


   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerListRaw str_cont(str);
   R_len_t str_n = str_cont.get_n();

   // get the number of strings to convert; if == 0, then you know what's the result
   if (str_n <= 0) {
      STRI__UNPROTECT_ALL
      return Rf_allocVector(to_raw_logical?VECSXP:STRSXP, 0);
   }

   // Open converters
   StriUcnv ucnv1(selected_from);
   StriUcnv ucnv2(selected_to);
   UConverter* uconv_from = ucnv1.getConverter(true /*register_callbacks*/);
   UConverter* uconv_to   = ucnv2.getConverter(true /*register_callbacks*/);

   // Get target encoding mark
   cetype_t encmark_to = to_raw_logical?CE_BYTES:ucnv2.getCE();

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(to_raw_logical?VECSXP:STRSXP, str_n));


   // estimate required buf size
   R_len_t bufsize = 0;
   for (R_len_t i=0; i<str_n; ++i) {
      if (!str_cont.isNA(i) && str_cont.get(i).length() > bufsize)
         bufsize = str_cont.get(i).length();
   }
   bufsize = bufsize*4; // this is just an estimate (for 8bit->utf8 conversions)
   String8buf buf(bufsize);

   for (R_len_t i=0; i<str_n; ++i) {
      if (str_cont.isNA(i)) {
         if (to_raw_logical) SET_VECTOR_ELT(ret, i, R_NilValue);
         else                SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      const char* curs = str_cont.get(i).c_str();
      R_len_t curn     = str_cont.get(i).length();

      UErrorCode status = U_ZERO_ERROR;
      UnicodeString encs(curs, curn, uconv_from, status); // FROM -> UTF-16 [this is the slow part]
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      R_len_t curn_tmp = encs.length();
      const UChar* curs_tmp = encs.getBuffer(); // The buffer contents is (probably) not NUL-terminated.
      if (!curs_tmp) {
         throw StriException(MSG__INTERNAL_ERROR);
      }

      R_len_t bufneed = UCNV_GET_MAX_BYTES_FOR_STRING(curn_tmp, ucnv_getMaxCharSize(uconv_to));
      // "The calculated size is guaranteed to be sufficient for this conversion."
      buf.resize(bufneed, false/*destroy contents*/); // grows or stays as it was

      status = U_ZERO_ERROR;
//      bufneed = encs.extract(buf.data(), buf.size(), uconv_to, status); // UTF-16 -> TO
      ucnv_resetFromUnicode(uconv_to);
      bufneed = ucnv_fromUChars(uconv_to, buf.data(), buf.size(), curs_tmp,
         curn_tmp, &status);
      if (bufneed <= buf.size()) {
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }
      else {// larger buffer needed [this shouldn't happen?]
//         warning("buf extending");
         buf.resize(bufneed, false/*destroy contents*/);
         status = U_ZERO_ERROR;
         bufneed = ucnv_fromUChars(uconv_to, buf.data(), buf.size(), curs_tmp,
            curn_tmp, &status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      }

      if (to_raw_logical) {
         SEXP outobj;
         STRI__PROTECT(outobj = Rf_allocVector(RAWSXP, bufneed));
         memcpy(RAW(outobj), buf.data(), (size_t)bufneed);
         SET_VECTOR_ELT(ret, i, outobj);
         STRI__UNPROTECT(1);
      }
      else {
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), bufneed, encmark_to));
      }
   }

   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({/* no special action on error */})
}
