/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2021, Marek Gagolewski <https://www.gagolewski.com>
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

#include "stri_stringi.h"
#include "stri_ucnv.h"
#include "stri_container_utf8.h"


/**
 * Get the largest number of bytes amongst the strings in a character vector
 * (useful for allocating temporary buffers)
 *
 * If all strings are NA or an empty character vector is given, -1 is returned.
 * Prior to memory allocation, you should check for < 0!
 *
 * Note that ICU permits only strings of length < 2^31.
 * @param s character vector
 * @return maximal number of bytes
 *
 * @version 0.1-?? (Marek Gagolewski)
 */
R_len_t stri__numbytes_max(SEXP str)
{
    // STRI_ASSERT - str is a character vector
    R_len_t ns = LENGTH(str);
    if (ns <= 0) return -1;
    R_len_t maxlen = -1;
    for (R_len_t i=0; i<ns; ++i) {
        SEXP cs = STRING_ELT(str, i);
        if (cs != NA_STRING) {
            /* INPUT ENCODING CHECK: this function does not need this. */
            R_len_t cns = LENGTH(cs);
            if (cns > maxlen) maxlen = cns;
        }
    }
    return maxlen;
    // TODO: overload this function for StriContainers.....
}


/**
 * Count the number of characters/code points in a string
 *
 * Note that ICU permits only strings of length < 2^31.
 *
 * @param s character vector
 * @return integer vector
 *
 * @version 0.1-?? (Marcin Bujarski)
 *
 * @version 0.1-?? (Marek Gagolewski)
 *          Multiple input encoding support
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-16)
 *          make StriException-friendly
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-03-27)
 *          using StriUcnv;
 *          warn on invalid UTF-8 sequences
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 1.6.3 (Marek Gagolewski, 2021-05-22)
 *    use stri__length_string for UTF-8
 */
SEXP stri_length(SEXP str)
{
    PROTECT(str = stri__prepare_arg_string(str, "str"));

    STRI__ERROR_HANDLER_BEGIN(1)

    R_len_t str_n = LENGTH(str);
    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_n));
    int* retint = INTEGER(ret);

    StriUcnv ucnvNative(NULL);

    for (R_len_t k = 0; k < str_n; k++) {
        SEXP curs = STRING_ELT(str, k);
        if (curs == NA_STRING) {
            retint[k] = NA_INTEGER;
            continue;
        }

        R_len_t curs_n = LENGTH(curs);  // O(1) - stored in SEXPREC
        if (IS_ASCII(curs) || IS_LATIN1(curs)) {
            retint[k] = curs_n;
        }
        else if (IS_BYTES(curs)) {
            throw StriException(MSG__BYTESENC);
        }
        else if (IS_UTF8(curs) || ucnvNative.isUTF8()) { // UTF-8 or native is UTF-8
            const char* curs_s = CHAR(curs);  // TODO: ALTREP will be problematic?
            retint[k] = stri__length_string(curs_s, curs_n);
        }
        else if (ucnvNative.is8bit()) { // native-8bit
            retint[k] = curs_n;
        }
        else { // native encoding, not 8 bit

            UConverter* uconv = ucnvNative.getConverter();

            // native encoding which is neither 8-bit nor UTF-8 (e.g., 'Big5')
            // this is weird, but we're prepared
            UErrorCode status = U_ZERO_ERROR;
            const char* source = CHAR(curs);  // TODO: ALTREP will be problematic?
            const char* sourceLimit = source + curs_n;
            R_len_t j;
            for (j = 0; source != sourceLimit; j++) {
                /*ignore_retval=*/ucnv_getNextUChar(uconv, &source, sourceLimit, &status);
                STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
            }
            retint[k] = j; // all right, we got it!
        }
    }

    STRI__UNPROTECT_ALL
    return ret;

    STRI__ERROR_HANDLER_END({ /* no special action on error */ })
}


/**
 * Get number of bytes in each string
 *
 * Note that ICU permits only strings of length < 2^31.
 *
 * @param s R object coercible to a character vector
 * @return integer vector
 *
 * @version 0.1-?? (Marcin Bujarski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *          StriException-friendly
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_numbytes(SEXP str)
{
    PROTECT(str = stri__prepare_arg_string(str, "str")); // prepare string argument
    R_len_t str_n = LENGTH(str);

    STRI__ERROR_HANDLER_BEGIN(1)
    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_n));
    int* retint = INTEGER(ret);
    for (R_len_t i=0; i<str_n; ++i) {
        SEXP curs = STRING_ELT(str, i);
        /* INPUT ENCODING CHECK: this function does not need this. */
        retint[i] = (curs == NA_STRING)?NA_INTEGER:LENGTH(curs); // O(1) - stored by R
    }
    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END({ /* no special action on error */ })
}


/**
 * Determine which strings are of length 0
 *
 * Note that ICU permits only strings of length < 2^31.
 *
 * @param s R character vector
 * @return logical vector
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-1 (Marek Gagolewski, 2014-04-01)
 *          StriException-friendly
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_isempty(SEXP str)
{
    PROTECT(str = stri__prepare_arg_string(str, "str")); // prepare string argument
    R_len_t str_n = LENGTH(str);

    STRI__ERROR_HANDLER_BEGIN(1)
    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(LGLSXP, str_n));
    int* retlog = LOGICAL(ret);
    for (R_len_t i=0; i<str_n; ++i) {
        SEXP curs = STRING_ELT(str, i);
        /* INPUT ENCODING CHECK: this function does not need this. */
        retlog[i] = (curs == NA_STRING)?NA_LOGICAL:(LENGTH(curs) <= 0);
    }
    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END({ /* no special action on error */ })
}


#ifdef DEBUG
//#define DEBUG_STRI_WIDTH
#endif


/** Get width of a single character
 *
 * inspired by http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
 * and https://github.com/nodejs/node/blob/master/src/node_i18n.cc
 * but with extras
 *
 * @version ?? init
 *
 * @version 1.2.1 (Marek Gagolewski, 2018-04-20)
 *    add Variation Selectors support (width 0)
 *
 * @version 1.6.1 (Marek Gagolewski, 2021-05-04)
 *    emoji support etc.
 *
 * @version 1.6.2 (Marek Gagolewski, 2021-05-13)
 *    bugfixes
 *
 * @param c code point
 * @return 0, 1, or 2
 */
int stri__width_char(UChar32 c)
{
    /* Characters with the \code{UCHAR_EAST_ASIAN_WIDTH} enumerable property
       equal to \code{U_EA_FULLWIDTH} or \code{U_EA_WIDE} are of width 2. */
    int width = (int)u_getIntPropertyValue(c, UCHAR_EAST_ASIAN_WIDTH);

#ifdef DEBUG_STRI_WIDTH
//     Rscript -e 'stringi::stri_width("\u005E\u0060\u2081\u03C9\u0425\u00DF")'
    Rprintf(
        "c=%08x MN=%d ME=%d CF=%d CC=%d SO=%d SK=%d EMOJI_MOD=%d EMOJI_PRES=%d h1=%d h2=%d w=%d\n", (int)c,
        0!=(U_GET_GC_MASK(c) & U_GC_MN_MASK),
        0!=(U_GET_GC_MASK(c) & U_GC_ME_MASK),
        0!=(U_GET_GC_MASK(c) & U_GC_CF_MASK),
        0!=(U_GET_GC_MASK(c) & U_GC_CC_MASK),
        0!=(U_GET_GC_MASK(c) & U_GC_SO_MASK),
        0!=(U_GET_GC_MASK(c) & U_GC_SK_MASK),
        0!=u_hasBinaryProperty(c, UCHAR_EMOJI_MODIFIER),
        0!=u_hasBinaryProperty(c, UCHAR_EMOJI_PRESENTATION),
        u_getIntPropertyValue(c, UCHAR_HANGUL_SYLLABLE_TYPE) == U_HST_VOWEL_JAMO,
        u_getIntPropertyValue(c, UCHAR_HANGUL_SYLLABLE_TYPE) == U_HST_TRAILING_JAMO,
        (int)width
    );
//      U_EA_NEUTRAL,   0/*[N]*/
//      U_EA_AMBIGUOUS, 1/*[A]*/
//      U_EA_HALFWIDTH, 2/*[H]*/
//      U_EA_FULLWIDTH, 3/*[F]*/
//      U_EA_NARROW,    4/*[Na]*/
//      U_EA_WIDE,      5/*[W]*/
#endif

    if (c == (UChar32)0x00AD) return 1; /* SOFT HYPHEN  */
    if (c == (UChar32)0x200B) return 0; /* ZERO WIDTH SPACE */

    /* GC: Me, Mn, Cf, Cc -> width = 0 */
    if (U_GET_GC_MASK(c) &
            (U_GC_MN_MASK | U_GC_ME_MASK | U_GC_CF_MASK | U_GC_CC_MASK))
        return 0;

    /* Hangul Jamo medial vowels and final consonants have width 0 */
    int hangul = (int)u_getIntPropertyValue(c, UCHAR_HANGUL_SYLLABLE_TYPE);
    if (hangul == U_HST_VOWEL_JAMO || hangul == U_HST_TRAILING_JAMO)
        return 0;

    /* Variation Selectors */
    if (c >= (UChar32)0xFE00 && c <= (UChar32)0xFE0F)
        return 0;

#if U_ICU_VERSION_MAJOR_NUM>=57
    // UCHAR_EMOJI_* is ICU >= 57
    if (
        u_hasBinaryProperty(c, UCHAR_EMOJI_MODIFIER)
    ) {
        return 0;
    }
#endif

    if (width == U_EA_FULLWIDTH || width == U_EA_WIDE)
        return 2;

    /* v1.6.1 had U_EA_AMBIGUOUS set to 2, this was not a good idea
    if (width == U_EA_AMBIGUOUS) return 2;
    // 'a' is narrow
    // 'a with ogonek' is neutral
    // 'Eszett' is ambiguous
    // 'grave accent' is narrow
    */

    /* v1.6.1 GC=So -> width = 2 */
    if (U_GET_GC_MASK(c) & (U_GC_SO_MASK))
        return 2;

    /*
    v1.6.1 had GC=Sk of width = 0
    but there are exceptions:
    \u005E \N{CIRCUMFLEX ACCENT}   ^  is Sk
    \u0060 \N{GRAVE ACCENT}        `  is Sk
    generally, it's not a good idea
    */


#if U_ICU_VERSION_MAJOR_NUM>=57
    // UCHAR_EMOJI_* is ICU >= 57
    if (width == U_EA_NEUTRAL && u_hasBinaryProperty(c, UCHAR_EMOJI_PRESENTATION))
        return 2;
#endif

    /*  any other characters have width 1 */
    return 1;
}




/** Get width of a single character (context-dependent)
 *
 * inspired by http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
 * and https://github.com/nodejs/node/blob/master/src/node_i18n.cc
 * but with extras
 *
 * @version 1.6.3 (Marek Gagolewski, 2021-06-14)
 *    stand-alone fun
 *
 * @param c code point
 * @param p previous code point
 * @return int
 */
int stri__width_char_with_context(UChar32 c, UChar32 p, bool& reset)
{
    if (reset) {
        p = 0;
        reset = false;
    }

#if U_ICU_VERSION_MAJOR_NUM>=57
    // UCHAR_EMOJI_* is ICU >= 57
    if (
        /*j > 0 &&*/ p == 0x200D /* ZERO WIDTH JOINER */ && (
            u_hasBinaryProperty(c, UCHAR_EMOJI_MODIFIER) ||
            u_hasBinaryProperty(c, UCHAR_EMOJI_PRESENTATION) ||
            c == 0x2640 /* FEMALE */ ||
            c == 0x2642 /* MALE */ ||
            c == 0x26A7 /* TRANSGENDER */ ||
            c == 0x2695 /* HEALTH */ ||
            c == 0x2696 /* JUDGE */ ||
            c == 0x1F5E8 /* SPEECH */ ||
            c == 0x1F32B /* CLOUDS */ ||
            c == 0x2708 /* PLANE */ ||
            c == 0x2764 /* HEART */ ||
            c == 0x2744 /* SNOWFLAKE */ ||
            c == 0x2620 /* SKULL AND CROSSBONES */
        )
    ) {
        // emoji sequence - ignore (display might not support it)
        return 0;
    }
    else if (
        /*j > 0 &&*/ (p >= 0x1F1E6 && p <= 0x1F1FF)
        && (c >= 0x1F1E6 && c <= 0x1F1FF)
    ) {
        // E2.0 flag (p counted as of width=2 already)
        reset = true;  // allow the next flag to be recognised
        return 0;
    }
    else {
        return stri__width_char(c);
    }
#else // U_ICU_VERSION_MAJOR_NUM < 57 - no emoji support
    return stri__width_char(c);
#endif
}


/** Get the length (number of Unicode code points) of a single UTF-8 string
 *  or get the position where a substring of <= max_length ends
 *
 * @param str_cur_s string
 * @param str_cur_n number of bytes in str_cur_s
 * @param max_length
 * @return length of the whole string (if max_length==NA_INTEGER) or index
 *
 * @version 1.6.3 (Marek Gagolewski, 2021-05-22)
 *    extracted from stri_length
 */
int stri__length_string(const char* str_cur_s, int str_cur_n, int max_length)
{
    // is string is in ASCII, then length == str_cur_n, but with
    // merely str_cur_s ptr we are unable to tell that here

    UChar32 c = 0;
    R_len_t j = 0;
    R_len_t cur_length = 0;
    while (j < str_cur_n) {
        R_len_t prevj = j;
        U8_NEXT(str_cur_s, j, str_cur_n, c); // faster that U8_FWD_1 & gives bad UChar32s
        if (c < 0)
            throw StriException(MSG__INVALID_UTF8);
        cur_length++;
        if (max_length != NA_INTEGER && cur_length > max_length)
            return prevj;
    }

    if (max_length == NA_INTEGER)
        return cur_length;
    else
        return str_cur_n;  // the whole string has length <= max_length
}


/** Get the width of a single UTF-8 string or get the position where
 *  a substring of <= max_width ends
 *
 * @param str_cur_s string
 * @param str_cur_n number of bytes in str_cur_s
 * @param max_width
 * @return width of the whole string (if max_width==NA_INTEGER)
 * or index
 *
 * @version 1.6.1 (Marek Gagolewski)
 *    most in https://unicode.org/Public/emoji/13.1/emoji-test.txt of width=2
 *
 * @version 1.6.2 (Marek Gagolewski, 2021-05-13)
 *    bugfixes
 *
 * @version 1.6.3 (Marek Gagolewski, 2021-05-22)
 *    max_width
 */
int stri__width_string(const char* str_cur_s, int str_cur_n, int max_width)
{
    int cur_width = 0;

    UChar32 p;      // previous
    UChar32 c = 0;  // current
    R_len_t j = 0;
    bool reset = true;
    while (j < str_cur_n) {
        R_len_t prevj = j;
        p = c;
        U8_NEXT(str_cur_s, j, str_cur_n, c);
        if (c < 0)
            throw StriException(MSG__INVALID_UTF8);

        cur_width += stri__width_char_with_context(c, p, reset);

        // test if max_width exceeded (here; there may be zero-width chars)
        if (max_width != NA_INTEGER && cur_width > max_width)
            return prevj;
    }

    if (max_width == NA_INTEGER)
        return cur_width;
    else
        return str_cur_n;  // the whole string has width <= max_width
}


/**
  * Determine the width of strings
  *
  * @param str character vector
  * @return integer vector
  *
  * @version 0.5-1 (Marek Gagolewski, 2015-04-22)
  */
SEXP stri_width(SEXP str)
{
    PROTECT(str = stri__prepare_arg_string(str, "str")); // prepare string argument

    STRI__ERROR_HANDLER_BEGIN(1)
    R_len_t str_n = LENGTH(str);
    StriContainerUTF8 str_cont(str, str_n);

    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(INTSXP, str_n));
    int* retint = INTEGER(ret);

    for (R_len_t i = str_cont.vectorize_init();
            i != str_cont.vectorize_end();
            i = str_cont.vectorize_next(i))
    {
        if (str_cont.isNA(i)) {
            retint[i] = NA_INTEGER;
            continue;
        }

        const char* str_cur_s = str_cont.get(i).c_str();
        R_len_t     str_cur_n = str_cont.get(i).length();
        retint[i] = stri__width_string(str_cur_s, str_cur_n);
    }

    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END({ /* no special action on error */ })
}
