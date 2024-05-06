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
#include "stri_container_regex.h"


/**
 * Default constructor
 *
 */
StriContainerRegexPattern::StriContainerRegexPattern()
    : StriContainerUTF16()
{
    this->lastMatcherIndex = -1;
    this->lastMatcher = NULL;
    this->lastCaptureGroupNamesIndex = -1;
    //this->lastCaptureGroupNames = ...
    //this->opts = 0;
}


/**
 * Construct String Container from R character vector
 * @param rstr R character vector
 * @param nrecycle extend length [vectorization]
 * @param flags regexp flags
 */
StriContainerRegexPattern::StriContainerRegexPattern(SEXP rstr, R_len_t _nrecycle, StriRegexMatcherOptions _opts)
    : StriContainerUTF16(rstr, _nrecycle, true)
{
    this->lastMatcherIndex = -1;
    this->lastMatcher = NULL;
    this->lastCaptureGroupNamesIndex = -1;
    //this->lastCaptureGroupNames = ...
    this->opts = _opts;

    R_len_t n = get_n();
    for (R_len_t i=0; i<n; ++i) {
        if (!isNA(i) && get(i).length() <= 0) {
            Rf_warning(MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED);
        }
    }
}


/** Copy constructor
 *
 */
StriContainerRegexPattern::StriContainerRegexPattern(StriContainerRegexPattern& container)
    :    StriContainerUTF16((StriContainerUTF16&)container)
{
    this->lastMatcherIndex = -1;
    this->lastMatcher = NULL;
    this->lastCaptureGroupNamesIndex = -1;
    //this->lastCaptureGroupNames = ...
    this->opts = container.opts;
}


StriContainerRegexPattern& StriContainerRegexPattern::operator=(StriContainerRegexPattern& container)
{
    this->~StriContainerRegexPattern();
    (StriContainerUTF16&) (*this) = (StriContainerUTF16&)container;
    this->lastMatcherIndex = -1;
    this->lastMatcher = NULL;
    this->lastCaptureGroupNamesIndex = -1;
    //this->lastCaptureGroupNames = ...
    this->opts = container.opts;
    return *this;
}


/** Destructor
 *
 */
StriContainerRegexPattern::~StriContainerRegexPattern()
{
    if (lastMatcher) {
        delete lastMatcher;
        lastMatcher = NULL;
    }
}


/** Get names of all capture groups in the i-th regex as an R STRSXP
 * allows reusing previous
 *
 * @param i index
 * @param include_whole_match whether the first elem should be an additional ""
 * @param last_i set to -1 to recompute
 * @param ret might copy dimnames from ret[last_i]
 *
 * @version 1.7.1 (Marek Gagolewski, 2021-06-20)  #153
 */
SEXP StriContainerRegexPattern::getCaptureGroupRNames(
    R_len_t i  // TODO allow reuse
) {
    // TODO - refactor - too similar to getCaptureGroupRDimnames

    if (this->isNA(i) || this->get(i).length() <= 0)
        return R_NilValue;

    const std::vector<std::string>& cgnames = this->getCaptureGroupNames(i);
    R_len_t pattern_cur_groups = cgnames.size();
    bool has_cgnames = false;
    for (R_len_t j=0; j<pattern_cur_groups; ++j) {
        if (!cgnames[j].empty()) { has_cgnames = true; break; }
    }

    if (has_cgnames) {
        SEXP tmp;
        PROTECT(tmp = Rf_allocVector(STRSXP, pattern_cur_groups));
        //SET_STRING_ELT(colnames, 0, Rf_mkChar("<whole match>"));
        for (R_len_t j=0; j<pattern_cur_groups; ++j) {
            SET_STRING_ELT(
                tmp,
                j,
                Rf_mkCharLenCE(cgnames[j].c_str(), cgnames[j].size(), CE_UTF8)
            );
        }
        UNPROTECT(1);
        return tmp;
    }

    return R_NilValue;
}

/** Get dimnames of all capture groups in the i-th regex as an R STRSXP
 * allows reusing previous
 *
 * @param i index
 * @param include_whole_match whether the first elem should be an additional ""
 * @param last_i set to -1 to recompute
 * @param ret might copy dimnames from ret[last_i]
 *
 * @version 1.7.1 (Marek Gagolewski, 2021-06-20)  #153
 */
SEXP StriContainerRegexPattern::getCaptureGroupRDimnames(
    R_len_t i, R_len_t last_i, SEXP ret
) {
    // TODO - refactor - too similar to getCaptureGroupRNames

    if (this->isNA(i) || this->get(i).length() <= 0)
        return R_NilValue;

    // last dimnames could be cached here but then
    // we'd have to use R_PreserveObject and R_ReleaseObject;
    // R-ext states "It is less efficient than the normal protection mechanism,
    // and should be used sparingly."
    // If a user calls PROTECT and then UNPROTECT on retval, how does this
    // interfere with R_PreserveObject?
    if (last_i >= 0 && !Rf_isNull(ret) && (last_i % this->get_n()) == (i % this->get_n())) {
        // reuse last dimnames
        SEXP tmp, dimnames;
        PROTECT(tmp = VECTOR_ELT(ret, last_i));
        PROTECT(dimnames = Rf_getAttrib(tmp, R_DimNamesSymbol));
        UNPROTECT(2);
        return dimnames;
    }
    else {
        const std::vector<std::string>& cgnames = this->getCaptureGroupNames(i);
        R_len_t pattern_cur_groups = cgnames.size();
        bool has_cgnames = false;
        for (R_len_t j=0; j<pattern_cur_groups; ++j) {
            if (!cgnames[j].empty()) { has_cgnames = true; break; }
        }

        if (has_cgnames) {
            SEXP tmp, dimnames;
            PROTECT(dimnames = Rf_allocVector(VECSXP, 2));
            PROTECT(tmp = Rf_allocVector(STRSXP, pattern_cur_groups+1));
            //SET_STRING_ELT(colnames, 0, Rf_mkChar("<whole match>"));
            for (R_len_t j=0; j<pattern_cur_groups; ++j) {
                SET_STRING_ELT(
                    tmp,
                    j+1,
                    Rf_mkCharLenCE(cgnames[j].c_str(), cgnames[j].size(), CE_UTF8)
                );
            }
            SET_VECTOR_ELT(dimnames, 1, tmp);
            UNPROTECT(2);
            return dimnames;
        }
    }
    return R_NilValue;
}


/** Get names of all capture groups in the i-th regex;
 * empty string denotes an unnamed group
 *
 * it is assumed that vectorize_next() is used:
 * for i >= this->n the last matcher is returned
 *
 * @param i index
 *
 * @version 1.7.1 (Marek Gagolewski, 2021-06-19)  #153
 */
const std::vector<std::string>& StriContainerRegexPattern::getCaptureGroupNames(R_len_t i)
{
    STRI_ASSERT(lastMatcherIndex >= 0 && lastMatcherIndex == (i % n));
    STRI_ASSERT(lastMatcher);
    STRI_ASSERT(!this->isNA(i));
    STRI_ASSERT(this->get(i).length() > 0);

    if (this->lastCaptureGroupNamesIndex == (i % n)) {
        return lastCaptureGroupNames; // reuse
    }

    int ngroups = lastMatcher->groupCount();
    lastCaptureGroupNames = std::vector<std::string>(ngroups);
    this->lastCaptureGroupNamesIndex = (i % n);


    if (ngroups == 0) return lastCaptureGroupNames;  // nothing to do

#if U_ICU_VERSION_MAJOR_NUM>=55
    /*
    Support for named capture groups has been introduced in ICU 55
    This is not documented, but the named capture group names are like
    [A-Za-z][A-Za-z0-9]*

    uregex.cpp:1506 in ICU 69.1 has something like:
    if ((c32 >= 0x41 && c32 <= 0x5a) ||       // A..Z
        (c32 >= 0x61 && c32 <= 0x7a) ||       // a..z
        (c32 >= 0x31 && c32 <= 0x39)) {       // 0..9
    groupName.append(c32);
    }

    RegexPattern (regex.h) has
    UHashtable     *fNamedCaptureMap;  // Map from capture group names to numbers.
    but it's private and we're no friends with it

    here's a simple regex pattern "parser"
    to extract group names which then be queried using RegexPattern::groupNumberFromName

    #if U_ICU_VERSION_MAJOR_NUM>=55
    #endif

    */


    UErrorCode status = U_ZERO_ERROR;
    UText* p = lastMatcher->pattern().patternText(status);
    if (U_FAILURE(status)) throw StriException(status);

    UChar32 c = utext_next32From(p, 0);
    while (c >= 0) {
        // this is not necessarily bullet-proof, but, come on,
        // these are just labels ;)
        // (\\?<heh>) -- not a named capture group
        // \\(?<Z>.\\) -- not a capture group
        // [(?<Z>.)] -- not a capture group

        if (c == '\\') {
            c = utext_next32(p);  // go to next
            c = utext_next32(p);  // ignore next
        }
        else if (c == '[') {
            // go to ...] but ignore \]
            for (c = utext_next32(p); c >= 0 && c != ']'; c = utext_next32(p)) {
                if (c == '\\') c = utext_next32(p); // ignore what follows
            }
            c = utext_next32(p);  // go to next
        }
        else if (c == '(') {
            c = utext_next32(p);
            if (c != '?') { c = utext_next32(p); continue; }
            c = utext_next32(p);
            if (c != '<') { c = utext_next32(p); continue; }

            std::string groupName;
            for (
                c = utext_next32(p);
                (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9');
                c = utext_next32(p)
            ) {
                // technically, first char should be [A-Za-z], but RegexPattern will check that anyway
                groupName.push_back((char)c);
            }
            if (c == '>') {
                status = U_ZERO_ERROR;
                int group = lastMatcher->pattern().groupNumberFromName(groupName.c_str(), -1, status);
                if (U_SUCCESS(status)) {  // if not, just ignore
                    group--;  // 1-based indexing
                    //Rprintf("%d %s\n", group, groupName.c_str());
                    STRI_ASSERT(group >= 0 && group < ngroups);
                    lastCaptureGroupNames[group] = groupName;
                }
            }
            c = utext_next32(p);;
        }
        else
            c = utext_next32(p);
    }

#endif  /* U_ICU_VERSION_MAJOR_NUM>=55 */
    return lastCaptureGroupNames;
}


/** The returned matcher shall not be deleted by the user
 *
 * it is assumed that vectorize_next() is used:
 * for i >= this->n the last matcher is returned
 *
 * @param i index
 */
RegexMatcher* StriContainerRegexPattern::getMatcher(R_len_t i)
{
    if (lastMatcher) {
        if (this->lastMatcherIndex >= 0 && this->lastMatcherIndex == (i % n)) {
            return lastMatcher; // reuse
        }
        else {
            delete lastMatcher; // invalidate
            this->lastMatcher = NULL;
        }
    }

    UErrorCode status = U_ZERO_ERROR;
    lastMatcher = new RegexMatcher(this->get(i), opts.flags, status);

    if (U_FAILURE(status)) {
        if (lastMatcher) delete lastMatcher;
        lastMatcher = NULL;

        const char* context; // to ease debugging, #382
        std::string s;
        if (str[i%n].isBogus())
            context = NULL;
        else {
            str[i%n].toUTF8String(s);
            context = s.c_str();
        }

        throw StriException(status, context);
    }

    if (!lastMatcher) throw StriException(MSG__MEM_ALLOC_ERROR);

    if (opts.stack_limit > 0) {
        lastMatcher->setStackLimit(opts.stack_limit, status);
        STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
    }

    if (opts.time_limit > 0) {
        lastMatcher->setTimeLimit(opts.time_limit, status);
        STRI__CHECKICUSTATUS_THROW(status, {/* do nothing special on err */})
    }


    this->lastMatcherIndex = (i % n);

    return lastMatcher;
}


/** Read regex flags from a list
 *
 * may call Rf_error
 *
 * @param opts_regex list
 * @return flags
 *
 * @version 0.1-?? (Marek Gagolewski)
 *
 * @version 0.2-3 (Marek Gagolewski, 2014-05-09)
 *          allow NULL for opts_regex
 *
 * @version 0.3-1 (Marek Gagolewski, 2014-11-05)
 *    Disallow NA options
 *
 * @version 1.1.6 (Marek Gagolewski, 2017-11-10)
 *    PROTECT STRING_ELT(names, i)
 *
 * @version 1.4.7 (Marek Gagolewski, 2020-08-24)
 *    add time_limit and stack_limit
 */
StriRegexMatcherOptions StriContainerRegexPattern::getRegexOptions(SEXP opts_regex)
{
    int32_t stack_limit = 0;
    int32_t time_limit = 0;
    uint32_t flags = 0;
    if (!Rf_isNull(opts_regex) && !Rf_isVectorList(opts_regex))
        Rf_error(MSG__ARG_EXPECTED_LIST, "opts_regex"); // error() call allowed here

    R_len_t narg = Rf_isNull(opts_regex)?0:LENGTH(opts_regex);

    if (narg > 0) {

        SEXP names = PROTECT(Rf_getAttrib(opts_regex, R_NamesSymbol));
        if (names == R_NilValue || LENGTH(names) != narg)
            Rf_error(MSG__REGEX_CONFIG_FAILED); // error() call allowed here

        for (R_len_t i=0; i<narg; ++i) {
            if (STRING_ELT(names, i) == NA_STRING)
                Rf_error(MSG__REGEX_CONFIG_FAILED); // error() call allowed here

            SEXP tmp_arg;
            PROTECT(tmp_arg = STRING_ELT(names, i));
            const char* curname = stri__copy_string_Ralloc(tmp_arg, "curname");  /* this is R_alloc'ed */
            UNPROTECT(1);

            PROTECT(tmp_arg = VECTOR_ELT(opts_regex, i));
            if  (!strcmp(curname, "case_insensitive")) {
                bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "case_insensitive");
                if (val) flags |= UREGEX_CASE_INSENSITIVE;
            } else if  (!strcmp(curname, "comments")) {
                bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "comments");
                if (val) flags |= UREGEX_COMMENTS;
            } else if  (!strcmp(curname, "dotall")) {
                bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "dotall");
                if (val) flags |= UREGEX_DOTALL;
            } else if  (!strcmp(curname, "literal")) {
                bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "literal");
                if (val) flags |= UREGEX_LITERAL;
            } else if  (!strcmp(curname, "multiline")) {
                bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "multiline");
                if (val) flags |= UREGEX_MULTILINE;
            } else if  (!strcmp(curname, "unix_lines")) {
                bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "unix_lines");
                if (val) flags |= UREGEX_UNIX_LINES;
            } else if  (!strcmp(curname, "uword")) {
                bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "uword");
                if (val) flags |= UREGEX_UWORD;
            } else if  (!strcmp(curname, "error_on_unknown_escapes")) {
                bool val = stri__prepare_arg_logical_1_notNA(tmp_arg, "error_on_unknown_escapes");
                if (val) flags |= UREGEX_ERROR_ON_UNKNOWN_ESCAPES;
            } else if  (!strcmp(curname, "stack_limit")) {
                stack_limit = stri__prepare_arg_integer_1_notNA(tmp_arg, "stack_limit");
            } else if  (!strcmp(curname, "time_limit")) {
                time_limit = stri__prepare_arg_integer_1_notNA(tmp_arg, "time_limit");
            } else {
                Rf_warning(MSG__INCORRECT_REGEX_OPTION, curname);
            }
            UNPROTECT(1);
        }
        UNPROTECT(1); /* names */
    }

    StriRegexMatcherOptions opts;
    opts.flags = flags;
    opts.time_limit = time_limit;
    opts.stack_limit = stack_limit;
    return opts;
}
