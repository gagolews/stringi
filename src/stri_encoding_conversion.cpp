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


#include "stri_stringi.h"


/** Convert from UTF-32 [single string, internal]
 *
 * On invalid codepoint, warning is generated and -1 is returned
 * @param data  UTF-32 codes
 * @param ndata number of codes
 * @param buf [out] output buffer
 * @param bufsize buffer size
 * @return number of bytes written
 *
 * @version 0.1 (Marek Gagolewski)
 */
R_len_t stri__enc_fromutf32(int* data, R_len_t ndata, char* buf, R_len_t bufsize)
{
   R_len_t i = 0;
   R_len_t k = 0;
   UBool err = FALSE;
   while (k < ndata) {
      UChar32 c = data[k++];
      U8_APPEND((uint8_t*)buf, i, bufsize, c, err);
      if (err) {
         Rf_warning(MSG__INVALID_CODE_POINT, (int)c);
         return -1;
      }
   }
   return i;
}


/** Convert from UTF-32
 *
 * @param vec integer vector or list with integer vectors
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_enc_fromutf32(SEXP vec)
{
   if (Rf_isVectorList(vec)) {
      R_len_t n = LENGTH(vec);
      R_len_t bufsize = 0;
      for (R_len_t i=0; i<n; ++i) {
         SEXP cur = VECTOR_ELT(vec, i);
         if (isNull(cur))
            continue;
         if (!Rf_isInteger(cur)) // this cannot be treated with stri_prepare_arg*, as vec may be a mem-shared object
            Rf_error(MSG__ARG_EXPECTED_INTEGER_NO_COERCION, "vec[[i]]"); // error() allowed here
         if (LENGTH(cur) > bufsize) bufsize = LENGTH(cur);
      }

      bufsize = U8_MAX_LENGTH*bufsize+1;
      char* buf = new char[bufsize]; // no call to error() between new and delete -> OK
      SEXP ret;
      PROTECT(ret = Rf_allocVector(STRSXP, n));
      for (R_len_t i=0; i<n; ++i) {
         SEXP cur = VECTOR_ELT(vec, i);
         if (isNull(cur)) {
            SET_STRING_ELT(ret, i, NA_STRING);
            continue;
         }
         R_len_t chars = stri__enc_fromutf32(INTEGER(cur), LENGTH(cur), buf, bufsize);
         if (chars < 0)
            SET_STRING_ELT(ret, i, NA_STRING);
         else
            SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf, chars, CE_UTF8));
      }
      delete [] buf;
      UNPROTECT(1);
      return ret;
   }
   else {
      vec = stri_prepare_arg_integer(vec, "vec");  // integer vector
      SEXP ret;
      PROTECT(ret = Rf_allocVector(STRSXP, 1));

      int* data = INTEGER(vec);
      R_len_t ndata = LENGTH(vec);
      R_len_t bufsize = U8_MAX_LENGTH*ndata+1;
      char* buf = new char[bufsize]; // no call to error() between new and delete -> OK
      R_len_t chars = stri__enc_fromutf32(data, ndata, buf, bufsize);
      if (chars < 0)
         SET_STRING_ELT(ret, 0, NA_STRING);
      else
         SET_STRING_ELT(ret, 0, Rf_mkCharLenCE(buf, chars, CE_UTF8));
      delete [] buf;
      UNPROTECT(1);
      return ret;
   }
}


/** Convert character vector to UTF-32
 *
 * @param str character vector
 * @return list with integer vectors
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_enc_toutf32(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t n = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN
   StriContainerUTF8 str_cont(str, n);

   R_len_t bufsize = 0;
   for (R_len_t i=0; i<n; ++i) {
       if (str_cont.isNA(i)) continue;
       R_len_t ni = str_cont.get(i).length();
       if (ni > bufsize) bufsize = ni;
   }

   bufsize = bufsize + 1; // at most 4 times too large... well, have to be
   int* buf = (int*)R_alloc(bufsize, (int)sizeof(int));

   SEXP ret;
   PROTECT(ret = Rf_allocVector(VECSXP, n));

   for (R_len_t i = str_cont.vectorize_init();
         i != str_cont.vectorize_end();
         i = str_cont.vectorize_next(i)) {

      if (str_cont.isNA(i)) continue; // leave NULL

//      deque<UChar32> chars; // this is slower than using a common, over-sized buf

      UChar32 c;
      const char* s = str_cont.get(i).c_str();
      R_len_t sn = str_cont.get(i).length();
      R_len_t j = 0;
      R_len_t k = 0;
      while (j < sn) {
         U8_NEXT_UNSAFE(s, j, c);
         buf[k++] = (int)c;
//         chars.push_back(c);
      }

      SEXP conv;
      PROTECT(conv = Rf_allocVector(INTSXP, k /*chars.size()*/));
      memcpy(INTEGER(conv), buf, (size_t)sizeof(int)*k);
//      for (deque<UChar32>::iterator it = chars.begin(); it != chars.end(); ++it)
//         *(conv_tab++) = (int)*it;
      SET_VECTOR_ELT(ret, i, conv);
      UNPROTECT(1);
   }

   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}



/** Convert character vector to UTF-8
 *
 * @param str character vector
 * @param is_unknown_8bit single logical value;
 * if TRUE, then in case of ENC_NATIVE or ENC_LATIN1, UTF-8
 * REPLACEMENT CHARACTERs (U+FFFD) are
 * put for codes > 127
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_enc_toutf8(SEXP str, SEXP is_unknown_8bit)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t n = LENGTH(str);
   bool is_unknown_8bit_logical = stri__prepare_arg_logical_1_notNA(is_unknown_8bit, "is_unknown_8bit");

   STRI__ERROR_HANDLER_BEGIN
   if (is_unknown_8bit_logical) {
      SEXP ret;
      PROTECT(ret = Rf_allocVector(STRSXP, n));
      for (R_len_t i=0; i<n; ++i) {
         SEXP curs = STRING_ELT(str, i);
         if (curs == NA_STRING) {
            SET_STRING_ELT(ret, i, NA_STRING);
            continue;
         }
         else if (IS_ASCII(curs) || IS_UTF8(curs)) {
            SET_STRING_ELT(ret, i, curs);
         }
         else { // some 8-bit encoding
            R_len_t curn = LENGTH(curs);
            const char* curs_tab = CHAR(curs);
            // TODO: buffer reuse....
            String8 buf(curn*3+1); // one byte -> either one byte or FFFD, which is 3 bytes in UTF-8
            R_len_t k = 0;
            for (R_len_t j=0; j<curn; ++j) {
               if (U8_IS_SINGLE(curs_tab[j]))
                  buf.data()[k++] = curs_tab[j];
               else { // 0xEF 0xBF 0xBD
                  buf.data()[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE1;
                  buf.data()[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE2;
                  buf.data()[k++] = (char)UCHAR_REPLACEMENT_UTF8_BYTE3;
               }
            }
            SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), k, CE_UTF8));
         }
      }
      UNPROTECT(1);
      return ret;
   }
   else {
      // Trivial - everything we need is in StriContainerUTF8 :)
      StriContainerUTF8 str_cont(str, n);
      return str_cont.toR();
   }
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}



/** Convert character vector to ASCII
 *
 * All charcodes > 127 are replaced with subst chars (0x1A)
 *
 * @param str character vector
 * @return character vector
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 */
SEXP stri_enc_toascii(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t n = LENGTH(str);

   STRI__ERROR_HANDLER_BEGIN
   SEXP ret;
   PROTECT(ret = Rf_allocVector(STRSXP, n));
   for (R_len_t i=0; i<n; ++i) {
      SEXP curs = STRING_ELT(str, i);
      if (curs == NA_STRING) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      else if (IS_ASCII(curs)) {
         SET_STRING_ELT(ret, i, curs);
      }
      else if (IS_UTF8(curs)) {
         R_len_t curn = LENGTH(curs);
         const char* curs_tab = CHAR(curs);
         // TODO: buffer reuse....
         String8 buf(curn+1); // this may be 4 times too much
         R_len_t k = 0;
         UChar32 c;
         for (int j=0; j<curn; ) {
            U8_NEXT(curs_tab, j, curn, c);
            if (c > ASCII_MAXCHARCODE)
               buf.data()[k++] = ASCII_SUBSTITUTE;
            else
               buf.data()[k++] = (char)c;
         }
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), k, CE_UTF8)); // will be marked as ASCII anyway by mkCharLenCE
      }
      else { // some 8-bit encoding
         R_len_t curn = LENGTH(curs);
         const char* curs_tab = CHAR(curs);
         // TODO: buffer reuse....
         String8 buf(curn+1);
         R_len_t k = 0;
         for (R_len_t j=0; j<curn; ++j) {
            if (U8_IS_SINGLE(curs_tab[j]))
               buf.data()[k++] = curs_tab[j];
            else {
               buf.data()[k++] = (char)ASCII_SUBSTITUTE; // subst char in ascii
            }
         }
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), k, CE_UTF8)); // will be marked as ASCII anyway by mkCharLenCE
      }
   }
   UNPROTECT(1);
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}




// ------------------------------------------------------------------------

/**
 * Convert character vector between a marked encodings and the encoding provided
 *
 * @param str     input character vector or list of raw vectors
 * @param to    target encoding, \code{NULL} or \code{""} for default enc
 * @param to_raw single logical, should list of raw vectors be returned?
 * @return a converted character vector or list of raw vectors
 *
 * @version 0.1 (Marek Gagolewski, 2013-11-12)
 */
SEXP stri_encode_from_marked(SEXP str, SEXP to, SEXP to_raw)
{
   str = stri_prepare_arg_string(str, "str");
   const char* selected_to   = stri__prepare_arg_enc(to, "to", true);
   bool to_raw_logical = stri__prepare_arg_logical_1_notNA(to_raw, "to_raw");

   UConverter* uconv_to = NULL;

   STRI__ERROR_HANDLER_BEGIN
   R_len_t str_n = LENGTH(str);
   StriContainerUTF16 str_cont(str, str_n);

   // get the number of strings to convert; if == 0, then you know what's the result
   if (str_n <= 0) return Rf_allocVector(to_raw_logical?VECSXP:STRSXP, 0);

   // Open converters
   uconv_to = stri__ucnv_open(selected_to);

   // Get target encoding mark
   UErrorCode err = U_ZERO_ERROR;
   const char* uconv_to_name = ucnv_getName(uconv_to, &err);
   if (U_FAILURE(err))
      throw StriException(err);
   cetype_t encmark_to = CE_BYTES; // all other cases than the below ones
      // - bytes enc (this is reasonable, isn't it?)
   if (!to_raw_logical) { // otherwise not needed
      if (!strcmp(uconv_to_name, "US-ASCII") || !strcmp(uconv_to_name, "UTF-8"))
         encmark_to = CE_UTF8; // no CE for ASCII, will be auto-detected by mkCharLenCE
      else if (!strcmp(uconv_to_name, "ISO-8859-1"))
         encmark_to = CE_LATIN1;
      else if (!strcmp(uconv_to_name, ucnv_getDefaultName()))
         encmark_to = CE_NATIVE;
   }

   // Prepare out val
   SEXP ret;
   PROTECT(ret = Rf_allocVector(to_raw_logical?VECSXP:STRSXP, str_n));

   String8 buf(0); // will be extended in a moment

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

      R_len_t bufneed = UCNV_GET_MAX_BYTES_FOR_STRING(curn_tmp, ucnv_getMaxCharSize(uconv_to));
      // "The calculated size is guaranteed to be sufficient for this conversion."
      buf.resize(bufneed);

      err = U_ZERO_ERROR;
      ucnv_resetFromUnicode(uconv_to);
      bufneed = ucnv_fromUChars(uconv_to, buf.data(), buf.size(), curs_tmp, curn_tmp, &err);
      if (bufneed <= buf.size()) {
         if (U_FAILURE(err))
            throw StriException(err);
      }
      else {// larger buffer needed [this shouldn't happen?]
//         warning("buf extending");
         buf.resize(bufneed);
         err = U_ZERO_ERROR;
         bufneed = ucnv_fromUChars(uconv_to, buf.data(), buf.size(), curs_tmp, curn_tmp, &err);
         if (U_FAILURE(err))
            throw StriException(err);
         if (bufneed > buf.size())
            throw StriException(MSG__INTERNAL_ERROR);
      }

      if (to_raw_logical) {
         SEXP outobj = Rf_allocVector(RAWSXP, bufneed);
         memcpy(RAW(outobj), buf.data(), (size_t)bufneed);
         SET_VECTOR_ELT(ret, i, outobj);
      }
      else {
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), bufneed, encmark_to));
      }
   }

   if (uconv_to) {
      ucnv_close(uconv_to);
      uconv_to = NULL;
   }

   UNPROTECT(1);
   return ret;

   STRI__ERROR_HANDLER_END({
      if (uconv_to)
         ucnv_close(uconv_to);
   })
}

/**
 * Convert character vector between given encodings
 *
 * @param str     input character vector or list of raw vectors
 * @param from  source encoding, \code{NULL} or \code{""} for default enc
 * @param to    target encoding, \code{NULL} or \code{""} for default enc
 * @param to_raw single logical, should list of raw vectors be returned?
 * @return a converted character vector or list of raw vectors
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski) arg to_raw_added, encoding marking
 * @version 0.3 (Marek Gagolewski, 2013-06-16) make StriException-friendly
 * @version 0.4 (Marek Gagolewski, 2013-08-08) use StriContainerListRaw
 * @version 0.5 (Marek Gagolewski, 2013-11-20) BUGFIX call stri_encode_from_marked if necessary
 */
SEXP stri_encode(SEXP str, SEXP from, SEXP to, SEXP to_raw)
{
   const char* selected_from = stri__prepare_arg_enc(from, "from", true);
   if (!selected_from && Rf_isVectorAtomic(str))
      return stri_encode_from_marked(str, to, to_raw);

   str = stri_prepare_arg_list_raw(str, "str");
   const char* selected_to   = stri__prepare_arg_enc(to, "to", true);
   bool to_raw_logical = stri__prepare_arg_logical_1_notNA(to_raw, "to_raw");

   UConverter* uconv_from = NULL;
   UConverter* uconv_to = NULL;

   STRI__ERROR_HANDLER_BEGIN
   StriContainerListRaw str_cont(str);
   R_len_t str_n = str_cont.get_n();

   // get the number of strings to convert; if == 0, then you know what's the result
   if (str_n <= 0) return Rf_allocVector(to_raw_logical?VECSXP:STRSXP, 0);

   // Open converters
   uconv_from = stri__ucnv_open(selected_from);
   uconv_to = stri__ucnv_open(selected_to);


   // Get target encoding mark
   UErrorCode err = U_ZERO_ERROR;
   const char* uconv_to_name = ucnv_getName(uconv_to, &err);
   if (U_FAILURE(err))
      throw StriException(err);
   cetype_t encmark_to = CE_BYTES; // all other cases than the below ones
      // - bytes enc (this is reasonable, isn't it?)
   if (!to_raw_logical) { // otherwise not needed
      if (!strcmp(uconv_to_name, "US-ASCII") || !strcmp(uconv_to_name, "UTF-8"))
         encmark_to = CE_UTF8; // no CE for ASCII, will be auto-detected by mkCharLenCE
      else if (!strcmp(uconv_to_name, "ISO-8859-1"))
         encmark_to = CE_LATIN1;
      else if (!strcmp(uconv_to_name, ucnv_getDefaultName()))
         encmark_to = CE_NATIVE;
   }

   // Prepare out val
   SEXP ret;
   PROTECT(ret = Rf_allocVector(to_raw_logical?VECSXP:STRSXP, str_n));

   String8 buf(0); // will be extended in a moment

   for (R_len_t i=0; i<str_n; ++i) {
      if (str_cont.isNA(i)) {
         if (to_raw_logical) SET_VECTOR_ELT(ret, i, R_NilValue);
         else                SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      const char* curd = str_cont.get(i).c_str();
      R_len_t curn     = str_cont.get(i).length();

      err = U_ZERO_ERROR;
      UnicodeString encs(curd, curn, uconv_from, err); // FROM -> UTF-16 [this is the slow part]
      if (U_FAILURE(err))
         throw StriException(err);

      R_len_t curn_tmp = encs.length();
      const UChar* curs_tmp = encs.getBuffer(); // The buffer contents is (probably) not NUL-terminated.
      if (!curs_tmp)
         throw StriException(MSG__INTERNAL_ERROR);

      R_len_t bufneed = UCNV_GET_MAX_BYTES_FOR_STRING(curn_tmp, ucnv_getMaxCharSize(uconv_to));
      // "The calculated size is guaranteed to be sufficient for this conversion."
      buf.resize(bufneed);

      err = U_ZERO_ERROR;
//      bufneed = encs.extract(buf.data(), buf.size(), uconv_to, err); // UTF-16 -> TO
      ucnv_resetFromUnicode(uconv_to);
      bufneed = ucnv_fromUChars(uconv_to, buf.data(), buf.size(), curs_tmp, curn_tmp, &err);
      if (bufneed <= buf.size()) {
         if (U_FAILURE(err))
            throw StriException(err);
      }
      else {// larger buffer needed [this shouldn't happen?]
//         warning("buf extending");
         buf.resize(bufneed);
         err = U_ZERO_ERROR;
         bufneed = ucnv_fromUChars(uconv_to, buf.data(), buf.size(), curs_tmp, curn_tmp, &err);
         if (U_FAILURE(err))
            throw StriException(err);
         if (bufneed > buf.size())
            throw StriException(MSG__INTERNAL_ERROR);
      }

      if (to_raw_logical) {
         SEXP outobj = Rf_allocVector(RAWSXP, bufneed);
         memcpy(RAW(outobj), buf.data(), (size_t)bufneed);
         SET_VECTOR_ELT(ret, i, outobj);
      }
      else {
         SET_STRING_ELT(ret, i, Rf_mkCharLenCE(buf.data(), bufneed, encmark_to));
      }
   }

   if (uconv_from) {
      ucnv_close(uconv_from);
      uconv_from = NULL;
   }
   if (uconv_to) {
      ucnv_close(uconv_to);
      uconv_to = NULL;
   }

   UNPROTECT(1);
   return ret;

   STRI__ERROR_HANDLER_END({
      if (uconv_from)
         ucnv_close(uconv_from);
      if (uconv_to)
         ucnv_close(uconv_to);
   })
}
