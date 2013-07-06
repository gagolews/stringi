## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus
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


#' @title
#' Generate List with Collator Options
#'
#' @description
#' Convenience function to tune collator's behavior,
#' e.g. in \code{\link{stri_compare}}, \code{\link{stri_order}},
#' \code{\link{stri_detect_fixed}}, and other \link{stringi-search-fixed} functions.
#'
#'
#' @details
#' ICU's collator performs a locale-aware, natural-language
#' alike string comparison.
#' This is a more intelligent form than that provided by base R
#' (on some platforms), and definitely
#' more complex than ordinary byte-comparison.
#'
#' A note on collation strength. Generally, \code{strength} set to 4 is
#' the least permissive.
#' Set to 2 to ignore case differences.
#' Set to 1 to also ignore diacritical differences.
#'
#' The strings are Unicode-normalized before the comparison.
#'
#'
#'
#' @param locale single string, \code{""} for default locale
#' @param strength single integer, collation strength, in \{1,2,...,4\};
#' \code{1} for the most permissive collation rules, \code{4} for the most
#' strict
#' @param alternate_shifted single logical value; \code{FALSE}
#'  treats all the codepoints with non-ignorable primary weights in the same way,
#'  \code{TRUE} causes codepoints with primary weights that are equal or below
#'  the variable top value to be ignored on primary level and moved to the quaternary level
#' @param french single logical value; used in Canadian French;
#' \code{TRUE} results in secondary weights being considered backwards
#' @param uppercase_first single logical value; \code{NA}
#' orders upper and lower case letters in accordance to their tertiary weights,
#' \code{TRUE} forces upper case letters to sort before lower case letters,
#' \code{FALSE} does the opposite
#' @param case_level single logical value;
#' controls whether an extra case level (positioned before the third level) is generated or not
#' @param normalization single logical value; if \code{TRUE},
#' then incremental check is performed to see whether the input data is in
#' the FCD form. If the data is not in the FCD form, incremental NFD
#' normalization is performed
#' @param numeric single logical value;
#' when turned on, this attribute generates a collation key for
#'  the numeric value of substrings of digits;
#'  This is a way to get '100' to sort AFTER '2'.
#' @return
#' a named list object; missing options are left with default values
#' @export
#' @aliases collator
#' @family locale_sensitive
#' @family search_fixed
#'
#' @references
#' Collation - ICU User Guide - http://userguide.icu-project.org/collation\cr
#' ICU Collation Service Architecture - ICU User Guide - http://userguide.icu-project.org/collation/architecture\cr
#' http://www.icu-project.org/apiref/icu4c/classicu_1_1Collator.html
#'
#' @examples
#' stri_cmp("zupa100", "zupa2") != stri_cmp("zupa100", "zupa2", stri_opts_collator(numeric=TRUE))
#' stri_cmp("above mentioned", "above-mentioned")
#' stri_cmp("above mentioned", "above-mentioned", stri_opts_collator(alternate_shifted=TRUE))
stri_opts_collator <- function(locale="", strength=3L,
   alternate_shifted=FALSE, french=FALSE,
   uppercase_first=NA, case_level=FALSE,
   normalization=FALSE, numeric=FALSE)
{
   opts <- list()
   if (!missing(locale))            opts["locale"]            <- locale
   if (!missing(strength))          opts["strength"]          <- strength
   if (!missing(alternate_shifted)) opts["alternate_shifted"] <- alternate_shifted
   if (!missing(french))            opts["french"]            <- french
   if (!missing(uppercase_first))   opts["uppercase_first"]   <- uppercase_first
   if (!missing(case_level))        opts["case_level"]        <- case_level
   if (!missing(normalization))     opts["normalization"]     <- normalization
   if (!missing(numeric))           opts["numeric"]           <- numeric
   opts
}



#' @title
#' Generate List with Regexp Matcher Options
#'
#' @description
#' Convenience function to tune regular expression matcher behavior,
#' e.g. in \code{\link{stri_count_regex}} and other \link{stringi-search-regex} functions.
#'
#'
#' @param case_insensitive logical; enable case insensitive matching
#' @param comments logical; allow white space and comments within patterns
#' @param dotall logical;  if set, `\code{.}` matches line terminators, otherwise `\code{.}` matching stops at line end
#' @param literal logical; if set, treat the entire pattern as a literal string.
#' Metacharacters or escape sequences in the input sequence will be given no special meaning;
#' note that in most cases you would rather use the \link{stringi-search-fixed}
#' facilities in this case (with \code{opts_collator=NA}).
#' @param multiline logical; controls behavior of `\code{$}` and `\code{^}`.
#' If set, recognize line terminators within string, otherwise, match only at start and end of input string
#' @param unix_lines logical; Unix-only line endings.
#' When this mode is enabled, only \code{U+000a} is recognized as a
#' line ending in the behavior of `\code{.}`, `\code{$}`, and `\code{^}`.
#' @param uword logical; Unicode word boundaries.
#' If set, uses the Unicode TR 29 definition of word boundaries.
#' Warning: Unicode word boundaries are quite different from traditional
#' regular expression word boundaries. See \url{http://unicode.org/reports/tr29/#Word_Boundaries}
#' @param error_on_unknown_escapes logical;
#' Error on Unrecognized backslash escapes.
#' If set, fail with an error on patterns that contain backslash-escaped ASCII
#'  letters without a known special meaning.
#'  If this flag is not set, these escaped letters represent themselves.
#' @return
#' a named list object; missing options are left with default values
#' @export
#' @aliases regex
#' @family search_regex
#'
#' @references
#' ICU regex options, \url{http://www.icu-project.org/apiref/icu4c/uregex_8h.html#a874989dfec4cbeb6baf4d1a51cb529ae}\cr
#'
stri_opts_regex <- function(case_insensitive, comments, dotall, literal,
                            multiline, unix_lines, uword, error_on_unknown_escapes)
{
   opts <- list()
   if (!missing(case_insensitive))         opts["case_insensitive"]         <- case_insensitive
   if (!missing(comments))                 opts["comments"]                 <- comments
   if (!missing(dotall))                   opts["dotall"]                   <- dotall
   if (!missing(literal))                  opts["literal"]                  <- literal
   if (!missing(multiline))                opts["multiline"]                <- multiline
   if (!missing(unix_lines))               opts["unix_lines"]               <- unix_lines
   if (!missing(uword))                    opts["uword"]                    <- uword
   if (!missing(error_on_unknown_escapes)) opts["error_on_unknown_escapes"] <- error_on_unknown_escapes
   opts
}

