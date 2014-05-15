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
#' Locate Occurrences of a Canonically Equivalent Pattern
#'
#' @description
#' These functions find the indices, at which
#' a given pattern matches a substring of the input string.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' See \link{stringi-search-coll} for more details on
#' locale-sensitive text searching in \pkg{stringi}.
#'
#'
#' Note the difference between  \code{stri_locate_last_coll}
#' and \code{\link{stri_locate_last_regex}} for overlapping pattern matches.
#' In \code{stri_locate_last_coll}, search is done from-the-end.
#'
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named list with \pkg{ICU} Collator's settings
#' as generated with \code{\link{stri_opts_collator}}; \code{NULL}
#' for default settings
#'
#' @return
#' For \code{stri_locate_all_coll},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned.
#' The first column gives the start positions
#' of matches, and the second column gives the end positions.
#' Moreover, you may gen two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' For \code{stri_locate_first_coll} and \code{stri_locate_last_coll},
#' you get an integer matrix with \code{max(length(str), length(pattern))} rows,
#' and two columns, giving the start and end positions of the first
#' or the last matches, respectively, and \code{NA}s iff not found.
#'
#' @examples
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_all_coll(c('AaaaaaaA', 'AAAA'), 'a')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_first_coll(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_last_coll(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#'
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' #first row is 1-2 like in locate_first
#' stri_locate_all_coll('bbbbb', 'bb')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_first_coll('bbbbb', 'bb')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' # but last row is 3-4, unlike in locate_last,
#' # keep this in mind [overlapping pattern match OK]!
#' stri_locate_last_coll('bbbbb', 'bb')
#'
#' @export
#' @rdname stri_locate_coll
#' @aliases stri_locate_all_coll stri_locate_first_coll stri_locate_last_coll
#' @family search_coll
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
stri_locate_all_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_all_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_coll
stri_locate_first_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_first_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_coll
stri_locate_last_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_last_coll", str, pattern, opts_collator, PACKAGE="stringi")
}
