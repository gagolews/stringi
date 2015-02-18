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
   TimeZone* curtz = stri__prepare_arg_timezone(tz, "tz", /*allowdefault*/false);

   /* This call adopts the TimeZone object passed in;
      the client is no longer responsible for deleting it. */
   TimeZone::adoptDefault(curtz);

   return R_NilValue;
}


/** Get localized time zone info
 *
 * @param tz single string or NULL
 * @param locale single string or NULL
 * @return list
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-24)
 */
SEXP stri_timezone_info(SEXP tz, SEXP locale) {
   TimeZone* curtz = stri__prepare_arg_timezone(tz, "tz", /*allowdefault*/true);
   const char* qloc = stri__prepare_arg_locale(locale, "locale", true); /* this is R_alloc'ed */

   // ID -> UnicodeString getID (UnicodeString &ID)
   // Name -> UnicodeString &    getDisplayName (const Locale &locale, UnicodeString &result) const
   // RawOffset -> int getRawOffset (void) const =0 [ms]
   // UsesDaylightTime -> UBool useDaylightTime (void) const =0

   const R_len_t infosize = 4;
   SEXP vals;

   PROTECT(vals = Rf_allocVector(VECSXP, infosize));
   for (int i=0; i<infosize; ++i)
      SET_VECTOR_ELT(vals, i, R_NilValue);

   UnicodeString val1;
   std::string val2;

   curtz->getID(val1);
   val1.toUTF8String(val2);
   SET_VECTOR_ELT(vals, 0, Rf_allocVector(STRSXP, 1));
   SET_STRING_ELT(VECTOR_ELT(vals, 0), 0, Rf_mkCharCE(val2.c_str(), CE_UTF8));

   // @TODO: ICU >= 52
//   UnicodeString id = val1;
//   UErrorCode err = U_ZERO_ERROR;
//   TimeZone::getWindowsID(id, val1, err);
//   val2.clear();
//   val1.toUTF8String(val2);
//   SET_VECTOR_ELT(vals, 2, Rf_mkString(val2.c_str()));

   curtz->getDisplayName(Locale::createFromName(qloc), val1);
   val2.clear();
   val1.toUTF8String(val2);
   SET_VECTOR_ELT(vals, 1, Rf_allocVector(STRSXP, 1));
   SET_STRING_ELT(VECTOR_ELT(vals, 1), 0, Rf_mkCharCE(val2.c_str(), CE_UTF8));

   SET_VECTOR_ELT(vals, 2, Rf_ScalarReal(curtz->getRawOffset()/1000.0/3600.0));
   SET_VECTOR_ELT(vals, 3, Rf_ScalarLogical((bool)curtz->useDaylightTime()));

   delete curtz;
   stri__set_names(vals, 4, "ID", "Name", /*"WindowsID",*/ "RawOffset", "UsesDaylightTime");
   UNPROTECT(1);
   return vals;
}
