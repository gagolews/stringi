/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
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
#include "stri_string8.h"
#include "stri_container_utf8.h"
#include "stri_container_utf16.h"
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
SEXP    stri__matrix_NA_INTEGER(R_len_t nrow, R_len_t ncol);
SEXP    stri__matrix_NA_STRING(R_len_t nrow, R_len_t ncol);
int     stri__match_arg(const char* option, const char** set);

// collator.cpp:
struct UCollator;
UCollator* stri__ucol_open(SEXP opts_collator);

// length.cpp
R_len_t stri__numbytes_max(SEXP str);
int     stri__width_char(UChar32 c);
int     stri__width_string(const char* str_cur_s, int str_cur_n);

// prepare_arg.cpp:
const char* stri__copy_string_Ralloc(SEXP, const char* argname);
const char* stri__prepare_arg_string_1_notNA(SEXP x,  const char* argname);
double      stri__prepare_arg_double_1_notNA(SEXP x,  const char* argname);
int         stri__prepare_arg_integer_1_notNA(SEXP x, const char* argname);
bool        stri__prepare_arg_logical_1_notNA(SEXP x, const char* argname);
const char* stri__prepare_arg_locale(SEXP loc,        const char* argname,
                                     bool allowdefault, bool allowna=false);
const char* stri__prepare_arg_enc(SEXP loc,           const char* argname,
                                     bool allowdefault);
TimeZone* stri__prepare_arg_timezone(SEXP tz, const char* argname, bool allowdefault);

// prepare_arg.cpp /* internal, but in namespace: for testing */
SEXP        stri_prepare_arg_list(SEXP x,             const char* argname);
SEXP        stri_prepare_arg_list_string(SEXP x,      const char* argname);
SEXP        stri_prepare_arg_list_integer(SEXP x,     const char* argname);
SEXP        stri_prepare_arg_list_raw(SEXP x,         const char* argname);
SEXP        stri_prepare_arg_string(SEXP x,           const char* argname);
SEXP        stri_prepare_arg_double(SEXP x,           const char* argname);
SEXP        stri_prepare_arg_POSIXct(SEXP x,          const char* argname);
SEXP        stri_prepare_arg_integer(SEXP x,          const char* argname);
SEXP        stri_prepare_arg_logical(SEXP x,          const char* argname);
SEXP        stri_prepare_arg_raw(SEXP x,              const char* argname);
SEXP        stri_prepare_arg_string_1(SEXP x,         const char* argname);
SEXP        stri_prepare_arg_double_1(SEXP x,         const char* argname);
SEXP        stri_prepare_arg_integer_1(SEXP x,        const char* argname);
SEXP        stri_prepare_arg_logical_1(SEXP x,        const char* argname);

// test.cpp /* internal, but in namespace: for testing */
SEXP stri_test_Rmark(SEXP str);
SEXP stri_test_UnicodeContainer16(SEXP str);
SEXP stri_test_UnicodeContainer16b(SEXP str);
SEXP stri_test_UnicodeContainer8(SEXP str);
SEXP stri_test_returnasis(SEXP x);

// search
void stri__locate_set_dimnames_list(SEXP list);
void stri__locate_set_dimnames_matrix(SEXP matrix);
SEXP stri__subset_by_logical(const StriContainerUTF8& str_cont,
   const std::vector<int>& which, int result_counter);
SEXP stri__subset_by_logical(const StriContainerUTF16& str_cont,
   const std::vector<int>& which, int result_counter);

// date/time
void stri__set_class_POSIXct(SEXP x);

// encoding_conversion.cpp:
SEXP stri_encode_from_marked(SEXP str, SEXP to, SEXP to_raw);

// date/time:
SEXP stri_c_posixst(SEXP x);

// ------------------------------------------------------------------------

#endif
