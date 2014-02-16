/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#ifndef __stri_external_h
#define __stri_external_h


#ifdef U_CHARSET_IS_UTF8
// do not enable this (must be unset before including ICU headers):
#undef U_CHARSET_IS_UTF8
#endif

#ifndef NDEBUG
//#define U_HIDE_DRAFT_API
#define U_HIDE_DEPRECATED_API
#endif

#define  UNISTR_FROM_CHAR_EXPLICIT   explicit
#define 	UNISTR_FROM_STRING_EXPLICIT explicit

#include <cstdarg>
#include <iostream>
#include <deque>
#include <queue>
#include <algorithm>
#include <vector>
#include <map>
using namespace std;


#include "unicode/ptypes.h"
#include "unicode/uchar.h"
#include "unicode/utypes.h"
#include "unicode/ucnv.h"
#include "unicode/ustring.h"
#include "unicode/stringpiece.h"
#include "unicode/utf8.h"
#include "unicode/utf16.h"
#include "unicode/normalizer2.h"
#include "unicode/locid.h"
#include "unicode/uloc.h"
#include "unicode/regex.h"
#include "unicode/brkiter.h"
#include "unicode/coll.h"
#include "unicode/ucol.h"
#include "unicode/ucsdet.h"
#include "unicode/stsearch.h"
#include "unicode/ulocdata.h"
#include "unicode/usearch.h"
#include "unicode/uniset.h"
using namespace icu;

#define USE_RINTERNALS
#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include <Rmath.h>
#include <Rdefines.h>
#include <R_ext/Rdynload.h>


#endif
