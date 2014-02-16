/* This file is part of the 'stringi' library.
 *
 * Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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


#ifndef __stri_messages_h
#define __stri_messages_h

/// inccorect uchar class id, see stri_char_getpropertyid and stri_char_getcategoryid
#define MSG__INCORRECT_UCHAR_CLASS_ID \
   "incorrect class identifier"

#define MSG__INCORRECT_COLLATOR_OPTION \
   "incorrect collator option: `%s`. ignoring"

#define MSG__INCORRECT_REGEX_OPTION \
   "incorrect regex option: `%s`. ignoring"

#define MSG__INVALID_CODE_POINT \
   "invalid Unicode codepoint \\U%08.8x"

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

#define MSG__INCORRECT_INTERNAL_ARG \
   "incorrect argument"

#define MSG__INTERNAL_ERROR \
   "internal error"

#define MSG__ICU_ERROR \
   "%s (%s)"

#define MSG__EXPECTED_NONNEGATIVE \
   "incorrect argument: expected a nonnegative numeric value"

#define MSG__EXPECTED_POSITIVE \
   "incorrect argument: expected a positive numeric value"

#define MSG__EXPECTED_CHARACTER \
   "incorrect argument: expected a character vector"

#define MSG__EXPECTED_DOUBLE \
   "incorrect argument: expected a numeric vector"

#define MSG__EXPECTED_INTEGER \
   "incorrect argument: expected an integer vector"

#define MSG__EXPECTED_LOGICAL \
   "incorrect argument: expected a logical vector"


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

#define MSG__REGEXP_FAILED_DETAILS \
   "regexp search failed: %s"

#define MSG__STRSEARCH_FAILED \
   "string search failed"

#define MSG__RESOURCE_ERROR_GET \
   "required resource unavailable; do you have ICU data installed (icudtXX.dat)?"

#define MSG__RESOURCE_ERROR_APPLY \
   "error while applying operation"

#define MSG__LOCATE_DIM_START \
   "start"

#define MSG__LOCATE_DIM_END \
   "end"

#define MSG__NEWLINE_FOUND \
   "newline character found in a string"



#define MSG__CHARCLASS_INCORRECT_WHICH \
   "unknown charclass `%s`. assuming NA"

#define MSG__CHARCLASS_INCORRECT \
   "unknown charclass. assuming NA"

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

#endif
