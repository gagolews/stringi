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
#include <unicode/timezone.h>
#include <unicode/strenum.h>


/** List available time zone IDs
 *
 * @param offset single numeric
 * @param region single string
 * @return character vector
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-24)
 */
SEXP stri_timezone_list(SEXP region, SEXP offset)
{
   StringEnumeration* tz_enum = NULL;
   PROTECT(region = stri_prepare_arg_string_1(region, "region"));
   PROTECT(offset = stri_prepare_arg_double_1(offset, "offset"));

   STRI__ERROR_HANDLER_BEGIN(2)
   StriContainerUTF8 region_cont(region, 1);

   UErrorCode status = U_ZERO_ERROR;
   
   int32_t offset_hours = 0;
   const int32_t* o = NULL;
   const char* r = NULL;
   
   if (!ISNA(REAL(offset)[0])) {
      // 0.5 and 0.75 are represented exactly within the double type
      offset_hours = (int32_t)(REAL(offset)[0]*1000.0*3600.0);
      o = &offset_hours;
   }
   
   if (!region_cont.isNA(0))
      r = region_cont.get(0).c_str();

   tz_enum = TimeZone::createTimeZoneIDEnumeration(UCAL_ZONE_TYPE_ANY, r, o, status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   
   status = U_ZERO_ERROR;
   tz_enum->reset(status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   status = U_ZERO_ERROR;
   R_len_t n = (R_len_t)tz_enum->count(status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, n));

   // MG: I reckon than IDs are more readable than DisplayNames
   for (R_len_t i=0; i<n; ++i) {
      int len;
      status = U_ZERO_ERROR;
      const char* cur = tz_enum->next(&len, status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(cur, len, CE_UTF8));
   }

   if (tz_enum) { delete tz_enum; tz_enum = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(
      if (tz_enum) { delete tz_enum; tz_enum = NULL; }
   )
}

