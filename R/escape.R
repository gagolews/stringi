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
#' Escape Unicode Code Points
#'
#' @description
#' Escapes all Unicode (not ASCII-printable) code points.
#'
#' @details
#' For non-printable and certain special (well-known,
#' see also \R man page \link{Quotes})
#' ASCII characters the following
#' (also recognized in \R) convention is used.
#' We get \code{\\a}, \code{\\b}, \code{\\t}, \code{\\n}, \code{\\v},
#' \code{\\f}, \code{\\r}, \code{\"}, \code{\'}, \code{\\\\}
#' or either {\\uXXXX} (4 hex digits) or {\\UXXXXXXXX} (8 hex digits)
#' otherwise.
#'
#'
#' As usual, any input string is converted to Unicode
#' before executing the escape process.
#'
#'
#' @param str character vector
#' @return
#' Returns a character vector.
#'
#' @family escape
#' @export
stri_escape_unicode <- function(str) {
   .Call("stri_escape_unicode", str, PACKAGE="stringi")
}


#' @title
#' Unscape All Escape Sequences
#'
#' @description
#' Unscapes all known escape sequences
#'
#' @details
#' Uses \pkg{ICU} facilities to unescape Unicode character sequences.
#'
#' The following ASCII standard escapes are recognized:
#' \code{\\a}, \code{\\b}, \code{\\t}, \code{\\n}, \code{\\v}, \code{\\?},
#' \code{\\e},
#' \code{\\f}, \code{\\r}, \code{\"}, \code{\'}, \code{\\\\}.
#'
#' Moreover, the function understands the following ones:
#' \code{\\uXXXX} (4 hex digits),
#' \code{\\UXXXXXXXX} (8 hex digits),
#' \code{\\xXX} (1-2 hex digits),
#' \code{\\ooo} (1-3 octal digits),
#' \code{\\cX} (control-X; X is masked with 0x1F).
#' For \code{\\xXX} and \code{\\ooo} beware of non-valid UTF8 byte sequences.
#'
#' Note that some versions of \R on Windows cannot handle
#' characters defined with  {\\UXXXXXXXX}.
#' We are working on that.
#'
#' @param str character vector
#' @return
#' Returns a character vector.
#' If an escape sequence is ill-formed,
#' result will be \code{NA} and a warning will be given.
#'
#' @family escape
#' @export
stri_unescape_unicode <- function(str) {
   .Call("stri_unescape_unicode", str, PACKAGE="stringi")
}
