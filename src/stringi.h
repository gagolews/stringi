/* This file is part of the 'stringi' library.
 * 
 * Copyright 2013 Marek Gagolewski, Bartek Tartanus
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

// do not enable this:
//#define U_CHARSET_IS_UTF8 1

#include <iostream>
#include <unicode/uchar.h>
#include <unicode/utypes.h>
#include <unicode/ucnv.h>
#include <unicode/stringpiece.h>
#include <unicode/utf8.h>
#include <unicode/normalizer2.h>
#include <unicode/locid.h>

#include <R.h>
#include <Rmath.h>
#include <Rdefines.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <cstring>
#include <iomanip>
#include <sstream>
using namespace std;
using namespace icu;

// undef R's length macro (conflicts with std::string.length())
// use LENGTH instead
#undef length


#define SSTR(x) (dynamic_cast<ostringstream&>(ostringstream() << std::dec << x).str())


// ------------------------------------------------------------------------

// trim.cpp:
SEXP stri_trim(SEXP s);

// unicode_normalization.cpp:
SEXP stri_unicode_normalization(SEXP s, SEXP type);

// casefold.cpp:
SEXP stri_casefold(SEXP s, SEXP type);

// dup.cpp:
SEXP stri_dup(SEXP s, SEXP c);

// join.cpp:
SEXP stri_flatten(SEXP s);
SEXP stri_join2(SEXP s1, SEXP s2);

// compare.cpp:
SEXP stri_casecompare(SEXP x, SEXP y);

// ICU_settings.cpp:
SEXP stri_getinfo();

// prepare_arg.cpp:
SEXP stri_prepare_arg_string(SEXP x);

// ucnv.cpp:
void stri__ucnv_getStandards(const char**& standards, R_len_t& cs);
const char* stri___ucnv_getFriendlyName(const char* canname);
SEXP stri_ucnv_enclist();
SEXP stri_ucnv_encinfo(SEXP enc);

// length.cpp
SEXP stri_numbytes(SEXP s);


// ------------------------------------------------------------------------



#endif
