## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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


#' Locate all occurences of each character class
#'
#' Vectorized over s and class
#' @param s character vector
#' @param class General Category or Binary Property identifier, integer vector
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Consecutive sequences of characters from a class are merged.
#' @seealso \code{\link{stri_char_getpropertyid}}, \code{\link{stri_char_getcategoryid}}
#' @export
stri_locate_all_class <- function(s, class) {
   .Call("stri_locate_all_class", s, class, PACKAGE="stringi")
}


#' Locate the first occurence of each character class
#'
#' Vectorized over s and class
#' @param s character vector
#' @param class General Category or Binary Property identifier, integer vector
#' @return Integer vector of length n, where n is the length of s. NA iff not found.
#' The returned indices are Unicode-code point-based
#' @seealso \code{\link{stri_char_getpropertyid}}, \code{\link{stri_char_getcategoryid}}
#' @export
stri_locate_first_class <- function(s, class) {
   .Call("stri_locate_first_or_last_class", s, class, TRUE, PACKAGE="stringi")
}


#' Locate the lase occurence of each character class
#'
#' Vectorized over s and class
#' @param s character vector
#' @param class General Category or Binary Property identifier, integer vector
#' @return Integer vector of length n, where n is the length of s. NA iff not found.
#' The returned indices are Unicode-code point-based
#' @seealso \code{\link{stri_char_getpropertyid}}, \code{\link{stri_char_getcategoryid}}
#' @export
stri_locate_last_class <- function(s, class) {
   .Call("stri_locate_first_or_last_class", s, class, FALSE, PACKAGE="stringi")
}

