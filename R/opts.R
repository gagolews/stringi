## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#' @title
#' Generate a List with Collator Options
#'
#' @description
#' A convenience function to tune the Collator's behavior,
#' e.g. in \code{\link{stri_compare}}, \code{\link{stri_order}},
#' \code{\link{stri_detect_fixed}},
#' and other \link{stringi-search-fixed} functions.
#'
#'
#' @details
#' \pkg{ICU}'s \emph{collator} performs a locale-aware, natural-language
#' alike string comparison.
#' This is a more reliable way of establishing relationships between
#' string than that provided by base \R, and definitely
#' one that is more complex than ordinary byte-comparison.
#'
#' A note on collation \code{strength}:
#' generally, \code{strength} set to 4 is
#' the least permissive.
#' Set to 2 to ignore case differences.
#' Set to 1 to also ignore diacritical differences.
#'
#' The strings are Unicode-normalized before the comparison.
#'
#'
#'
#' @param locale single string, \code{NULL} or
#' \code{""} for default locale
#' @param strength single integer in \{1,2,3,4\}, which defines collation strength;
#' \code{1} for the most permissive collation rules, \code{4} for the most
#' strict ones
#' @param alternate_shifted single logical value; \code{FALSE}
#'  treats all the code points with non-ignorable primary weights in the same way,
#'  \code{TRUE} causes code points with primary weights that are equal or below
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
#'
#' @return
#' Returns a named list object; missing options are left with default values.
#'
#' @export
#' @family locale_sensitive
#' @family search_fixed
#'
#' @references
#' \emph{Collation} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/collation}
#'
#' \emph{ICU Collation Service Architecture} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/collation/architecture}
#'
#' \emph{\code{icu::Collator} Class Reference} -- ICU4C API Documentation,
#' \url{http://www.icu-project.org/apiref/icu4c/classicu_1_1Collator.html}
#'
#' @examples
#' \dontrun{
#' stri_cmp("zupa100", "zupa2") != stri_cmp("zupa100", "zupa2", stri_opts_collator(numeric=TRUE))
#' stri_cmp("above mentioned", "above-mentioned")
#' stri_cmp("above mentioned", "above-mentioned", stri_opts_collator(alternate_shifted=TRUE))
#' }
stri_opts_collator <- function(locale=NULL, strength=3L,
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
#' Generate a List with Regex Matcher Options
#'
#' @description
#' A convenience function to tune regular expressions matcher behavior,
#' e.g. in \code{\link{stri_count_regex}}
#' and other \link{stringi-search-regex} functions.
#'
#'
#' @param case_insensitive logical; enable case insensitive matching
#' @param comments logical; allow white space and comments within patterns
#' @param dotall logical;  if set, `\code{.}` matches line terminators,
#'  otherwise matching of `\code{.}`  stops at a line end
#' @param literal logical; if set, treat the entire pattern as a literal string:
#' metacharacters or escape sequences in the input sequence will be given no special meaning;
#' note that in most cases you would rather use the \link{stringi-search-fixed}
#' facilities in this case (with \code{opts_collator=NA}).
#' @param multiline logical; controls the behavior of `\code{$}` and `\code{^}`.
#' If set, recognize line terminators within a string, otherwise,
#'  match only at start and end of input string
#' @param unix_lines logical; Unix-only line endings.
#' When this mode is enabled, only \code{U+000a} is recognized as a
#' line ending by `\code{.}`, `\code{$}`, and `\code{^}`.
#' @param uword logical; Unicode word boundaries.
#' If set, uses the Unicode TR 29 definition of word boundaries;
#' warning: Unicode word boundaries are quite different from traditional
#' regex word boundaries.
#' See \url{http://unicode.org/reports/tr29/#Word_Boundaries}
#' @param error_on_unknown_escapes logical;
#' whether to generate an error on unrecognized backslash escapes;
#' if set, fail with an error on patterns that contain backslash-escaped ASCII
#' letters without a known special meaning;
#' otherwise, these escaped letters represent themselves.
#'
#' Note that some regex options may be changed using ICU regex flag
#' settings inside regexes. For example, \code{"(?i)pattern"} does
#' a case-insensitive match of a given pattern,
#' see the ICU User Guide entry on Regular Expressions in the References section.
#'
#' @return
#' Returns a named list object; missing options are left with default values.
#'
#' @export
#' @family search_regex
#'
#' @references
#' \emph{\code{enum URegexpFlag}: Constants for Regular Expression Match Modes}
#' -- ICU4C API Documentation,
#' \url{http://www.icu-project.org/apiref/icu4c/uregex_8h.html}
#'
#' \emph{Regular Expressions} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/strings/regexp}
#'
#' @examples
#' \dontrun{
#' stri_detect_regex("ala", "ALA") # case-sensitive by default
#' stri_detect_regex("ala", "ALA", stri_opts_regex(case_insensitive=TRUE))
#' stri_detect_regex("ala", "(?i:)ALA") # equivalent
#' }
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
