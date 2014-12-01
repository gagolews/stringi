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
#' Trim Characters from the Left and/or Right Side of a String
#'
#' @description
#' These functions may be used e.g. to get rid of unnecessary
#' whitespaces from strings. Trimming ends at the first or
#' starts at the last \code{pattern} match.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' \code{stri_trim} is a convenience function, which dispatches
#' control to \code{stri_trim_*}. Unless you are very lazy, do not use it:
#' it is a little bit slower.
#'
#' Contrary to many other string processing libraries,
#' our trimming functions are quite general. A character class,
#' given by \code{pattern},
#' may be adjusted to suit your needs (most often you will use the default
#' value). On the other hand, for replacing pattern matches with
#' arbitrary replacement string, see \code{\link{stri_replace}}.
#'
#' Interestingly, with these functions you may sometimes extract data, which
#' in some cases require using regular expressions. E.g. you may get
#' \code{"23.5"} out of \code{"total of 23.5 bitcoins"}.
#'
#' For trimming whitespaces, please note the difference
#' between Unicode binary property `\code{\\p\{Wspace\}}` (more general)
#' and general character category `\code{\\p\{Z\}}`,
#' see \link{stringi-search-charclass}.
#'
#' @param str character vector
#' @param pattern character vector specifying character classes that
#' should be preserved, see \link{stringi-search-charclass},
#' defaults to `\code{\\P\{Wspace\}}`
#' @param side character [\code{stri_trim} only]; defaults to \code{"both"}
#'
#' @return All these functions return a character vector.
#'
#' @examples
#' stri_trim_left("               aaa")
#' stri_trim_right("rexamine.com/", "\\p{P}")
#' stri_trim_both(" Total of 23.5 bitcoins. ", "\\p{N}")
#' stri_trim_both(" Total of 23.5 bitcoins. ", "\\p{L}")
#'
#' @aliases stri_trim
#' @family search_replace
#' @family search_charclass
#' @rdname stri_trim
#' @export
stri_trim_both <- function(str, pattern="\\P{Wspace}") {
   .Call(C_stri_trim_both, str, pattern)
}


#' @rdname stri_trim
#' @export
stri_trim_left <- function(str, pattern="\\P{Wspace}") {
  .Call(C_stri_trim_left, str, pattern)
}


#' @rdname stri_trim
#' @export
stri_trim_right <- function(str, pattern="\\P{Wspace}") {
  .Call(C_stri_trim_right, str, pattern)
}


#' @rdname stri_trim
#' @export
stri_trim <- function(str, side=c("both", "left", "right"), pattern="\\P{Wspace}") {
   # `both` is default for compatibility with stringr
   side <- match.arg(side) # this is slow

   switch(side,
          both  =stri_trim_both(str, pattern),
          left  =stri_trim_left(str, pattern),
          right =stri_trim_right(str, pattern)
   )
}
