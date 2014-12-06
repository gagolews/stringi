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
#include "stri_ucnv.h"


/**
 * Opens (on demand) a desired converter
 *
 * The converter is opened if necessary.
 * @param register_callbacks
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-10)
 *          Use own error callbacks
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          moved to StriUcnv;
 *          throws StriException instead of calling Rf_error
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-01)
 *    don't register callbacks by default
 */
void StriUcnv::openConverter(bool register_callbacks) {
   if (m_ucnv)
      return;

   UErrorCode status = U_ZERO_ERROR;

   m_ucnv = ucnv_open(m_name, &status);
   STRI__CHECKICUSTATUS_THROW(status, { m_ucnv = NULL; })

   if (register_callbacks) {
      status = U_ZERO_ERROR;
      ucnv_setFromUCallBack((UConverter*)m_ucnv,
         (UConverterFromUCallback)STRI__UCNV_FROM_U_CALLBACK_SUBSTITUTE_WARN,
         (const void *)NULL, (UConverterFromUCallback *)NULL,
         (const void **)NULL,
         &status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      status = U_ZERO_ERROR;
      ucnv_setToUCallBack  ((UConverter*)m_ucnv,
         (UConverterToUCallback)STRI__UCNV_TO_U_CALLBACK_SUBSTITUTE_WARN,
         (const void *)NULL,
         (UConverterToUCallback *)NULL,
         (const void **)NULL,
         &status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   }
}


/** Returns a desired converted
 *
 * @return UConverter
 * @param register_callbacks
 *
 * @version 0.2-1 (Marek Gagolewski)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-01)
 *    don't register callbacks by default
 */
UConverter* StriUcnv::getConverter(bool register_callbacks)
{
   openConverter(register_callbacks);
#ifndef NDEBUG
   if (!m_ucnv) throw StriException("!NDEBUG: StriUcnv::getConverter()");
#endif
   return m_ucnv;
}


/** Own fallback function for ucnv conversion: substitute & warn
 *
 *
 * @param context  The function currently recognizes the callback options:
 *                 UCNV_SUB_STOP_ON_ILLEGAL: STOPS at the ILLEGAL_SEQUENCE,
 *                      returning the error code back to the caller immediately.
 *                 NULL: Substitutes any ILLEGAL_SEQUENCE
 * @param toUArgs Information about the conversion in progress
 * @param codeUnits Points to 'length' bytes of the concerned codepage sequence
 * @param length Size (in bytes) of the concerned codepage sequence
 * @param reason Defines the reason the callback was invoked
 * @param err Return value will be set to success if the callback was handled,
 *      otherwise this value will be set to a failure status.
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-10)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          moved to StriUcnv
 */
void StriUcnv::STRI__UCNV_TO_U_CALLBACK_SUBSTITUTE_WARN (
                 const void *context,
                 UConverterToUnicodeArgs *toArgs,
                 const char* codeUnits,
                 int32_t length,
                 UConverterCallbackReason reason,
                 UErrorCode * err)
{
   bool wasSubstitute = (reason <= UCNV_IRREGULAR &&
      (context == NULL || (*((char*)context) == *UCNV_SUB_STOP_ON_ILLEGAL && reason == UCNV_UNASSIGNED)));

   // "DO NOT CALL THIS FUNCTION DIRECTLY!" :>
   UCNV_TO_U_CALLBACK_SUBSTITUTE(context, toArgs, codeUnits, length, reason, err);

   if (*err == U_ZERO_ERROR && wasSubstitute) {
      // substitute char was induced
      switch (length) {
         case 1:  Rf_warning(MSG__UNCONVERTABLE_BINARY_1, codeUnits[0]); break;
         case 2:  Rf_warning(MSG__UNCONVERTABLE_BINARY_2, codeUnits[0], codeUnits[1]); break;
         case 3:  Rf_warning(MSG__UNCONVERTABLE_BINARY_3, codeUnits[0], codeUnits[1], codeUnits[2]); break;
         case 4:  Rf_warning(MSG__UNCONVERTABLE_BINARY_4, codeUnits[0], codeUnits[1], codeUnits[2], codeUnits[3]); break;
         default: Rf_warning(MSG__UNCONVERTABLE_BINARY_n); break;
      }
   }
}


/** Own fallback function for ucnv conversion: substitute & warn
 *
 *
 * @param context The function currently recognizes the callback options:
 *                 UCNV_SUB_STOP_ON_ILLEGAL: STOPS at the ILLEGAL_SEQUENCE,
 *                      returning the error code back to the caller immediately.
 *                 NULL: Substitutes any ILLEGAL_SEQUENCE
 * @param fromUArgs Information about the conversion in progress
 * @param codeUnits Points to 'length' UChars of the concerned Unicode sequence
 * @param length Size (in bytes) of the concerned codepage sequence
 * @param codePoint Single UChar32 (UTF-32) containing the concerend Unicode codepoint.
 * @param reason Defines the reason the callback was invoked
 * @param err Return value will be set to success if the callback was handled,
 *      otherwise this value will be set to a failure status.
 * @see ucnv_setSubstChars
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-08-10)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          moved to StriUcnv
 */
void StriUcnv::STRI__UCNV_FROM_U_CALLBACK_SUBSTITUTE_WARN (
                  const void *context,
                  UConverterFromUnicodeArgs *fromArgs,
                  const UChar* codeUnits,
                  int32_t length,
                  UChar32 codePoint,
                  UConverterCallbackReason reason,
                  UErrorCode * err)
{
   bool wasSubstitute = (reason <= UCNV_IRREGULAR &&
      (context == NULL || (*((char*)context) == *UCNV_SUB_STOP_ON_ILLEGAL && reason == UCNV_UNASSIGNED)));

   // "DO NOT CALL THIS FUNCTION DIRECTLY!" :>
   UCNV_FROM_U_CALLBACK_SUBSTITUTE(context, fromArgs, codeUnits, length, codePoint, reason, err);

   if (*err == U_ZERO_ERROR && wasSubstitute) {
      // substitute char was induced
      Rf_warning(MSG__UNCONVERTABLE_CODE_POINT, codePoint);
   }
}


/**
 * Get ICU ucnv standard names and their count
 *
 * @return vector of strings owned by ICU (don't delete them)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          moved to StriUcnv;
 *          don't use R_alloc;
 *          return vector<const char*>
 */
vector<const char*> StriUcnv::getStandards()
{
   UErrorCode status = U_ZERO_ERROR;
   R_len_t std_n = (R_len_t)ucnv_countStandards()-1; // -1 - this is not documented in ICU4C
   if (std_n <= 0)
      throw StriException(MSG__ENC_ERROR_SET); // error() allowed here
   vector<const char*> standards(std_n);

   for (R_len_t i=0; i<std_n; ++i) {
      status = U_ZERO_ERROR;
      standards[i] = ucnv_getStandard(i, &status);
      if (U_FAILURE(status)) {
#ifndef NDEBUG
         Rf_warning("could not get standard name (StriUcnv::getStandards())");
#endif
         standards[i] = NULL;
      }
   }

   return standards;
}


/**
 * Get friendly encoding name
 *
 * @param canname Canonical (ICU) encoding name
 * @return First existing of: MIME name or JAVA name or Canonical
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          moved to StriUcnv
 */
const char* StriUcnv::getFriendlyName(const char* canname)
{
   if (!canname) return NULL;

   UErrorCode status;
   const char* frname;

   status = U_ZERO_ERROR;
   frname = ucnv_getStandardName(canname, "MIME", &status);
   if (!U_FAILURE(status) && frname)
      return frname;

   status = U_ZERO_ERROR;
   frname = ucnv_getStandardName(canname, "JAVA", &status);
   if (!U_FAILURE(status) && frname)
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
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          moved to StriUcnv
 */
bool StriUcnv::hasASCIIsubset()
{
   openConverter(false);

   // minCharSize, not maxCharSize, as we want to include UTF-8
   if (ucnv_getMinCharSize(m_ucnv) != 1) return false;

   const int ascii_from = 1;
   const int ascii_to   = 127;
   unsigned char ascii[ascii_to-ascii_from+2]; // + \0
   for (int i=ascii_from; i<=ascii_to; ++i)
      ascii[i-ascii_from] = (unsigned char)i;
   ascii[ascii_to-ascii_from+1] = '\0';

   UChar32 c;

   const char* ascii_last = (const char*)ascii;
   const char* ascii1 = (const char*)ascii;
   const char* ascii2 = (const char*)(ascii+(ascii_to-ascii_from)+1);

   ucnv_reset(m_ucnv);

   while (ascii1 < ascii2) {
      UErrorCode status = U_ZERO_ERROR;
      c = ucnv_getNextUChar(m_ucnv, &ascii1, ascii2, &status);
      if (U_FAILURE(status)) {
#ifndef NDEBUG
         Rf_warning("Cannot convert ASCII character 0x%2x (encoding=%s)",
            (int)ascii_last[0],
            ucnv_getName(m_ucnv, &status));
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
         || c != (int)(unsigned char)ascii_last[0]) {
         return false;
      }
      ascii_last = ascii1;
   }

   return true;
}


/**
 * Converts each character (23..255) to UTF-8 and then back to original enc
 * and checks whether it gets the same result
 *
 * This sould be used only on 8-bit converters
 *
 * @param conv ICU charset converter
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-28)
 *          moved to StriUcnv
 */
bool StriUcnv::is1to1Unicode()
{
   openConverter(false);
   if (ucnv_getMinCharSize(m_ucnv) != 1) return false;

   const int ascii_from = 32;
   const int ascii_to = 255;
   unsigned char ascii[ascii_to-ascii_from+2]; // + \0
   for (int i=ascii_from; i<=ascii_to; ++i)
      ascii[i-ascii_from] = (unsigned char)i;
   ascii[ascii_to-ascii_from+1] = '\0';

   UChar32 c;
   const int buflen =  UCNV_GET_MAX_BYTES_FOR_STRING(1, 1); /* const size */
   char buf[buflen];

   const char* ascii_last = (const char*)(ascii);
   const char* ascii1 = (const char*)(ascii);
   const char* ascii2 = (const char*)(ascii+(ascii_to-ascii_from)+1);

   UErrorCode status = U_ZERO_ERROR;
   ucnv_reset(m_ucnv);

   while (ascii1 < ascii2) {
      status = U_ZERO_ERROR;
      c = ucnv_getNextUChar(m_ucnv, &ascii1, ascii2, &status);
      if (U_FAILURE(status)) {
#ifndef NDEBUG
         Rf_warning("Cannot convert character 0x%2x (encoding=%s)",
            (int)(unsigned char)ascii_last[0],
            ucnv_getName(m_ucnv, &status));
#endif
         return false;
      }

      if (ascii_last != ascii1-1) // one byte should be consumed
         return false;

      // check whether the character is represented
      // by a single UTF-16 code point
      UChar lead = U16_LEAD(c); //, trail = U16_TRAIL(c);
      if (!U16_IS_SINGLE(lead)) {
#ifndef NDEBUG
         Rf_warning("Problematic character 0x%2x -> \\u%8x (encoding=%s)",
            (int)ascii_last[0],
            c,
            ucnv_getName(m_ucnv, &status));
#endif
         return false;
      }

      // character not convertable => ignore
      status = U_ZERO_ERROR;
      if (c != UCHAR_REPLACEMENT) {
         ucnv_fromUChars(m_ucnv, buf, buflen, (UChar*)&c, 1, &status);
         if (U_FAILURE(status)) {
#ifndef NDEBUG
            Rf_warning("Cannot convert character 0x%2x (encoding=%s)",
               (int)(unsigned char)ascii_last[0],
               ucnv_getName(m_ucnv, &status));
#endif
            return false;
         }

         if (buf[1] != '\0' || buf[0] != ascii_last[0]) {
#ifndef NDEBUG
            Rf_warning("Problematic character 0x%2x -> \\u%8x -> 0x%2x (encoding=%s)",
               (int)(unsigned char)ascii_last[0],
               c,
               (int)buf[0],
               ucnv_getName(m_ucnv, &status));
#endif
            return false;
         }
      }
      // @TODO: check tolower, toupper etc. (???)

      ascii_last = ascii1;
   }

   return true;
}
