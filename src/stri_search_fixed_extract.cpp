/* This file is part of the 'stringi' package for R.
 * Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
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


// #include "stri_stringi.h"
// #include "stri_container_utf8.h"
// #include "stri_container_bytesearch.h"
// #include <deque>
// #include <utility>
// using namespace std;


// THESE FUNCTIONS HAVE NO SENSE :)
// THIS FILE SHOULD BE REMOVED


// /**
//  * Extract first or last occurrences of pattern in a string [exact byte search]
//  * - THIS IS DUMB! :)
//  *
//  * @param str character vector
//  * @param pattern character vector
//  * @param first looking for first or last match?
//  * @return character vector
//  *
//  * @version 0.1-?? (Marek Gagolewski, 2013-06-24)
//  *
//  * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
//  *          stri_extract_fixed now uses byte search only
//  */
// SEXP stri__extract_firstlast_fixed(SEXP str, SEXP pattern, bool)
// {
//    str = stri_prepare_arg_string(str, "str");
//    pattern = stri_prepare_arg_string(pattern, "pattern");
//
//    STRI__ERROR_HANDLER_BEGIN
//    int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
//    StriContainerUTF8 str_cont(str, vectorize_length);
//    StriContainerByteSearch pattern_cont(pattern, vectorize_length);
//
//    SEXP ret;
//    STRI__PROTECT(ret = Rf_allocVector(STRSXP, vectorize_length));
//
//    for (R_len_t i = pattern_cont.vectorize_init();
//       i != pattern_cont.vectorize_end();
//       i = pattern_cont.vectorize_next(i))
//    {
//       STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
//          SET_STRING_ELT(ret, i, NA_STRING);, SET_STRING_ELT(ret, i, NA_STRING);)
//
//       pattern_cont.setupMatcher(i, str_cont.get(i).c_str(), str_cont.get(i).length());
//
//       int start = pattern_cont.findFirst(); // whatever
//
//       if (start == USEARCH_DONE)
//          SET_STRING_ELT(ret, i, NA_STRING);
//       else
//          SET_STRING_ELT(ret, i, pattern_cont.toR(i));
//    }
//
//    STRI__UNPROTECT_ALL
//    return ret;
//    STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
// }
//
//
// /**
//  * Extract first occurrence of a fixed pattern in each string
//  *
//  * @param str character vector
//  * @param pattern character vector
//  * @return character vector
//  *
//  * @version 0.1-?? (Marek Gagolewski, 2013-06-24)
//  *
//  * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
//  *          stri_extract_fixed now uses byte search only
//  */
// SEXP stri_extract_first_fixed(SEXP str, SEXP pattern)
// {
//    return stri__extract_firstlast_fixed(str, pattern, true);
// }
//
//
// /**
//  * Extract last occurrence of a fixed pattern in each string
//  *
//  * @param str character vector
//  * @param pattern character vector
//  * @return character vector
//  *
//  * @version 0.1-?? (Marek Gagolewski, 2013-06-24)
//  *
//  * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
//  *          stri_extract_fixed now uses byte search only
//  */
// SEXP stri_extract_last_fixed(SEXP str, SEXP pattern)
// {
//    return stri__extract_firstlast_fixed(str, pattern, false);
// }
//
//
// /**
//  * Extract all occurrences of pattern in a string [exact byte search]
//  *
//  * @param str character vector
//  * @param pattern character vector
//  * @return character vector
//  *
//  * @version 0.1-?? (Marek Gagolewski, 2013-06-24)
//  *
//  * @version 0.2-3 (Marek Gagolewski, 2014-05-08)
//  *          stri_extract_fixed now uses byte search only
//  */
// SEXP stri_extract_all_fixed(SEXP str, SEXP pattern)
// {
//    str = stri_prepare_arg_string(str, "str");
//    pattern = stri_prepare_arg_string(pattern, "pattern");
//
//    STRI__ERROR_HANDLER_BEGIN
//    int vectorize_length = stri__recycling_rule(true, 2, LENGTH(str), LENGTH(pattern));
//    StriContainerUTF8 str_cont(str, vectorize_length);
//    StriContainerByteSearch pattern_cont(pattern, vectorize_length);
//
//    SEXP ret;
//    STRI__PROTECT(ret = Rf_allocVector(VECSXP, vectorize_length));
//
//    for (R_len_t i = pattern_cont.vectorize_init();
//       i != pattern_cont.vectorize_end();
//       i = pattern_cont.vectorize_next(i))
//    {
//       STRI__CONTINUE_ON_EMPTY_OR_NA_STR_PATTERN(str_cont, pattern_cont,
//          SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));, SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));)
//
//       pattern_cont.setupMatcher(i, str_cont.get(i).c_str(), str_cont.get(i).length());
//
//       int count = 0;
//       while (pattern_cont.findNext() != USEARCH_DONE)
//          ++count;
//
//       if (count == 0)
//          SET_VECTOR_ELT(ret, i, stri__vector_NA_strings(1));
//       else {
//          SEXP ans, match;
//          STRI__PROTECT(ans = Rf_allocVector(STRSXP, count));
//          STRI__PROTECT(match = pattern_cont.toR(i));
//          for (R_len_t j=0; j<count; ++j)
//             SET_STRING_ELT(ans, j, match);
//          SET_VECTOR_ELT(ret, i, ans);
//          STRI__UNPROTECT(2);
//       }
//    }
//
//    STRI__UNPROTECT_ALL
//    return ret;
//    STRI__ERROR_HANDLER_END( ;/* do nothing special on error */ )
// }
