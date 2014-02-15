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


// ------------------------------------------------------------------------


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
 * @version 0.1 (Marek Gagolewski, 2013-08-10)
 */
void STRI__UCNV_TO_U_CALLBACK_SUBSTITUTE_WARN (
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
 * @version 0.1 (Marek Gagolewski, 2013-08-10)
 */
void STRI__UCNV_FROM_U_CALLBACK_SUBSTITUTE_WARN (
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


/** Open UConverter for given character encoding
 *
 *  If the converted could be opened, then an error is generated.
 *
 *  @param enc encoding name or NULL for default encoding (please,
 *       use \code{stri__prepare_arg_enc()})
 *  @return opened UConverter* (must be closed manually after use)
 *
 * @version 0.1 (Marek Gagolewski)
 * @version 0.2 (Marek Gagolewski, 2013-08-10) Use own error callbacks
 */
UConverter* stri__ucnv_open(const char* enc)
{
   UErrorCode err = U_ZERO_ERROR;
   UConverter* uconv = NULL;

   uconv = ucnv_open(enc, &err);
   if (U_FAILURE(err))
      Rf_error(MSG__ENC_ERROR_SET); // error() allowed here

   ucnv_setFromUCallBack((UConverter*)uconv,
      (UConverterFromUCallback)STRI__UCNV_FROM_U_CALLBACK_SUBSTITUTE_WARN,
      (const void *)NULL, (UConverterFromUCallback *)NULL,
      (const void **)NULL,
      &err);
   if (U_FAILURE(err))
      Rf_error(MSG__ENC_ERROR_SET); // error() allowed here

   ucnv_setToUCallBack  ((UConverter*)uconv,
      (UConverterToUCallback)STRI__UCNV_TO_U_CALLBACK_SUBSTITUTE_WARN,
      (const void *)NULL,
      (UConverterToUCallback *)NULL,
      (const void **)NULL,
      &err);
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
   standards = (const char**)R_alloc(cs, (int)sizeof(const char*)); // will be freed automatically

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
   UErrorCode err = U_ZERO_ERROR;

   // set default fallbacks
   ucnv_setFromUCallBack(uconv, UCNV_FROM_U_CALLBACK_SUBSTITUTE, NULL, NULL, NULL, &err);
   if (U_FAILURE(err))
      Rf_error(MSG__ENC_ERROR_SET); // error() allowed here

   ucnv_setToUCallBack  (uconv, UCNV_TO_U_CALLBACK_SUBSTITUTE,   NULL, NULL, NULL, &err);
   if (U_FAILURE(err))
      Rf_error(MSG__ENC_ERROR_SET); // error() allowed here

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
