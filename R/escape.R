## This file is part of the 'stringi' library.
##
## Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.


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
