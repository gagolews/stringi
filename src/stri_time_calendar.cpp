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
   PROTECT(cl = Rf_allocVector(STRSXP, 2));
   // SET_STRING_ELT(cl, 0, Rf_mkChar("POSIXst"));
   SET_STRING_ELT(cl, 0, Rf_mkChar("POSIXct"));
   SET_STRING_ELT(cl, 1, Rf_mkChar("POSIXt"));
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
 * @param tz
 * @param locale
 *
 * @return POSIXst
 *
 * @version 0.5-1 (Marek Gagolewski, 2014-12-30)
 * @version 0.5-1 (Marek Gagolewski, 2015-03-06) tz arg added
 */
SEXP stri_datetime_add(SEXP time, SEXP value, SEXP units, SEXP tz, SEXP locale) {
   PROTECT(time = stri_prepare_arg_POSIXct(time, "time"));
   PROTECT(value = stri_prepare_arg_integer(value, "value"));
   if (!isNull(tz)) PROTECT(tz = stri_prepare_arg_string_1(tz, "tz"));
   else             PROTECT(tz); /* needed to set tzone attrib */

   R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(time), LENGTH(value));

   const char* units_val = stri__prepare_arg_string_1_notNA(units, "units");
   const char* units_opts[] = {"years", "months", "weeks", "days", "hours", "minutes", "seconds", "milliseconds", NULL};
   int units_cur = stri__match_arg(units_val, units_opts);

   const char* locale_val = stri__prepare_arg_locale(locale, "locale", true);

   TimeZone* tz_val = stri__prepare_arg_timezone(tz, "tz", true/*allowdefault*/);

   Calendar* cal = NULL;
   STRI__ERROR_HANDLER_BEGIN(3)
   StriContainerDouble time_cont(time, vectorize_length);
   StriContainerInteger value_cont(value, vectorize_length);

   UCalendarDateFields units_field;
   switch (units_cur) {
      case 0: units_field = UCAL_YEAR;                   break;
      case 1: units_field = UCAL_MONTH;                  break;
      case 2: units_field = UCAL_WEEK_OF_YEAR;           break;
      case 3: units_field = UCAL_DAY_OF_MONTH;           break;
      case 4: units_field = UCAL_HOUR_OF_DAY;            break;
      case 5: units_field = UCAL_MINUTE;                 break;
      case 6: units_field = UCAL_SECOND;                 break;
      case 7: units_field = UCAL_MILLISECOND;            break;
      default: throw StriException(MSG__INCORRECT_MATCH_OPTION, "units");
   }

   UErrorCode status = U_ZERO_ERROR;
   cal = Calendar::createInstance(locale_val, status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   cal->adoptTimeZone(tz_val);
   tz_val = NULL; /* The Calendar takes ownership of the TimeZone. */

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(REALSXP, vectorize_length));
   double* ret_val = REAL(ret);
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (time_cont.isNA(i) || value_cont.isNA(i)) {
         ret_val[i] = NA_REAL;
         continue;
      }
      status = U_ZERO_ERROR;
      cal->setTime((UDate)(time_cont.get(i)*1000.0), status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      status = U_ZERO_ERROR;
      cal->add(units_field, value_cont.get(i), status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      status = U_ZERO_ERROR;
      ret_val[i] = ((double)cal->getTime(status))/1000.0;
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
   }

   if (!isNull(tz)) Rf_setAttrib(ret, Rf_ScalarString(Rf_mkChar("tzone")), tz);
   stri__set_class_POSIXct(ret);
   if (tz_val) { delete tz_val; tz_val = NULL; }
   if (cal) { delete cal; cal = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      if (tz_val) { delete tz_val; tz_val = NULL; }
      if (cal) { delete cal; cal = NULL; }
   })
}


/**
 * Get values of date-time fields
 *
 * @param time
 * @param locale
 * @param tz
 *
 * @return list
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-01-01)
 * @version 0.5-1 (Marek Gagolewski, 2015-03-03) tz arg added
 */
SEXP stri_datetime_fields(SEXP time, SEXP tz, SEXP locale) {
   PROTECT(time = stri_prepare_arg_POSIXct(time, "time"));
   const char* locale_val = stri__prepare_arg_locale(locale, "locale", true);
   if (!isNull(tz)) PROTECT(tz = stri_prepare_arg_string_1(tz, "tz"));
   else             PROTECT(tz); /* needed to set tzone attrib */

   TimeZone* tz_val = stri__prepare_arg_timezone(tz, "tz", true/*allowdefault*/);
   Calendar* cal = NULL;
   STRI__ERROR_HANDLER_BEGIN(2)
   R_len_t vectorize_length = LENGTH(time);
   StriContainerDouble time_cont(time, vectorize_length);

   UErrorCode status = U_ZERO_ERROR;
   cal = Calendar::createInstance(locale_val, status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   cal->adoptTimeZone(tz_val);
   tz_val = NULL; /* The Calendar takes ownership of the TimeZone. */

   SEXP ret;
#define STRI__FIELDS_NUM 14
   STRI__PROTECT(ret = Rf_allocVector(VECSXP, STRI__FIELDS_NUM));
   for (R_len_t j=0; j<STRI__FIELDS_NUM; ++j)
      SET_VECTOR_ELT(ret, j, Rf_allocVector(INTSXP, vectorize_length));

   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (time_cont.isNA(i)) {
         for (R_len_t j=0; j<STRI__FIELDS_NUM; ++j)
            INTEGER(VECTOR_ELT(ret, j))[i] = NA_INTEGER;
         continue;
      }

      status = U_ZERO_ERROR;
      cal->setTime((UDate)(time_cont.get(i)*1000.0), status);
      STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

      for (R_len_t j=0; j<STRI__FIELDS_NUM; ++j) {
         UCalendarDateFields units_field;
         switch (j) {
            case 0:  units_field = UCAL_EXTENDED_YEAR;          break;
            case 1:  units_field = UCAL_MONTH;                  break;
            case 2:  units_field = UCAL_DAY_OF_MONTH;           break;
            case 3:  units_field = UCAL_HOUR_OF_DAY;            break;
            case 4:  units_field = UCAL_MINUTE;                 break;
            case 5:  units_field = UCAL_SECOND;                 break;
            case 6:  units_field = UCAL_MILLISECOND;            break;
            case 7:  units_field = UCAL_WEEK_OF_YEAR;           break;
            case 8:  units_field = UCAL_WEEK_OF_MONTH;          break;
            case 9:  units_field = UCAL_DAY_OF_YEAR;            break;
            case 10: units_field = UCAL_DAY_OF_WEEK;            break;
            case 11: units_field = UCAL_HOUR;                   break;
            case 12: units_field = UCAL_AM_PM;                  break;
            case 13: units_field = UCAL_ERA;                    break;
            default: throw StriException(MSG__INCORRECT_MATCH_OPTION, "units");
         }
         //UCAL_IS_LEAP_MONTH
         //UCAL_MILLISECONDS_IN_DAY -> SecondsInDay

         // UCAL_AM_PM -> "AM" or "PM" (localized? or factor?+index in stri_datetime_symbols) add arg use_symbols????
         // UCAL_DAY_OF_WEEK -> (localized? or factor?) SUNDAY, MONDAY
         // UCAL_DAY_OF_YEAR '

         // isWekend

         status = U_ZERO_ERROR;
         INTEGER(VECTOR_ELT(ret, j))[i] = cal->get(units_field, status);
         STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

         if (units_field == UCAL_MONTH)      ++INTEGER(VECTOR_ELT(ret, j))[i]; // month + 1
         else if (units_field == UCAL_AM_PM) ++INTEGER(VECTOR_ELT(ret, j))[i]; // ampm + 1
         else if (units_field == UCAL_ERA)   ++INTEGER(VECTOR_ELT(ret, j))[i]; // era + 1
      }
   }

   stri__set_names(ret, STRI__FIELDS_NUM,
      "Year", "Month", "Day", "Hour", "Minute", "Second", "Millisecond",
      "WeekOfYear", "WeekOfMonth","DayOfYear", "DayOfWeek", "Hour12", "AmPm", "Era");
   if (tz_val) { delete tz_val; tz_val = NULL; }
   if (cal) { delete cal; cal = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      if (tz_val) { delete tz_val; tz_val = NULL; }
      if (cal) { delete cal; cal = NULL; }
   })
}


/**
 * Create a date-time object
 *
 * @param year
 * @param month
 * @param day
 * @param hours
 * @param minutes
 * @param seconds
 * @param tz
 * @param lenient
 * @param locale
 *
 * @return POSIXct
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-01-01)
 * @version 0.5-1 (Marek Gagolewski, 2015-01-11) lenient arg added
 * @version 0.5-1 (Marek Gagolewski, 2015-03-02) tz arg added
 * @version 1.1.2 (Marek Gagolewski, 2016-09-30) round() is not C++98
 */
SEXP stri_datetime_create(SEXP year, SEXP month, SEXP day, SEXP hour,
   SEXP minute, SEXP second, SEXP lenient, SEXP tz, SEXP locale)
{
   PROTECT(year = stri_prepare_arg_integer(year, "year"));
   PROTECT(month = stri_prepare_arg_integer(month, "month"));
   PROTECT(day = stri_prepare_arg_integer(day, "day"));
   PROTECT(hour = stri_prepare_arg_integer(hour, "hour"));
   PROTECT(minute = stri_prepare_arg_integer(minute, "minute"));
   PROTECT(second = stri_prepare_arg_double(second, "second"));
   const char* locale_val = stri__prepare_arg_locale(locale, "locale", true);
   bool lenient_val = stri__prepare_arg_logical_1_notNA(lenient, "lenient");
   if (!isNull(tz)) PROTECT(tz = stri_prepare_arg_string_1(tz, "tz"));
   else             PROTECT(tz); /* needed to set tzone attrib */

   R_len_t vectorize_length = stri__recycling_rule(true, 6,
      LENGTH(year), LENGTH(month), LENGTH(day),
      LENGTH(hour), LENGTH(minute), LENGTH(second));

   TimeZone* tz_val = stri__prepare_arg_timezone(tz, "tz", true/*allowdefault*/);
   Calendar* cal = NULL;
   STRI__ERROR_HANDLER_BEGIN(7)
   StriContainerInteger year_cont(year, vectorize_length);
   StriContainerInteger month_cont(month, vectorize_length);
   StriContainerInteger day_cont(day, vectorize_length);
   StriContainerInteger hour_cont(hour, vectorize_length);
   StriContainerInteger minute_cont(minute, vectorize_length);
   StriContainerDouble second_cont(second, vectorize_length);

   UErrorCode status = U_ZERO_ERROR;
   cal = Calendar::createInstance(locale_val, status);
   STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

   cal->setLenient(lenient_val);

   cal->adoptTimeZone(tz_val);
   tz_val = NULL; /* The Calendar takes ownership of the TimeZone. */

   SEXP ret;
   STRI__PROTECT(ret = Rf_allocVector(REALSXP, vectorize_length));
   double* ret_val = REAL(ret);
   for (R_len_t i=0; i<vectorize_length; ++i) {
      if (year_cont.isNA(i) || month_cont.isNA(i)  || day_cont.isNA(i) ||
          hour_cont.isNA(i) || minute_cont.isNA(i) || second_cont.isNA(i)) {
         ret_val[i] = NA_REAL;
         continue;
      }

      cal->set(UCAL_EXTENDED_YEAR, year_cont.get(i));
      cal->set(UCAL_MONTH, month_cont.get(i)-1);
      cal->set(UCAL_DATE, day_cont.get(i));
      cal->set(UCAL_HOUR_OF_DAY, hour_cont.get(i));
      cal->set(UCAL_MINUTE, minute_cont.get(i));
      cal->set(UCAL_SECOND, (int)floor(second_cont.get(i)));
      cal->set(UCAL_MILLISECOND, (int)fround((second_cont.get(i)-floor(second_cont.get(i)))*1000.0, 0));

      status = U_ZERO_ERROR;
      ret_val[i] = ((double)cal->getTime(status))/1000.0;
      if (U_FAILURE(status)) REAL(ret)[i] = NA_REAL;
   }

   if (!isNull(tz)) Rf_setAttrib(ret, Rf_ScalarString(Rf_mkChar("tzone")), tz);
   stri__set_class_POSIXct(ret);
   if (tz_val) { delete tz_val; tz_val = NULL; }
   if (cal) { delete cal; cal = NULL; }
   STRI__UNPROTECT_ALL
   return ret;
   STRI__ERROR_HANDLER_END({
      if (tz_val) { delete tz_val; tz_val = NULL; }
      if (cal) { delete cal; cal = NULL; }
   })
}


/**
 * @param x list
 * @return POSIXst
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-03-07)
 */
SEXP stri_c_posixst(SEXP x) {
   if (!Rf_isVectorList(x)) Rf_error(MSG__INTERNAL_ERROR);
   if (NAMED(x) != 0)  Rf_error(MSG__INTERNAL_ERROR);
   R_len_t n = LENGTH(x);
   R_len_t m = 0;
   for (R_len_t i=0; i<n; ++i) {
      SET_VECTOR_ELT(x, i, stri_prepare_arg_POSIXct(VECTOR_ELT(x, i), "..."));
      m += LENGTH(VECTOR_ELT(x, i));
   }
   SEXP ret;
   PROTECT(ret = Rf_allocVector(REALSXP, m));
   double* ret_val = REAL(ret);
   R_len_t k = 0;
   for (R_len_t i=0; i<n; ++i) {
      R_len_t ni = LENGTH(VECTOR_ELT(x, i));
      double* xi_val = REAL(VECTOR_ELT(x, i));
      for (R_len_t j=0; j<ni; ++j)
         ret_val[k++] = xi_val[j];
   }

   // @TODO: tz?
   stri__set_class_POSIXct(ret);
   UNPROTECT(1);
   return ret;
}
