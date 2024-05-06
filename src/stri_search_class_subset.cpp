/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2024, Marek Gagolewski <https://www.gagolewski.com/>
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
#include "stri_container_utf8.h"
#include "stri_container_charclass.h"


/**
 * Detect if a character class occurs in a string
 *
 * @param str character vector
 * @param pattern character vector
 * @param omit_na single logical value
 * @return logical vector
 *
 * @version 0.3-1 (Bartek Tartanus, 2014-07-25)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-10-17)
 *                using std::vector<int> to avoid mem-leaks
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-04)
 *    #122: omit_na arg added
 *
 * @version 1.0-3 (Marek Gagolewski, 2016-02-03)
 *    #216: `negate` arg added
 *
 * @version 1.7.1 (Marek Gagolewski, 2021-06-17)
 *    assure LENGTH(pattern) <= LENGTH(str)
 */
SEXP stri_subset_charclass(SEXP str, SEXP pattern, SEXP omit_na, SEXP negate)
{
    bool negate_1 = stri__prepare_arg_logical_1_notNA(negate, "negate");
    bool omit_na1 = stri__prepare_arg_logical_1_notNA(omit_na, "omit_na");
    PROTECT(str = stri__prepare_arg_string(str, "str"));
    PROTECT(pattern = stri__prepare_arg_string(pattern, "pattern"));

    if (LENGTH(str) > 0 && LENGTH(str) < LENGTH(pattern))
        Rf_error(MSG__WARN_RECYCLING_RULE2);

    R_len_t vectorize_length =
        stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

    if (vectorize_length == 0) {
        UNPROTECT(2);
        return Rf_allocVector(STRSXP, 0);
    }

    STRI__ERROR_HANDLER_BEGIN(2)
    StriContainerUTF8 str_cont(str, vectorize_length);
    StriContainerCharClass pattern_cont(pattern, vectorize_length);

    // BT: this cannot be done with deque, because pattern is reused so i does not
    // go like 0,1,2...n but 0,pat_len,2*pat_len,1,pat_len+1 and so on
    // MG: agreed
    std::vector<int> which(vectorize_length);
    int result_counter = 0;

    for (R_len_t i = pattern_cont.vectorize_init();
            i != pattern_cont.vectorize_end();
            i = pattern_cont.vectorize_next(i))
    {
        if (str_cont.isNA(i) || pattern_cont.isNA(i)) {
            if (omit_na1) which[i] = FALSE;
            else {
                which[i] = NA_LOGICAL;
                result_counter++;
            }
            continue;
        }

        const UnicodeSet* pattern_cur = &pattern_cont.get(i);
        R_len_t     str_cur_n = str_cont.get(i).length();
        const char* str_cur_s = str_cont.get(i).c_str();

        UChar32 chr = 0;
        which[i] = FALSE;
        for (R_len_t j=0; j<str_cur_n; ) {
            U8_NEXT(str_cur_s, j, str_cur_n, chr);
            if (chr < 0) // invalid UTF-8 sequence
                throw StriException(MSG__INVALID_UTF8);
            if (pattern_cur->contains(chr)) {
                which[i] = TRUE;
                break;
            }
        }
        if (negate_1) which[i] = !which[i];
        if (which[i]) result_counter++;
    }

    SEXP ret;
    STRI__PROTECT(ret = stri__subset_by_logical(str_cont, which, result_counter));
    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}



/**
 * Substitutes vector elements if a pattern occurs in a string
 *
 * @param str character vector
 * @param pattern character vector
 * @param value character vector
 * @return character vector
 *
 * @version 1.0-3 (Marek Gagolewski, 2016-02-03)
 *   #124
 *
 * @version 1.0-3 (Marek Gagolewski, 2016-02-03)
 *   #216: `negate` arg added
 *
 * @version 1.7.1 (Marek Gagolewski, 2021-06-17)
 *    assure LENGTH(pattern) and LENGTH(value) <= LENGTH(str)
 */
SEXP stri_subset_charclass_replacement(SEXP str, SEXP pattern, SEXP negate, SEXP value)
{
    bool negate_1 = stri__prepare_arg_logical_1_notNA(negate, "negate");
    PROTECT(str = stri__prepare_arg_string(str, "str"));
    PROTECT(pattern = stri__prepare_arg_string(pattern, "pattern"));
    PROTECT(value = stri__prepare_arg_string(value, "value"));

    // we are subsetting `str`, therefore recycling is slightly different here
    if (LENGTH(value) == 0) Rf_error(MSG__REPLACEMENT_ZERO);
    if (LENGTH(pattern) == 0) Rf_error(MSG__WARN_EMPTY_VECTOR);
    if (LENGTH(str) == 0) {
        UNPROTECT(3);
        return Rf_allocVector(STRSXP, 0);
    }
    if (LENGTH(str) < LENGTH(pattern))  // for LENGTH(value), we emit warning later on
        Rf_error(MSG__WARN_RECYCLING_RULE2);
    if ((LENGTH(str) % LENGTH(pattern)) != 0)
        Rf_warning(MSG__WARN_RECYCLING_RULE);
    R_len_t vectorize_length = LENGTH(str);

    STRI__ERROR_HANDLER_BEGIN(3)
    R_len_t value_length = LENGTH(value);
    StriContainerUTF8 value_cont(value, value_length);
    StriContainerUTF8 str_cont(str, vectorize_length);
    StriContainerCharClass pattern_cont(pattern, vectorize_length);

    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));

    std::vector<int> detected(vectorize_length, 0);
    for (R_len_t i = pattern_cont.vectorize_init();
            i != pattern_cont.vectorize_end();
            i = pattern_cont.vectorize_next(i))
    {
        if (pattern_cont.isNA(i)) {
            // behave like `[<-`
            detected[i] = false;
            continue;
        }
        if (str_cont.isNA(i)) {
            detected[i] = NA_INTEGER;
            continue;
        }

        const UnicodeSet* pattern_cur = &pattern_cont.get(i);
        R_len_t     str_cur_n = str_cont.get(i).length();
        const char* str_cur_s = str_cont.get(i).c_str();

        UChar32 chr = 0;
        bool found = false;
        for (R_len_t j=0; j<str_cur_n; ) {
            U8_NEXT(str_cur_s, j, str_cur_n, chr);
            if (chr < 0) // invalid UTF-8 sequence
                throw StriException(MSG__INVALID_UTF8);
            if (pattern_cur->contains(chr)) {
                found = true;
                break;
            }
        }

        detected[i] = ((found && !negate_1) || (!found && negate_1));
    }

    R_len_t k = 0;  // we must traverse `str_cont` in order now
    for (R_len_t i = 0; i<vectorize_length; ++i) {
        if (detected[i] == NA_INTEGER)
            SET_STRING_ELT(ret, i, NA_STRING);
        else if (detected[i] == 0)
            SET_STRING_ELT(ret, i, str_cont.toR(i));
        else
            SET_STRING_ELT(ret, i, value_cont.toR((k++)%value_length));
    }
    if ((k % value_length) != 0) Rf_warning(MSG_REPLACEMENT_MULTIPLE);

    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(;/* nothing special to be done on error */)
}
