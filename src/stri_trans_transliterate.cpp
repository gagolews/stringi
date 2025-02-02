/* This file is part of the 'stringi' project.
 * Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
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
#include "stri_container_utf16.h"
#include <unicode/translit.h>
#include <unicode/strenum.h>
#include <string>


/** List available transliterators
 *
 * @return character vector
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-19)
 *
 * @version 0.2-3 (Marek Gagolewski, 2015-05-12)
 *          uses Transliterator::getAvailableIDs
 *          as getAvailableID is obsolete as of ICU 3.x
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-04)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 */
SEXP stri_trans_list()
{
    StringEnumeration* trans_enum = NULL;

    STRI__ERROR_HANDLER_BEGIN(0)

    UErrorCode status = U_ZERO_ERROR;
    trans_enum = Transliterator::getAvailableIDs(status); /*The caller should delete this object when done using it. */
    STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

    trans_enum->reset(status);
    STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

    R_len_t n = (R_len_t)trans_enum->count(status);
    STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(STRSXP, n));

    // MG: I reckon than IDs are more readable than DisplayNames
    for (R_len_t i=0; i<n; ++i) {
        int len;
        const char* cur = trans_enum->next(&len, status);
        STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
        SET_STRING_ELT(ret, i, Rf_mkCharLenCE(cur, len, CE_UTF8));
    }

    if (trans_enum) {
        delete trans_enum;
        trans_enum = NULL;
    }
    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(
        if (trans_enum) {
            delete trans_enum;
            trans_enum = NULL;
        }
    )
}


/** General text transform with ICU Transliterator
 *
 * @param str character vector
 * @param id single string
 * @param rules single bool
 * @param forward single bool
 * @return character vector
 *
 * @version 0.2-2 (Marek Gagolewski, 2014-04-19)
 * @version 1.6.3 (Marek Gagolewski, 2021-06-03)  rules, forward
 */
SEXP stri_trans_general(SEXP str, SEXP id, SEXP rules, SEXP forward)
{
    PROTECT(str = stri__prepare_arg_string(str, "str"));
    PROTECT(id  = stri__prepare_arg_string_1(id, "id"));
    bool rules_val = stri__prepare_arg_logical_1_notNA(rules, "rules");
    bool forward_val = stri__prepare_arg_logical_1_notNA(forward, "forward");

    R_len_t str_length = LENGTH(str);

    Transliterator* trans = NULL;
    STRI__ERROR_HANDLER_BEGIN(2)
    StriContainerUTF16 id_cont(id, 1);
    if (id_cont.isNA(0)) {
        STRI__UNPROTECT_ALL
        return stri__vector_NA_strings(str_length);
    }

    UErrorCode status = U_ZERO_ERROR;
    UParseError parserr;
    if (!rules_val)
        trans = Transliterator::createInstance(
            id_cont.get(0),
            (forward_val?UTRANS_FORWARD:UTRANS_REVERSE),
            status
        );
    else
        trans = Transliterator::createFromRules(
            UnicodeString("Rule-based Transliterator"),  // can be anything
            id_cont.get(0),
            (forward_val?UTRANS_FORWARD:UTRANS_REVERSE),
            parserr,
            status
        );
    STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

    StriContainerUTF16 str_cont(str, str_length, false); // writable, no recycle

    for (R_len_t i=0; i<str_length; ++i) {
        if (str_cont.isNA(i)) continue;
        trans->transliterate(str_cont.getWritable(i));
    }

    if (trans) {
        delete trans;
        trans = NULL;
    }
    STRI__UNPROTECT_ALL
    return str_cont.toR();
    STRI__ERROR_HANDLER_END(
        if (trans) {
            delete trans;
            trans = NULL;
        }
    )
}
