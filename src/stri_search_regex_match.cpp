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
#include "stri_container_utf8.h"
#include "stri_container_regex.h"
#include <vector>
#include <deque>
#include <utility>
using namespace std;



/**
 * Extract all capture groups of the first/last occurrence
 * of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @param first logical - search for the first or the last occurrence?
 * @param cg_missing single string
 * @return character matrix
 *
 * @version 0.1-??? (Marek Gagolewski, 2013-06-22)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-06)
 *    new arg: cg_missing
 *
 * @version 1.0-2 (Marek Gagolewski, 2016-01-29)
 *    Issue #214: allow a regex pattern like `.*`  to match an empty string
 *
 * @version 1.1.8 (Marek Gagolewski, 2018-04-09)
 *    #288: stri_match did not return correct number of columns
 *    when input was empty
 *
 * @version 1.4.7 (Marek Gagolewski, 2020-08-24)
 *    Use StriContainerRegexPattern::getRegexOptions
 *
 * @version 1.7.1 (Marek Gagolewski, 2021-06-19)
 *    #153: named capture groups
 */
SEXP stri__match_firstlast_regex(SEXP str, SEXP pattern, SEXP cg_missing, SEXP opts_regex, bool first)
{
    // @TODO: capture_groups arg (integer vector/set - which capture groups to extract)
    PROTECT(str = stri__prepare_arg_string(str, "str")); // prepare string argument
    PROTECT(pattern = stri__prepare_arg_string(pattern, "pattern")); // prepare string argument
    PROTECT(cg_missing = stri__prepare_arg_string_1(cg_missing, "cg_missing"));
    R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

    StriRegexMatcherOptions pattern_opts =
        StriContainerRegexPattern::getRegexOptions(opts_regex);

    UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
    STRI__ERROR_HANDLER_BEGIN(3)
    StriContainerUTF8 str_cont(str, vectorize_length);
    StriContainerUTF8 cg_missing_cont(cg_missing, 1);
    STRI__PROTECT(cg_missing = STRING_ELT(cg_missing, 0));

    // we don't know how many capture groups are there:
    vector< vector< pair<const char*, const char*> > > occurrences(vectorize_length);
    R_len_t occurrences_max = 1;

    StriContainerRegexPattern pattern_cont(pattern, (LENGTH(str)>0)?vectorize_length:LENGTH(pattern), pattern_opts);
    if (LENGTH(str) == 0 && LENGTH(pattern) > 0) {
        // we need to determine the number of capture groups anyway
        for (R_len_t i = pattern_cont.vectorize_init();
                i != pattern_cont.vectorize_end();
                i = pattern_cont.vectorize_next(i))
        {
            if ((pattern_cont).isNA(i) || (pattern_cont).get(i).length() <= 0) {
                if (!(pattern_cont).isNA(i))
                    Rf_warning(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);
                continue;
            }

            RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
            int pattern_cur_groups = matcher->groupCount();
            if (occurrences_max < pattern_cur_groups+1) occurrences_max=pattern_cur_groups+1;
        }
    }
    else
    {
        for (R_len_t i = pattern_cont.vectorize_init();
                i != pattern_cont.vectorize_end();
                i = pattern_cont.vectorize_next(i))
        {
            if ((pattern_cont).isNA(i) || (pattern_cont).get(i).length() <= 0) {
                if (!(pattern_cont).isNA(i))
                    Rf_warning(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);
                continue;
            }

            UErrorCode status = U_ZERO_ERROR;
            RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
            int pattern_cur_groups = matcher->groupCount();
            if (occurrences_max < pattern_cur_groups+1) occurrences_max=pattern_cur_groups+1;

            if ((str_cont).isNA(i)) {
                continue;
            }

            str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
            const char* str_cur_s = str_cont.get(i).c_str();

            occurrences[i] = vector< pair<const char*, const char*> >(pattern_cur_groups+1);
            matcher->reset(str_text);
            while (1) {
                int m_res = (int)matcher->find(status);
                STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
                if (!m_res) break;
                occurrences[i][0].first  = str_cur_s+(int)matcher->start(status);
                occurrences[i][0].second = str_cur_s+(int)matcher->end(status);
                for (R_len_t j=1; j<=pattern_cur_groups; ++j) {
                    int m_start = (int)matcher->start(j, status);
                    STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
                    int m_end = (int)matcher->end(j, status);
                    STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
                    if (m_start < 0 || m_end < 0) {
                        occurrences[i][j].first  = NULL;
                        occurrences[i][j].second = NULL;
                    }
                    else {
                        occurrences[i][j].first  = str_cur_s+m_start;
                        occurrences[i][j].second = str_cur_s+m_end;
                    }
                }
                if (first) break;
            }
        }
    }

    if (str_text) {
        utext_close(str_text);
        str_text = NULL;
    }

    SEXP ret;
    STRI__PROTECT(ret = stri__matrix_NA_STRING(vectorize_length, occurrences_max));
    for (R_len_t i=0; i<vectorize_length; ++i) {
        R_len_t ni = (R_len_t)occurrences[i].size();
        for (R_len_t j=0; j<ni; ++j) {
            pair<const char*, const char*> retij = occurrences[i][j];
            if (retij.first != NULL && retij.second != NULL)
                SET_STRING_ELT(ret, i+j*vectorize_length,
                               Rf_mkCharLenCE(retij.first, (R_len_t)(retij.second-retij.first), CE_UTF8));
            else
                SET_STRING_ELT(ret, i+j*vectorize_length, cg_missing);
        }
    }

    if (pattern_cont.get_n() == 1) {  // only if there's 1 pattern, otherwise how to agree names?
        SEXP dimnames;
        STRI__PROTECT(dimnames = pattern_cont.getCaptureGroupRDimnames(0));  // reuses last matcher btw
        if (!Rf_isNull(dimnames)) Rf_setAttrib(ret, R_DimNamesSymbol, dimnames);
        STRI__UNPROTECT(1);
    }

    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(if (str_text) utext_close(str_text);)
}


/**
 * Extract all capture groups of the first occurrence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param cg_missing single string
 * @param opts_regex list
 * @return character matrix
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-22)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-06)
 *    new arg: cg_missing
 */
SEXP stri_match_first_regex(SEXP str, SEXP pattern, SEXP cg_missing, SEXP opts_regex)
{
    return stri__match_firstlast_regex(str, pattern, cg_missing, opts_regex, true);
}


/**
 * Extract all capture groups of the  last occurrence of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param cg_missing single string
 * @param opts_regex list
 * @return character matrix
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-22)
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-06)
 *    new arg: cg_missing
 */
SEXP stri_match_last_regex(SEXP str, SEXP pattern, SEXP cg_missing, SEXP opts_regex)
{
    return stri__match_firstlast_regex(str, pattern, cg_missing, opts_regex, false);
}


/**
 * Extract all capture groups of  all occurrences of a regex pattern in each string
 *
 * @param str character vector
 * @param pattern character vector
 * @param opts_regex list
 * @param cg_missing single string
 * @return list of character matrices
 *
 * @version 0.1-?? (Marek Gagolewski, 2013-06-22)
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Issue #112: str_prepare_arg* retvals were not PROTECTed from gc
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-11-27)
 *    FR #117: omit_no_match arg added
 *
 * @version 0.4-1 (Marek Gagolewski, 2014-12-06)
 *    new arg: cg_missing
 *
 * @version 1.0-2 (Marek Gagolewski, 2016-01-29)
 *    Issue #214: allow a regex pattern like `.*`  to match an empty string
 *
 * @version 1.7.1 (Marek Gagolewski, 2021-06-19)
 *    #153: named capture groups
 */
SEXP stri_match_all_regex(SEXP str, SEXP pattern, SEXP omit_no_match, SEXP cg_missing, SEXP opts_regex)
{
    bool omit_no_match1 = stri__prepare_arg_logical_1_notNA(omit_no_match, "omit_no_match");
    PROTECT(str = stri__prepare_arg_string(str, "str")); // prepare string argument
    PROTECT(pattern = stri__prepare_arg_string(pattern, "pattern")); // prepare string argument
    PROTECT(cg_missing = stri__prepare_arg_string_1(cg_missing, "cg_missing"));
    R_len_t vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));

    StriRegexMatcherOptions pattern_opts =
        StriContainerRegexPattern::getRegexOptions(opts_regex);

    UText* str_text = NULL; // may potentially be slower, but definitely is more convenient!
    STRI__ERROR_HANDLER_BEGIN(3)
    StriContainerUTF8 str_cont(str, vectorize_length);
    StriContainerRegexPattern pattern_cont(pattern, vectorize_length, pattern_opts);
    StriContainerUTF8 cg_missing_cont(cg_missing, 1);
    STRI__PROTECT(cg_missing = STRING_ELT(cg_missing, 0));

    SEXP ret;
    STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));

    R_len_t last_i = -1;
    for (R_len_t i = pattern_cont.vectorize_init();
            i != pattern_cont.vectorize_end();
            i = pattern_cont.vectorize_next(i))
    {
        if ((pattern_cont).isNA(i) || (pattern_cont).get(i).length() <= 0) {
            if (!(pattern_cont).isNA(i))
                Rf_warning(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);
            SET_VECTOR_ELT(ret, i, stri__matrix_NA_STRING(1, 1));
            continue;
        }

        UErrorCode status = U_ZERO_ERROR;
        RegexMatcher *matcher = pattern_cont.getMatcher(i); // will be deleted automatically
        R_len_t pattern_cur_groups = matcher->groupCount();

        SEXP cur_res, dimnames;  // all 2 will be PROTECT'd below
        STRI__PROTECT(dimnames = pattern_cont.getCaptureGroupRDimnames(i, last_i, ret));
        last_i = i;

        if ((str_cont).isNA(i)) {
            STRI__PROTECT(cur_res = stri__matrix_NA_STRING(1, pattern_cur_groups+1));
            if (!Rf_isNull(dimnames)) Rf_setAttrib(cur_res, R_DimNamesSymbol, dimnames);
            SET_VECTOR_ELT(ret, i, cur_res);
            STRI__UNPROTECT(2);  // cur_res, dimnames
            continue;
        }

        str_text = utext_openUTF8(str_text, str_cont.get(i).c_str(), str_cont.get(i).length(), &status);
        STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})

        matcher->reset(str_text);

        deque< pair<R_len_t, R_len_t> > occurrences;
        while (1) {
            int m_res = (int)matcher->find(status);
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
            if (!m_res) break;

            occurrences.push_back(pair<R_len_t, R_len_t>((R_len_t)matcher->start(status), (R_len_t)matcher->end(status)));
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
            for (R_len_t j=0; j<pattern_cur_groups; ++j)
                occurrences.push_back(pair<R_len_t, R_len_t>((R_len_t)matcher->start(j+1, status), (R_len_t)matcher->end(j+1, status)));
            STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
        }

        R_len_t noccurrences = (R_len_t)occurrences.size()/(pattern_cur_groups+1);
        if (noccurrences <= 0) {
            STRI__PROTECT(cur_res = stri__matrix_NA_STRING(omit_no_match1?0:1, pattern_cur_groups+1));
            if (!Rf_isNull(dimnames)) Rf_setAttrib(cur_res, R_DimNamesSymbol, dimnames);
            SET_VECTOR_ELT(ret, i, cur_res);
            STRI__UNPROTECT(2);  // cur_res, dimnames
            continue;
        }

        STRI__PROTECT(cur_res = Rf_allocMatrix(STRSXP, noccurrences, pattern_cur_groups+1));
        if (!Rf_isNull(dimnames)) Rf_setAttrib(cur_res, R_DimNamesSymbol, dimnames);

        const char* str_cur_s = str_cont.get(i).c_str();
        deque< pair<R_len_t, R_len_t> >::iterator iter = occurrences.begin();
        for (R_len_t j = 0; iter != occurrences.end(); ++j) {
            pair<R_len_t, R_len_t> curo = *iter;
            SET_STRING_ELT(cur_res, j, Rf_mkCharLenCE(str_cur_s+curo.first, curo.second-curo.first, CE_UTF8));
            ++iter;
            for (R_len_t k = 0; iter != occurrences.end() && k < pattern_cur_groups; ++iter, ++k) {
                curo = *iter;
                if (curo.first < 0 || curo.second < 0)
                    SET_STRING_ELT(cur_res, j+(k+1)*noccurrences, cg_missing);
                else
                    SET_STRING_ELT(cur_res, j+(k+1)*noccurrences,
                                   Rf_mkCharLenCE(str_cur_s+curo.first, curo.second-curo.first, CE_UTF8));
            }
        }

        SET_VECTOR_ELT(ret, i, cur_res);
        STRI__UNPROTECT(2);  // cur_res, dimnames
    }

    if (str_text) {
        utext_close(str_text);
        str_text = NULL;
    }
    STRI__UNPROTECT_ALL
    return ret;
    STRI__ERROR_HANDLER_END(if (str_text) utext_close(str_text);)
}
