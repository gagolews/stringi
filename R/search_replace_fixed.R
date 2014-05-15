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
#' Replace Occurrences of a Fixed Pattern Matches
#'
#' @description
#' Replaces with the given replacement string every/first/last
#' substring of the input that matches the pattern.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' For natural language processing this function may be not give
#' you desired results. Refer to \link{stringi-search-fixed} for more details.
#'
#' These functions scan the input string for matches of the pattern.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the replacement string.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of patterns to search for
#' @param replacement character vector of strings to replace with
#'
#' @return Each function returns a character vector.
#'
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_fixed(s, " ", "#")
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_fixed(s, "o", "0")
#'
#' @export
#' @rdname stri_replace_fixed
#' @aliases stri_replace_all_fixed stri_replace_first_fixed stri_replace_last_fixed
#' @family search_fixed
#' @family search_replace
stri_replace_all_fixed <- function(str, pattern, replacement) {
   .Call("stri_replace_all_fixed", str, pattern, replacement,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_fixed
stri_replace_first_fixed <- function(str, pattern, replacement) {
   .Call("stri_replace_first_fixed", str, pattern, replacement,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_fixed
stri_replace_last_fixed <- function(str, pattern, replacement) {
   .Call("stri_replace_last_fixed", str, pattern, replacement,
         PACKAGE="stringi")
}
