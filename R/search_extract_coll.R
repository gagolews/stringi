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
#' Extract Canonically Equivalent Pattern Matches
#'
#' @description
#' These functions extract substrings of \code{str} that
#' match a given \code{pattern}.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' There are locale-sensitive operations.
#' See \link{stringi-search-coll} for more details on
#' locale-sensitive text searching in \pkg{stringi}.
#'
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named list with \pkg{ICU} Collator's settings
#' as generated with \code{\link{stri_opts_collator}}; \code{NULL}
#' for default settings
#'
#' @return
#' For \code{stri_extract_all_coll}, a list of
#' \code{max(length(str), length(pattern))} character vectors is returned.
#' Otherwise, you get a character vector.
#' \code{NA} if not found.
#'
#' @examples
#' stri_extract_all_coll(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_extract_first_coll(c('Yy\u00FD', 'AAA'), 'y',
#'    stri_opts_collator(strength=2, locale="sk_SK"))
#' stri_extract_last_coll(c('Yy\u00FD', 'AAA'), 'y',
#'    stri_opts_collator(strength=1, locale="sk_SK"))
#'
#' @export
#' @rdname stri_extract_coll
#' @aliases stri_extract_all_coll stri_extract_first_coll stri_extract_last_coll
#' @family search_coll
#' @family search_extract
#' @family locale_sensitive
stri_extract_all_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_extract_all_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_coll
stri_extract_first_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_extract_first_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_coll
stri_extract_last_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_extract_last_coll", str, pattern, opts_collator, PACKAGE="stringi")
}
