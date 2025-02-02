/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
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


#ifndef __stri_stringi_h
#define __stri_stringi_h

#include "stri_external.h"
#include "stri_messages.h"
#include "stri_macros.h"
#include "stri_exception.h"
#include "stri_exports.h"



// common.cpp
void    stri__set_names(SEXP object, R_len_t numnames, ...);
SEXP    stri__make_character_vector_char_ptr(R_len_t numnames, ...);
SEXP    stri__make_character_vector_UnicodeString_ptr(R_len_t numnames, ...);
R_len_t stri__recycling_rule(bool enableWarning, int n, ...);
SEXP    stri__vector_NA_integers(R_len_t howmany);
SEXP    stri__vector_NA_strings(R_len_t howmany);
SEXP    stri__vector_empty_strings(R_len_t howmany);
SEXP    stri__emptyList();
SEXP    stri__matrix_NA_INTEGER(R_len_t nrow, R_len_t ncol, int filler=NA_INTEGER);  // TODO: other ones can be generalised too
SEXP    stri__matrix_NA_STRING(R_len_t nrow, R_len_t ncol);
int     stri__match_arg(const char* option, const char** set);

// collator.cpp:
struct UCollator;
UCollator* stri__ucol_open(SEXP opts_collator);

// length.cpp
R_len_t stri__numbytes_max(SEXP str);
int     stri__width_char(UChar32 c);
int     stri__width_char_with_context(UChar32 c, UChar32 p, bool& reset);
int     stri__width_string(const char* s, int n, int max_width=NA_INTEGER);
int     stri__length_string(const char* s, int n, int max_length=NA_INTEGER);

// prepare_arg.cpp:
SEXP stri__prepare_arg_string_1(SEXP x,  const char* argname);
SEXP stri__prepare_arg_double_1(SEXP x,  const char* argname, bool factors_as_strings=true);
SEXP stri__prepare_arg_integer_1(SEXP x, const char* argname, bool factors_as_strings=true);
SEXP stri__prepare_arg_logical_1(SEXP x, const char* argname);

const char* stri__copy_string_Ralloc(SEXP, const char* argname);
const char* stri__prepare_arg_string_1_notNA(SEXP x,  const char* argname);
double      stri__prepare_arg_double_1_notNA(SEXP x,  const char* argname);
int         stri__prepare_arg_integer_1_notNA(SEXP x, const char* argname);
bool        stri__prepare_arg_logical_1_notNA(SEXP x, const char* argname);

const char* stri__prepare_arg_string_1_NA(SEXP x,  const char* argname);
double      stri__prepare_arg_double_1_NA(SEXP x, const char* argname);
int stri__prepare_arg_logical_1_NA(SEXP x, const char* argname);
int stri__prepare_arg_integer_1_NA(SEXP x, const char* argname);

bool stri__is_C_locale(const char* str);
const char* stri__prepare_arg_locale(
    SEXP loc, const char* argname,
    bool allowdefault=true, bool allownull=true
);
const char* stri__prepare_arg_enc(
    SEXP loc, const char* argname,
    bool allowdefault
);
TimeZone* stri__prepare_arg_timezone(SEXP tz, const char* argname, bool allowdefault);

SEXP stri__prepare_arg_list(SEXP x,         const char* argname);
SEXP stri__prepare_arg_list_string(SEXP x,  const char* argname);
SEXP stri__prepare_arg_list_integer(SEXP x, const char* argname);
SEXP stri__prepare_arg_list_raw(SEXP x,     const char* argname);

SEXP stri__prepare_arg_string(SEXP x,       const char* argname, bool allow_error=true);
SEXP stri__prepare_arg_logical(SEXP x,      const char* argname, bool allow_error=true);
SEXP stri__prepare_arg_double(SEXP x,       const char* argname, bool factors_as_strings=true, bool allow_error=true);
SEXP stri__prepare_arg_integer(SEXP x,      const char* argname, bool factors_as_strings=true, bool allow_error=true);
SEXP stri__prepare_arg_raw(SEXP x,          const char* argname, bool factors_as_strings=true, bool allow_error=true);

SEXP stri__prepare_arg_POSIXct(SEXP x,      const char* argname);



// search
void stri__locate_set_dimnames_list(
    SEXP list,
    bool get_length=false
);
void stri__locate_set_dimnames_matrix(
    SEXP matrix,
    bool get_length=false
);


// date/time
void stri__set_class_POSIXct(SEXP x);
Calendar* stri__get_calendar(const char* locale_val);

// ------------------------------------------------------------------------

#endif
