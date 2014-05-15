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
#' Replace Occurrences of a Regex Pattern Matches
#'
#' @description
#' Replaces with the given replacement string every/first/last
#' substring of the input that matches a regular expression
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' These functions scan the input string for matches of the pattern.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the replacement string.
#'
#' The replacement string may contain references to capture groups
#' (in round parentheses).
#' References are of the form \code{$n}, where \code{n} is the number
#' of the capture group (their numbering starts from 1).
#'
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions
#' @param replacement character vector of strings to replace with,
#' possibly including references to capture groups
#' @param opts_regex a named list with \pkg{ICU} Regex settings
#' as generated with \code{\link{stri_opts_regex}}; \code{NULL}
#' for default settings
#'
#' @return Each function returns a character vector.
#'
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_regex(s, " .*? ", "#")
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_regex(s, "(el|s)it", "1234")
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_regex('abaca', 'a', c('!', '*'))
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_regex('123|456|789', '(\\p{N}).(\\p{N})', '$2-$1')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_regex(c("stringi R", "REXAMINE", "123"), '( R|R.)', ' r ')
#'
#' @export
#' @rdname stri_replace_regex
#' @aliases stri_replace_all_regex stri_replace_first_regex stri_replace_last_regex
#' @family search_regex
#' @family search_replace
stri_replace_all_regex <- function(str, pattern, replacement, opts_regex=NULL) {
   .Call("stri_replace_all_regex", str, pattern, replacement, opts_regex,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_regex
stri_replace_first_regex <- function(str, pattern, replacement, opts_regex=NULL) {
   .Call("stri_replace_first_regex", str, pattern, replacement, opts_regex,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_regex
stri_replace_last_regex <- function(str, pattern, replacement, opts_regex=NULL) {
   .Call("stri_replace_last_regex", str, pattern, replacement, opts_regex,
         PACKAGE="stringi")
}
