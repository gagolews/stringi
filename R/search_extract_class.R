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
#' Extract Character Class Matches
#'
#' @description
#' These functions extract substrings of \code{str} that
#' consists of characters from character classes specified by \code{pattern}.
#'
#' Generally, this is the way to extract single characters, only.
#' Longer substrings, however, may be extracted,
#' with the \code{stri_extract_all_charclass} function
#' and \code{merge=TRUE}.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{merge}.
#'
#' @param str character vector to search in
#' @param pattern character vector specifying character classes to match,
#' see \link{stringi-search-charclass}
#' @param merge logical [\code{stri_extract_all_charclass} only];
#' should consecutive matches be merged into one string?
#'
#' @return
#' For \code{stri_extract_all_charclass},
#' a list of \code{max(length(str), length(pattern), length(merge))}
#' character vectors is returned.
#' Otherwise, you get a character vector.
#' \code{NA} if not found.
#'
#'
#' @examples
#' stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}')
#' stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}', merge=FALSE)
#' stri_extract_first_charclass('AaBbCc', '\\p{Ll}')
#' stri_extract_last_charclass('AaBbCc', '\\p{Ll}')
#'
#' @export
#' @rdname stri_extract_charclass
#' @aliases stri_extract_all_charclass stri_extract_first_charclass stri_extract_last_charclass
#' @family search_charclass
#' @family search_extract
stri_extract_all_charclass <- function(str, pattern, merge=TRUE) {
   .Call("stri_extract_all_charclass", str, pattern, merge, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_charclass
stri_extract_first_charclass <- function(str, pattern) {
   .Call("stri_extract_first_charclass", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_charclass
stri_extract_last_charclass <- function(str, pattern) {
   .Call("stri_extract_last_charclass", str, pattern, PACKAGE="stringi")
}
