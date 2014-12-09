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


#ifndef __stri_messages_h
#define __stri_messages_h

/// inccorect uchar class id, see stri_char_getpropertyid and stri_char_getcategoryid
#define MSG__INCORRECT_UCHAR_CLASS_ID \
   "incorrect class identifier"

#define MSG__INCORRECT_MATCH_OPTION \
   "incorrect option for `%s`"

#define MSG__INCORRECT_COLLATOR_OPTION \
   "incorrect opts_collator setting: `%s`. ignoring"

#define MSG__INCORRECT_COLLATOR_OPTION_SPEC \
   "incorrect collator option specifier. see ?stri_opts_collator"

#define MSG__INCORRECT_BRKITER_OPTION_SPEC \
   "incorrect break iterator option specifier. see ?stri_opts_brkiter"

#define MSG__INCORRECT_FIXED_OPTION \
   "incorrect opts_fixed setting: `%s`. ignoring"

#define MSG__INCORRECT_REGEX_OPTION \
   "incorrect opts_regex setting: `%s`. ignoring"

#define MSG__INVALID_CODE_POINT \
   "invalid Unicode codepoint \\U%08.8x"

#define MSG__INVALID_CODE_POINT_FIXING \
   "invalid UTF-8 codepoint definition. fixing"

#define MSG__INVALID_CODE_POINT_REPLNA \
   "invalid UTF-8 codepoint definition. setting string to NA. see also stri_enc_toutf8()"

#define MSG__INVALID_UTF8 \
   "invalid UTF-8 byte sequence detected. perhaps you should try calling stri_enc_toutf8()"

#define MSG__INVALID_ESCAPE \
   "invalid escape sequence detected. Setting NA"

#define MSG__UNCONVERTABLE_CODE_POINT \
   "the Unicode codepoint \\U%08.8x cannot be converted to destination encoding"

#define MSG__UNCONVERTABLE_BINARY_1 \
   "input data \\x%02.2x in current source encoding could not be converted to Unicode"

#define MSG__UNCONVERTABLE_BINARY_2 \
   "input data \\x%02.2x\\x%02.2x in current source encoding could not be converted to Unicode"

#define MSG__UNCONVERTABLE_BINARY_3 \
   "input data \\x%02.2x\\x%02.2x\\x%02.2x in current source encoding could not be converted to Unicode"

#define MSG__UNCONVERTABLE_BINARY_4 \
   "input data \\x%02.2x\\x%02.2x\\x%02.2x\\x%02.2x in current source encoding could not be converted to Unicode"

#define MSG__UNCONVERTABLE_BINARY_n \
   "some input data in current source encoding could not be converted to Unicode"

/// warning when applying recycling rule to not fully recycled args
#define MSG__WARN_RECYCLING_RULE \
   "longer object length is not a multiple of shorter object length"

#define MSG__WARN_RECYCLING_RULE2 \
   "vector length not consistent with other arguments"

#define MSG__INCORRECT_INTERNAL_ARG \
   "incorrect argument"

#define MSG__INTERNAL_ERROR \
   "internal error"

#define MSG__ICU_ERROR \
   "%s (%s)"

#define MSG__ICU_WARNING \
   "%s (%s)"

#define MSG__EXPECTED_NONNEGATIVE \
   "argument `%s`: expected a nonnegative numeric value"

#define MSG__EXPECTED_POSITIVE \
   "argument `%s`: expected a positive numeric value"

#define MSG__EXPECTED_SMALLER \
   "argument `%s`: value too large"

#define MSG__EXPECTED_ASCII \
   "incorrect argument: the string contains non-ASCII characters"

#define MSG__LOCALE_ERROR_SET \
   "could not set or select given locale"

#define MSG__ENC_ERROR_GETNAME \
   "could not fetch name of the character encoding from the ICU converter"

#define MSG__ENC_ERROR_SET \
   "could not set, query or select given character encoding"

#define MSG__ENC_ERROR_CONVERT \
   "could not convert string encoding"

#define MSG__LOCALE_INCORRECT_ID \
   "incorrect locale identifier"

#define MSG__ENC_INCORRECT_ID \
   "incorrect character encoding identifier"

#define MSG__ENC_INCORRECT_ID_WHAT \
   "incorrect character encoding identifier: %s"

#define MSG__ENC_NOT8BIT \
   "encoding %s is not an 8-bit encoding"

#define MSG__BYTESENC \
   "bytes encoding is not supported by this function"

#define MSG__REGEXP_FAILED \
   "regexp search failed"

#define MSG__REGEXP_CONFIG_FAILED \
   "regexp engine config failed"

#define MSG__FIXED_CONFIG_FAILED \
   "fixed search engine config failed"

#define MSG__REGEXP_FAILED_DETAILS \
   "regexp search failed: %s"

#define MSG__STRSEARCH_FAILED \
   "string search failed"

#define MSG__RESOURCE_ERROR_GET \
   "required resource unavailable; try calling stri_install_check()"

#define MSG__RESOURCE_ERROR_APPLY \
   "error while applying operation"

#define MSG__LOCATE_DIM_START \
   "start"

#define MSG__LOCATE_DIM_END \
   "end"

#define MSG__NEWLINE_FOUND \
   "newline character found in a string"

#define MSG__NOT_EQ_N_CODEPOINTS \
   "each string in `%s` should consist of exactly %d code points"

#define MSG__CHARCLASS_INCORRECT_WHICH \
   "unknown charclass `%s`. assuming NA"

#define MSG__CHARCLASS_INCORRECT \
   "unknown charclass"

#define MSG__ARG_EXPECTED_NOT_NA \
   "missing value in argument `%s` is not supported"

#define MSG__ARG_EXPECTED_NOT_EMPTY \
   "argument `%s` should be a non-empty vector"

#define MSG__ARG_EXPECTED_1_STRING \
   "argument `%s` should be one character string; taking the first one"

#define MSG__ARG_EXPECTED_1_LOGICAL \
   "argument `%s` should be one logical value; taking the first one"

#define MSG__ARG_EXPECTED_1_INTEGER \
   "argument `%s` should be one integer value; taking the first one"

#define MSG__ARG_EXPECTED_1_NUMERIC \
   "argument `%s` should be one numeric value; taking the first one"

#define MSG__ARG_EXPECTED_STRING \
   "argument `%s` should be a character vector (or an object coercible to)"

#define MSG__ARG_EXPECTED_LIST \
   "argument `%s` should be a list"

#define MSG__ARG_EXPECTED_LIST_STRING \
   "argument `%s` should be a list of character vectors (or an object coercible to)"

#define MSG__ARG_EXPECTED_LIST_INTEGER \
   "argument `%s` should be a list of integer vectors or an integer vector (or an object coercible to)"


#define MSG__ARG_EXPECTED_RAW \
   "argument `%s` should be a raw vector (or an object coercible to)"

#define MSG__ARG_EXPECTED_LOGICAL \
   "argument `%s` should be a logical vector (or an object coercible to)"

#define MSG__ARG_EXPECTED_INTEGER \
   "argument `%s` should be an integer vector (or an object coercible to)"

#define MSG__ARG_EXPECTED_NUMERIC \
   "argument `%s` should be a numeric vector (or an object coercible to)"

#define MSG__ARG_EXPECTED_STRING_NO_COERCION \
   "argument `%s` should be a character vector"

#define MSG__ARG_EXPECTED_RAW_IN_LIST_NO_COERCION \
   "all elements in `%s` should be a raw vectors"

#define MSG__ARG_EXPECTED_RAW_NO_COERCION \
   "argument `%s` should be a raw vector"

#define MSG__ARG_EXPECTED_LOGICAL_NO_COERCION \
   "argument `%s` should be a logical vector"

#define MSG__ARG_EXPECTED_INTEGER_NO_COERCION \
   "argument `%s` should be an integer vector"

#define MSG__ARG_EXPECTED_NUMERIC_NO_COERCION \
   "argument `%s` should be a numeric vector"

#define MSG__ARG_EXPECTED_MATRIX_WITH_GIVEN_COLUMNS \
   "argument `%s` should be a matrix with %d columns"

#define MSG__ARG_EXPECTED_NOT_MATRIX \
   "argument `%s` is a matrix, which is not supported in given context"

#define MSG__ARG_IGNORING \
   "ignoring argument `%s` in given context"

#define MSG__ARG_EXCLUSIVE \
   "arguments `%s` and `%s` are mutually exclusive in given context"


#define MSG__EMPTY_SEARCH_PATTERN_UNSUPPORTED \
   "empty search patterns are not supported"

#define MSG__OVERLAPPING_PATTERN_UNSUPPORTED \
   "overlapping pattern matches are not supported"

#define MSG__MEM_ALLOC_ERROR \
   "memory allocation error"

#endif
