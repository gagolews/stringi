/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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
 
#ifndef __stringi_h
#define __stringi_h

// for DEBUG mode
#undef NDEBUG
// for non-DEBUG mode:
// #define NDEBUG


#ifdef U_CHARSET_IS_UTF8
// do not enable this:
#undef U_CHARSET_IS_UTF8
#endif


#include <iostream>
#include <unicode/uchar.h>
#include <unicode/utypes.h>
#include <unicode/ucnv.h>
#include <unicode/stringpiece.h>
#include <unicode/utf8.h>
#include <unicode/utf16.h>
#include <unicode/normalizer2.h>
#include <unicode/locid.h>
#include <unicode/uloc.h>
#include <unicode/regex.h>

#include <R.h>
#include <Rmath.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
using namespace std;
using namespace icu;

// undef R's length macro (conflicts with std::string.length())
// use LENGTH instead
#undef length

/// Unicode replacement character
#define UCHAR_REPLACEMENT 0xFFFD

#include "messages.h"
#include "rustring.h"

// ------------------------------------------------------------------------


// common.cpp
SEXP stri__mkStringNA(R_len_t howmany);
SEXP stri__mkStringEmpty(R_len_t howmany);
void stri__asciiUpperCase(char* x);
SEXP stri__emptyList();

// trim.cpp:
SEXP stri_trim(SEXP s);
SEXP stri_ltrim(SEXP s);
SEXP stri_rtrim(SEXP s);
SEXP stri_trim_all(SEXP s);
SEXP stri_pad(SEXP s, SEXP width, SEXP side, SEXP pad);

// unicode_normalization.cpp:
SEXP stri_unicode_normalization(SEXP s, SEXP type);

// casefold.cpp:
SEXP stri_casefold(SEXP s, SEXP type);

// count.cpp
SEXP stri_count_fixed(SEXP s, SEXP pattern);

//detect.cpp
SEXP stri_detect_regex(SEXP str, SEXP pattern);

// dup.cpp:
SEXP stri_dup(SEXP s, SEXP c);

// join.cpp:
SEXP stri_flatten(SEXP s, SEXP sep);
SEXP stri_join(SEXP s);
SEXP stri_join2(SEXP s1, SEXP s2);

// justify.cpp
SEXP stri_justify(SEXP s, SEXP width);

// compare.cpp:
SEXP stri_casecompare(SEXP x, SEXP y);

// ICU_settings.cpp:
SEXP stri_info();

// prepare_arg.cpp:
SEXP stri_prepare_arg_string(SEXP x);
SEXP stri_prepare_arg_double(SEXP x);
SEXP stri_prepare_arg_integer(SEXP x);
SEXP stri_prepare_arg_logical(SEXP x);
const char* stri__prepare_arg_locale(SEXP loc, bool allowdefault=true);

// ucnv.cpp:
void stri__ucnv_getStandards(const char**& standards, R_len_t& cs);
const char* stri___ucnv_getFriendlyName(const char* canname);
UConverter* stri__ucnv_open(const char* enc);
UConverter* stri__ucnv_open(SEXP enc);
bool stri__ucnv_hasASCIIsubset(UConverter* conv);
bool stri__ucnv_is1to1Unicode(UConverter* conv);
SEXP stri_encode(SEXP s, SEXP from, SEXP to);
SEXP stri_enclist();
SEXP stri_encinfo(SEXP enc);
SEXP stri_encset(SEXP loc);
SEXP stri_enc_is_ascii(SEXP s);
SEXP stri_enc_is_utf8(SEXP s);

// uloc.cpp:
SEXP stri_localeinfo(SEXP loc);
SEXP stri_localelist();
SEXP stri_localeset(SEXP loc);

// uchar.cpp:
#define STRI__UCHAR_COMPLEMENT_MASK      0x40000000
#define STRI__UCHAR_NOTUSED_MASK         0xffffffff
#define STRI__UCHAR_CLASS_LENGTH         2

#define STRI__UCHAR_IS_ANY_BINPROP(x) \
   (((x)[0] == STRI__UCHAR_NOTUSED_MASK) && ((x)[1] != STRI__UCHAR_NOTUSED_MASK))
#define STRI__UCHAR_IS_MATCHING_BINPROP(x) \
   ((STRI__UCHAR_IS_ANY_BINPROP(x)) && (((x)[1] & (~STRI__UCHAR_COMPLEMENT_MASK)) == (x)[1]))
#define STRI__UCHAR_IS_COMPLEMENT_BINPROP(x) \
   ((STRI__UCHAR_IS_ANY_BINPROP(x)) && (((x)[1] & STRI__UCHAR_COMPLEMENT_MASK) == STRI__UCHAR_COMPLEMENT_MASK))
   
#define STRI__UCHAR_CREATE_MATCHING_BINPROP(x,c) \
   { (x)[0] = STRI__UCHAR_NOTUSED_MASK; (x)[1] = c; }
#define STRI__UCHAR_CREATE_COMPLEMENT_BINPROP(x,c) \
   { (x)[0] = STRI__UCHAR_NOTUSED_MASK; (x)[1] = (c | STRI__UCHAR_COMPLEMENT_MASK); }

#define STRI__UCHAR_GET_MATCHING_BINPROP(x)         ((x)[1])
#define STRI__UCHAR_GET_COMPLEMENT_BINPROP(x)       ((x)[1] & (~STRI__UCHAR_COMPLEMENT_MASK))


#define STRI__UCHAR_IS_ANY_GCMASK(x) \
   (((x)[1] == STRI__UCHAR_NOTUSED_MASK) && ((x)[0] != STRI__UCHAR_NOTUSED_MASK))
#define STRI__UCHAR_IS_MATCHING_GCMASK(x) \
   ((STRI__UCHAR_IS_ANY_GCMASK(x)) && (((x)[0] & (~STRI__UCHAR_COMPLEMENT_MASK)) == (x)[0]))
#define STRI__UCHAR_IS_COMPLEMENT_GCMASK(x) \
   ((STRI__UCHAR_IS_ANY_GCMASK(x)) && (((x)[0] & STRI__UCHAR_COMPLEMENT_MASK) == STRI__UCHAR_COMPLEMENT_MASK))
   
#define STRI__UCHAR_CREATE_MATCHING_GCMASK(x,c) \
   { (x)[1] = STRI__UCHAR_NOTUSED_MASK; (x)[0] = c; }
#define STRI__UCHAR_CREATE_COMPLEMENT_GCMASK(x,c) \
   { (x)[1] = STRI__UCHAR_NOTUSED_MASK; (x)[0] = (c | STRI__UCHAR_COMPLEMENT_MASK); }

#define STRI__UCHAR_GET_MATCHING_GCMASK(x)         ((x)[0])
#define STRI__UCHAR_GET_COMPLEMENT_GCMASK(x)       ((x)[0] & (~STRI__UCHAR_COMPLEMENT_MASK))

   

void stri__uchar_charType(const char* s, int n, int* codes);
SEXP stri_charcategories();
SEXP stri_chartype(SEXP s);
SEXP stri_char_getcategoryid(SEXP x);
SEXP stri_char_getpropertyid(SEXP x);


// length.cpp
SEXP stri_numbytes(SEXP s);
R_len_t stri__numbytes_max(SEXP s);
SEXP stri_length(SEXP s);

// replace.cpp
SEXP stri_replace_first_fixed(SEXP s, SEXP pat, SEXP rep);
SEXP stri_replace_all_fixed(SEXP s, SEXP pat, SEXP rep);

// reverse.cpp
SEXP stri_reverse(SEXP s);

// wrap.cpp
SEXP stri_wrap_greedy(SEXP count, SEXP width, SEXP spacecost);
SEXP stri_wrap_dynamic(SEXP count, SEXP width, SEXP spacecost);
SEXP stri_wrap(SEXP wordslist,SEXP method,SEXP width,SEXP spacecost);

// split.cpp
SEXP stri_split_fixed(SEXP s, SEXP split, SEXP n, SEXP omitempty);
SEXP stri_split_pos(SEXP s, SEXP from, SEXP to);
SEXP stri__split_pos(const char* s, int* from, int* to, int ns, int n);

// sub.cpp
SEXP stri_sub(SEXP s, SEXP from, SEXP to);

// locate.cpp
SEXP stri_locate_all_class(SEXP s, SEXP c);
SEXP stri_locate_first_or_last_class(SEXP s, SEXP c, SEXP first);

void stri__locate_all_class1(const char* s, int n, int32_t* c,
   int* start, int* end, int& o);
void stri__locate_first_and_last_class1(const char* s, int n, int32_t* cls,
   int& first, int& last);
   
// ------------------------------------------------------------------------



#endif
