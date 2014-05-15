## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice,
## this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
## this list of conditions and the following disclaimer in the documentation
## and/or other materials provided with the distribution.
##
## 3. Neither the name of the copyright holder nor the names of its
## contributors may be used to endorse or promote products derived from
## this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
## BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
## FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
## OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
## WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
## OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
## EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#' @title
#' Count the Number of Pattern Matches in a String
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_count_regex}},
#' \code{\link{stri_count_fixed}}, \code{\link{stri_count_coll}},
#' or \code{\link{stri_count_charclass}},
#' depending on the argument used.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns an integer vector.
#'
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_count(s, fixed=letters)
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_count(s, regex="[[:alpha:]]")
#'
#' @export
#' @family search_count
stri_count <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_count_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_count_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_count_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_count_charclass(str, charclass, ...)
}
