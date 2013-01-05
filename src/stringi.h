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

// ------------------------------------------------------------------------



#endif
