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
 
#ifndef __external_h
#define __external_h


#ifdef U_CHARSET_IS_UTF8
// do not enable this (must be unset before including ICU headers):
#undef U_CHARSET_IS_UTF8
#endif


//#define U_HIDE_DRAFT_API
#define U_HIDE_DEPRECATED_API

#define  UNISTR_FROM_CHAR_EXPLICIT   explicit
#define 	UNISTR_FROM_STRING_EXPLICIT explicit

#include <cstdarg>
#include <iostream>
#include <deque>
#include <queue>
#include <algorithm>
#include <vector>
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
#include <unicode/brkiter.h>
#include <unicode/coll.h>
#include <unicode/ucol.h>
#include <unicode/stsearch.h>
using namespace std;
using namespace icu;

#define USE_RINTERNALS
#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include <Rmath.h>
#include <Rdefines.h>
#include <R_ext/Rdynload.h>


#endif
