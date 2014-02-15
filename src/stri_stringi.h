/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * 'stringi' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'stringi' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __stri_stringi_h
#define __stri_stringi_h

#include "stri_external.h"
#include "stri_messages.h"
#include "stri_macros.h"
#include "stri_exception.h"
#include "stri_container_base.h"
#include "stri_string8.h"
#include "stri_container_utf8.h"
#include "stri_container_utf16.h"
#include "stri_container_regex.h"
#include "stri_container_usearch.h"
#include "stri_container_bytesearch.h"
#include "stri_container_listutf8.h"
#include "stri_container_listraw.h"
#include "stri_container_integer.h"
#include "stri_container_logical.h"
#include "stri_charclass.h"
#include "stri_container_charclass.h"

// ------------------------------------------------------------------------


/** Two \code{R_len_t}s as one :)
 *
 */
struct R_len_t_x2 {
   R_len_t_x2(R_len_t _v1, R_len_t _v2) { this->v1 = _v1; this->v2 = _v2; }
   R_len_t v1;
   R_len_t v2;
};


/** Two \code{char*}s as one :)
 *
 */
struct charptr_x2 {
   charptr_x2() { this->v1 = NULL; this->v2 = NULL; }
   charptr_x2(const char* _v1, const char* _v2) { this->v1 = _v1; this->v2 = _v2; }
   const char* v1;
   const char* v2;
};

// ------------------------------------------------------------------------

// @TODO: stri_multisub                                   // ...TODO... [version >0.1]
// @TODO: stri_multisub_replacement                       // ...TODO... [version >0.1]
// @TODO: SEXP stri_enc_fromutf16(SEXP str);              // ...TODO... be careful: BOMs! [version >0.1]
// @TODO: SEXP stri_enc_toutf16(SEXP str);                // ...TODO... -> list with elems of type raw [version >0.1]
// @TODO: stri_enc_detect()                               // ...TODO... [version >0.1]

// ------------------------------------------------------------------------


// casemap.cpp:
SEXP stri_trans_case(SEXP str, SEXP type, SEXP locale);


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

// collator.cpp:
UCollator*  stri__ucol_open(SEXP collator_opts);

// compare.cpp:
int  stri__compare_codepoints(const char* str1, R_len_t n1,
                              const char* str2, R_len_t n2);
SEXP stri__compare_codepoints(SEXP e1, SEXP e2);
SEXP stri__order_codepoints(SEXP e1, SEXP decreasing);
SEXP stri_compare(SEXP e1, SEXP e2, SEXP collator_opts);
SEXP stri_order(SEXP str, SEXP decreasing, SEXP collator_opts);


// ICU_settings.cpp:
SEXP stri_info();


// escape.cpp
SEXP stri_escape_unicode(SEXP str);
SEXP stri_unescape_unicode(SEXP str);

// join.cpp:
SEXP stri_dup(SEXP str, SEXP times);
SEXP stri_flatten(SEXP str, SEXP collapse);
SEXP stri_flatten_nosep(SEXP str);
SEXP stri_join(SEXP strlist, SEXP sep, SEXP collapse);
SEXP stri_join2(SEXP e1, SEXP e2);



// length.cpp
R_len_t stri__numbytes_max(SEXP str);
SEXP    stri_numbytes(SEXP str);
SEXP    stri_length(SEXP str);
SEXP    stri_isempty(SEXP str);
// SEXP stri_width(SEXP str);                               // ...TODO... [version >= 0.2]



// prepare_arg.cpp:
SEXP        stri_prepare_arg_list_string(SEXP x,      const char* argname);
SEXP        stri_prepare_arg_list_raw(SEXP x,         const char* argname);
SEXP        stri_prepare_arg_string(SEXP x,           const char* argname);
SEXP        stri_prepare_arg_double(SEXP x,           const char* argname);
SEXP        stri_prepare_arg_integer(SEXP x,          const char* argname);
SEXP        stri_prepare_arg_logical(SEXP x,          const char* argname);
SEXP        stri_prepare_arg_raw(SEXP x,              const char* argname);
SEXP        stri_prepare_arg_string_1(SEXP x,         const char* argname);
SEXP        stri_prepare_arg_double_1(SEXP x,         const char* argname);
SEXP        stri_prepare_arg_integer_1(SEXP x,        const char* argname);
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
// SEXP stri_split_pos(SEXP str, SEXP from, SEXP to);                        // ...TO DO... [version >= 0.2]
// SEXP stri__split_pos(const char* s, int* from, int* to, int ns, int n);   // ...TO DO... [version >= 0.2]





// encoding_management.cpp:
UConverter* stri__ucnv_open(const char* enc);
bool        stri__ucnv_hasASCIIsubset(UConverter* conv);
bool        stri__ucnv_is1to1Unicode(UConverter* conv);
void        stri__ucnv_getStandards(const char**& standards, R_len_t& cs);
const char* stri__ucnv_getFriendlyName(const char* canname);

SEXP stri_enc_list();
SEXP stri_enc_info(SEXP enc);
SEXP stri_enc_set(SEXP loc);


// encoding_conversion.cpp:
SEXP    stri_encode(SEXP str, SEXP from, SEXP to, SEXP to_raw);
SEXP    stri_encode_from_marked(SEXP str, SEXP to, SEXP to_raw);
R_len_t stri__enc_fromutf32(int* data, R_len_t ndata,
                            char* buf, R_len_t bufsize);
SEXP    stri_enc_fromutf32(SEXP str);
SEXP    stri_enc_toutf32(SEXP str);
SEXP    stri_enc_toutf8(SEXP str, SEXP is_unknown_8bit);
SEXP    stri_enc_toascii(SEXP str);


// encoding_detection.cpp:
double stri__enc_check_8bit(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence);
double stri__enc_check_ascii(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence);
double stri__enc_check_utf8(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence);
double stri__enc_check_utf16(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence, bool le);
double stri__enc_check_utf16le(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence);
double stri__enc_check_utf16be(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence);
double stri__enc_check_utf32(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence, bool le);
double stri__enc_check_utf32le(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence);
double stri__enc_check_utf32be(const char* str_cur_s,
                              R_len_t str_cur_n, bool get_confidence);

SEXP stri_enc_detect2(SEXP str, SEXP loc);
SEXP stri_enc_detect(SEXP str, SEXP filter_angle_brackets);
SEXP stri_enc_isenc(SEXP str, SEXP type);


// encoding_normalization.cpp:
const Normalizer2* stri__normalizer_get(SEXP type);
SEXP stri_enc_nf(SEXP s, SEXP type);
SEXP stri_enc_isnf(SEXP s, SEXP type);



// uloc.cpp:
SEXP stri_locale_info(SEXP loc);
SEXP stri_locale_list();
SEXP stri_locale_set(SEXP loc);






// wrap.cpp
// SEXP stri_wrap_greedy(SEXP count, int width, int spacecost);                // TODO [version >= 0.2]
// SEXP stri_wrap_dynamic(SEXP count, int width, int spacecost);               // TODO [version >= 0.2]
// SEXP stri_wrap(SEXP wordslist, SEXP method, SEXP width, SEXP spacecost);    // TODO [version >= 0.2]


// justify.cpp
// SEXP stri_justify(SEXP str, SEXP width);                                    // TODO [version >= 0.2]



// ----------- SEARCH --------------------------------------------


void stri__locate_set_dimnames_list(SEXP list);
void stri__locate_set_dimnames_matrix(SEXP matrix);


SEXP stri__replace_allfirstlast_fixed_byte(SEXP str, SEXP pattern,
                                           SEXP replacement, int type);
SEXP stri__extract_firstlast_fixed_byte(SEXP str, SEXP pattern, bool first);
SEXP stri__locate_firstlast_fixed_byte(SEXP str, SEXP pattern, bool first);
SEXP stri__count_fixed_byte(SEXP str, SEXP pattern);
SEXP stri__detect_fixed_byte(SEXP str, SEXP pattern);
SEXP stri__locate_all_fixed_byte(SEXP str, SEXP pattern);
SEXP stri__extract_all_fixed_byte(SEXP str, SEXP pattern);
SEXP stri__split_fixed_byte(SEXP str, SEXP pattern, SEXP n_max,
                            SEXP omit_empty);

SEXP stri__replace_allfirstlast_fixed(SEXP str, SEXP pattern, SEXP replacement,
                                      SEXP collator_opts, int type);
SEXP stri__locate_firstlast_fixed(SEXP str, SEXP pattern, SEXP collator_opts,
                                  bool first);
SEXP stri__extract_firstlast_fixed(SEXP str, SEXP pattern, SEXP collator_opts,
                                   bool first);

SEXP stri_detect_fixed(SEXP str, SEXP pattern, SEXP collator_opts);
SEXP stri_count_fixed(SEXP str, SEXP pattern, SEXP collator_opts);
SEXP stri_locate_all_fixed(SEXP str, SEXP pattern, SEXP collator_opts);
SEXP stri_locate_first_fixed(SEXP str, SEXP pattern, SEXP collator_opts);
SEXP stri_locate_last_fixed(SEXP str, SEXP pattern, SEXP collator_opts);
SEXP stri_extract_first_fixed(SEXP str, SEXP pattern, SEXP collator_opts);
SEXP stri_extract_last_fixed(SEXP str, SEXP pattern, SEXP collator_opts);
SEXP stri_extract_all_fixed(SEXP str, SEXP pattern, SEXP collator_opts);
SEXP stri_replace_all_fixed(SEXP str, SEXP pattern, SEXP replacement,
                            SEXP collator_opts);
SEXP stri_replace_first_fixed(SEXP str, SEXP pattern, SEXP replacement,
                              SEXP collator_opts);
SEXP stri_replace_last_fixed(SEXP str, SEXP pattern, SEXP replacement,
                             SEXP collator_opts);
SEXP stri_split_fixed(SEXP str, SEXP split, SEXP n_max, SEXP omit_empty,
                      SEXP collator_opts);


SEXP stri__extract_firstlast_regex(SEXP str, SEXP pattern,
                                   SEXP opts_regex, bool first);
SEXP stri__locate_firstlast_regex(SEXP str, SEXP pattern,
                                  SEXP opts_regex, bool first);
SEXP stri__replace_allfirstlast_regex(SEXP str, SEXP pattern, SEXP replacement,
                                      SEXP opts_regex, int type);

SEXP stri_detect_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_count_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_locate_all_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_locate_first_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_locate_last_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_replace_all_regex(SEXP str, SEXP pattern, SEXP replacement,
                           SEXP opts_regex);
SEXP stri_replace_first_regex(SEXP str, SEXP pattern, SEXP replacement,
                              SEXP opts_regex);
SEXP stri_replace_last_regex(SEXP str, SEXP pattern, SEXP replacement,
                             SEXP opts_regex);
SEXP stri_split_regex(SEXP str, SEXP pattern, SEXP n_max, SEXP omit_empty,
                      SEXP opts_regex);
SEXP stri_extract_first_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_extract_last_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_extract_all_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_match_first_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_match_last_regex(SEXP str, SEXP pattern, SEXP opts_regex);
SEXP stri_match_all_regex(SEXP str, SEXP pattern, SEXP opts_regex);


SEXP stri__extract_firstlast_charclass(SEXP str, SEXP pattern, bool first);
SEXP stri__locate_firstlast_charclass(SEXP str, SEXP pattern, bool first);
SEXP stri__replace_firstlast_charclass(SEXP str, SEXP pattern,
                                       SEXP replacement, bool first);

SEXP stri_count_charclass(SEXP str, SEXP pattern);
SEXP stri_detect_charclass(SEXP str, SEXP pattern);
SEXP stri_extract_first_charclass(SEXP str, SEXP pattern);
SEXP stri_extract_last_charclass(SEXP str, SEXP pattern);
SEXP stri_extract_all_charclass(SEXP str, SEXP pattern, SEXP merge);
SEXP stri_locate_first_charclass(SEXP str, SEXP pattern);
SEXP stri_locate_last_charclass(SEXP str, SEXP pattern);
SEXP stri_locate_all_charclass(SEXP str, SEXP pattern, SEXP merge);
SEXP stri_replace_last_charclass(SEXP str, SEXP pattern, SEXP replacement);
SEXP stri_replace_first_charclass(SEXP str, SEXP pattern, SEXP replacement);
SEXP stri_replace_all_charclass(SEXP str, SEXP pattern, SEXP replacement);
SEXP stri_split_charclass(SEXP str, SEXP pattern, SEXP n_max, SEXP omit_empty);

SEXP stri_split_lines(SEXP str, SEXP n_max, SEXP omit_empty);
SEXP stri_split_lines1(SEXP str);


// uchar.cpp:
// SEXP stri_charcategories();        // ...TO DO... [version >= 0.2]
// SEXP stri_chartype(SEXP str);      // ...TO DO... [version >= 0.2]





// trim.cpp:
SEXP stri__trim_leftright(SEXP str, SEXP pattern, bool left, bool right);
SEXP stri_trim_both(SEXP str, SEXP pattern);
SEXP stri_trim_left(SEXP str, SEXP pattern);
SEXP stri_trim_right(SEXP str, SEXP pattern);
// SEXP stri_trim_double(SEXP str, SEXP pattern, SEXP leave_first);   // ...TO DO... [version >= 0.2]


// pad.cpp
//SEXP stri_pad(SEXP str, SEXP length, SEXP pad);   // ...TO DO...  [version >= 0.2]



// stats.cpp
SEXP stri_stats_general(SEXP str);
SEXP stri_stats_latex(SEXP str);



// test.cpp /* internal, but in namespace: for testing */
SEXP stri_test_Rmark(SEXP str);
SEXP stri_test_UnicodeContainer16(SEXP str);
SEXP stri_test_UnicodeContainer8(SEXP str);
SEXP stri_test_returnasis(SEXP x);

// ------------------------------------------------------------------------



#endif
