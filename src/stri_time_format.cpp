/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2024, Marek Gagolewski <https://www.gagolewski.com/>
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
#include "stri_container_utf8.h"
#include "stri_container_double.h"
#include "stri_container_integer.h"
#include <unicode/calendar.h>
#include <unicode/gregocal.h>
#include <unicode/smpdtfmt.h>


/**
 * Get date format
 *
 * @version 1.6.3 (Marek Gagolewski, 2021-05-24)
 *    refactor from stri_datetime_parse
 */
DateFormat* stri__get_date_format(
    const char* format_val, const char* locale_val, UErrorCode status
) {
    DateFormat* fmt = NULL;

    // "format" may be one of:
    const char* format_opts[] = {
        "date_full", "date_long", "date_medium", "date_short",
        "date_relative_full", "date_relative_long", "date_relative_medium", "date_relative_short",
        "time_full", "time_long", "time_medium", "time_short",
        "time_relative_full", "time_relative_long", "time_relative_medium", "time_relative_short",
        "datetime_full", "datetime_long", "datetime_medium", "datetime_short",
        "datetime_relative_full", "datetime_relative_long", "datetime_relative_medium", "datetime_relative_short",
        NULL
    };
    int format_cur = stri__match_arg(format_val, format_opts);

    if (format_cur >= 0) {
        DateFormat::EStyle style = DateFormat::kNone;
        switch (format_cur % 8) {
        case 0:
            style = DateFormat::kFull;
            break;
        case 1:
            style = DateFormat::kLong;
            break;
        case 2:
            style = DateFormat::kMedium;
            break;
        case 3:
            style = DateFormat::kShort;
            break;
        case 4:
            style = DateFormat::kFullRelative;
            break;
        case 5:
            style = DateFormat::kLongRelative;
            break;
        case 6:
            style = DateFormat::kMediumRelative;
            break;
        case 7:
            style = DateFormat::kShortRelative;
            break;
        default:
            style = DateFormat::kNone;
            break;
        }

        /* ICU 54.1: Relative time styles are not currently supported.  */
        switch (format_cur / 8) {
        case 0:
            fmt = DateFormat::createDateInstance(
                style, Locale::createFromName(locale_val)
            );
            break;

        case 1:
            fmt = DateFormat::createTimeInstance(
                (DateFormat::EStyle)(style & ~DateFormat::kRelative),
                Locale::createFromName(locale_val)
            );
            break;

        case 2:
            fmt = DateFormat::createDateTimeInstance(
                style,
                (DateFormat::EStyle)(style & ~DateFormat::kRelative),
                Locale::createFromName(locale_val)
            );
            break;

        default:
            fmt = NULL;
            break;

        }
    }
    else {
        UnicodeString format_str(format_val);
        fmt = new SimpleDateFormat(
            format_str, Locale::createFromName(locale_val), status
        );
    }

    return fmt;
}


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
 * @version 0.5-1 (Marek Gagolewski, 2015-01-05)
 * @version 0.5-1 (Marek Gagolewski, 2015-02-22) use tz
 * @version 1.6.3 (Marek Gagolewski, 2021-05-24) #434: vectorise wrt format
 */
SEXP stri_datetime_format(SEXP time, SEXP format, SEXP tz, SEXP locale)
{
    const char* locale_val = stri__prepare_arg_locale(locale, "locale");
    PROTECT(time = stri__prepare_arg_POSIXct(time, "time"));
    PROTECT(format = stri__prepare_arg_string(format, "format"));

    R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(time), LENGTH(format));
    if (vectorize_length <= 0) {
        UNPROTECT(2);
        return Rf_allocVector(STRSXP, 0);
    }

    TimeZone* tz_val = stri__prepare_arg_timezone(tz, "tz", true/*allowdefault*/);
    Calendar* cal = NULL;
    DateFormat* fmt = NULL;

    STRI__ERROR_HANDLER_BEGIN(2)
    StriContainerDouble time_cont(time, vectorize_length);
    StriContainerUTF8 format_cont(format, vectorize_length);

    cal = stri__get_calendar(locale_val);

    cal->adoptTimeZone(tz_val);
    tz_val = NULL; /* The Calendar takes ownership of the TimeZone. */

    UErrorCode status = U_ZERO_ERROR;
    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

    const String8* format_last = NULL; // this will allow for formatter reuse
    for (R_len_t i = format_cont.vectorize_init();
            i != format_cont.vectorize_end();
            i = format_cont.vectorize_next(i))
    {
        if (time_cont.isNA(i) || format_cont.isNA(i)) {
            SET_STRING_ELT(ret, i, NA_STRING);
            continue;
        }

        const String8* format_cur = &(format_cont.get(i));
        if (format_cur != format_last) {
            // well, no reuse possible - resetting
            format_last = format_cur;

            if (fmt) {
                delete fmt;
                fmt = NULL;
            }

            status = U_ZERO_ERROR;
            fmt = stri__get_date_format(format_cur->c_str(), locale_val, status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
        }

        status = U_ZERO_ERROR;
        cal->setTime((UDate)(time_cont.get(i)*1000.0), status);
        STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

        FieldPosition pos;
        UnicodeString out;
        fmt->format(*cal, out, pos);

        std::string s;
        out.toUTF8String(s);
        SET_STRING_ELT(ret, i, Rf_mkCharLenCE(s.c_str(), (int)s.length(), (cetype_t)CE_UTF8));
    }

    if (tz_val) {
        delete tz_val;
        tz_val = NULL;
    }
    if (fmt) {
        delete fmt;
        fmt = NULL;
    }
    if (cal) {
        delete cal;
        cal = NULL;
    }
    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END({
        if (tz_val) {
            delete tz_val;
            tz_val = NULL;
        }
        if (fmt) {
            delete fmt;
            fmt = NULL;
        }
        if (cal) {
            delete cal;
            cal = NULL;
        }
    })
}


/**
 * Parse date-time objects
 *
 * @param str
 * @param format
 * @param tz
 * @param lenient
 * @param locale
 *
 * @return character vector
 *
 * @version 0.5-1 (Marek Gagolewski, 2015-01-08)
 * @version 0.5-1 (Marek Gagolewski, 2015-01-11) lenient arg added
 * @version 0.5-1 (Marek Gagolewski, 2015-02-22) use tz
 * @version 0.5-1 (Marek Gagolewski, 2015-03-01) set tzone attrib on retval
 * @version 1.6.3 (Marek Gagolewski, 2021-05-24) #434: vectorise wrt format
 * @version 1.6.3 (Marek Gagolewski, 2021-06-07) empty retval should have a class too
 * @version 1.8.1 (Marek Gagolewski, 2023-11-08) #469: default time is midnight today
 */
SEXP stri_datetime_parse(SEXP str, SEXP format, SEXP lenient, SEXP tz, SEXP locale)
{
    const char* locale_val = stri__prepare_arg_locale(locale, "locale");
    PROTECT(str = stri__prepare_arg_string(str, "str"));
    PROTECT(format = stri__prepare_arg_string(format, "format"));
    bool lenient_val = stri__prepare_arg_logical_1_notNA(lenient, "lenient");
    if (!Rf_isNull(tz)) PROTECT(tz = stri__prepare_arg_string_1(tz, "tz"));
    else                PROTECT(tz); /* needed to set tzone attrib */

    R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(format));
    if (vectorize_length <= 0) {
        SEXP ret;
        PROTECT(ret = Rf_allocVector(REALSXP, 0));
        if (!Rf_isNull(tz))
            Rf_setAttrib(ret, Rf_ScalarString(Rf_mkChar("tzone")), tz);
        stri__set_class_POSIXct(ret);
        UNPROTECT(4);
        return ret;
    }

    TimeZone* tz_val = stri__prepare_arg_timezone(tz, "tz", true/*allowdefault*/);
    Calendar* cal = NULL;
    DateFormat* fmt = NULL;
    STRI__ERROR_HANDLER_BEGIN(3)
    StriContainerUTF16 str_cont(str, vectorize_length);
    StriContainerUTF8 format_cont(format, vectorize_length);

    cal = stri__get_calendar(locale_val);

    cal->adoptTimeZone(tz_val);
    tz_val = NULL; /* The Calendar takes ownership of the TimeZone. */

    cal->setLenient(lenient_val);

    UDate now = cal->getNow();

    UErrorCode status = U_ZERO_ERROR;
    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(REALSXP, vectorize_length));

    const String8* format_last = NULL; // this will allow for formatter reuse
    for (R_len_t i = format_cont.vectorize_init();
            i != format_cont.vectorize_end();
            i = format_cont.vectorize_next(i))
    {
        if (str_cont.isNA(i) || format_cont.isNA(i)) {
            REAL(ret)[i] = NA_REAL;
            continue;
        }

        const String8* format_cur = &(format_cont.get(i));
        if (format_cur != format_last) {
            // well, no reuse possible - resetting
            format_last = format_cur;

            if (fmt) {
                delete fmt;
                fmt = NULL;
            }

            status = U_ZERO_ERROR;
            fmt = stri__get_date_format(format_cur->c_str(), locale_val, status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
        }

        status = U_ZERO_ERROR;
        cal->setTime(now, status);
        STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

        // weirdly, all the time fields must be reset
        cal->clear(UCAL_MILLISECOND);
        cal->clear(UCAL_SECOND);
        cal->clear(UCAL_MINUTE);
        cal->clear(UCAL_AM_PM);
        cal->clear(UCAL_HOUR);
        cal->clear(UCAL_HOUR_OF_DAY);
        cal->clear(UCAL_MILLISECONDS_IN_DAY);

        ParsePosition pos;
        fmt->parse(str_cont.get(i), *cal, pos);

        if (pos.getErrorIndex() >= 0)
            REAL(ret)[i] = NA_REAL;
        else {
            status = U_ZERO_ERROR;
            REAL(ret)[i] = ((double)cal->getTime(status))/1000.0;
            if (U_FAILURE(status)) REAL(ret)[i] = NA_REAL;
        }
    }


    if (!Rf_isNull(tz))
        Rf_setAttrib(ret, Rf_ScalarString(Rf_mkChar("tzone")), tz);
    stri__set_class_POSIXct(ret);
    if (tz_val) {
        delete tz_val;
        tz_val = NULL;
    }
    if (fmt) {
        delete fmt;
        fmt = NULL;
    }
    if (cal) {
        delete cal;
        cal = NULL;
    }
    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END({
        if (tz_val) {
            delete tz_val;
            tz_val = NULL;
        }
        if (fmt) {
            delete fmt;
            fmt = NULL;
        }
        if (cal) {
            delete cal;
            cal = NULL;
        }
    })
}




/**
 * Converts a single strptime/strftime format to the one used by ICU
 *
 * @param x
 * @return a single R string
 */
SEXP stri__datetime_fstr_1(const String8& _x)
{
    STRI_ASSERT(!_x.isNA());
    R_len_t n = _x.length();
    const char* x = _x.c_str();

    std::string buf;
    buf.reserve(n+1);  // whatever

    R_len_t i=0;
    bool literal_substring = false;
    while (i < n) {
        // consume everything up to the next '%'
        if (x[i] == '\'') {
            if (!literal_substring) {
                literal_substring = true;
                buf.push_back('\'');
            }
            buf.push_back('\\');
            buf.push_back('\'');
            i++;
            continue;
        }

        if (x[i] != '%') {
            if (!literal_substring) {
                literal_substring = true;
                buf.push_back('\'');
            }

            buf.push_back(x[i]);
            i++;
            continue;
        }

        // '%' found.
        i++;
        if (i >= n)  // dangling %
            throw StriException(MSG__INVALID_FORMAT_SPECIFIER, "");

        // if "%%", then output '%' and continue looking for the next '%'
        if (x[i] == '%') {
            if (!literal_substring) {
                literal_substring = true;
                buf.push_back('\'');
            }
            buf.push_back('%');
            i++;
            continue;
        }

        if (literal_substring) {
            literal_substring = false;
            buf.push_back('\'');
        }

        char spec = x[i++];
        switch (spec) {
            case 'U':
            case 'V':
            case 'x':
            case 'X':
            case 'u':
            case 'w':
            case 'r':
            case 'g':
            case 'G':
            case 'c':
            Rf_warning(MSG__PROBLEMATIC_FORMAT_SPECIFIER_CHAR, spec);
            break;

            default:
            break;
        }

        switch (spec) {
            case 'U': buf.append("ww"                     ); break;
            case 'W': buf.append("ww"                     ); break;
            case 'g': buf.append("yy"                     ); break;
            case 'G': buf.append("Y"                      ); break;
            case 'a': buf.append("ccc"                    ); break;
            case 'A': buf.append("cccc"                   ); break;
            case 'b': buf.append("MMM"                    ); break;
            case 'B': buf.append("MMMM"                   ); break;
            case 'c': buf.append("eee MMM d HH:mm:ss yyyy"); break;
            case 'd': buf.append("dd"                     ); break;
            case 'D': buf.append("MM/dd/yy"               ); break;
            case 'e': buf.append("d"                      ); break;
            case 'F': buf.append("yyyy-MM-dd"             ); break;
            case 'h': buf.append("MMM"                    ); break;
            case 'H': buf.append("HH"                     ); break;
            case 'I': buf.append("hh"                     ); break;
            case 'j': buf.append("D"                      ); break;
            case 'm': buf.append("MM"                     ); break;
            case 'M': buf.append("mm"                     ); break;
            case 'n': buf.append("\n"                     ); break;
            case 'p': buf.append("a"                      ); break;
            case 'r': buf.append("hh:mm:ss"               ); break;
            case 'R': buf.append("HH:mm"                  ); break;
            case 'S': buf.append("ss"                     ); break;
            case 't': buf.append("\t"                     ); break;
            case 'T': buf.append("HH:mm:ss"               ); break;
            case 'u': buf.append("c"                      ); break;
            case 'V': buf.append("ww"                     ); break;
            case 'w': buf.append("c"                      ); break;
            case 'x': buf.append("yy/MM/dd"               ); break;
            case 'X': buf.append("HH:mm:ss"               ); break;
            case 'y': buf.append("yy"                     ); break;
            case 'Y': buf.append("yyyy"                   ); break;
            case 'z': buf.append("Z"                      ); break;
            case 'Z': buf.append("z"                      ); break;

            default:
                throw StriException(MSG__INVALID_FORMAT_SPECIFIER_SUB, 1, x+i-1);
        }
    }

    if (literal_substring) {
        literal_substring = false;
        buf.push_back('\'');
    }

    return Rf_mkCharLenCE(buf.data(), buf.size(), CE_UTF8);
}



/**
 * Convert %Y-%m-%d to yyyy'-'MM'-'dd and stuff (for strptime/strftime <-> ICU)
 *
 * @param x character vector
 *
 * @return character vector
 *
 * @version 1.6.4 (Marek Gagolewski, 2021-06-07)
 */
SEXP stri_datetime_fstr(SEXP x)
{
    PROTECT(x = stri__prepare_arg_string(x, "x"));
    R_len_t vectorize_length = LENGTH(x);
    if (vectorize_length <= 0) {
        UNPROTECT(1);
        return Rf_allocVector(STRSXP, 0);
    }

    STRI__ERROR_HANDLER_BEGIN(1)
    StriContainerUTF8 x_cont(x, vectorize_length);

    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

    for (
        R_len_t i = x_cont.vectorize_init();
        i != x_cont.vectorize_end();
        i = x_cont.vectorize_next(i)
    ) {
        if (x_cont.isNA(i)) {
            SET_STRING_ELT(ret, i, NA_STRING);
            continue;
        }

        SEXP out;
        STRI__PROTECT(out = stri__datetime_fstr_1(x_cont.get(i)));
        SET_STRING_ELT(ret, i, out);
        STRI__UNPROTECT(1);
    }

    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
