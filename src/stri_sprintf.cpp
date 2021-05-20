/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2021, Marek Gagolewski <https://www.gagolewski.com>
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
#include "stri_container_integer.h"
#include "stri_container_logical.h"
#include "stri_container_double.h"
#include "stri_string8buf.h"
#include <cstring>
#include <vector>



#define STRI_SPRINTF_SPEC_INTEGER "dioxX"
#define STRI_SPRINTF_SPEC_DOUBLE "feEgGaA"
#define STRI_SPRINTF_SPEC_STRING "s"

#define STRI_SPRINTF_SPEC_TYPE (STRI_SPRINTF_SPEC_INTEGER \
                                STRI_SPRINTF_SPEC_DOUBLE  \
                                STRI_SPRINTF_SPEC_STRING)

#define STRI_SPRINTF_FLAGS "-+ 0#"


typedef enum {
    STRI_SPRINTF_TYPE_UNDEFINED=0,
    STRI_SPRINTF_TYPE_INTEGER,
    STRI_SPRINTF_TYPE_DOUBLE,
    STRI_SPRINTF_TYPE_STRING,
} StriSprintfType;


struct StriSprintfFormatSpec
{
    StriSprintfType type;
    bool pad_from_right;   // '-'
    bool pad_zero;         // '0'
    bool sign_space;       // ' '
    bool sign_plus;        // '+'
    bool alternate_output; // '#'
    int min_width;
    int precision;         // can be negative

    StriSprintfFormatSpec(char type_spec)
    {
        if (strchr(STRI_SPRINTF_SPEC_INTEGER, type_spec) != nullptr)
            type = STRI_SPRINTF_TYPE_INTEGER;
        else if (strchr(STRI_SPRINTF_SPEC_DOUBLE, type_spec) != nullptr)
            type = STRI_SPRINTF_TYPE_DOUBLE;
        else
            type = STRI_SPRINTF_TYPE_STRING;

        pad_from_right = false;
        pad_zero = false;
        sign_space = false;
        sign_plus = false;
        alternate_output = false;
        min_width = NA_INTEGER;
        precision = NA_INTEGER;
        // eEfFgG - default precision = 6
        // aA - default precision = depends on the input
        // dioxX - default precision = 1
        // s - default precision - unspecified

        // gG uses eE if precision <= exponent < -4
    }


    void normalise()
    {
        if (min_width != NA_INTEGER && min_width < 0) {
            min_width = -min_width;
            pad_from_right = true;
        }

        if (min_width == 0)
            min_width = NA_INTEGER;

        if (precision != NA_INTEGER && precision < 0)
            precision = NA_INTEGER;

        if (pad_from_right)
            pad_zero = false;

        if (sign_plus)
            sign_space = false;
    }
};


/**
 * stops right after delim, modifies j0 in place
 */
int stri__atoi_to_delim(const char* f, R_len_t& j0, char delim, int max_val=99999)
{
    int val = (int)f[j0++]-(int)'\0';
    while (true) {
        if (f[j0] == delim) { j0++; break; }

        if (f[j0] < '0' || f[j0] > '9')
            throw StriException(MSG__INVALID_FORMAT_STRING, f);

        val = val*10 + ((int)f[j0++]-(int)'\0');
        if (val > max_val)
            throw StriException(MSG__INVALID_FORMAT_STRING, f);
    }
    return val;
}


/**
 * stops at non-digit, modifies j0 in place
 */
int stri__atoi_to_other(const char* f, R_len_t& j0, int max_val=99999)
{
    int val = (int)f[j0++]-(int)'\0';
    while (true) {
        if (f[j0] < '0' || f[j0] > '9')
            break;

        val = val*10 + ((int)f[j0++]-(int)'\0');
        if (val > max_val)
            throw StriException(MSG__INVALID_FORMAT_STRING, f);
    }
    return val;
}


/**
 * preflight - get possible format spec
 * throws an error on any chars in [^0-9*$. +0#-]
 *
 * @returns index of the first char in STRI_SPRINTF_SPEC_TYPE
 */
int stri__find_type_spec(const char* f, R_len_t j1, R_len_t n)
{
    while (true) {
        if (j1 >= n)
            throw StriException(MSG__INVALID_FORMAT_STRING, f); // dangling %...
        else if (strchr(STRI_SPRINTF_SPEC_TYPE, f[j1]) != nullptr)
            break;
        else if (strchr(STRI_SPRINTF_FLAGS, f[j1]) != nullptr)
            ;
        else if (f[j1] == '*' || f[j1] == '$' || f[j1] == '.')
            ;
        else if (f[j1] >= '0' && f[j1] <= '9')
            ;
        else
            throw StriException(MSG__INVALID_FORMAT_STRING, f);

        j1++;
    }
}



/*


s
%

start: 123$ / none
flags
width: none / 123 / * / *123$
precision: none / .123 / . / .* / .123$

%i$... instead of %... - which argument is taken (indexed starting from 1)
*j$ instead of *


<m> field_width
    A negative field width is taken as a '-' flag followed by a positive field width.
<.n> precision
    precision "." == ".0"
A negative precision is taken as if the precision were  omitted.   This
       gives  the minimum number of digits to appear for d, i, o, u, x, and X conver-
       sions, the number of digits to appear after the radix character for a,  A,  e,
       E,  f, and F conversions, the maximum number of significant digits for g and G
       conversions, or the maximum number of characters to be printed from  a  string
       for s and S conversions.


There can be two asterisks, right?

default precision???
default field width???
*/


/** Enables fetching of the i-th/next integer/real/string datum from `...`.
 *
 * @version 1.6.2 (Marek Gagolewski, 2021-05-20)
 */
class StriSprintfDataProvider
{
private:
    SEXP x;  // protected outside
    R_len_t narg;
    R_len_t vectorize_length;
    std::vector< StriContainerInteger* > x_integer;
    std::vector< StriContainerDouble* > x_double;
    std::vector< StriContainerUTF8* > x_string;
    R_len_t nprotect;
    R_len_t cur_elem;  // 0..vectorize_length-1
    R_len_t cur_item;  // 0..narg-1

public:
    StriSprintfDataProvider(SEXP x, R_len_t vectorize_length) :
        x(x),
        narg(LENGTH(x)),
        vectorize_length(vectorize_length),
        x_integer(narg, nullptr),
        x_double(narg, nullptr),
        x_string(narg, nullptr),
        nprotect(0)
    {
        STRI_ASSERT(Rf_isVectorList(x));
        cur_elem = -1;
    }

    ~StriSprintfDataProvider()
    {
        for (R_len_t j=0; j<narg; ++j) {
            if (x_integer[j] != nullptr) {
                delete x_integer[j];
            }
            if (x_double[j] != nullptr) {
                delete x_double[j];
            }
            if (x_string[j] != nullptr) {
                delete x_string[j];
            }
        }
        if (nprotect > 0) UNPROTECT(nprotect);
    }

    void reset(R_len_t elem) {
        cur_elem = elem;
        cur_item = 0;
    }


    /** Gets the next (i negative) or the i-th integer datum
     *  Can be NA, so check with ... == NA_INTEGER.
     */
    int getIntegerOrNA(int i=-1)
    {
        if (i < 0) i = (cur_item++);
        // else do not advance cur_item
        if (i >= narg) throw StriException(MSG__ARG_NEED_MORE);

        if (x_integer[i] == nullptr) {
            SEXP y;
            // the following may call Rf_error:
            PROTECT(y = stri_prepare_arg_integer(VECTOR_ELT(x, i), "...",
                false/*factors_as_strings*/, false/*allow_error*/));
            nprotect++;
            if (isNull(y)) throw StriException(MSG__ARG_EXPECTED_INTEGER, "...");
            x_integer[i] = new StriContainerInteger(y, vectorize_length);
        }

        return x_integer[i]->getNAble(cur_elem);
    }



    /** Gets the next (i negative) or the i-th real datum;
     *  Can be NA, so check with ISNA(...).
     */
    double getDoubleOrNA(int i=-1)
    {
        if (i < 0) i = (cur_item++);
        // else do not advance cur_item
        if (i >= narg) throw StriException(MSG__ARG_NEED_MORE);

        if (x_double[i] == nullptr) {
            SEXP y;
            // the following may call Rf_error:
            PROTECT(y = stri_prepare_arg_double(VECTOR_ELT(x, i), "...",
                false/*factors_as_strings*/, false/*allow_error*/));
            nprotect++;
            if (isNull(y)) throw StriException(MSG__ARG_EXPECTED_NUMERIC, "...");
            x_double[i] = new StriContainerDouble(y, vectorize_length);
        }

        return x_double[i]->getNAble(cur_elem);
    }


    /** Gets the next (i negative) or the i-th real datum
     *  Can be NA, so check with ....isNA().
     */
    const String8& getStringOrNA(int i=-1)
    {
        if (i < 0) i = (cur_item++);
        // else do not advance cur_item
        if (i >= narg) throw StriException(MSG__ARG_NEED_MORE);

        if (x_string[i] == nullptr) {
            SEXP y;
            // the following may call Rf_error:
            PROTECT(y = stri_prepare_arg_string(VECTOR_ELT(x, i), "...",
                false/*allow_error*/));
            nprotect++;
            if (isNull(y)) throw StriException(MSG__ARG_EXPECTED_STRING, "...");
            x_string[i] = new StriContainerUTF8(y, vectorize_length);
        }

        return x_string[i]->getNAble(cur_elem);
    }
};



SEXP stri__sprintf_1(
    const String8& _f,
    StriSprintfDataProvider& data,
    const String8& na_string,
    const String8& inf_string,
    const String8& nan_string,
    bool use_length
) {
    STRI_ASSERT(!_f.isNA());
    R_len_t n = _f.length();
    const char* f = _f.c_str();

    std::string buf;
    buf.reserve(n+1); // whatever; maybe there are no format specifiers at all

    R_len_t i=0;
    while (i < n) {
        if (f[i] != '%') { buf.push_back(f[i++]); continue; }

        i++;
        if (i >= n) throw StriException(MSG__INVALID_FORMAT_STRING, f); // dangling %
        if (f[i] == '%') { buf.push_back('%'); i++; continue; }

        // pre-flight stage:
        R_len_t j0 = i;  // start
        R_len_t j1 = stri__find_type_spec(f, i, n);  // stop
        i = j1+1; // in the next iteration, start right after the format spec
        // now f[j0..j1] may be a format specifier (without the preceding %)

        StriSprintfFormatSpec spec(f[j1]);
        // %<DATUM INDEX$><FLAGS><FIELD WIDTH><.PRECISION><CONVERSION SPECIFIER>
        //       1            2        3           4            5 == f[j1]

        // 1. optional [1-9][0-9]*\$  - which datum is to be formatted?
        int which_datum = -1;
        if (f[j0] >= '1' && f[j0] <= '9') {
            // we expect arg pos spec now
            which_datum = stri__atoi_to_delim(
                f, /*by reference*/j0, /*delimiter*/'$'
            );
        }

        // 2. optional flags [ +0#-]
        while (true) {
            if      (f[j0] == ' ') spec.sign_space       = true;
            else if (f[j0] == '+') spec.sign_plus        = true;
            else if (f[j0] == '0') spec.pad_zero         = true;
            else if (f[j0] == '-') spec.pad_from_right   = true;
            else if (f[j0] == '#') spec.alternate_output = true;
            else break;
            j0++;
        }

        // 3. optional field width: none / 123 / * / *123$
        if (f[j0] >= '1' && f[j0] <= '9') {
            spec.min_width = stri__atoi_to_other(f, /*by reference*/j0);
        }
        else if (f[j0] == '*') {  // take from ... args
            j0++;
            int which_width = -1;
            if (f[j0] >= '1' && f[j0] <= '9') {
                which_width = stri__atoi_to_delim(
                    f, /*by reference*/j0, /*delimiter*/'$'
                );
            }
            spec.min_width = data.getIntegerOrNA(which_width);
        }

        // 4. optional field precision: none / .123 / . / .* / .123$
        if (f[j0] == '.') {
            j0++;
            if (f[j0] >= '1' && f[j0] <= '9') {
                spec.precision = stri__atoi_to_other(f, /*by reference*/j0);
            }
            else if (f[j0] == '*') {  // take from ... args
                j0++;
                int which_precision = -1;
                if (f[j0] >= '1' && f[j0] <= '9') {
                    which_precision = stri__atoi_to_delim(
                        f, /*by reference*/j0, /*delimiter*/'$'
                    );
                }
                spec.precision = data.getIntegerOrNA(which_precision);
            }
            else {
                ; // unspecified
            }
        }

        // now we should be at the conversion specifier
        if (j0 != j1)
            throw StriException(MSG__INVALID_FORMAT_STRING, f);

        spec.normalise();

        // which_datum
//         if (use_length_val) width = str.countCodePoints();
//         else width = stri__width_string(str.c_str(), str.length())
    }
//              NA_STRING
//         MSG__INVALID_FORMAT_STRING
    return NA_STRING;
}


/**
 * Format a string
 *
 * vectorized over format and each vector in x
 *
 * @param format character vector
 * @param x list of vectors
 * @param na_string single string, can be NA
 * @param inf_string single string
 * @param nan_string single string
 * @param use_length single logical value
 * @return character vector
 *
 * @version 1.6.3 (Marek Gagolewski, 2021-05-18)
*/
SEXP stri_sprintf(SEXP format, SEXP x, SEXP na_string,
    SEXP inf_string, SEXP nan_string, SEXP use_length)
{
    bool use_length_val = stri__prepare_arg_logical_1_notNA(use_length, "use_length");
    PROTECT(x = stri_prepare_arg_list(x, "x"));
    PROTECT(format = stri_prepare_arg_string(format, "format"));
    PROTECT(na_string = stri_prepare_arg_string_1(na_string, "na_string"));
    PROTECT(inf_string = stri_prepare_arg_string_1(inf_string, "inf_string"));
    PROTECT(nan_string = stri_prepare_arg_string_1(nan_string, "nan_string"));

    R_len_t format_length = LENGTH(format);
    R_len_t vectorize_length = format_length;
    R_len_t narg = LENGTH(x);

    // TODO: allow for the Unicode plus and minus
    // TODO: ICU number format  1,234.567 / 1 234,567 / etc.

    for (R_len_t j=0; j<narg; j++) {
        if (isNull(VECTOR_ELT(x, j))) {
            vectorize_length = 0;
            continue;
        }

        if (!Rf_isVector(VECTOR_ELT(x, j)))
            Rf_error(MSG__ARG_EXPECTED_VECTOR, "..."); // error() allowed here

        if (vectorize_length > 0) {
            R_len_t cur_length = LENGTH(VECTOR_ELT(x, j));
            if (cur_length <= 0)
                vectorize_length = 0;
            else if (vectorize_length < cur_length)
                vectorize_length = cur_length;
        }
    }

    if (vectorize_length <= 0) {
        UNPROTECT(5);
        return Rf_allocVector(STRSXP, 0);
    }

    // ASSERT: vectorize_length > 0
    // ASSERT: all elements in x are meet Rf_isVector(VECTOR_ELT(x, j))

    if (vectorize_length % format_length != 0)
        Rf_warning(MSG__WARN_RECYCLING_RULE);

    for (R_len_t j=0; j<narg; j++)
        if (vectorize_length % LENGTH(VECTOR_ELT(x, j)) != 0)
            Rf_warning(MSG__WARN_RECYCLING_RULE);

    STRI__ERROR_HANDLER_BEGIN(5)
    StriContainerUTF8 format_cont(format, vectorize_length);
    StriContainerUTF8 na_string_cont(na_string, 1);
    StriContainerUTF8 inf_string_cont(inf_string, 1);
    StriContainerUTF8 nan_string_cont(nan_string, 1);

    StriSprintfDataProvider data(x, vectorize_length);

    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

    for (
        R_len_t i = format_cont.vectorize_init();
        i != format_cont.vectorize_end();
        i = format_cont.vectorize_next(i)
    ) {
        if (format_cont.isNA(i)) {
            SET_STRING_ELT(ret, i, NA_STRING);
            continue;
        }

        continue;  // !!!!!!!!!!!!!!T.B.D.!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        // The "parsing" of the format string is done from scratch
        // each time and the output strings are generated on the fly.
        // Let's keep the code simple; the possibility of having
        // *-fields of different max widths/numbers of different precisions
        // makes the process quite complicated anyway.
        data.reset(i);


        SEXP out;
        PROTECT(out = stri__sprintf_1(
            format_cont.get(i),
            data,
            na_string_cont.getNAble(0),
            inf_string_cont.getNAble(0),
            nan_string_cont.getNAble(0),
            use_length_val
        ));
        SET_STRING_ELT(ret, i, out);
        UNPROTECT(1);
    }

    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
