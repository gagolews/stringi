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
#' Extract a Substring From or Replace a Substring In a Character Vector
#'
#' @description
#' The first function extracts substrings under code point-based
#' index ranges provided. The second one allows to substitute parts of
#' a string with given strings.
#'
#' @details
#' Vectorized over \code{str}, [\code{value}], \code{from} and
#' (\code{to} or \code{length}).
#' \code{to} and \code{length} are mutually exclusive.
#'
#' \code{to} has priority over \code{length}.
#' If \code{from} is a two-column matrix, then the first column is used
#' as \code{from} and the second one as \code{to}. In such case arguments
#' \code{to} and \code{length} are ignored.
#'
#' Of course, the indices are code point-based,
#' and not byte-based.
#' Note that for some Unicode strings, the extracted substrings may not
#' be well-formed, especially if the input is not NFC-normalized
#' (see \code{\link{stri_trans_nfc}}),
#' includes byte order marks, Bidirectional text marks, and so on.
#' Handle with care.
#'
#' Indices are 1-based, i.e. an index equal to 1 denotes the first character
#' in a string, which gives a typical \R look-and-feel.
#' Argument \code{to} defines the last index of the substring, inclusive.
#'
#' For negative indices in \code{from} or \code{to},
#' counting starts at the end of the string.
#' E.g. index -1 denotes the last code point in the string.
#' Negative \code{length} means counting backwards.
#'
#'
#' In \code{stri_sub}, out-of-bound indices are silently
#' corrected. If \code{from} > \code{to}, then an empty string is returned.
#'
#' In \code{stri_sub<-}, ``strange'' configurations of indices work as
#' string concatenation at the front, back, or middle.
#'
#' @param str character vector
#' @param from integer vector or two-column matrix
#' @param to integer vector; mutually exclusive with \code{length} and \code{from} being a matrix
#' @param length integer vector; mutually exclusive with \code{to} and \code{from} being a matrix
#' @param value character vector to be substituted [replacement function]
#'
#'
#' @return \code{stri_sub} returns a character vector.
#' \code{stri_sub<-} changes the \code{value} object.
#'
#' The extract function \code{stri_sub} returns the indicated substrings.

#' The replacement function \code{stri_sub<-} is invoked for its
#' side effect: after a call, \code{str} is modified.
#'
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_sub(s, from=1:3*6, to=21)
#' stri_sub(s, from=c(1,7,13), length=5)
#' stri_sub(s, from=1, length=1:3)
#' stri_sub(s, -17, -7)
#' stri_sub(s, -5, length=4)
#' (stri_sub(s, 1, 5) <- "stringi")
#' (stri_sub(s, -6, length=5) <- ".")
#' (stri_sub(s, 1, 1:3) <- 1:2)
#'
#' @family indexing
#' @rdname stri_sub
#' @export
stri_sub <- function(str, from = 1L, to = -1L, length) {
   # Whoaaa! One of the longest R functions in stringi :)
   if (missing(length)) {
      if (is.matrix(from) && !missing(to))
         warning("argument `to` is ignored in given context")
      .Call(C_stri_sub, str, from, to, NULL)
   }
   else {
      if (!missing(to))
         warning("argument `to` is ignored in given context")
      if (is.matrix(from))
         warning("argument `length` is ignored in given context")
      .Call(C_stri_sub, str, from, NULL, length)
   }
}


#' @rdname stri_sub
#' @export
#' @usage stri_sub(str, from = 1L, to = -1L, length) <- value
"stri_sub<-" <- function(str, from = 1L, to = -1L, length, value) {
   # Whoaaa! One of the longest R functions in stringi :)
   if (missing(length)) {
      if (is.matrix(from) && !missing(to))
         warning("argument `to` is ignored in given context")
      .Call(C_stri_sub_replacement, str, from, to, NULL, value)
   }
   else {
      if (!missing(to))
         warning("argument `to` is ignored in given context")
      if (is.matrix(from))
         warning("argument `length` is ignored in given context")
      .Call(C_stri_sub_replacement, str, from, NULL, length, value)
   }
}
