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
#' Locate Occurrences of a Fixed Pattern
#'
#' @description
#' These functions find the indices, at which
#' a given pattern matches a substring of the input string.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' These are locale-independent operations.
#' For natural language processing this function may be not give
#' you desired results. Refer to \link{stringi-search-fixed} for more details.
#'
#'
#' Note the difference between  \code{stri_locate_last_fixed}
#' and \code{\link{stri_locate_last_regex}} for overlapping pattern matches.
#' In \code{stri_locate_last_fixed}, search is done from-the-end.
#'
#' @param str character vector
#' @param pattern character vector
#'
#' @return
#' For \code{stri_locate_all_fixed},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned.
#' The first column gives the start positions
#' of matches, and the second column gives the end positions.
#' Moreover, you may gen two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' For \code{stri_locate_first_fixed} and \code{stri_locate_last_fixed},
#' you get an integer matrix with \code{max(length(str), length(pattern))} rows,
#' and two columns, giving the start and end positions of the first
#' or the last matches, respectively, and \code{NA}s iff not found.
#'
#' @examples
#' stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_locate_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' stri_locate_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#'
#' #first row is 1-2 like in locate_first
#' stri_locate_all_fixed('bbbbb', 'bb')
#' stri_locate_first_fixed('bbbbb', 'bb')
#' # but last row is 3-4, unlike in locate_last,
#' # keep this in mind [overlapping pattern match OK]!
#' stri_locate_last_fixed('bbbbb', 'bb')
#'
#' locate <- stri_locate_first_fixed('stringi - REXAMINE', letters)
#' rownames(locate) <- letters
#' locate
#'
#' @export
#' @rdname stri_locate_fixed
#' @aliases stri_locate_all_fixed stri_locate_first_fixed stri_locate_last_fixed
#' @family search_fixed
#' @family search_locate
#' @family indexing
stri_locate_all_fixed <- function(str, pattern) {
   .Call("stri_locate_all_fixed", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_fixed
stri_locate_first_fixed <- function(str, pattern) {
   .Call("stri_locate_first_fixed", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_fixed
stri_locate_last_fixed <- function(str, pattern) {
   .Call("stri_locate_last_fixed", str, pattern, PACKAGE="stringi")
}
