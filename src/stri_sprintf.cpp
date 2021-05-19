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


#define STRI_SPRINTF_TYPE_INTEGER 1
#define STRI_SPRINTF_TYPE_REAL 2
#define STRI_SPRINTF_TYPE_CHARACTER 3

/*
dioxX
feEgGaA
s
%

%<FLAGS><MINIMUM FIELD WIDTH><PRECISION><CONVERSION SPECIFIER>

%i$... instead of %... - which argument is taken (indexed starting from 1)
*j$ instead of *


<m> field_width
    A negative field width is taken as a '-' flag followed by a positive field width.
<.n> precision
    precision "." == ".0"
A negative precision is taken as if the precision were  omitted.   This
       gives  the minimum number of digits to appear for d, i, o, u, x, and X conver‐
       sions, the number of digits to appear after the radix character for a,  A,  e,
       E,  f, and F conversions, the maximum number of significant digits for g and G
       conversions, or the maximum number of characters to be printed from  a  string
       for s and S conversions.


There can be two asterisks, right?


'-' pad_right
'0' pad_zero   # always off (ignored) if pad_right

' ' sign_space
'+' sign_plus  # overrides sign_space if set
'#' alternate_output


default precision???
default field width???
*/



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

    std::vector< StriContainerInteger* > x_integer(narg, nullptr);
    std::vector< StriContainerDouble* > x_double(narg, nullptr);
    std::vector< StriContainerUTF8* > x_character(narg, nullptr);

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

//     MSG__ARG_NEED_MORE
//     int stri__width_string(const char* str_cur_s, int str_cur_n)

// stri_prepare_arg_double(x, "...", false/*factors_as_strings*/)

    }

    for (R_len_t j=0; j<narg; ++j) {
        if (x_integer[j] != nullptr)
            delete x_integer[j];
        if (x_double[j] != nullptr)
            delete x_double[j];
        if (x_character[j] != nullptr)
            delete x_character[j];
    }

    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
