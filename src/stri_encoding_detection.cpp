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
#include <unicode/ucsdet.h>
#include <unicode/locid.h>
#include <unicode/uloc.h>
#include <unicode/locid.h>
#include <unicode/ulocdata.h>
#include <unicode/uniset.h>
#include <map>
#include <vector>
#include <algorithm>
#include "stri_container_listraw.h"
#include "stri_container_logical.h"
#include "stri_ucnv.h"
using namespace std;


/** Check if a string may be valid 8-bit (including UTF-8) encoded
 *
 *  simple check whether all charcodes are nonzero
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or do exact check
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-06)
 *          separate func
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-13)
 *          warnchars count added
 */
double stri__enc_check_8bit(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence) {
   R_len_t warnchars = 0;
   for (R_len_t j=0; j < str_cur_n; ++j) {
      if (str_cur_s[j] == 0)
         return 0.0;
      if (get_confidence && (str_cur_s[j] <= 31 || str_cur_s[j] == 127)) {
         switch (str_cur_s[j]) {
            case 9:  // \t
            case 10: // \n
            case 13: // \r
            case 26: // ASCII SUBSTITUTE
               break; // ignore
            default:
               warnchars++;
         }
      }
   }
   return (get_confidence?(double)warnchars/double(str_cur_n):1.0);
}


/** Check if a string is valid ASCII
 *
 *  simple check whether charcodes are in [1..127]
 * by using U8_IS_SINGLE
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or do exact check
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-06)
 *          separate func
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-13)
 *          warnchars count added
 */
double stri__enc_check_ascii(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence) {
   R_len_t warnchars = 0;
   for (R_len_t j=0; j < str_cur_n; ++j) {
      if (!U8_IS_SINGLE(str_cur_s[j]) || str_cur_s[j] == 0) // i.e. 0 < c <= 127
         return 0.0;
      if (get_confidence && (str_cur_s[j] <= 31 || str_cur_s[j] == 127)) {
         switch (str_cur_s[j]) {
            case 9:  // \t
            case 10: // \n
            case 13: // \r
            case 26: // ASCII SUBSTITUTE
               break; // ignore
            default:
               warnchars++;
         }
      }
   }
   return (get_confidence?(double)(str_cur_n-warnchars)/double(str_cur_n):1.0);
}


/** Check if a string is valid UTF-8
 *
 * checks if a string is probably UTF-8-encoded;
 * simple check with U8_NEXT
 *
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or do exact check
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-06)
 *          separate func
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-13)
 *          confidence calculation basing on ICU's i18n/csrutf8.cpp
 */
double stri__enc_check_utf8(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   if (!get_confidence) {
      UChar32 c;
      for (R_len_t j=0; j < str_cur_n; ) {
         if (str_cur_s[j] == 0)
            return 0.0; // definitely not valid UTF-8

         U8_NEXT(str_cur_s, j, str_cur_n, c);
         if (c < 0) // ICU utf8.h doc for U8_NEXT: c -> output UChar32 variable, set to <0 in case of an error
            return 0.0; // definitely not valid UTF-8
      }
      return 1.0;
   }
   else {
      // Based on ICU's i18n/csrutf8.cpp [with own mods]
      bool hasBOM = (str_cur_n >= 3 &&
            (uint8_t)(str_cur_s[0]) == UTF8_BOM_BYTE1 &&
            (uint8_t)(str_cur_s[1]) == UTF8_BOM_BYTE2 &&
            (uint8_t)(str_cur_s[2]) == UTF8_BOM_BYTE3);
      R_len_t numValid = 0;   // counts only valid UTF-8 multibyte seqs
      R_len_t numInvalid = 0;

      // Scan for multi-byte sequences
      for (R_len_t i=0; i < str_cur_n; i += 1) {
         uint32_t b = str_cur_s[i];

         if ((b & 0x80) == 0) {
            continue;   // ASCII => OK
         }

         // Hi bit on char found.  Figure out how long the sequence should be
         R_len_t trailBytes = 0;
         if ((b & 0x0E0) == 0x0C0)
            trailBytes = 1;
         else if ((b & 0x0F0) == 0x0E0)
            trailBytes = 2;
         else if ((b & 0x0F8) == 0xF0)
            trailBytes = 3;
         else {
            numInvalid += 1;
            if (numInvalid > 5)
                break; // that's enough => not UTF-8
            continue;
         }

         // Verify that we've got the right number of trail bytes in the sequence
         while (true) {
            i += 1;

            if (i >= str_cur_n)
                break;

            b = str_cur_s[i];

            if ((b & 0xC0) != 0x080) {
                numInvalid += 1;
                break;
            }

            if (--trailBytes == 0) {
                numValid += 1;
                break;
            }
         }
      }

      // Cook up some sort of confidence score, based on presense of a BOM
      //    and the existence of valid and/or invalid multi-byte sequences.
      if (hasBOM && numInvalid == 0)
         return 1.0;
      else if (hasBOM && numValid > numInvalid*10)
         return 0.75;
      else if (numValid > 3 && numInvalid == 0)
         return 1.0;
      else if (numValid > 0 && numInvalid == 0)
         return 0.50; // too few multibyte UTF-8 seqs to be quite sure
      else if (numValid == 0 && numInvalid == 0)
         // Plain ASCII. => It's OK for UTF-8
         return 0.50;
      else if (numValid > numInvalid*10)
         // Probably corrupt utf-8 data.  Valid sequences aren't likely by chance.
         return 0.25;
      else
         return 0.0;
   }
}


/** Check if a string is valid UTF-16LE or UTF-16BE
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or do exact check
 * @param le check for UTF-16LE?
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-09)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-14)
 *          confidence calculation basing on ICU's i18n/csucode.cpp
 */
double stri__enc_check_utf16(const char* str_cur_s, R_len_t str_cur_n,
   bool get_confidence, bool le)
{
   if (str_cur_n % 2 != 0)
      return 0.0;

   bool hasLE_BOM = STRI__ENC_HAS_BOM_UTF16LE(str_cur_s, str_cur_n);
   bool hasBE_BOM = STRI__ENC_HAS_BOM_UTF16BE(str_cur_s, str_cur_n);

   if ((!le && hasLE_BOM) || (le && hasBE_BOM))
      return 0.0;

   R_len_t warnchars = 0;

   for (R_len_t i=0; i<str_cur_n; i += 2) {
      uint16_t c = (le)?
                  STRI__GET_INT16_LE(str_cur_s, i):
                  STRI__GET_INT16_BE(str_cur_s, i);

      if (U16_IS_SINGLE(c)) {
         if (c == 0)
            return 0.0;
         else if (c >= 0x0530) // last cyrrilic supplement
            warnchars += 2;
         continue;
      }

      if (!U16_IS_SURROGATE_LEAD(c))
         return 0.0;

      i += 2;
      if (i >= str_cur_n)
         return 0.0;
      c = (le)?
          STRI__GET_INT16_LE(str_cur_s, i):
          STRI__GET_INT16_BE(str_cur_s, i);
      if (!U16_IS_SURROGATE_TRAIL(c))
         return 0.0;
   }

   return (get_confidence?(double)(str_cur_n-warnchars)/double(str_cur_n):1.0);
}


/** Check if a string is valid UTF-16BE
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or to exact check
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-09)
 */
double stri__enc_check_utf16be(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   return stri__enc_check_utf16(str_cur_s, str_cur_n, get_confidence, false);
}


/** Check if a string is valid UTF-16LE
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or do exact check
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-09)
 */
double stri__enc_check_utf16le(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   return stri__enc_check_utf16(str_cur_s, str_cur_n, get_confidence, true);
}


/** Check if a string is valid UTF-32LE or UTF-32BE
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or do exact check
 * @param le check for UTF-32LE?
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-09)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-13)
 *          confidence calculation basing on ICU's i18n/csucode.cpp
 */
double stri__enc_check_utf32(const char* str_cur_s, R_len_t str_cur_n,
   bool get_confidence, bool le)
{
   if (str_cur_n % 4 != 0)
      return 0.0;

   bool hasLE_BOM = STRI__ENC_HAS_BOM_UTF32LE(str_cur_s, str_cur_n);
   bool hasBE_BOM = STRI__ENC_HAS_BOM_UTF32BE(str_cur_s, str_cur_n);

   if ((!le && hasLE_BOM) || (le && hasBE_BOM))
      return 0.0;

   R_len_t numValid = 0;
   R_len_t numInvalid = 0;

   for (R_len_t i=0; i<str_cur_n; i+=4) {
      int32_t ch = le?
         (int32_t)STRI__GET_INT32_LE(str_cur_s, i):
         (int32_t)STRI__GET_INT32_BE(str_cur_s, i);

      if (ch < 0 || ch >= 0x10FFFF || (ch >= 0xD800 && ch <= 0xDFFF)) {
         if (!get_confidence)
            return 0.0;
         else
            numInvalid++;
      }
      else
         numValid++;
   }

   if (!get_confidence)
      return 1.0;

   if ((hasLE_BOM || hasBE_BOM) && numInvalid==0)
      return 1.0;
   else if ((hasLE_BOM || hasBE_BOM) && numValid > numInvalid*10)
      return 0.80;
   else if (numValid > 3 && numInvalid == 0)
      return 1.0;
   else if (numValid > 0 && numInvalid == 0)
      return 0.80;
   else if (numValid > numInvalid*10)
      return 0.25; // Probably corruput UTF-32BE data. Valid sequences aren't likely by chance.
   else
      return 0.0;
}


/** Check if a string is valid UTF-32BE
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or do exact check
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-13)
 */
double stri__enc_check_utf32be(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   return stri__enc_check_utf32(str_cur_s, str_cur_n, get_confidence, false);
}


/** Check if a string is valid UTF-32LE
 *
 * @param str_cur_s character vector
 * @param str_cur_n number of bytes
 * @param get_confidence determine confidence value or do exact check
 *
 * @return confidence value in [0,1]
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-13)
 */
double stri__enc_check_utf32le(const char* str_cur_s, R_len_t str_cur_n, bool get_confidence)
{
   return stri__enc_check_utf32(str_cur_s, str_cur_n, get_confidence, true);
}


/** Which string is in given encoding
 *
 *
 *  @param str character vector or raw vector or list of raw vectors
 *  @param type (single integer, internal)
 *  @return logical vector
 *
 * @version 0.1-?? (Bartek Tartanus)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-08)
 *          use StriContainerListRaw
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-09)
 *          one function for is_*, do dispatch
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_isenc(SEXP str, SEXP type)
{
   if (!Rf_isInteger(type) || LENGTH(type) != 1)
      Rf_error(MSG__INCORRECT_INTERNAL_ARG); // this is an internal arg, check manually, error() allowed here
   int _type = INTEGER(type)[0];
   double (*isenc)(const char*, R_len_t, bool) = NULL;
   switch (_type) {
      case 1:  isenc = stri__enc_check_ascii;   break;
      case 2:  isenc = stri__enc_check_utf8;    break;
      case 3:  isenc = stri__enc_check_utf16be; break;
      case 4:  isenc = stri__enc_check_utf16le; break;
      case 5:  isenc = stri__enc_check_utf32be; break;
      case 6:  isenc = stri__enc_check_utf32le; break;
      default: Rf_error(MSG__INCORRECT_INTERNAL_ARG); // error() call allowed here
   }


   PROTECT(str = stri_prepare_arg_list_raw(str, "str"));

   STRI__ERROR_HANDLER_BEGIN(1)
   StriContainerListRaw str_cont(str);
   R_len_t str_length = str_cont.get_n();

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(LGLSXP, str_length));
   int* ret_tab = LOGICAL(ret); // may be faster than LOGICAL(ret)[i] all the time

   for (R_len_t i=0; i < str_length; ++i) {
      if (str_cont.isNA(i)) {
         ret_tab[i] = NA_LOGICAL;
         continue;
      }

      bool get_confidence = false; // TO BE DONE
      ret_tab[i] = isenc(str_cont.get(i).c_str(), str_cont.get(i).length(), get_confidence) != 0.0;
   }

   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({ /* no-op on error */ })
}


/** Detect encoding and language
 *
 * @param str character vector
 * @param filter_angle_brackets logical vector
 *
 * @return list
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-03)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-08)
 *          use StriContainerListRaw + BUGFIX
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_detect(SEXP str, SEXP filter_angle_brackets)
{
   PROTECT(str = stri_prepare_arg_list_raw(str, "str"));
   PROTECT(filter_angle_brackets = stri_prepare_arg_logical(filter_angle_brackets, "filter_angle_brackets"));

   UCharsetDetector* ucsdet = NULL;


   STRI__ERROR_HANDLER_BEGIN(2)

   UErrorCode status = U_ZERO_ERROR;
   ucsdet = ucsdet_open(&status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   StriContainerListRaw str_cont(str);
   R_len_t str_n = str_cont.get_n();

   R_len_t vectorize_length = stri__recycling_rule(true, 2, str_n, LENGTH(filter_angle_brackets));
   str_cont.set_nrecycle(vectorize_length); // must be set after container creation

   SEXP ret, names, wrong;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

   STRI__PROTECT(names = Rf_allocVector(STRSXP, 3));
   SET_STRING_ELT(names, 0, Rf_mkChar("Encoding"));
   SET_STRING_ELT(names, 1, Rf_mkChar("Language"));
   SET_STRING_ELT(names, 2, Rf_mkChar("Confidence"));

   STRI__PROTECT(wrong = Rf_allocVector(VECSXP, 3));
   SET_VECTOR_ELT(wrong, 0, stri__vector_NA_strings(1));
   SET_VECTOR_ELT(wrong, 1, stri__vector_NA_strings(1));
   SET_VECTOR_ELT(wrong, 2, stri__vector_NA_integers(1));
   Rf_setAttrib(wrong, R_NamesSymbol, names);

   StriContainerLogical filter(filter_angle_brackets, vectorize_length);
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (str_cont.isNA(i) || filter.isNA(i)) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
      }

      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_n     = str_cont.get(i).length();

      status = U_ZERO_ERROR;
      ucsdet_setText(ucsdet, str_cur_s, str_cur_n, &status);
   	STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      ucsdet_enableInputFilter(ucsdet, filter.get(i));

      status = U_ZERO_ERROR;
      int matchesFound;
      const UCharsetMatch** match = ucsdet_detectAll(ucsdet, &matchesFound, &status);
   	if (U_FAILURE(status) || !match || matchesFound <= 0) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
   	}


      SEXP val_enc, val_lang, val_conf;
      STRI__PROTECT(val_enc  = Rf_allocVector(STRSXP, matchesFound));
      STRI__PROTECT(val_lang = Rf_allocVector(STRSXP, matchesFound));
      STRI__PROTECT(val_conf = Rf_allocVector(REALSXP, matchesFound));

      for (R_len_t j=0; j<matchesFound; ++j) {
         status = U_ZERO_ERROR;
         const char* name = ucsdet_getName(match[j], &status);
         if (U_FAILURE(status) || !name)
            SET_STRING_ELT(val_enc, j, NA_STRING);
         else
            SET_STRING_ELT(val_enc, j, Rf_mkChar(name));

         status = U_ZERO_ERROR;
    	   int32_t conf = ucsdet_getConfidence(match[j], &status);
         if (U_FAILURE(status))
            REAL(val_conf)[j] = NA_REAL;
         else
            REAL(val_conf)[j] = (double)(conf)/100.0;

         status = U_ZERO_ERROR;
    	   const char* lang = ucsdet_getLanguage(match[j], &status);
         if (U_FAILURE(status) || !lang)
            SET_STRING_ELT(val_lang, j, NA_STRING);
         else
            SET_STRING_ELT(val_lang, j, Rf_mkChar(lang));
      }

      SEXP val;
      STRI__PROTECT(val = Rf_allocVector(VECSXP, 3));
      SET_VECTOR_ELT(val, 0, val_enc);
      SET_VECTOR_ELT(val, 1, val_lang);
      SET_VECTOR_ELT(val, 2, val_conf);
      Rf_setAttrib(val, R_NamesSymbol, names);
      SET_VECTOR_ELT(ret, i, val);
      STRI__UNPROTECT(4);
   }

   if (ucsdet) {
      ucsdet_close(ucsdet);
      ucsdet = NULL;
   }
   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END(
      if (ucsdet) {
         ucsdet_close(ucsdet);
         ucsdet = NULL;
      })
}


// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------


/** locale-dependent 8-bit converter check
 *
 * help struct for stri_enc_detect2
 *
 * @version 0.1-??
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-18)
 *          be locale-dependent, use ICU ulocdata
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-11-13)
 *          allow only ASCII-supersets
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          use StriUcnv
 */
struct Converter8bit {
   bool isNA;
   bool countChars[256];
   bool badChars[256];
   const char* name;

   Converter8bit(const char* _name, const UnicodeSet* exset) {
      isNA = true;
      name = NULL;
      StriUcnv ucnv_obj(_name);
      if (!ucnv_obj.is8bit())
         return; // not an 8-bit converter

      //ucnv_obj.setCallBackSubstitute(); // restore default (no warn) callbacks
      UConverter* ucnv = ucnv_obj.getConverter(false);


      // Check which characters in given encoding
      // are not mapped to Unicode [badChars]
      char allChars[256+1]; // all bytes 0-255
      for (R_len_t i=0; i<256; ++i)
         allChars[i] = (char)i;
      allChars[256] = '\0';

      // reset tabs
      for (R_len_t i=0; i<256; ++i) {
         countChars[i] = false;
         badChars[i]   = false;
      }

      UnicodeSet curset;
      std::map<UChar32, uint8_t> curmap;
      const char* text_start = allChars+1;
      const char* text_end   = allChars+256;
      ucnv_reset(ucnv);
      for (R_len_t i=1; i<256; ++i) {
         UErrorCode status = U_ZERO_ERROR;
         UChar32 c = ucnv_getNextUChar(ucnv, &text_start, text_end, &status);
         if (U_FAILURE(status)) {
            return;
         }
         if (i >= 32 && i <= 127 && c != (UChar32)i) {
            // allow only ASCII supersets
            return;
         }

         if (c == UCHAR_REPLACEMENT || c < 0) {
            badChars[i] = true;
         }
         else {
            if (!u_isdefined(c) || u_isalpha(c))
               badChars[i] = true;
            curset.add(c);
            curmap[c] = (uint8_t)i;
         }
      }


      if (!curset.containsAll(*exset)) {
         // not all characters are representable in given encoding
         return;
      }


      // now mark all characters form exset to be counted
      R_len_t exset_size = exset->size();
      for (R_len_t k=0; k<exset_size; ++k) {
         UChar32 c = exset->charAt(k);
         if (c >= 0) {
            uint8_t ind = curmap[c];
            countChars[ind] = true;
         }
      }

      isNA = false;
      this->name = _name;
   }
};


// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------


/** Guesses text encoding; help struct for stri_enc_detect2
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-18)
 *          locale-dependent, use ulocdata
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-11-13)
 *          allow qloc==NULL in 8bit check
 */
struct EncGuess {
   const char* name;
   double confidence;

   EncGuess(const char* _name, double _confidence) {
      name = _name;
      confidence = _confidence;
   }

   bool operator<(const EncGuess& e2) const {
      return (this->confidence > e2.confidence); // decreasing sort
   }

   static void do_utf32(vector<EncGuess>& guesses, const char* str_cur_s,
      R_len_t str_cur_n)
   {
      /* check UTF-32LE, UTF-32BE or UTF-32+BOM */
      double isutf32le = stri__enc_check_utf32le(str_cur_s, str_cur_n, true);
      double isutf32be = stri__enc_check_utf32be(str_cur_s, str_cur_n, true);
      if (isutf32le >= 0.25 && isutf32be >= 0.25) {
         // no BOM, both valid
         // i think this will never happen
         guesses.push_back(EncGuess("UTF-32LE", isutf32le));
         guesses.push_back(EncGuess("UTF-32BE", isutf32be));
      }
      else if (isutf32le >= 0.25) {
         if (STRI__ENC_HAS_BOM_UTF32LE(str_cur_s, str_cur_n))
            guesses.push_back(EncGuess("UTF-32", isutf32le)); // with BOM
         else
            guesses.push_back(EncGuess("UTF-32LE", isutf32le));
      }
      else if (isutf32be >= 0.25) {
         if (STRI__ENC_HAS_BOM_UTF32BE(str_cur_s, str_cur_n))
            guesses.push_back(EncGuess("UTF-32", isutf32be)); // with BOM
         else
            guesses.push_back(EncGuess("UTF-32BE", isutf32be));
      }
   }

   static void do_utf16(vector<EncGuess>& guesses, const char* str_cur_s,
      R_len_t str_cur_n)
   {
      /* check UTF-16LE, UTF-16BE or UTF-16+BOM */
      double isutf16le = stri__enc_check_utf16le(str_cur_s, str_cur_n, true);
      double isutf16be = stri__enc_check_utf16be(str_cur_s, str_cur_n, true);
      if (isutf16le >= 0.25 && isutf16be >= 0.25) {
         // no BOM, both valid
         // this may sometimes happen
         guesses.push_back(EncGuess("UTF-16LE", isutf16le));
         guesses.push_back(EncGuess("UTF-16BE", isutf16be));
      }
      else if (isutf16le >= 0.25) {
         if (STRI__ENC_HAS_BOM_UTF16LE(str_cur_s, str_cur_n))
            guesses.push_back(EncGuess("UTF-16", isutf16le)); // with BOM
         else
            guesses.push_back(EncGuess("UTF-16LE", isutf16le));
      }
      else if (isutf16be >= 0.25) {
         if (STRI__ENC_HAS_BOM_UTF16BE(str_cur_s, str_cur_n))
            guesses.push_back(EncGuess("UTF-16", isutf16be)); // with BOM
         else
            guesses.push_back(EncGuess("UTF-16BE", isutf16be));
      }
   }

   static void do_8bit(vector<EncGuess>& guesses, const char* str_cur_s,
      R_len_t str_cur_n, const char* qloc)
   {
      double is8bit = stri__enc_check_8bit(str_cur_s, str_cur_n, false);
      if (is8bit != 0.0) {
         // may be an 8-bit encoding
         double isascii = stri__enc_check_ascii(str_cur_s, str_cur_n, true);
         if (isascii >= 0.25) // i.e. equal to 1.0 => nothing more to check
            guesses.push_back(EncGuess("ASCII", isascii));
         else {
            // not ascii
            double isutf8 = stri__enc_check_utf8(str_cur_s, str_cur_n, true);
            if (isutf8 >= 0.25)
               guesses.push_back(EncGuess("UTF-8", isutf8));
            if (isutf8 < 1.0 && qloc) {
               do_8bit_locale(guesses, str_cur_s, str_cur_n, qloc);
            }
         }
      }
   }

   static void do_8bit_locale(vector<EncGuess>& guesses, const char* str_cur_s,
      R_len_t str_cur_n, const char* qloc)
   {
      vector<Converter8bit> converters;
      if (!qloc) throw StriException(MSG__INTERNAL_ERROR); // just to be sure

      UErrorCode status = U_ZERO_ERROR;
      ULocaleData* uld = ulocdata_open(qloc, &status);
   	STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      USet* exset_tmp = ulocdata_getExemplarSet(uld, NULL,
         USET_ADD_CASE_MAPPINGS, ULOCDATA_ES_STANDARD, &status);
   	STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      UnicodeSet* exset = UnicodeSet::fromUSet(exset_tmp); // don't delete, just a pointer
      exset->removeAllStrings();


      R_len_t ucnv_count = (R_len_t)ucnv_countAvailable();
      for (R_len_t i=0; i<ucnv_count; ++i) { // for each converter
         Converter8bit conv(StriUcnv::getFriendlyName(ucnv_getAvailableName(i)), exset);
         if (!conv.isNA) converters.push_back(conv);
      }

      uset_close(exset_tmp); exset = NULL;
      ulocdata_close(uld);

      if (converters.size() <= 0)
         return;

      // count all bytes with codes >= 128 in str_cur_s
      R_len_t counts[256];
      R_len_t countsge128 = 0; // total count
      for (R_len_t k=0; k<256; ++k)
         counts[k] = 0; // reset tab
      for (R_len_t j=0; j<str_cur_n; ++j) {
         if ((uint8_t)(str_cur_s[j]) >= (uint8_t)128) {
            counts[(uint8_t)(str_cur_s[j])]++;
            countsge128++;
         }
      }
      // assert: countsge128 > 0 (otherwise ASCII, so this function hasn't been not called)

      std::vector<int> badCounts(converters.size(), 0); // filled with 0
      std::vector<int> desiredCounts(converters.size(),0);
      R_len_t maxDesiredCounts = 0;


      for (R_len_t j=0; j<(R_len_t)converters.size(); ++j) { // for each converter
         for (R_len_t k=128; k<256; ++k) { // for each character
            // 1. Count bytes that are BAD and NOT COUNTED in this encoding
            if (converters[j].badChars[k] && !converters[j].countChars[k]) {
               badCounts[j] += (int)counts[k];
            }
            // 2. Count indicated characters
            if (converters[j].countChars[k]) {
               desiredCounts[j] += (int)counts[k];
            }
         }
         if (desiredCounts[j] > maxDesiredCounts)
            maxDesiredCounts = desiredCounts[j];
      }

      // add guesses
      for (R_len_t j=0; j<(R_len_t)converters.size(); ++j) { // for each converter
         // some heuristic:
         double conf = min(1.0, max(0.0,
               (double)(countsge128-0.5*badCounts[j]-maxDesiredCounts+desiredCounts[j])/
               (double)(countsge128)));
         if (conf > 0.25)
            guesses.push_back(EncGuess(converters[j].name, conf));
      }
   }
};


// -----------------------------------------------------------------------
// -----------------------------------------------------------------------


/** Detect encoding with initial guess
 *
 * @param str character or raw vector or a list of raw vectors
 * @param loc locale id
 *
 * @return list
 *
 * @version 0.1-?? (2013-08-15, Marek Gagolewski)
 *
 * @version 0.1-?? (2013-08-18, Marek Gagolewski)
 *          improved 8-bit confidence measurement,
 *          some code moved to structs, use locale & ICU locdata
 *
 * @version 0.1-?? (2013-11-13, Marek Gagolewski)
 *          added loc NA handling (no locale)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_enc_detect2(SEXP str, SEXP loc)
{
   const char* qloc = /* this is R_alloc'ed */
      stri__prepare_arg_locale(loc, "locale", true, true); // allowdefault, allowna
   // raw vector, character vector, or list of raw vectors:
   PROTECT(str = stri_prepare_arg_list_raw(str, "str"));

   STRI__ERROR_HANDLER_BEGIN(1)

   StriContainerListRaw str_cont(str);
   R_len_t str_n = str_cont.get_n();

   SEXP ret, names, wrong;
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, str_n));

   STRI__PROTECT(names = Rf_allocVector(STRSXP, 3));
   SET_STRING_ELT(names, 0, Rf_mkChar("Encoding"));
   SET_STRING_ELT(names, 1, Rf_mkChar("Language"));
   SET_STRING_ELT(names, 2, Rf_mkChar("Confidence"));

   STRI__PROTECT(wrong = Rf_allocVector(VECSXP, 3));
   SET_VECTOR_ELT(wrong, 0, stri__vector_NA_strings(1));
   SET_VECTOR_ELT(wrong, 1, stri__vector_NA_strings(1));
   SET_VECTOR_ELT(wrong, 2, stri__vector_NA_integers(1));
   Rf_setAttrib(wrong, R_NamesSymbol, names);

   for (R_len_t i=0; i<str_n; ++i) {
      if (str_cont.isNA(i)) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
      }

      const char* str_cur_s = str_cont.get(i).c_str();
      R_len_t str_cur_n     = str_cont.get(i).length();
      if (str_cur_n <= 0) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
      }

      vector<EncGuess> guesses;
      guesses.reserve(6);

      EncGuess::do_utf32(guesses, str_cur_s, str_cur_n);
      EncGuess::do_utf16(guesses, str_cur_s, str_cur_n);
      EncGuess::do_8bit(guesses, str_cur_s, str_cur_n, qloc);  // includes UTF-8

      R_len_t matchesFound = (R_len_t)guesses.size();
      if (matchesFound <= 0) {
         SET_VECTOR_ELT(ret, i, wrong);
         continue;
      }

      std::stable_sort(guesses.begin(), guesses.end());

      SEXP val_enc, val_lang, val_conf;
      STRI__PROTECT(val_enc  = Rf_allocVector(STRSXP, matchesFound));
      STRI__PROTECT(val_lang = Rf_allocVector(STRSXP, matchesFound));
      STRI__PROTECT(val_conf = Rf_allocVector(REALSXP, matchesFound));

      for (R_len_t j=0; j<matchesFound; ++j) {
         SET_STRING_ELT(val_enc, j, Rf_mkChar(guesses[j].name));
         REAL(val_conf)[j] = guesses[j].confidence;
    	   SET_STRING_ELT(val_lang, j, NA_STRING); // always no lang
      }

      SEXP val;
      STRI__PROTECT(val = Rf_allocVector(VECSXP, 3));
      SET_VECTOR_ELT(val, 0, val_enc);
      SET_VECTOR_ELT(val, 1, val_lang);
      SET_VECTOR_ELT(val, 2, val_conf);
      Rf_setAttrib(val, R_NamesSymbol, names);
      SET_VECTOR_ELT(ret, i, val);
      STRI__UNPROTECT(4);
   }

   STRI__UNPROTECT_ALL
   return ret;

   STRI__ERROR_HANDLER_END({ /* no-op on error */ })
}
