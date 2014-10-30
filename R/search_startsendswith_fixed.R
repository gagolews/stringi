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
#' Determine if the Start or End of a String Matches a Fixed Pattern
#'
#' @description
#' These functions check if a string starts or ends with a fixed
#' pattern occurrence.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern},
#' and \code{from} or \code{to}.
#'
#' For natural language processing this function might not give
#' you desired results. Refer to \link{stringi-search-fixed} for more details.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' Argument \code{start} controls the start position in \code{str}
#' at which \code{pattern} is mathed.
#' On the other hand, \code{to} gives the end position.
#'
#' Indices given by \code{from} or \code{to} are 1-based,
#' i.e. an index equal to 1 denotes the first character
#' in a string, which gives a typical R look-and-feel.
#'
#' For negative indices in \code{from} or \code{to}, counting starts
#' at the end of the string. E.g. index -1 denotes the last code point
#' in the string.
#'
#' @param str character vector
#' @param pattern character vector
#' @param from integer vector
#' @param to integer vector
#'
#' @return Returns a logical vector.
#'
#' @export
#' @rdname stri_startswith_fixed
#' @family search_startsendswith
#' @family search_fixed
stri_startswith_fixed <- function(str, pattern, from=1L) {
   .Call("stri_startswith_fixed", str, pattern, from, PACKAGE="stringi")
}


#' @export
#' @rdname stri_startswith_fixed
stri_endswith_fixed <- function(str, pattern, to=-1L) {
   .Call("stri_endswith_fixed", str, pattern, to, PACKAGE="stringi")
}
