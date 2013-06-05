## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus and Marcin Bujarski
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.




#' @title String Searching
#' 
#' @description
#' This man page describes how to perform string search-based
#' operations in \pkg{stringi}.
#' 
#' @details
#' There are three string searching ``engines'' in \pkg{stringi}.
#' \itemize{
#'    \item \code{stri_*_regex} - ICU's regular expressions, see \link{stringi-search-regex},
#'    \item \code{stri_*_fixed} - ICU's \code{StringSearch}, locale-sensitive ``fixed'' patterns, see \link{stringi-search-fixed},
#'    \item \code{stri_*_charclass} - character classes:
#'    more exactly, either general character categories or binary properties, see \link{stringi-search-charclass},
#' }
#' 
#' Each ``engine'' is able to perform many search-based operations:
#' \itemize{
#'    \item \code{stri_detect_*} - detects if a pattern occurs in a string, see e.g. \code{\link{stri_detect}}
#'    \item \code{stri_count_*} - counts the number of pattern's occurences, see e.g. \code{\link{stri_count}}
#'    \item \code{stri_locate_*} -locates all, first, or last occurences of a pattern, see e.g. \code{\link{stri_locate}}
#' }
#' 
#' @name stringi-search
#' @rdname stringi-search
#' @family search_regex
#' @family search_fixed
#' @family search_charclass
#' @family search_detect
#' @family search_count
#' @family search_locate
#' @family search_replace
#' @family search_split
#' @family search_extract
#' @concepts search regex collator character binary property class fixed
#' @family stringi_general_topics
invisible(NULL)



#' @title
#' Regular Expressions in \pkg{stringi}
#'
#' @description
#' Something about regular expressions.....
#' 
#' 
#' @details
#' All \code{stri_*_regex} functions in \pkg{stingi} use
#' the \pkg{ICU} regex engine.
#' 
#' ignore_case.....
#' 
#' all regex functions treat text as single line.
#' if you want multiline facilities, do split (all \pkg{stringi} functions
#' are nicely vectorized)
#' 
#' @section Syntax of Regular Expressions in ICU:
#' 
#' TO BE DONE......
#'
#' @references
#' Regular expressions - ICU User Guide, \url{http://userguide.icu-project.org/strings/regexp} \cr
#' Unicode Regular Expressions \url{http://www.regular-expressions.info/unicode.html}\cr
#' 
#' @name stringi-search-regex
#' @family search_regex
invisible(NULL)



#' @title
#' Locale-Sensitive Text Searching in \pkg{stringi}
#'
#' @description
#' something general....
#' 
#' 
#' @details
#' All \code{stri_*_fixed} functions in \pkg{stingi} use
#' the \pkg{ICU} \code{StringSearch} engine.
#' 
#' For more information on ICU's Collator & SearchEngine
#' and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_collator_genopts}}.
#' 
#' @section String Search Engine:
#' 
#' ...modified form of the Boyer Moore's search (cf. Werner, 1999),
#' with time complexity of
#' O(n+p) (\code{n == length(str)}, \code{p == length(pattern)}).
#' 
#' Tuning Collator's parameter allow us to perform correct matching
#' that properly takes into account accented letters, conjoined letters,
#' and ignorable punctuation 
#' 
#' If you, however, still want to use bytewise comparisons,
#' just pass \code{NA} as \code{collator_opts} in search
#' functions... This will be the fastest approach, especially
#' for short texts.
#'
#' @references
#' ICU String Search Service - ICU User Guide - http://userguide.icu-project.org/collation/icu-string-search-service\cr
#' L. Werner, Efficient Text Searching in Java, 1999, http://icu-project.org/docs/papers/efficient_text_searching_in_java.html
#' 
#' @name stringi-search-fixed
#' @family search_fixed
invisible(NULL)



#' @title Character Classes in \pkg{stringi}
#'
#' @description
#' some general info....
#' 
#' 
#' @details
#' All \code{stri_*_charclass} functions in \pkg{stingi} perform
#' single character search-based operations....
#' 
#'
#' There are two separate ways to specify character classes in \pkg{stringi}:
#' 
#' \itemize{
#' \item with Unicode General Category Masks, e.g. \code{"Lu"} for uppercase letters 
#' (1-2 letter identifier, same may be used in regex)
#' \item with Unicode Binary Property Identifies, e.g. \code{"WHITE_SPACE"}
#' }
#' 
#' differences.....
#' 
#' Note that e.g. General Category \code{Z} (some space) and Binary Property
#' \code{WHITE_SPACE} may match different character sets.
#' 
#' Each class may be preceeded with '^' (complement)...
#' 
#' @section Unicode General Categories:
#' 
#' \itemize{
#' \item \code{Lu}: UPPERCASE_LETTER
#' \item \code{Ll}: LOWERCASE_LETTER
#' \item \code{Lt}: TITLECASE_LETTER
#' \item \code{Lm}: MODIFIER_LETTER
#' \item \code{Lo}: OTHER_LETTER
#' \item \code{Mn}: NON_SPACING_MARK
#' \item \code{Me}: ENCLOSING_MARK
#' \item \code{Mc}: COMBINING_SPACING_MARK
#' \item \code{Nd}: DECIMAL_DIGIT_NUMBER
#' \item \code{Nl}: LETTER_NUMBER
#' \item \code{No}: OTHER_NUMBER
#' \item \code{Zs}: SPACE_SEPARATOR
#' \item \code{Zl}: LINE_SEPARATOR
#' \item \code{Zp}: PARAGRAPH_SEPARATOR
#' \item \code{Cc}: CONTROL_CHAR
#' \item \code{Cf}: FORMAT_CHAR
#' \item \code{Co}: PRIVATE_USE_CHAR
#' \item \code{Cs}: SURROGATE
#' \item \code{Pd}: DASH_PUNCTUATION
#' \item \code{Ps}: START_PUNCTUATION
#' \item \code{Pe}: END_PUNCTUATION
#' \item \code{Pc}: CONNECTOR_PUNCTUATION
#' \item \code{Po}: OTHER_PUNCTUATION
#' \item \code{Sm}: MATH_SYMBOL
#' \item \code{Sc}: CURRENCY_SYMBOL
#' \item \code{Sk}: MODIFIER_SYMBOL
#' \item \code{So}: OTHER_SYMBOL
#' \item \code{Pi}: INITIAL_PUNCTUATION
#' \item \code{Pf}: FINAL_PUNCTUATION
#' \item \code{L}: ...
#' \item \code{Z}: ...
#' \item \code{C}: ...
#' \item \code{M}: ...
#' \item \code{N}: ...
#' \item \code{P}: ...
#' \item \code{S}: ...
#' }
#' 
#'
#'
#' @section Unicode Binary Properies:
#' 
#' \itemize{
#' \item \code{ALPHABETIC}
#' \item \code{ASCII_HEX_DIGIT}
#' \item \code{BIDI_CONTROL}
#' \item \code{BIDI_MIRRORED}
#' \item \code{DASH}
#' \item \code{DEFAULT_IGNORABLE_CODE_POINT}
#' \item \code{DEPRECATED}
#' \item \code{DIACRITIC}
#' \item \code{EXTENDER}
#' \item \code{FULL_COMPOSITION_EXCLUSION}
#' \item \code{GRAPHEME_BASE}
#' \item \code{GRAPHEME_EXTEND}
#' \item \code{GRAPHEME_LINK}
#' \item \code{HEX_DIGIT}
#' \item \code{HYPHEN}
#' \item \code{ID_CONTINUE}
#' \item \code{ID_START}
#' \item \code{IDEOGRAPHIC}
#' \item \code{IDS_BINARY_OPERATOR}
#' \item \code{IDS_TRINARY_OPERATOR}
#' \item \code{JOIN_CONTROL}
#' \item \code{LOGICAL_ORDER_EXCEPTION}
#' \item \code{LOWERCASE}
#' \item \code{MATH}
#' \item \code{NONCHARACTER_CODE_POINT}
#' \item \code{QUOTATION_MARK}
#' \item \code{RADICAL}
#' \item \code{SOFT_DOTTED}
#' \item \code{TERMINAL_PUNCTUATION}
#' \item \code{UNIFIED_IDEOGRAPH}
#' \item \code{UPPERCASE}
#' \item \code{WHITE_SPACE}
#' \item \code{XID_CONTINUE}
#' \item \code{XID_START}
#' \item \code{CASE_SENSITIVE}
#' \item \code{S_TERM}
#' \item \code{VARIATION_SELECTOR}
#' \item \code{NFD_INERT}
#' \item \code{NFKD_INERT}
#' \item \code{NFC_INERT}
#' \item \code{NFKC_INERT}
#' \item \code{SEGMENT_STARTER}
#' \item \code{PATTERN_SYNTAX}
#' \item \code{PATTERN_WHITE_SPACE}
#' \item \code{POSIX_ALNUM}
#' \item \code{POSIX_BLANK}
#' \item \code{POSIX_GRAPH}
#' \item \code{POSIX_PRINT}
#' \item \code{POSIX_XDIGIT}
#' \item \code{CASED}
#' \item \code{CASE_IGNORABLE}
#' \item \code{CHANGES_WHEN_LOWERCASED}
#' \item \code{CHANGES_WHEN_UPPERCASED}
#' \item \code{CHANGES_WHEN_TITLECASED}
#' \item \code{CHANGES_WHEN_CASEFOLDED}
#' \item \code{CHANGES_WHEN_CASEMAPPED}
#' \item \code{CHANGES_WHEN_NFKC_CASEFOLDED}
#' }
#' 
#' 
#' @references
#' ?????? add something :-)
#' 
#' @name stringi-search-charclass
#' @family search_charclass
invisible(NULL)
