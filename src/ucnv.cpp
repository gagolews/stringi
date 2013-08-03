/* This file is part of the 'stringi' library.
 *
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus
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


// ------------------------------------------------------------------------


/** Open UConverter for given character encoding
 *
 *  If the converted could be opened, then an error is generated.
 *
 *  @param enc encoding name or NULL for default encoding (please,
 *       use \code{stri__prepare_arg_enc()})
 *  @return opened UConverter* (must be closed manually after use)
 *
 * @version 0.1 (Marek Gagolewski)
 */
UConverter* stri__ucnv_open(const char* enc)
{
   UErrorCode err = U_ZERO_ERROR;
   UConverter* uconv = NULL;

   uconv = ucnv_open(enc, &err);
   if (U_FAILURE(err))
      Rf_error(MSG__ENC_ERROR_SET); // error() allowed here

   return uconv;
}



// ------------------------------------------------------------------------


/**
 * Sets current (default) ICU charset
 *
 * If given charset is unavailable, an error is raised
 *
 * @param enc new charset (single string)
 * @return nothing (\code{R_NilValue})
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_enc_set(SEXP enc)
{
   const char* selected_enc
      = stri__prepare_arg_enc(enc, "enc", false); // here, the default encoding may not be requested

   // this will generate an error if enc is not supported:
   UConverter* uconv = stri__ucnv_open(selected_enc);

   UErrorCode err = U_ZERO_ERROR;
   const char* name = ucnv_getName(uconv, &err); // get "official" encoding name
   ucnv_close(uconv); // no longer needed
   if (U_FAILURE(err))
      Rf_error(MSG__ENC_ERROR_SET);  // error() allowed here
   ucnv_setDefaultName(name); // set as default

   return R_NilValue;
}





/**
 * Get all available ICU charsets and their aliases (elems 2,3,...)
 *
 * @return R list object; element name == ICU charset canonical name;
 * elements are character vectors (aliases)
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_enc_list()
{
   R_len_t c = (R_len_t)ucnv_countAvailable();

   SEXP ret;
   SEXP names;
   PROTECT(ret = Rf_allocVector(VECSXP, c));
   PROTECT(names = Rf_allocVector(STRSXP, c));

   for (R_len_t i=0; i<c; ++i) {
      const char* canonical_name = ucnv_getAvailableName(i);
      if (!canonical_name) {
         SET_STRING_ELT(names, i, NA_STRING);
         continue;
      }

      SET_STRING_ELT(names, i, Rf_mkChar(canonical_name));

      UErrorCode err = U_ZERO_ERROR;
      R_len_t ci = (R_len_t)ucnv_countAliases(canonical_name, &err);
      if (U_FAILURE(err) || ci <= 0)
         SET_VECTOR_ELT(ret, i, Rf_ScalarString(NA_STRING));
      else {
         SEXP aliases;
         PROTECT(aliases = Rf_allocVector(STRSXP, ci));
         for (R_len_t j=0; j<ci; ++j) {
            err = U_ZERO_ERROR;
            const char* alias = ucnv_getAlias(canonical_name, j, &err);
            if (U_FAILURE(err) || !alias)
               SET_STRING_ELT(aliases, j, NA_STRING);
            else
               SET_STRING_ELT(aliases, j, Rf_mkChar(alias));
         }
         UNPROTECT(1);
         SET_VECTOR_ELT(ret, i, aliases);
      }
   }

   Rf_setAttrib(ret, R_NamesSymbol, names);
   UNPROTECT(2);
   return ret;
}







/** Which string is ASCII-encoded
 *
 * simple check whether charcodes are in [1..127]
 * by using U8_IS_SINGLE
 *
 *  @param s character vector
 *  @return logical vector
 *
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_enc_isascii(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, str_length));
   int* ret_tab = LOGICAL(ret); // may be faster than LOGICAL(ret)[i] all the time

   for (R_len_t i=0; i < str_length; ++i) {
      SEXP str_cur = STRING_ELT(str, i);
      if (str_cur == NA_STRING) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }
      const char* str_cur_s = CHAR(str_cur);
      R_len_t str_cur_n = LENGTH(str_cur);
      ret_tab[i] = true;
      for (R_len_t j=0; j < str_cur_n; ++j) {
         if (!U8_IS_SINGLE(str_cur_s[j])) { // i.e. <= 127
            ret_tab[i] = false; // definitely not ASCII
            break;
         }
      }
   }

   UNPROTECT(1);
   return ret;
}




/** Which string is probably UTF-8-encoded
 *
 * simple check with U8_NEXT
 *
 *  @param s character vector
 *  @return logical vector
 *
 * @version 0.1 (Bartek Tartanus)
 */
SEXP stri_enc_isutf8(SEXP str)
{
   str = stri_prepare_arg_string(str, "str");
   R_len_t str_length = LENGTH(str);

   SEXP ret;
   PROTECT(ret = Rf_allocVector(LGLSXP, str_length));
   int* ret_tab = LOGICAL(ret);

   for (R_len_t i=0; i < str_length; ++i) {
      SEXP str_cur = STRING_ELT(str, i);
      if (str_cur == NA_STRING){
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      const char* str_cur_s = CHAR(str_cur);
      R_len_t str_cur_n = LENGTH(str_cur);
      UChar32 c;
      ret_tab[i] = true;
      for (R_len_t j=0; j < str_cur_n; ) {
         U8_NEXT(str_cur_s, j, str_cur_n, c);
         if (c < 0) { // ICU utf8.h doc for U8_NEXT: c -> output UChar32 variable, set to <0 in case of an error
            ret_tab[i] = false; // definitely not UTF-8
            break;
         }
      }
   }

   UNPROTECT(1);
   return ret;
}







// ------------------------------------------------------------------------


/**
 * Get ICU ucnv standard names and their count
 *
 *  @param standards [OUT] - dynamically allocated array of char strings
 *  (items are are possesed by ICU, but the array should be freed)
 *  @param cs [out] - size of \code{standards}
 *
 *  @version 0.1 (Marek Gagolewski)
 */
void stri__ucnv_getStandards(const char**& standards, R_len_t& cs)
{
   UErrorCode err;
   cs = (R_len_t)ucnv_countStandards()-1; // -1 - this is not documented in ICU4C
   if (cs <= 0) Rf_error(MSG__ENC_ERROR_SET); // error() allowed here
   standards = (const char**)R_alloc(cs, sizeof(const char*)); // will be freed automatically

   for (R_len_t i=0; i<cs; ++i) {
      err = U_ZERO_ERROR;
      standards[i] = ucnv_getStandard(i, &err);
      if (U_FAILURE(err)) {
#ifndef NDEBUG
         Rf_warning("could not get standard name (stri_list)");
#endif
         standards[i] = NULL;
      }
   }
}



/**
 * Get friendly encoding name
 *
 * @param canname Canonical (ICU) encoding name
 * @return First existing of: MIME name or JAVA name or Canonical
 *
 * @version 0.1 (Marek Gagolewski)
 */
const char* stri__ucnv_getFriendlyName(const char* canname)
{
   if (!canname) return NULL;

   UErrorCode err;
   const char* frname;

   err = U_ZERO_ERROR;
   frname = ucnv_getStandardName(canname, "MIME", &err);
   if (!U_FAILURE(err) && frname)
      return frname;

   err = U_ZERO_ERROR;
   frname = ucnv_getStandardName(canname, "JAVA", &err);
   if (!U_FAILURE(err) && frname)
      return frname;

   return canname;
}



/**
 * Convert each ASCII character (1..127) to UTF-8
 * and checks whether it gets the same result
 *
 * This sould be used only on 8-bit converters
 *
 * @param conv ICU charset converter
 *
 * @version 0.1 (Marek Gagolewski)
 */
bool stri__ucnv_hasASCIIsubset(UConverter* conv)
{
   if (ucnv_getMinCharSize(conv) != 1) return false;

   const int ascii_from = 0x0001;
   const int ascii_to   = 0x007f;
   char ascii[ascii_to-ascii_from+2]; // + \0
   for (int i=ascii_from; i<=ascii_to; ++i)
      ascii[i-ascii_from] = (char)i;
   ascii[ascii_to-ascii_from+1] = '\0';

   UChar32 c;

   const char* ascii_last = ascii;
   const char* ascii1 = ascii;
   const char* ascii2 = ascii+(ascii_to-ascii_from)+1;

   ucnv_reset(conv);

   while (ascii1 < ascii2) {
      UErrorCode err = U_ZERO_ERROR;
      c = ucnv_getNextUChar(conv, &ascii1, ascii2, &err);
      if (U_FAILURE(err)) {
#ifndef NDEBUG
         Rf_warning("Cannot convert ASCII character 0x%2x (encoding=%s)",
            (int)(unsigned char)ascii_last[0],
            ucnv_getName(conv, &err));
#endif
         return false;
      }

      // Has just one byte been consumed? (??is that necessary??)
      // How many code units (bytes) are used for the UTF-8 encoding
      // of this Unicode code point? Does this code unit (byte)
      // encode a code point by itself (US-ASCII 0..0x7f)?
      // Is that the same ASCII char?
      if (ascii_last != ascii1-1
         || U8_LENGTH(c) != 1
         || c != (int)ascii_last[0]) {
         return false;
      }
      ascii_last = ascii1;
   }

   return true;
}


/**
 * Converts each character (23..255) to UTF-8 and the back to original enc
 * and checks whether it gets the same result
 *
 * This sould be used only on 8-bit converters
 *
 * @param conv ICU charset converter
 *
 * @version 0.1 (Marek Gagolewski)
 */
bool stri__ucnv_is1to1Unicode(UConverter* conv)
{
   if (ucnv_getMinCharSize(conv) != 1) return false;

   const int ascii_from = 32;
   const int ascii_to = 0x00ff;
   char ascii[ascii_to-ascii_from+2]; // + \0
   for (int i=ascii_from; i<=ascii_to; ++i)
      ascii[i-ascii_from] = (char)i;
   ascii[ascii_to-ascii_from+1] = '\0';

   UChar32 c;
   const int buflen =  UCNV_GET_MAX_BYTES_FOR_STRING(1, 1);
   char buf[buflen];

   const char* ascii_last = ascii;
   const char* ascii1 = ascii;
   const char* ascii2 = ascii+(ascii_to-ascii_from)+1;

   UErrorCode err = U_ZERO_ERROR;
   ucnv_reset(conv);

   while (ascii1 < ascii2) {
      c = ucnv_getNextUChar(conv, &ascii1, ascii2, &err);
      if (U_FAILURE(err)) {
#ifndef NDEBUG
         Rf_warning("Cannot convert character 0x%2x (encoding=%s)",
            (int)(unsigned char)ascii_last[0],
            ucnv_getName(conv, &err));
#endif
         return false;
      }

//      cerr << (int)(unsigned char)ascii_last[0] << " -> " << c << endl;
      if (ascii_last != ascii1-1) // one byte should be consumed
         return false;

      // check whether the character is represented
      // by a single UTF-16 code point
      UChar lead = U16_LEAD(c); //, trail = U16_TRAIL(c);
      if (!U16_IS_SINGLE(lead)) {
#ifndef NDEBUG
         Rf_warning("Problematic character 0x%2x -> \\u%8x (encoding=%s)",
            (int)(unsigned char)ascii_last[0],
            c,
            ucnv_getName(conv, &err));
#endif
         return false;
      }

      // character not convertable => ignore
      if (c != UCHAR_REPLACEMENT) {
         ucnv_fromUChars(conv, buf, buflen, (UChar*)&c, 1, &err);
         if (U_FAILURE(err)) {
#ifndef NDEBUG
            Rf_warning("Cannot convert character 0x%2x (encoding=%s)",
               (int)(unsigned char)ascii_last[0],
               ucnv_getName(conv, &err));
#endif
            return false;
         }

         if (buf[1] != '\0' || buf[0] != ascii_last[0]) {
#ifndef NDEBUG
            Rf_warning("Problematic character 0x%2x -> \\u%8x -> 0x%2x (encoding=%s)",
               (int)(unsigned char)ascii_last[0],
               c,
               (int)buf[0],
               ucnv_getName(conv, &err));
#endif
            return false;
         }
      }


      // @TODO: check tolower, toupper etc. (???)

      ascii_last = ascii1;
   }

   return true;
}


/** Fetch information on given encoding
 *
 * @param enc either NULL or "" for default encoding, or one string with encoding name
 * @return R list object with many components (see R doc for details)
 *
 * @version 0.1 (Marek Gagolewski)
 */
SEXP stri_enc_info(SEXP enc)
{
   const char* selected_enc = stri__prepare_arg_enc(enc, "enc", true);
   UConverter* uconv = stri__ucnv_open(selected_enc);
   UErrorCode err;

   // get list of available standards
   R_len_t cs;
   const char** standards; // allocated with R_alloc -> freed automatically
   stri__ucnv_getStandards(standards, cs);

   // alloc output list
   SEXP vals;
   SEXP names;
   const int nval = cs+2+5;
   PROTECT(names = Rf_allocVector(STRSXP, nval));
   SET_STRING_ELT(names, 0, Rf_mkChar("Name.friendly"));
   SET_STRING_ELT(names, 1, Rf_mkChar("Name.ICU"));
   for (R_len_t i=0; i<cs; ++i)
      SET_STRING_ELT(names, i+2, Rf_mkChar((string("Name.")+standards[i]).c_str()));
   SET_STRING_ELT(names, nval-5, Rf_mkChar("ASCII.subset"));
   SET_STRING_ELT(names, nval-4, Rf_mkChar("Unicode.1to1"));
   SET_STRING_ELT(names, nval-3, Rf_mkChar("CharSize.8bit"));
   SET_STRING_ELT(names, nval-2, Rf_mkChar("CharSize.min"));
   SET_STRING_ELT(names, nval-1, Rf_mkChar("CharSize.max"));

   PROTECT(vals = Rf_allocVector(VECSXP, nval));


   // get canonical (ICU) name
   err = U_ZERO_ERROR;
   const char* canname = ucnv_getName(uconv, &err);

   if (U_FAILURE(err) || !canname) {
      SET_VECTOR_ELT(vals, 1, Rf_ScalarString(NA_STRING));
      Rf_warning(MSG__ENC_ERROR_GETNAME);
   }
   else {
      SET_VECTOR_ELT(vals, 1, Rf_mkString(canname));

      // friendly name
      const char* frname = stri__ucnv_getFriendlyName(canname);
      if (frname)  SET_VECTOR_ELT(vals, 0, Rf_mkString(frname));
      else         SET_VECTOR_ELT(vals, 0, Rf_ScalarString(NA_STRING));


      // has ASCII as its subset?
      SET_VECTOR_ELT(vals, nval-5, Rf_ScalarLogical((int)stri__ucnv_hasASCIIsubset(uconv)));

      // min,max character size, is 8bit?
      int mincharsize = (int)ucnv_getMinCharSize(uconv);
      int maxcharsize = (int)ucnv_getMaxCharSize(uconv);
      int is8bit = (mincharsize==1 && maxcharsize == 1);
      SET_VECTOR_ELT(vals, nval-3, Rf_ScalarLogical(is8bit));
      SET_VECTOR_ELT(vals, nval-2, Rf_ScalarInteger(mincharsize));
      SET_VECTOR_ELT(vals, nval-1, Rf_ScalarInteger(maxcharsize));

      // is there a one-to-one correspondence with Unicode?
      if (!is8bit)
         SET_VECTOR_ELT(vals, nval-4, Rf_ScalarLogical(NA_LOGICAL));
      else
         SET_VECTOR_ELT(vals, nval-4, Rf_ScalarLogical((int)stri__ucnv_is1to1Unicode(uconv)));

      // other standard names
      for (R_len_t i=0; i<cs; ++i) {
         err = U_ZERO_ERROR;
         const char* stdname = ucnv_getStandardName(canname, standards[i], &err);
         if (U_FAILURE(err) || !stdname)
            SET_VECTOR_ELT(vals, i+2, Rf_ScalarString(NA_STRING));
         else
            SET_VECTOR_ELT(vals, i+2, Rf_mkString(stdname));
      }
   }
   ucnv_close(uconv);
   Rf_setAttrib(vals, R_NamesSymbol, names);
   UNPROTECT(2);
   return vals;
}



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
   int* buf = (int*)R_alloc(bufsize, sizeof(int));

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
      memcpy(INTEGER(conv), buf, sizeof(int)*k);
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
 */
SEXP stri_encode(SEXP str, SEXP from, SEXP to, SEXP to_raw)
{
   const char* selected_from = stri__prepare_arg_enc(from, "from", true);
   const char* selected_to   = stri__prepare_arg_enc(to, "to", true);
   bool to_raw_logical = stri__prepare_arg_logical_1_notNA(to_raw, "to_raw");

   // check is args passed are OK
   if (Rf_isVectorList(str)) {
      R_len_t nv = LENGTH(str);
      for (R_len_t i=0; i<nv; ++i) {
         SEXP cur = VECTOR_ELT(str, i);
         if (isNull(cur))
            continue;
         if (!isRaw(cur))  // this cannot be treated with stri_prepare_arg*, as str may be a mem-shared object
            Rf_error(MSG__ARG_EXPECTED_RAW_NO_COERCION, "str[[i]]");  // error() allowed here

      }
   }
   else
      str = stri_prepare_arg_string(str, "str");

   // get number of strings to convert, if == 0, then you know what's the result
   R_len_t ns = LENGTH(str);
   if (ns <= 0) return Rf_allocVector(to_raw_logical?VECSXP:STRSXP, 0);
   bool is_vector_arg = (bool)(Rf_isVectorList(str));

   UConverter* uconv_from = NULL;
   UConverter* uconv_to = NULL;

   STRI__ERROR_HANDLER_BEGIN
   // Open converters
   uconv_from = stri__ucnv_open(selected_from);
   uconv_to = stri__ucnv_open(selected_to);

   // Get target encoding mark
   UErrorCode err = U_ZERO_ERROR;
   const char* uconv_to_name = ucnv_getName(uconv_to, &err);
   if (U_FAILURE(err))
      throw StriException(err);
   cetype_t encmark_to = CE_BYTES; // all other cases than the below ones - bytes enc (this is reasonable, isn't it?)
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
   PROTECT(ret = Rf_allocVector(to_raw_logical?VECSXP:STRSXP, ns));

   String8 buf(0);

   for (R_len_t i=0; i<ns; ++i) {
      SEXP curs;
      bool isNA = false;
      const char* curd = 0;
      if (is_vector_arg) {
         curs = VECTOR_ELT(str, i);
         if (isNull(curs)) isNA = true;
         else curd = (const char*)RAW(curs);
      }
      else {
         curs = STRING_ELT(str, i);
         if (curs == NA_STRING) isNA = true;
         else curd = (const char*)CHAR(curs);
      }

      if (isNA) {
         if (to_raw_logical) SET_VECTOR_ELT(ret, i, R_NilValue);
         else                SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }

      R_len_t curn = LENGTH(curs);

      err = U_ZERO_ERROR;
      UnicodeString encs(curd, curn, uconv_from, err); // FROM -> UTF-16 [this is the slow part]
      if (U_FAILURE(err))
         throw StriException(err);  // error() allowed here

      R_len_t bufneed = encs.length()*ucnv_getMaxCharSize(uconv_to)+1;
      buf.resize(bufneed);

      err = U_ZERO_ERROR;
      bufneed = encs.extract(buf.data(), buf.size(), uconv_to, err); // UTF-16 -> TO
      if (bufneed > buf.size()) { // larger buffer needed
//         warning("buf extending");
         buf.resize(bufneed);
         err = U_ZERO_ERROR;
         bufneed = encs.extract(buf.data(), buf.size(), uconv_to, err);
         if (U_FAILURE(err))
            throw StriException(err);
         if (bufneed > buf.size())
            throw StriException(MSG__INTERNAL_ERROR);
      }

      if (to_raw_logical) {
         SEXP outobj = Rf_allocVector(RAWSXP, bufneed);
         memcpy(RAW(outobj), buf.data(), bufneed);
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


/** Detect encoding and language
 * 
 * @param str character;
 * @param filter_angle_brackets logical;
 * 
 * @return list
 * 
 * @version 0.1 (2013-08-03) Marek Gagolewski
 */
SEXP stri_enc_detect(SEXP str, SEXP filter_angle_brackets)
{
   Rf_error("TO DO");
}

