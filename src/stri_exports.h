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


#ifndef __stri_exports_h
#define __stri_exports_h

#include <R.h>
#include <Rdefines.h>


// compare.cpp:
SEXP stri_cmp(SEXP e1, SEXP e2, SEXP opts_collator=R_NilValue);
SEXP stri_cmp_le(SEXP e1, SEXP e2, SEXP opts_collator=R_NilValue);
SEXP stri_cmp_lt(SEXP e1, SEXP e2, SEXP opts_collator=R_NilValue);
SEXP stri_cmp_ge(SEXP e1, SEXP e2, SEXP opts_collator=R_NilValue);
SEXP stri_cmp_gt(SEXP e1, SEXP e2, SEXP opts_collator=R_NilValue);
SEXP stri_cmp_equiv(SEXP e1, SEXP e2, SEXP opts_collator=R_NilValue);
SEXP stri_cmp_nequiv(SEXP e1, SEXP e2, SEXP opts_collator=R_NilValue);
SEXP stri_cmp_eq(SEXP e1, SEXP e2);
SEXP stri_cmp_neq(SEXP e1, SEXP e2);

// sort.cpp
SEXP stri_sort(SEXP str, SEXP decreasing=Rf_ScalarLogical(FALSE),
   SEXP na_last=Rf_ScalarLogical(NA_LOGICAL), SEXP opts_collator=R_NilValue);
SEXP stri_order(SEXP str, SEXP decreasing=Rf_ScalarLogical(FALSE),
   SEXP na_last=Rf_ScalarLogical(TRUE), SEXP opts_collator=R_NilValue);

SEXP stri_unique(SEXP str, SEXP opts_collator=R_NilValue);
SEXP stri_duplicated(SEXP str, SEXP fromLast=Rf_ScalarLogical(FALSE),
   SEXP opts_collator=R_NilValue);
SEXP stri_duplicated_any(SEXP str, SEXP fromLast=Rf_ScalarLogical(FALSE),
   SEXP opts_collator=R_NilValue);

// ICU_settings.cpp:
SEXP stri_info();

// escape.cpp
SEXP stri_escape_unicode(SEXP str);
SEXP stri_unescape_unicode(SEXP str);

// join.cpp:
SEXP stri_flatten(SEXP str, SEXP collapse=Rf_mkString(""));
SEXP stri_join(SEXP strlist, SEXP sep=Rf_mkString(""),
   SEXP collapse=R_NilValue, SEXP ignore_null=Rf_ScalarLogical(FALSE));
SEXP stri_join2(SEXP e1, SEXP e2);
SEXP stri_dup(SEXP str, SEXP times);

// length.cpp
SEXP stri_numbytes(SEXP str);
SEXP stri_length(SEXP str);
SEXP stri_isempty(SEXP str);
SEXP stri_width(SEXP str);

// reverse.cpp
SEXP stri_reverse(SEXP s);

// sub.cpp
SEXP stri_sub(SEXP str, SEXP from, SEXP to, SEXP length);
SEXP stri_sub_replacement(SEXP str, SEXP from, SEXP to, SEXP length, SEXP value);

// encoding_management.cpp:
SEXP stri_enc_list();
SEXP stri_enc_info(SEXP enc=R_NilValue);
SEXP stri_enc_set(SEXP enc);
SEXP stri_enc_mark(SEXP str);

// uloc.cpp:
SEXP stri_locale_info(SEXP loc=R_NilValue);
SEXP stri_locale_list();
SEXP stri_locale_set(SEXP loc);

// trim.cpp:
SEXP stri_trim_both(SEXP str, SEXP pattern);
SEXP stri_trim_left(SEXP str, SEXP pattern);
SEXP stri_trim_right(SEXP str, SEXP pattern);

// random.cpp
SEXP stri_rand_shuffle(SEXP str);
SEXP stri_rand_strings(SEXP n, SEXP length, SEXP pattern=Rf_mkString("[A-Za-z0-9]"));

// stats.cpp
SEXP stri_stats_general(SEXP str);
SEXP stri_stats_latex(SEXP str);

// trans_transliterate.cpp:
SEXP stri_trans_list();
SEXP stri_trans_general(SEXP str, SEXP id);

// utils.cpp
SEXP stri_list2matrix(SEXP x, SEXP byrow=Rf_ScalarLogical(FALSE),
   SEXP fill=Rf_ScalarString(NA_STRING), SEXP n_min=Rf_ScalarInteger(0));



// encoding_conversion.cpp:
SEXP stri_encode(SEXP str, SEXP from=R_NilValue, SEXP to=R_NilValue,
   SEXP to_raw=Rf_ScalarLogical(FALSE));
SEXP stri_enc_fromutf32(SEXP str);
SEXP stri_enc_toutf32(SEXP str);
SEXP stri_enc_toutf8(SEXP str, SEXP is_unknown_8bit=Rf_ScalarLogical(FALSE),
   SEXP validate=Rf_ScalarLogical(FALSE));
SEXP stri_enc_toascii(SEXP str);


// encoding_detection.cpp:
SEXP stri_enc_detect2(SEXP str, SEXP loc=R_NilValue);
SEXP stri_enc_detect(SEXP str, SEXP filter_angle_brackets=Rf_ScalarLogical(FALSE));
SEXP stri_enc_isascii(SEXP str);
SEXP stri_enc_isutf8(SEXP str);
SEXP stri_enc_isutf16le(SEXP str);
SEXP stri_enc_isutf16be(SEXP str);
SEXP stri_enc_isutf32le(SEXP str);
SEXP stri_enc_isutf32be(SEXP str);


// wrap.cpp
SEXP stri_wrap(SEXP str, SEXP width, SEXP cost_exponent=Rf_ScalarInteger(2),
   SEXP indent=Rf_ScalarInteger(0), SEXP exdent=Rf_ScalarInteger(0),
   SEXP prefix=Rf_mkString(""), SEXP initial=Rf_mkString(""),
   SEXP whitespace_only=Rf_ScalarLogical(FALSE),
   SEXP use_length=Rf_ScalarLogical(FALSE), SEXP locale=R_NilValue);

// search
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


SEXP stri_extract_all_boundaries(SEXP str, SEXP simplify, SEXP omit_no_match, SEXP opts_brkiter);
SEXP stri_extract_first_boundaries(SEXP str, SEXP opts_brkiter);
SEXP stri_extract_last_boundaries(SEXP str, SEXP opts_brkiter);
SEXP stri_locate_all_boundaries(SEXP str, SEXP omit_no_match, SEXP opts_brkiter);
SEXP stri_locate_first_boundaries(SEXP str, SEXP opts_brkiter);
SEXP stri_locate_last_boundaries(SEXP str, SEXP opts_brkiter);
SEXP stri_split_boundaries(SEXP str, SEXP n, SEXP tokens_only, SEXP simplify, SEXP opts_brkiter);
SEXP stri_count_boundaries(SEXP str, SEXP opts_brkiter);

SEXP stri_split_lines(SEXP str, SEXP omit_empty);
SEXP stri_split_lines1(SEXP str);

SEXP stri_replace_na(SEXP str, SEXP replacement);

// pad.cpp
SEXP stri_pad(SEXP str, SEXP width, SEXP side, SEXP pad, SEXP use_length);

// trans_other.cpp:
SEXP stri_trans_char(SEXP str, SEXP pattern, SEXP replacement);


// trans_casemap.cpp:
SEXP stri_trans_casemap(SEXP str, SEXP type, SEXP locale);
SEXP stri_trans_totitle(SEXP str, SEXP opts_brkiter);


// trans_normalization.cpp:
SEXP stri_trans_nf(SEXP s, SEXP type);
SEXP stri_trans_isnf(SEXP s, SEXP type);


// date/time
SEXP stri_timezone_list(SEXP region, SEXP offset);
SEXP stri_timezone_set(SEXP tz);
SEXP stri_timezone_info(SEXP tz, SEXP locale, SEXP display_type);

SEXP stri_datetime_symbols(SEXP locale, SEXP context, SEXP width);

SEXP stri_c_posixst(SEXP x);
SEXP stri_datetime_now();
SEXP stri_datetime_add(SEXP time, SEXP delta, SEXP units, SEXP tz, SEXP locale);
SEXP stri_datetime_fields(SEXP time, SEXP tz, SEXP locale);
SEXP stri_datetime_create(SEXP year, SEXP month, SEXP day, SEXP hour,
   SEXP minute, SEXP second, SEXP lenient, SEXP tz, SEXP locale);
SEXP stri_datetime_format(SEXP time, SEXP format, SEXP tz, SEXP locale);
SEXP stri_datetime_parse(SEXP str, SEXP format, SEXP lenient, SEXP tz, SEXP locale);


#endif
