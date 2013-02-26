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
 
#include "stringi.h"


/** 
 * .... 
 * @param str R character vector
 * @param pattern R character vector containing regular expressions
 */
SEXP stri_detect_regex(SEXP str, SEXP pattern) {
    str = stri_prepare_arg_string(str);
    pattern = stri_prepare_arg_string(pattern);
    
    int ns = LENGTH(str);
    int np = LENGTH(pattern);
    int nmax = ns;
    if (ns > np)
        nmax = ns;
    else
        nmax = np;
    if (nmax % np != 0 || nmax % ns != 0)
        warning(MSG__WARN_RECYCLING_RULE);
    
    SEXP ret, s, p;
    PROTECT(ret = allocVector(LGLSXP, nmax));
    UErrorCode status;
    
    for (int i = 0; i < nmax; i++) {
        s = STRING_ELT(str, i % ns);
        p = STRING_ELT(pattern, i % np);
        if (s == NA_STRING || p == NA_STRING) {
            LOGICAL(ret)[i] = NA_LOGICAL;
            continue;
        }
        status = U_ZERO_ERROR;
        RegexMatcher* matcher = new RegexMatcher(CHAR(p), CHAR(s), 0, status);
        if (U_FAILURE(status)) {    // hmm
            error(u_errorName(status));
        }
        else {
            LOGICAL(ret)[i] = matcher->find();     //or ...->matches(status)?
        }
        delete matcher;
    }
    
    UNPROTECT(1);
    return ret;
}
