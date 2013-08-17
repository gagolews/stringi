## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus
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
#' see also R man page \link{Quotes})
#' ASCII characters the following
#' (also recognized in R) convention is used.
#' We get \code{\\a}, \code{\\b}, \code{\\t}, \code{\\n}, \code{\\v},
#' \code{\\f}, \code{\\r}, \code{\"}, \code{\'}, \code{\\\\}
#' or either {\\uXXXX} (4 hex digits) or {\\UXXXXXXXX} (8 hex digits)
#' otherwise.
#' 
#' As usual, any input string is converted to Unicode
#' on init.
#' 
#'
#' @param str character vector
#' @return
#' Returns a character vector.
#'
#' @family escape
#' @export
#' @rdname stri_escape_unicode
stri_escape_unicode <- function(str) {
   .Call("stri_escape_unicode", str, PACKAGE="stringi")
}
