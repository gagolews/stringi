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
#' \item \code{Cc}: CONTROL CHAR
#' \item \code{Cf}: FORMAT CHAR
#' \item \code{Co}: PRIVATE USE CHAR
#' \item \code{Cs}: SURROGATE
#' \item \code{Ll}: LOWERCASE LETTER
#' \item \code{Lm}: MODIFIER LETTER
#' \item \code{Lo}: OTHER LETTER
#' \item \code{Lt}: TITLECASE LETTER
#' \item \code{Lu}: UPPERCASE LETTER
#' \item \code{Mc}: COMBINING SPACING MARK
#' \item \code{Me}: ENCLOSING MARK
#' \item \code{Mn}: NON SPACING MARK
#' \item \code{Nd}: DECIMAL DIGIT NUMBER
#' \item \code{Nl}: LETTER NUMBER
#' \item \code{No}: OTHER NUMBER
#' \item \code{Pd}: DASH PUNCTUATION
#' \item \code{Ps}: START PUNCTUATION
#' \item \code{Pe}: END PUNCTUATION
#' \item \code{Pc}: CONNECTOR PUNCTUATION
#' \item \code{Po}: OTHER PUNCTUATION
#' \item \code{Pi}: INITIAL PUNCTUATION
#' \item \code{Pf}: FINAL PUNCTUATION
#' \item \code{Sm}: MATH SYMBOL
#' \item \code{Sc}: CURRENCY SYMBOL
#' \item \code{Sk}: MODIFIER SYMBOL
#' \item \code{So}: OTHER SYMBOL
#' \item \code{Zs}: SPACE SEPARATOR
#' \item \code{Zl}: LINE SEPARATOR
#' \item \code{Zp}: PARAGRAPH SEPARATOR
#' \item \code{C}: Union of ...
#' \item \code{L}: Union of \code{Lu}, \code{Ll}, \code{Lt}, \code{Lm}, \code{Lo}
#' \item \code{M}: Union of ...
#' \item \code{N}: Union of ...
#' \item \code{P}: Union of ..
#' \item \code{S}: Union of \code{Sm}, \code{Sc}, \code{Sk}, \code{So}
#' \item \code{Z}: Union of ..
#' }
#' 
#'
#'
#' @section Unicode Binary Properies
#' 
#' (matched case-insensitively, normalized like with ICU character encoding
#' specification)
#' 
#' \itemize{
#' \item \code{ALPHABETIC}
#' \item \code{ASCII_HEX_DIGIT} - matches \code{[0-9A-Fa-f]} regex
#' \item \code{BIDI_CONTROL} - format controls which have specific functions 
#' in the Bidi (bidirectional text) Algorithm.
#' \item \code{BIDI_MIRRORED} - Characters that may change display in right-to-left text.
#' \item \code{DASH} - Variations of dashes.
#' \item \code{DEFAULT_IGNORABLE_CODE_POINT} - Ignorable in most processing, 
#' e.g. <2060..206F, FFF0..FFFB, E0000..E0FFF>
#' \item \code{DEPRECATED} - a deprecated character according 
#' to the current Unicode standard (the usage of deprecated characters 
#' is strongly discouraged)
#' \item \code{DIACRITIC} - Characters that linguistically modify the meaning of another character to which they apply.
#' \item \code{EXTENDER} - Extend the value or shape of a preceding alphabetic character, e.g., length and iteration marks.
#' \item \code{FULL_COMPOSITION_EXCLUSION}
#' \item \code{GRAPHEME_BASE}
#' \item \code{GRAPHEME_EXTEND}
#' \item \code{GRAPHEME_LINK}
#' \item \code{HEX_DIGIT} - Characters commonly used for hexadecimal numbers, 
#' cf. also \code{ASCII_HEX_DIGIT}
#' \item \code{HYPHEN} - Dashes used to mark connections between 
#' pieces of words, plus the Katakana middle dot.
#' \item \code{ID_CONTINUE} - Characters that can continue an identifier,
#'  \code{ID_START}+Mn+Mc+Nd+Pc
#' \item \code{ID_START} - Characters that can start an identifier. 
#' Lu+Ll+Lt+Lm+Lo+Nl
#' \item \code{IDEOGRAPHIC} - CJKV (Chineese-Japaneese-Korean-Vietnameese) 
#' ideographs.
#' \item \code{IDS_BINARY_OPERATOR}
#' \item \code{IDS_TRINARY_OPERATOR}
#' \item \code{JOIN_CONTROL}
#' \item \code{LOGICAL_ORDER_EXCEPTION}
#' \item \code{LOWERCASE}
#' \item \code{MATH}
#' \item \code{NONCHARACTER_CODE_POINT}
#' \item \code{QUOTATION_MARK}
#' \item \code{RADICAL}
#' \item \code{SOFT_DOTTED} - Characters with a "soft dot", like i or j. 
#' An accent placed on these characters causes the dot to disappear.
#' \item \code{TERMINAL_PUNCTUATION} - Punctuation characters that generally 
#' mark the end of textual units.
#' \item \code{UNIFIED_IDEOGRAPH}
#' \item \code{UPPERCASE}
#' \item \code{WHITE_SPACE} - Space characters+TAB+CR+LF-ZWSP-ZWNBSP
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
