# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
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
## 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
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
#' These functions may be used, e.g., to remove unnecessary
#' white-spaces from strings. Trimming ends at the first or
#' starts at the last \code{pattern} match.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' \code{stri_trim} is a convenience wrapper over \code{stri_trim_left}
#' and \code{stri_trim_right}.
#'
#' Contrary to many other string processing libraries,
#' our trimming functions are universal. The class of characters
#' to be retained or trimmed can be adjusted.
#'
#' For replacing pattern matches with
#' an arbitrary replacement string, see \code{\link{stri_replace}}.
#'
#' Trimming can also be used where you would normally rely on
#' regular expressions. For instance, you may get
#' \code{'23.5'} out of \code{'total of 23.5 bitcoins'}.
#'
#' For trimming white-spaces, please note the difference
#' between Unicode binary property `\code{\\p\{Wspace\}}` (more universal)
#' and general character category `\code{\\p\{Z\}}`,
#' see \link{stringi-search-charclass}.
#'
#' @param str a character vector of strings to be trimmed
#' @param pattern a single pattern, specifying the class of characters
#'     (see \link{stringi-search-charclass}) to
#'     to be preserved (if \code{negate} is \code{FALSE}; default)
#'     or trimmed (otherwise)
#' @param side character [\code{stri_trim} only]; defaults to \code{'both'}
#' @param negate either \code{TRUE} or \code{FALSE}; see \code{pattern}
#'
#'
#' @return
#' All functions return a character vector.
#'
#'
#' @examples
#' stri_trim_left('               aaa')
#' stri_trim_right('r-project.org/', '\\P{P}')
#' stri_trim_both(' Total of 23.5 bitcoins. ', '\\p{N}')
#' stri_trim_both(' Total of 23.5 bitcoins. ', '\\P{N}', negate=TRUE)
#'
#' @aliases stri_trim
#' @family search_replace
#' @family search_charclass
#' @rdname stri_trim
#' @export
stri_trim_both <- function(str, pattern="\\P{Wspace}", negate=FALSE)
{
    .Call(C_stri_trim_both, str, pattern, negate)
}


#' @rdname stri_trim
#' @export
stri_trim_left <- function(str, pattern="\\P{Wspace}", negate=FALSE)
{
    .Call(C_stri_trim_left, str, pattern, negate)
}


#' @rdname stri_trim
#' @export
stri_trim_right <- function(str, pattern="\\P{Wspace}", negate=FALSE)
{
    .Call(C_stri_trim_right, str, pattern, negate)
}


#' @rdname stri_trim
#' @export
stri_trim <- function(str, side=c("both", "left", "right"), pattern="\\P{Wspace}", negate=FALSE)
{
    # `both` is default for compatibility with stringr
    side <- match.arg(side)  # this is slow

    switch(side,
        both=stri_trim_both(str, pattern, negate),
        left=stri_trim_left(str, pattern, negate),
        right=stri_trim_right(str, pattern, negate)
    )
}
