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




#' String Searching
#' 
#' This man page describes how to perform string search-based
#' operations in \pkg{stringi}.
#' 
#' There are three string searching ``engines'' in \pkg{stringi}.
#' \itemize{
#'    \item \code{stri_*_regex} - ICU's regular expressions, see \link{stringi-search-regex},
#'    \item \code{stri_*_fixed} - ICU's \code{StringSearch}, locale-sensitive ``fixed'' patterns, see \link{stringi-search-fixed},
#'    \item \code{stri_*_charclass} - single character classes and binary properties, see \link{stringi-search-charclass},
#' }
#' 
#' Each ``engine'' is able to perform many search-based operations:
#' \itemize{
#'    \item \code{stri_detect_*} - detects if a pattern occurs in a string
#'    \item \code{stri_count_*} - counts the number of pattern's occurences
#'    \item ...
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



#' Regular Expressions in \pkg{stringi}
#'
#' All \code{stri_*_regex} functions in \pkg{stingi} use
#' the \pkg{ICU} regex engine.
#' 
#' ignore_case.....
#' 
#' all regex functions treat text as single line.
#' if you want multiline facilities, do split (all \pkg{stringi} functions
#' are nicely vectorized)
#'
#' @references
#' Regular expressions - ICU User Guide, \url{http://userguide.icu-project.org/strings/regexp} \cr
#' Unicode Regular Expressions \url{http://www.regular-expressions.info/unicode.html}\cr
#' 
#' @name stringi-search-regex
#' @family search_regex
invisible(NULL)



#' Locale-sensitive Text Searching in \pkg{stringi}
#'
#' All \code{stri_*_fixed} functions in \pkg{stingi} use
#' the \pkg{ICU} \code{StringSearch} engine.
#' 
#' For more information on ICU's Collator & SearchEngine
#' and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_collator_genopts}}.
#' 
#' \bold{String Search Engine}
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



#' Character Classes in \pkg{stringi}
#'
#' All \code{stri_*_charclass} functions in \pkg{stingi} perform
#' single character search-based operations....
#' 
#'
#' There are two separate ways to specify character classes or
#' their complements in \pkg{stringi}:
#' 
#' * with Unicode General Category Masks, e.g. \code{Lu} for Upper-Case Letters,
#' see \code{\link{stri_char_getcategoryid}}
#' 
#' * with Unicode Binary Property Identifies, e.g. \code{ALPHABETIC} for
#' alphabetic characters, see \code{\link{stri_char_getpropertyid}}
#' 
#' Note that e.g. General Category \code{Z} (some space) and Binary Property
#' \code{WHITE_SPACE} may match different character sets.
#' 
#' @references
#' Regular expressions - ICU User Guide, \url{http://userguide.icu-project.org/strings/regexp} \cr
#' Unicode Regular Expressions \url{http://www.regular-expressions.info/unicode.html}\cr
#' 
#' @name stringi-search-charclass
#' @family search_charclass
invisible(NULL)
