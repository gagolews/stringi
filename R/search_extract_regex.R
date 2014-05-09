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
#' Extract Regex Pattern Matches
#'
#' @description
#' These functions extract substrings of \code{str} that
#' match a given \code{pattern}.
#'
#' See also \code{\link{stri_match_all_regex}} for extracting
#' matches together with regex capture groups.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions
#' @param opts_regex a named list with \pkg{ICU} Regex settings
#' as generated with \code{\link{stri_opts_regex}}; \code{NULL}
#' for default settings
#'
#' @return
#' For \code{stri_extract_all_regex},
#' list of \code{max(length(str), length(pattern))} character vectors is returned.
#' Otherwise, you get a character vector.
#' \code{NA} if not found.
#'
#' @examples
#' stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_first_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_last_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#'
#' @export
#' @rdname stri_extract_regex
#' @aliases stri_extract_all_regex stri_extract_first_regex stri_extract_last_regex
#' @family search_regex
#' @family search_extract
stri_extract_all_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_extract_all_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_regex
stri_extract_first_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_extract_first_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_regex
stri_extract_last_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_extract_last_regex", str, pattern, opts_regex, PACKAGE="stringi")
}
