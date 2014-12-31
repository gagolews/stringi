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
#include "stri_container_double.h"
#include "stri_container_integer.h"
#include <unicode/calendar.h>
#include <unicode/gregocal.h>

/** Set POSIXct class on a given object
 *
 * @param x R object
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-29)
 */
void stri__set_class_POSIXct(SEXP x) {
   SEXP cl;
   PROTECT(cl = Rf_allocVector(STRSXP, 3));
   SET_STRING_ELT(cl, 0, Rf_mkChar("POSIXst"));
   SET_STRING_ELT(cl, 1, Rf_mkChar("POSIXct"));
   SET_STRING_ELT(cl, 2, Rf_mkChar("POSIXt"));
   Rf_setAttrib(x, R_ClassSymbol, cl);
   UNPROTECT(1);
}


/** Get current date-time
 *
 * @return POSIXct
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-29)
 */
SEXP stri_datetime_now()
{
   UDate now = Calendar::getNow();
   SEXP ret;
   PROTECT(ret = Rf_ScalarReal(((double)now)/1000.0)); // msec.->sec.
   stri__set_class_POSIXct(ret);
   UNPROTECT(1);
   return ret;
}


/** Date-time artithmetic
 *
 * @param time
 * @param value
 * @param units
 * @param calendar
 *
 * @return POSIXct
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-30)
 */
SEXP stri_datetime_add(SEXP time, SEXP value, SEXP units, SEXP /*calendar*/) {
   PROTECT(time = stri_prepare_arg_POSIXct(time, "time"));
   PROTECT(value = stri_prepare_arg_integer(value, "value"));
   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(time), LENGTH(value));
   if (vectorize_length <= 0) {
      SEXP ret;
      PROTECT(ret = Rf_allocVector(REALSXP, 0));
      stri__set_class_POSIXct(ret);
      UNPROTECT(3);
      return ret;
   }

   const char* units_val = stri__prepare_arg_string_1_notNA(units, "units");
   const char* units_opts[] = {"years", "months", "weeks", "days", "hours", "minutes", "seconds", "milliseconds", NULL};
   int units_cur = stri__match_arg(units_val, units_opts);

//   const char* calendar_val = stri__prepare_arg_string_1_notNA(calendar, "calendar");
//   const char* calendar_opts[] = {"gregorian", NULL};
//   int calendar_cur = stri__match_arg(calendar_val, calendar_opts);

   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerDouble time_cont(time, vectorize_length);
   StriContainerInteger value_cont(value, vectorize_length);

   UCalendarDateFields units_field;
   switch (units_cur) {
      case 0: units_field = UCAL_YEAR;                   break;
      case 1: units_field = UCAL_MONTH;                  break;
      case 2: units_field = UCAL_WEEK_OF_YEAR;           break;
      case 3: units_field = UCAL_DAY_OF_MONTH;           break;
      case 4: units_field = UCAL_HOUR;                   break;
      case 5: units_field = UCAL_MINUTE;                 break;
      case 6: units_field = UCAL_SECOND;                 break;
      case 7: units_field = UCAL_MILLISECOND;            break;
      default: throw StriException(MSG__INCORRECT_MATCH_OPTION, "units");
   }

   // Question: add locale?
   // Question: consider tzone?

   UErrorCode status = U_ZERO_ERROR;
   GregorianCalendar cal(status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   SEXP ret;
   PROTECT(ret = Rf_allocVector(REALSXP, vectorize_length));
   double* ret_val = REAL(ret);
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (time_cont.isNA(i) || value_cont.isNA(i)) {
         ret_val[i] = NA_REAL;
         continue;
      }
      status = U_ZERO_ERROR;
      cal.setTime((UDate)(time_cont.get(i)*1000.0), status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      status = U_ZERO_ERROR;
      cal.add(units_field, value_cont.get(i), status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      status = U_ZERO_ERROR;
      ret_val[i] = ((double)cal.getTime(status))/1000.0;
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   }

   Rf_setAttrib(ret, Rf_ScalarString(Rf_mkChar("tzone")), Rf_getAttrib(time, Rf_ScalarString(Rf_mkChar("tzone"))));
   stri__set_class_POSIXct(ret);
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
