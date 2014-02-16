## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#' @title
#' Reverse Each String
#'
#' @description
#' Reverses characters in every string.
#'
#' @details
#' Note that this operation is not very intelligent -- it just reverses
#' the order of all Unicode code points.
#' It may result in non-Unicode-normalized
#' strings and may give strange output for bidirectional strings.
#'
#' @param str character vector
#'
#' @return Returns a character vector.
#'
#' @examples
#' stri_reverse(c("123", "abc d e f"))
#' stri_reverse("ZXY (\u0105\u0104123$^).")
#' \dontrun{
#' stri_reverse(stri_enc_nfd('\u0105')) == stri_enc_nfd('\u0105') # A, ogonek -> agonek, A
#' }
#' @export
stri_reverse <- function(str) {
   .Call("stri_reverse", str, PACKAGE="stringi")
}
