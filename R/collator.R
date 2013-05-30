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


#' Generate List with Collator Options
#' 
#' Convenience function to tune collator's behavior,
#' e.g. in \code{\link{stri_compare}}, \code{\link{stri_order}},
#' \code{\link{stri_detect_fixed}}, and other \link{search_fixed} functions.
#' 
#'
#' 
#' ICU's collator performs a locale-aware, natural-language
#' alike string comparison.
#' This is a more intelligent form than that provided by base R, and definitely
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
#' A named R list object; missing options are left with default values.
#' @export
#' @aliases collator
#' @concepts collator collation comparison ordering sorting fcd nfd locale language context
#' @family locale_sensitive
#' @family search_fixed
#' 
#' @references
#' Collation - ICU User Guide - http://userguide.icu-project.org/collation\cr
#' ICU Collation Service Architecture - ICU User Guide - http://userguide.icu-project.org/collation/architecture\cr
#' http://www.icu-project.org/apiref/icu4c/classicu_1_1Collator.html
#' 
#' @examples
#' stri_cmp("zupa100", "zupa2") != stri_cmp("zupa100", "zupa2", stri_collator_genopts(numeric=TRUE))
#' stri_cmp("above mentioned", "above-mentioned")
#' stri_cmp("above mentioned", "above-mentioned", stri_collator_genopts(alternate_shifted=TRUE))
stri_collator_genopts <- function(locale="", strength=3L,
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
