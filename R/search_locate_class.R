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
#' Locate Occurrences of a Character Class
#'
#' @description
#' These functions may be used e.g. to find the indices, at which
#' letters, digits, or white spaces occur in a given string.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{merge}.
#'
#' @param str character vector to search in
#' @param pattern character vector specifying character classes to match,
#' see \link{stringi-search-charclass}
#' @param merge logical [\code{stri_locate_all_charclass} only];
#' indicates whether consecutive sequences of indices in the resulting
#' matrix shall be merged
#'
#' @return
#' For \code{stri_locate_all_charclass},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned.
#' The first column gives the start positions
#' of matches, and the second column gives the end positions.
#' Moreover, you may get two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' For \code{stri_locate_first_charclass} and \code{stri_locate_last_charclass},
#' you get an integer matrix with \code{max(length(str), length(pattern))} rows,
#' and two columns, giving the start and end positions of the first
#' or the last matches, respectively, and two \code{NA}s iff not found.
#' Note that the first column is always equal to the second column, as
#' we look for single code points in these two cases.
#'
#' @examples
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}', merge=FALSE)
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_first_charclass('AaBbCc', '\\p{Ll}')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_last_charclass('AaBbCc', '\\p{Ll}')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_locate_all_charclass(c('REXAMINE'), '\\p{Lu}', merge=c(TRUE, FALSE))
#'
#' @export
#' @rdname stri_locate_charclass
#' @aliases stri_locate_all_charclass stri_locate_first_charclass stri_locate_last_charclass
#' @family search_charclass
#' @family search_locate
#' @family indexing
stri_locate_all_charclass <- function(str, pattern, merge=TRUE) {
   .Call("stri_locate_all_charclass", str, pattern, merge, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_charclass
stri_locate_first_charclass <- function(str, pattern) {
   .Call("stri_locate_first_charclass", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_charclass
stri_locate_last_charclass <- function(str, pattern) {
   .Call("stri_locate_last_charclass", str, pattern, PACKAGE="stringi")
}
