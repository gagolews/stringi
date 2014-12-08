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


#ifndef __stri_stringi_h
#define __stri_stringi_h

#include "stri_external.h"
#include "stri_messages.h"
#include "stri_macros.h"
#include "stri_exception.h"
#include "stri_string8.h"
#include "stri_container_utf8.h"
#include "stri_container_utf16.h"


// ------------------------------------------------------------------------

// @TODO: SEXP stri_enc_fromutf16(SEXP str);              // ...TODO... be careful: BOMs! [version >=0.3]
// @TODO: SEXP stri_enc_toutf16(SEXP str);                // ...TODO... -> list with elems of type raw [version >=0.3]

// ------------------------------------------------------------------------


// common.cpp
void    stri__set_names(SEXP object, R_len_t numnames, ...);
SEXP    stri__make_character_vector(R_len_t numnames, ...);
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

// compare.cpp:
SEXP stri_cmp_integer(SEXP e1, SEXP e2, SEXP opts_collator);
SEXP stri_cmp_logical(SEXP e1, SEXP e2, SEXP opts_collator, SEXP type);
SEXP stri_cmp_codepoints(SEXP e1, SEXP e2, SEXP type);

SEXP stri_order_or_sort(SEXP str, SEXP decreasing, SEXP na_last,
   SEXP opts_collator, SEXP type);

SEXP stri_unique(SEXP str, SEXP opts_collator);
SEXP stri_duplicated(SEXP str, SEXP fromLast, SEXP opts_collator);
SEXP stri_duplicated_any(SEXP str, SEXP fromLast, SEXP opts_collator);

// ICU_settings.cpp:
SEXP stri_info();


// escape.cpp
SEXP stri_escape_unicode(SEXP str);
SEXP stri_unescape_unicode(SEXP str);

// join.cpp:
SEXP stri_dup(SEXP str, SEXP times);
SEXP stri_flatten_noressep(SEXP str);
SEXP stri_flatten_withressep(SEXP str, SEXP collapse);
SEXP stri_join_nocollapse(SEXP strlist, SEXP sep, SEXP ignore_null);
SEXP stri_join_withcollapse(SEXP strlist, SEXP sep, SEXP collapse, SEXP ignore_null);
SEXP stri_join2_nocollapse(SEXP e1, SEXP e2);
SEXP stri_join2_withcollapse(SEXP e1, SEXP e2, SEXP collapse);


// length.cpp
R_len_t stri__numbytes_max(SEXP str);
SEXP    stri_numbytes(SEXP str);
SEXP    stri_length(SEXP str);
SEXP    stri_isempty(SEXP str);
// SEXP stri_width(SEXP str);                               // ...TODO... [version >= 0.3]


// prepare_arg.cpp:
SEXP        stri_prepare_arg_list_string(SEXP x,      const char* argname);
SEXP        stri_prepare_arg_list_integer(SEXP x,     const char* argname);
SEXP        stri_prepare_arg_list_raw(SEXP x,         const char* argname);
SEXP        stri_prepare_arg_string(SEXP x,           const char* argname);
SEXP        stri_prepare_arg_double(SEXP x,           const char* argname);
SEXP        stri_prepare_arg_integer(SEXP x,          const char* argname);
SEXP        stri_prepare_arg_logical(SEXP x,          const char* argname);
SEXP        stri_prepare_arg_raw(SEXP x,              const char* argname);
SEXP        stri_prepare_arg_string_1(SEXP x,         const char* argname);
SEXP        stri_prepare_arg_double_1(SEXP x,         const char* argname);
double      stri__prepare_arg_double_1_notNA(SEXP x,  const char* argname);
SEXP        stri_prepare_arg_integer_1(SEXP x,        const char* argname);
int         stri__prepare_arg_integer_1_notNA(SEXP x, const char* argname);
SEXP        stri_prepare_arg_logical_1(SEXP x,        const char* argname);
bool        stri__prepare_arg_logical_1_notNA(SEXP x, const char* argname);
const char* stri__prepare_arg_locale(SEXP loc,        const char* argname,
                                     bool allowdefault, bool allowna=false);
const char* stri__prepare_arg_enc(SEXP loc,           const char* argname,
                                     bool allowdefault);


// reverse.cpp
SEXP stri_reverse(SEXP s);


// sub.cpp
SEXP stri_sub(SEXP str, SEXP from, SEXP to, SEXP length);
SEXP stri_sub_replacement(SEXP str, SEXP from, SEXP to,
                          SEXP length, SEXP value);
// SEXP stri_split_pos(SEXP str, SEXP from, SEXP to);                        // ...TO DO... [version >= 0.3]
// SEXP stri__split_pos(const char* s, int* from, int* to, int ns, int n);   // ...TO DO... [version >= 0.3]

// encoding_management.cpp:
SEXP stri_enc_list();
SEXP stri_enc_info(SEXP enc);
SEXP stri_enc_set(SEXP loc);
SEXP stri_enc_mark(SEXP str);

// encoding_conversion.cpp:
SEXP stri_encode(SEXP str, SEXP from, SEXP to, SEXP to_raw);
SEXP stri_encode_from_marked(SEXP str, SEXP to, SEXP to_raw);
SEXP stri_enc_fromutf32(SEXP str);
SEXP stri_enc_toutf32(SEXP str);
SEXP stri_enc_toutf8(SEXP str, SEXP is_unknown_8bit, SEXP validate);
SEXP stri_enc_toascii(SEXP str);


// encoding_detection.cpp:
SEXP stri_enc_detect2(SEXP str, SEXP loc);
SEXP stri_enc_detect(SEXP str, SEXP filter_angle_brackets);
SEXP stri_enc_isenc(SEXP str, SEXP type);


// uloc.cpp:
SEXP stri_locale_info(SEXP loc);
SEXP stri_locale_list();
SEXP stri_locale_set(SEXP loc);


// wrap.cpp
SEXP stri_wrap(SEXP str, SEXP width, SEXP cost_exponent,
   SEXP indent, SEXP exdent, SEXP prefix, SEXP initial, SEXP locale);

// justify.cpp
// SEXP stri_justify(SEXP str, SEXP width);                                    // TODO [version >= 0.3]


// ----------- SEARCH --------------------------------------------

void stri__locate_set_dimnames_list(SEXP list);
void stri__locate_set_dimnames_matrix(SEXP matrix);
SEXP stri__subset_by_logical(const StriContainerUTF8& str_cont,
   const std::vector<int>& which, int result_counter);
SEXP stri__subset_by_logical(const StriContainerUTF16& str_cont,
   const std::vector<int>& which, int result_counter);

SEXP stri_detect_coll(SEXP str, SEXP pattern, SEXP opts_collator);
SEXP stri_count_coll(SEXP str, SEXP pattern, SEXP opts_collator);
SEXP stri_locate_all_coll(SEXP str, SEXP pattern, SEXP omit_no_match, SEXP opts_collator);
SEXP stri_locate_first_coll(SEXP str, SEXP pattern, SEXP opts_collator);
SEXP stri_locate_last_coll(SEXP str, SEXP pattern, SEXP opts_collator);
SEXP stri_extract_first_coll(SEXP str, SEXP pattern, SEXP opts_collator);
SEXP stri_extract_last_coll(SEXP str, SEXP pattern, SEXP opts_collator);
SEXP stri_extract_all_coll(SEXP str, SEXP pattern, SEXP simplify, SEXP omit_no_match, SEXP opts_collator);
SEXP stri_replace_all_coll(SEXP str, SEXP pattern, SEXP replacement,
                            SEXP vectorize_all, SEXP opts_collator);
SEXP stri_replace_first_coll(SEXP str, SEXP pattern, SEXP replacement,
                              SEXP opts_collator);
SEXP stri_replace_last_coll(SEXP str, SEXP pattern, SEXP replacement,
                             SEXP opts_collator);
SEXP stri_split_coll(SEXP str, SEXP split, SEXP n, SEXP omit_empty,
                      SEXP tokens_only, SEXP simplify, SEXP opts_collator);
SEXP stri_endswith_coll(SEXP str, SEXP pattern, SEXP to, SEXP opts_collator);
SEXP stri_startswith_coll(SEXP str, SEXP pattern, SEXP from, SEXP opts_collator);
SEXP stri_subset_coll(SEXP str, SEXP pattern, SEXP omit_na, SEXP opts_collator);


SEXP stri_detect_fixed(SEXP str, SEXP pattern, SEXP opts_fixed);
SEXP stri_count_fixed(SEXP str, SEXP pattern, SEXP opts_fixed);
SEXP stri_locate_all_fixed(SEXP str, SEXP pattern, SEXP omit_no_match, SEXP opts_fixed);
SEXP stri_locate_first_fixed(SEXP str, SEXP pattern, SEXP opts_fixed);
SEXP stri_locate_last_fixed(SEXP str, SEXP pattern, SEXP opts_fixed);
SEXP stri_extract_first_fixed(SEXP str, SEXP pattern, SEXP opts_fixed);
SEXP stri_extract_last_fixed(SEXP str, SEXP pattern, SEXP opts_fixed);
SEXP stri_extract_all_fixed(SEXP str, SEXP pattern, SEXP simplify, SEXP omit_no_match, SEXP opts_fixed);
SEXP stri_replace_all_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP vectorize_all, SEXP opts_fixed);
SEXP stri_replace_first_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_fixed);
SEXP stri_replace_last_fixed(SEXP str, SEXP pattern, SEXP replacement, SEXP opts_fixed);
SEXP stri_split_fixed(SEXP str, SEXP split, SEXP n,
            SEXP omit_empty, SEXP tokens_only, SEXP simplify, SEXP opts_fixed);
SEXP stri_subset_fixed(SEXP str, SEXP pattern, SEXP omit_na, SEXP opts_fixed);
SEXP stri_endswith_fixed(SEXP str, SEXP pattern, SEXP to, SEXP opts_fixed);
SEXP stri_startswith_fixed(SEXP str, SEXP pattern, SEXP from, SEXP opts_fixed);


SEXP stri_detect_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_count_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_locate_all_regex(SEXP str, SEXP pattern, SEXP omit_no_match, SEXP opts_regex);
SEXP stri_locate_first_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_locate_last_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_replace_all_regex(SEXP str, SEXP pattern, SEXP replacement,
                           SEXP vectorize_all, SEXP opts_regex);
SEXP stri_replace_first_regex(SEXP str, SEXP pattern, SEXP replacement,
                              SEXP opts_regex);
SEXP stri_replace_last_regex(SEXP str, SEXP pattern, SEXP replacement,
                             SEXP opts_regex);
SEXP stri_split_regex(SEXP str, SEXP pattern, SEXP n, SEXP omit_empty,
                      SEXP tokens_only, SEXP simplify, SEXP opts_regex);
SEXP stri_subset_regex(SEXP str, SEXP pattern, SEXP omit_na, SEXP opts_regex);
SEXP stri_extract_first_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_extract_last_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_extract_all_regex(SEXP str, SEXP pattern, SEXP simplify, SEXP omit_no_match, SEXP opts_regex);
SEXP stri_match_first_regex(SEXP str, SEXP pattern, SEXP cg_missing, SEXP opts_regex);
SEXP stri_match_last_regex(SEXP str, SEXP pattern, SEXP cg_missing, SEXP opts_regex);
SEXP stri_match_all_regex(SEXP str, SEXP pattern, SEXP omit_no_match, SEXP cg_missing, SEXP opts_regex);


SEXP stri_count_charclass(SEXP str, SEXP pattern);
SEXP stri_detect_charclass(SEXP str, SEXP pattern);
SEXP stri_extract_first_charclass(SEXP str, SEXP pattern);
SEXP stri_extract_last_charclass(SEXP str, SEXP pattern);
SEXP stri_extract_all_charclass(SEXP str, SEXP pattern, SEXP merge, SEXP simplify, SEXP omit_no_match);
SEXP stri_locate_first_charclass(SEXP str, SEXP pattern);
SEXP stri_locate_last_charclass(SEXP str, SEXP pattern);
SEXP stri_locate_all_charclass(SEXP str, SEXP pattern, SEXP merge, SEXP omit_no_match);
SEXP stri_replace_last_charclass(SEXP str, SEXP pattern, SEXP replacement);
SEXP stri_replace_first_charclass(SEXP str, SEXP pattern, SEXP replacement);
SEXP stri_replace_all_charclass(SEXP str, SEXP pattern, SEXP replacement,
                                SEXP merge, SEXP vectorize_all);
SEXP stri_split_charclass(SEXP str, SEXP pattern, SEXP n,
                          SEXP omit_empty, SEXP tokens_only, SEXP simplify);
SEXP stri_endswith_charclass(SEXP str, SEXP pattern, SEXP to);
SEXP stri_startswith_charclass(SEXP str, SEXP pattern, SEXP from);
SEXP stri_subset_charclass(SEXP str, SEXP pattern, SEXP omit_na);


SEXP stri_locate_all_boundaries(SEXP str, SEXP omit_no_match, SEXP opts_brkiter);
SEXP stri_locate_first_boundaries(SEXP str, SEXP opts_brkiter);
SEXP stri_locate_last_boundaries(SEXP str, SEXP opts_brkiter);
SEXP stri_split_boundaries(SEXP str, SEXP n, SEXP tokens_only, SEXP simplify, SEXP opts_brkiter);
SEXP stri_count_boundaries(SEXP str, SEXP opts_brkiter);
SEXP stri_split_lines(SEXP str, SEXP omit_empty);
SEXP stri_split_lines1(SEXP str);

SEXP stri_replace_na(SEXP str, SEXP replacement);


// uchar.cpp:
// SEXP stri_charcategories();        // ...TO DO... [version >= 0.3]
// SEXP stri_chartype(SEXP str);      // ...TO DO... [version >= 0.3]


// trim.cpp:
SEXP stri_trim_both(SEXP str, SEXP pattern);
SEXP stri_trim_left(SEXP str, SEXP pattern);
SEXP stri_trim_right(SEXP str, SEXP pattern);


// pad.cpp
SEXP stri_pad(SEXP str, SEXP min_length, SEXP side, SEXP pad);


// random.cpp
SEXP stri_rand_shuffle(SEXP str);
SEXP stri_rand_strings(SEXP n, SEXP length, SEXP pattern);


// stats.cpp
SEXP stri_stats_general(SEXP str);
SEXP stri_stats_latex(SEXP str);


// trans_casemap.cpp:
SEXP stri_trans_casemap(SEXP str, SEXP type, SEXP locale);
SEXP stri_trans_totitle(SEXP str, SEXP opts_brkiter);


// trans_normalization.cpp:
SEXP stri_trans_nf(SEXP s, SEXP type);
SEXP stri_trans_isnf(SEXP s, SEXP type);


// trans_transliterate.cpp:
SEXP stri_trans_list();
SEXP stri_trans_general(SEXP str, SEXP id);


// test.cpp /* internal, but in namespace: for testing */
SEXP stri_test_Rmark(SEXP str);
SEXP stri_test_UnicodeContainer16(SEXP str);
SEXP stri_test_UnicodeContainer16b(SEXP str);
SEXP stri_test_UnicodeContainer8(SEXP str);
SEXP stri_test_returnasis(SEXP x);


// utils.cpp
SEXP stri_list2matrix(SEXP x, SEXP byrow, SEXP fill, SEXP n_min);

// ------------------------------------------------------------------------

#endif
