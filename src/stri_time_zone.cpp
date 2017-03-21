/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2017, Marek Gagolewski and other contributors.
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
#include <unicode/strenum.h>
#include <string>


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
   STRI__CHECKICUSTATUS_RFERROR(status, {/* do nothing special on err */})

   status = U_ZERO_ERROR;
   tz_enum->reset(status);
   STRI__CHECKICUSTATUS_RFERROR(status, {/* do nothing special on err */})

   status = U_ZERO_ERROR;
   R_len_t n = (R_len_t)tz_enum->count(status);
   STRI__CHECKICUSTATUS_RFERROR(status, {/* do nothing special on err */})

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(STRSXP, n));

//   SEXP nam;
//   STRI__PROTECT(nam = Rf_allocVector(STRSXP, n));

   // MG: I reckon that IDs are more readable than DisplayNames (which are moreover localized)
   for (R_len_t i=0; i<n; ++i) {
      int len;
      status = U_ZERO_ERROR;
      const char* cur = tz_enum->next(&len, status);
      STRI__CHECKICUSTATUS_RFERROR(status, {/* do nothing special on err */})
      SET_STRING_ELT(ret, i, Rf_mkCharLenCE(cur, len, CE_UTF8));

//      TimeZone* curtz = TimeZone::createTimeZone(UnicodeString::fromUTF8(cur));
//      UnicodeString curdn;
//      curtz->getDisplayName(locale, curdn);
//      delete curtz;
//      string out;
//      curdn.toUTF8String(out);
//      SET_STRING_ELT(nam, i, Rf_mkCharCE(out.c_str(), CE_UTF8));
   }

//   Rf_setAttrib(ret, R_NamesSymbol, nam);

   if (tz_enum) { delete tz_enum; tz_enum = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(
      if (tz_enum) { delete tz_enum; tz_enum = NULL; }
   )
}


///** Get default time zone
// *
// * @return single string
// *
// * @version 0.5-1 (Marek Gagolewski, 2014-12-24)
// */
//SEXP stri_timezone_get() {
//   TimeZone* curtz = stri__prepare_arg_timezone(R_NilValue, "tz", /*allowdefault*/true);
//
//   UnicodeString id;
//   curtz->getID(id);
//   delete curtz;
//
//   std::string id2;
//   id.toUTF8String(id2);
//
//   return Rf_mkString(id2.c_str());
//}


/** Set default time zone
 *
 * @param tz single string
 * @return nothing
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-24)
 */
SEXP stri_timezone_set(SEXP tz) {
   TimeZone* curtz = stri__prepare_arg_timezone(tz, "tz", false/*allowdefault*/);

   /* This call adopts the TimeZone object passed in;
      the client is no longer responsible for deleting it. */
   TimeZone::adoptDefault(curtz);

   return R_NilValue;
}


/** Get localized time zone info
 *
 * @param tz single string or NULL
 * @param locale single string or NULL
 * @param display_type single string
 * @return list
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-24)
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-03-01)
 *    new out: WindowsID, NameDaylight, new in: display_type
 */
SEXP stri_timezone_info(SEXP tz, SEXP locale, SEXP display_type) {
   TimeZone* curtz = stri__prepare_arg_timezone(tz, "tz", R_NilValue);
   const char* qloc = stri__prepare_arg_locale(locale, "locale", true); /* this is R_alloc'ed */
   const char* dtype_str = stri__prepare_arg_string_1_notNA(display_type, "display_type"); /* this is R_alloc'ed */
   const char* dtype_opts[] = {
      "short", "long", "generic_short", "generic_long", "gmt_short", "gmt_long",
      "common", "generic_location",
      NULL};
   int dtype_cur = stri__match_arg(dtype_str, dtype_opts);

   TimeZone::EDisplayType dtype;
   switch (dtype_cur) {
      case 0:  dtype = TimeZone::SHORT; break;
      case 1:  dtype = TimeZone::LONG; break;
      case 2:  dtype = TimeZone::SHORT_GENERIC; break;
      case 3:  dtype = TimeZone::LONG_GENERIC; break;
      case 4:  dtype = TimeZone::SHORT_GMT; break;
      case 5:  dtype = TimeZone::LONG_GMT; break;
      case 6:  dtype = TimeZone::SHORT_COMMONLY_USED; break;
      case 7:  dtype = TimeZone::GENERIC_LOCATION; break;
      default: Rf_error(MSG__INCORRECT_MATCH_OPTION, "display_type"); break;
   }

   const R_len_t infosize = 6;
   SEXP vals;

   PROTECT(vals = Rf_allocVector(VECSXP, infosize));
   for (int i=0; i<infosize; ++i)
      SET_VECTOR_ELT(vals, i, R_NilValue);

   R_len_t curidx = -1;

   ++curidx;
   UnicodeString val_ID;
   curtz->getID(val_ID);
   SET_VECTOR_ELT(vals, curidx, stri__make_character_vector_UnicodeString_ptr(1, &val_ID));

   ++curidx;
   UnicodeString val_name;
   curtz->getDisplayName(false, dtype, Locale::createFromName(qloc), val_name);
   SET_VECTOR_ELT(vals, curidx, stri__make_character_vector_UnicodeString_ptr(1, &val_name));

   ++curidx;
   if ((bool)curtz->useDaylightTime()) {
      UnicodeString val_name2;
      curtz->getDisplayName(true, dtype, Locale::createFromName(qloc), val_name2);
      SET_VECTOR_ELT(vals, curidx, stri__make_character_vector_UnicodeString_ptr(1, &val_name2));
   }
   else
      SET_VECTOR_ELT(vals, curidx, Rf_ScalarString(NA_STRING));

   ++curidx;
   UnicodeString val_windows;
   UErrorCode status = U_ZERO_ERROR;
#if U_ICU_VERSION_MAJOR_NUM>=52
   TimeZone::getWindowsID(val_ID, val_windows, status); // Stable since ICU 52
#endif
   if (U_SUCCESS(status) && val_windows.length() > 0)
      SET_VECTOR_ELT(vals, curidx, stri__make_character_vector_UnicodeString_ptr(1, &val_windows));
   else
      SET_VECTOR_ELT(vals, curidx, Rf_ScalarString(NA_STRING));

   ++curidx;
   SET_VECTOR_ELT(vals, curidx, Rf_ScalarReal(curtz->getRawOffset()/1000.0/3600.0));

   ++curidx;
   SET_VECTOR_ELT(vals, curidx, Rf_ScalarLogical((bool)curtz->useDaylightTime()));

   delete curtz;
   stri__set_names(vals, infosize, "ID", "Name", "Name.Daylight", "Name.Windows", "RawOffset", "UsesDaylightTime");
   UNPROTECT(1);
   return vals;
}
