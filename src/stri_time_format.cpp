/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2015, Marek Gagolewski and Bartek Tartanus
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
#include "stri_container_utf16.h"
#include "stri_container_double.h"
#include "stri_container_integer.h"
#include <unicode/calendar.h>
#include <unicode/gregocal.h>
#include <unicode/smpdtfmt.h>


/**
 * Format date-time objects
 * 
 * @param time
 * @param format
 * @param tz
 * @param locale
 * 
 * @return character vector
 * 
 * @version 0.5-1 (Marek Gagolewski, 2015-01-03)
 */
SEXP stri_datetime_format(SEXP time, SEXP format, SEXP tz, SEXP locale) {
   PROTECT(time = stri_prepare_arg_POSIXct(time, "time"));
   const char* format_val = stri__prepare_arg_string_1_notNA(format, "format");
   const char* locale_val = stri__prepare_arg_locale(locale, "locale", true);
   
   Calendar* cal = NULL;
   STRI__ERROR_HANDLER_BEGIN(1)
   R_len_t vectorize_length = LENGTH(time);
   StriContainerDouble time_cont(time, vectorize_length);
   UnicodeString format_str(format_val);
   
   UErrorCode status = U_ZERO_ERROR;
   SimpleDateFormat fmt(format_str, Locale::createFromName(locale_val), status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   
   status = U_ZERO_ERROR;
   Calendar* cal = Calendar::createInstance(locale_val, status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   
   /* TO DO:
   void    adoptTimeZone (TimeZone *value)
 	Sets the calendar's time zone to be the one passed in. 
    */

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (time_cont.isNA(i)) {
         SET_STRING_ELT(ret, i, NA_STRING);
         continue;
      }
      
      status = U_ZERO_ERROR;
      cal->setTime((UDate)(time_cont.get(i)*1000.0), status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      
      FieldPosition pos;
      UnicodeString out;
      fmt.format(*cal, out, pos);
      
      std::string s;
      out.toUTF8String(s);
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(s.c_str(), (int)s.length(), (cetype_t)CE_UTF8));
   }

   if (cal) { delete cal; cal = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      if (cal) { delete cal; cal = NULL; }
   })
}
