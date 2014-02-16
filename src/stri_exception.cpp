/* This file is part of the 'stringi' package for R.
 * Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#include "stri_stringi.h"



const char* StriException::getICUerrorName(UErrorCode status)
{
   switch(status) {
      case U_USING_FALLBACK_WARNING:
         return "A resource bundle lookup returned a fallback result (not an error)";
//      case U_ERROR_WARNING_START:
//         return "Start of information results (semantically successful)";
      case U_USING_DEFAULT_WARNING:
         return "A resource bundle lookup returned a result from the root locale (not an error)";
      case U_SAFECLONE_ALLOCATED_WARNING:
         return "A SafeClone operation required allocating memory (informational only)";
      case U_STATE_OLD_WARNING:
         return "ICU has to use compatibility layer to construct the service. Expect performance/memory usage degradation. Consider upgrading";
      case U_STRING_NOT_TERMINATED_WARNING:
         return "An output string could not be NUL-terminated because output length==destCapacity.";
      case U_SORT_KEY_TOO_SHORT_WARNING:
         return "Number of levels requested in getBound is higher than the number of levels in the sort key.";
      case U_AMBIGUOUS_ALIAS_WARNING:
         return "This converter alias can go to different converter implementations.";
      case U_DIFFERENT_UCA_VERSION:
         return "ucol_open encountered a mismatch between UCA version and collator image version, so the collator was constructed from rules. No impact to further function";
      case U_PLUGIN_CHANGED_LEVEL_WARNING:
         return "A plugin caused a level change. May not be an error, but later plugins may not load.";
      case U_ERROR_WARNING_LIMIT:
         return "This must always be the last warning value to indicate the limit for UErrorCode warnings (last warning code +1)";
      case U_ZERO_ERROR:
         return "No error, no warning.";
      case U_ILLEGAL_ARGUMENT_ERROR:
         return "Start of codes indicating failure.";
      case U_MISSING_RESOURCE_ERROR:
         return "The requested resource cannot be found.";
      case U_INVALID_FORMAT_ERROR:
         return "Data format is not what is expected.";
      case U_FILE_ACCESS_ERROR:
         return "The requested file cannot be found.";
      case U_INTERNAL_PROGRAM_ERROR:
         return "Indicates a bug in the library code.";
      case U_MESSAGE_PARSE_ERROR:
         return "Unable to parse a message (message format)";
      case U_MEMORY_ALLOCATION_ERROR:
         return "Memory allocation error.";
      case U_INDEX_OUTOFBOUNDS_ERROR:
         return "Trying to access the index that is out of bounds.";
      case U_PARSE_ERROR:
         return "Equivalent to Java ParseException.";
      case U_INVALID_CHAR_FOUND:
         return "Character conversion: Unmappable input sequence / Invalid character.";
      case U_TRUNCATED_CHAR_FOUND:
         return "Character conversion: Incomplete input sequence.";
      case U_ILLEGAL_CHAR_FOUND:
         return "Character conversion: Illegal input sequence/combination of input units.";
      case U_INVALID_TABLE_FORMAT:
         return "Conversion table file found, but corrupted.";
      case U_INVALID_TABLE_FILE:
         return "Conversion table file not found.";
      case U_BUFFER_OVERFLOW_ERROR:
         return "A result would not fit in the supplied buffer.";
      case U_UNSUPPORTED_ERROR:
         return "Requested operation not supported in current context.";
      case U_RESOURCE_TYPE_MISMATCH:
         return "an operation is requested over a resource that does not support it";
      case U_ILLEGAL_ESCAPE_SEQUENCE:
         return "ISO-2022 illlegal escape sequence.";
      case U_UNSUPPORTED_ESCAPE_SEQUENCE:
         return "ISO-2022 unsupported escape sequence.";
      case U_NO_SPACE_AVAILABLE:
         return "No space available for in-buffer expansion for Arabic shaping.";
      case U_CE_NOT_FOUND_ERROR:
         return "Currently used only while setting variable top, but can be used generally.";
      case U_PRIMARY_TOO_LONG_ERROR:
         return "User tried to set variable top to a primary that is longer than two bytes.";
      case U_STATE_TOO_OLD_ERROR:
         return "ICU cannot construct a service from this state, as it is no longer supported.";
      case U_TOO_MANY_ALIASES_ERROR:
         return "There are too many aliases in the path to the requested resource. It is very possible that a circular alias definition has occured";
      case U_ENUM_OUT_OF_SYNC_ERROR:
         return "UEnumeration out of sync with underlying collection.";
      case U_INVARIANT_CONVERSION_ERROR:
         return "Unable to convert a UChar* string to char* with the invariant converter.";
      case U_INVALID_STATE_ERROR:
         return "Requested operation can not be completed with ICU in its current state.";
      case U_COLLATOR_VERSION_MISMATCH:
         return "Collator version is not compatible with the base version.";
      case U_USELESS_COLLATOR_ERROR:
         return "Collator is options only and no base is specified.";
      case U_NO_WRITE_PERMISSION:
         return "Attempt to modify read-only or constant data.";
      case U_STANDARD_ERROR_LIMIT:
         return "This must always be the last value to indicate the limit for standard errors.";
      case U_BAD_VARIABLE_DEFINITION:
         return "Missing '$' or duplicate variable name.";
//      case U_PARSE_ERROR_START:
//         return "Start of Transliterator errors.";
      case U_MALFORMED_RULE:
         return "Elements of a rule are misplaced.";
      case U_MALFORMED_SET:
         return "A UnicodeSet pattern is invalid.";
      case U_MALFORMED_SYMBOL_REFERENCE:
         return "UNUSED as of ICU 2.4.";
      case U_MALFORMED_UNICODE_ESCAPE:
         return "A Unicode escape pattern is invalid.";
      case U_MALFORMED_VARIABLE_DEFINITION:
         return "A variable definition is invalid.";
      case U_MALFORMED_VARIABLE_REFERENCE:
         return "A variable reference is invalid.";
      case U_MISMATCHED_SEGMENT_DELIMITERS:
         return "UNUSED as of ICU 2.4.";
      case U_MISPLACED_ANCHOR_START:
         return "A start anchor appears at an illegal position.";
      case U_MISPLACED_CURSOR_OFFSET:
         return "A cursor offset occurs at an illegal position.";
      case U_MISPLACED_QUANTIFIER:
         return "A quantifier appears after a segment close delimiter.";
      case U_MISSING_OPERATOR:
         return "A rule contains no operator.";
      case U_MISSING_SEGMENT_CLOSE:
         return "UNUSED as of ICU 2.4.";
      case U_MULTIPLE_ANTE_CONTEXTS:
         return "More than one ante context.";
      case U_MULTIPLE_CURSORS:
         return "More than one cursor.";
      case U_MULTIPLE_POST_CONTEXTS:
         return "More than one post context.";
      case U_TRAILING_BACKSLASH:
         return "A dangling backslash.";
      case U_UNDEFINED_SEGMENT_REFERENCE:
         return "A segment reference does not correspond to a defined segment.";
      case U_UNDEFINED_VARIABLE:
         return "A variable reference does not correspond to a defined variable.";
      case U_UNQUOTED_SPECIAL:
         return "A special character was not quoted or escaped.";
      case U_UNTERMINATED_QUOTE:
         return "A closing single quote is missing.";
      case U_RULE_MASK_ERROR:
         return "A rule is hidden by an earlier more general rule.";
      case U_MISPLACED_COMPOUND_FILTER:
         return "A compound filter is in an invalid location.";
      case U_MULTIPLE_COMPOUND_FILTERS:
         return "More than one compound filter.";
      case U_INVALID_RBT_SYNTAX:
         return "A '::id' rule was passed to the RuleBasedTransliterator parser.";
      case U_INVALID_PROPERTY_PATTERN:
         return "UNUSED as of ICU 2.4.";
      case U_MALFORMED_PRAGMA:
         return "A 'use' pragma is invlalid.";
      case U_UNCLOSED_SEGMENT:
         return "A closing ')' is missing.";
      case U_ILLEGAL_CHAR_IN_SEGMENT:
         return "UNUSED as of ICU 2.4.";
      case U_VARIABLE_RANGE_EXHAUSTED:
         return "Too many stand-ins generated for the given variable range.";
      case U_VARIABLE_RANGE_OVERLAP:
         return "The variable range overlaps characters used in rules.";
      case U_ILLEGAL_CHARACTER:
         return "A special character is outside its allowed context.";
      case U_INTERNAL_TRANSLITERATOR_ERROR:
         return "Internal transliterator system error.";
      case U_INVALID_ID:
         return "A '::id' rule specifies an unknown transliterator.";
      case U_INVALID_FUNCTION:
         return "A '&fn()' rule specifies an unknown transliterator.";
      case U_PARSE_ERROR_LIMIT:
         return "The limit for Transliterator errors.";
      case U_UNEXPECTED_TOKEN:
         return "Syntax error in format pattern.";
//      case U_FMT_PARSE_ERROR_START:
//         return "Start of format library errors.";
      case U_MULTIPLE_DECIMAL_SEPARATORS:
//      case U_MULTIPLE_DECIMAL_SEPERATORS:
         return "More than one decimal separator in number pattern.";
      case U_MULTIPLE_EXPONENTIAL_SYMBOLS:
         return "More than one exponent symbol in number pattern.";
      case U_MALFORMED_EXPONENTIAL_PATTERN:
         return "Grouping symbol in exponent pattern.";
      case U_MULTIPLE_PERCENT_SYMBOLS:
         return "More than one percent symbol in number pattern.";
      case U_MULTIPLE_PERMILL_SYMBOLS:
         return "More than one permill symbol in number pattern.";
      case U_MULTIPLE_PAD_SPECIFIERS:
         return "More than one pad symbol in number pattern.";
      case U_PATTERN_SYNTAX_ERROR:
         return "Syntax error in format pattern.";
      case U_ILLEGAL_PAD_POSITION:
         return "Pad symbol misplaced in number pattern.";
      case U_UNMATCHED_BRACES:
         return "Braces do not match in message pattern.";
      case U_UNSUPPORTED_PROPERTY:
         return "UNUSED as of ICU 2.4.";
      case U_UNSUPPORTED_ATTRIBUTE:
         return "UNUSED as of ICU 2.4.";
      case U_ARGUMENT_TYPE_MISMATCH:
         return "Argument name and argument index mismatch in MessageFormat functions.";
      case U_DUPLICATE_KEYWORD:
         return "Duplicate keyword in PluralFormat.";
      case U_UNDEFINED_KEYWORD:
         return "Undefined Plural keyword.";
      case U_DEFAULT_KEYWORD_MISSING:
         return "Missing DEFAULT rule in plural rules.";
      case U_DECIMAL_NUMBER_SYNTAX_ERROR:
         return "Decimal number syntax error.";
      case U_FORMAT_INEXACT_ERROR:
         return "Cannot format a number exactly and rounding mode is ROUND_UNNECESSARY.";
      case U_FMT_PARSE_ERROR_LIMIT:
         return "The limit for format library errors.";
      case U_BRK_INTERNAL_ERROR:
         return "An internal error (bug) was detected.";
//      case U_BRK_ERROR_START:
//         return "Start of codes indicating Break Iterator failures.";
      case U_BRK_HEX_DIGITS_EXPECTED:
         return "Hex digits expected as part of a escaped char in a rule.";
      case U_BRK_SEMICOLON_EXPECTED:
         return "Missing ';' at the end of a RBBI rule.";
      case U_BRK_RULE_SYNTAX:
         return "Syntax error in RBBI rule.";
      case U_BRK_UNCLOSED_SET:
         return "UnicodeSet witing an RBBI rule missing a closing ']'.";
      case U_BRK_ASSIGN_ERROR:
         return "Syntax error in RBBI rule assignment statement.";
      case U_BRK_VARIABLE_REDFINITION:
         return "RBBI rule $Variable redefined.";
      case U_BRK_MISMATCHED_PAREN:
         return "Mis-matched parentheses in an RBBI rule.";
      case U_BRK_NEW_LINE_IN_QUOTED_STRING:
         return "Missing closing quote in an RBBI rule.";
      case U_BRK_UNDEFINED_VARIABLE:
         return "Use of an undefined $Variable in an RBBI rule.";
      case U_BRK_INIT_ERROR:
         return "Initialization failure. Probable missing ICU Data.";
      case U_BRK_RULE_EMPTY_SET:
         return "Rule contains an empty Unicode Set.";
      case U_BRK_UNRECOGNIZED_OPTION:
         return "!!option in RBBI rules not recognized.";
      case U_BRK_MALFORMED_RULE_TAG:
         return "The {nnn} tag on a rule is mal formed.";
      case U_BRK_ERROR_LIMIT:
         return "This must always be the last value to indicate the limit for Break Iterator failures.";
      case U_REGEX_INTERNAL_ERROR:
         return "An internal error (bug) was detected.";
//      case U_REGEX_ERROR_START:
//         return "Start of codes indicating Regexp failures.";
      case U_REGEX_RULE_SYNTAX:
         return "Syntax error in regexp pattern.";
      case U_REGEX_INVALID_STATE:
         return "RegexMatcher in invalid state for requested operation.";
      case U_REGEX_BAD_ESCAPE_SEQUENCE:
         return "Unrecognized backslash escape sequence in pattern.";
      case U_REGEX_PROPERTY_SYNTAX:
         return "Incorrect Unicode property.";
      case U_REGEX_UNIMPLEMENTED:
         return "Use of regexp feature that is not yet implemented.";
      case U_REGEX_MISMATCHED_PAREN:
         return "Incorrectly nested parentheses in regexp pattern.";
      case U_REGEX_NUMBER_TOO_BIG:
         return "Decimal number is too large.";
      case U_REGEX_BAD_INTERVAL:
         return "Error in {min,max} interval.";
      case U_REGEX_MAX_LT_MIN:
         return "In {min,max}, max is less than min.";
      case U_REGEX_INVALID_BACK_REF:
         return "Back-reference to a non-existent capture group.";
      case U_REGEX_INVALID_FLAG:
         return "Invalid value for match mode flags.";
      case U_REGEX_LOOK_BEHIND_LIMIT:
         return "Look-Behind pattern matches must have a bounded maximum length.";
      case U_REGEX_SET_CONTAINS_STRING:
         return "Regexps cannot have UnicodeSets containing strings.";
      case U_REGEX_OCTAL_TOO_BIG:
         return "Octal character constants must be <= 0377.";
      case U_REGEX_MISSING_CLOSE_BRACKET:
         return "Missing closing bracket on a bracket expression.";
      case U_REGEX_INVALID_RANGE:
         return "In a character range [x-y], x is greater than y.";
      case U_REGEX_STACK_OVERFLOW:
         return "Regular expression backtrack stack overflow.";
      case U_REGEX_TIME_OUT:
         return "Maximum allowed match time exceeded.";
      case U_REGEX_STOPPED_BY_CALLER:
         return "Matching operation aborted by user callback fn.";
      case U_REGEX_ERROR_LIMIT:
         return "This must always be the last value to indicate the limit for regexp errors.";
//      case U_PLUGIN_ERROR_START:
//         return "Start of codes indicating plugin failures.";
      case U_PLUGIN_TOO_HIGH:
         return "The plugin's level is too high to be loaded right now.";
      case U_PLUGIN_DIDNT_SET_LEVEL:
         return "The plugin didn't call uplug_setPlugLevel in response to a QUERY.";
      case U_PLUGIN_ERROR_LIMIT:
         return "This must always be the last value to indicate the limit for plugin errors. ";
      default:
         return "Unknown error.";
   }
}
