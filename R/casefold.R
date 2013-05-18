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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.


#' Translate String to lowercase
#' 
#' @param str character vector on which casefolding is applied
#' @return character vector
#' 
#' @export
#' @family casefold
stri_tolower <- function(str) {
   .Call("stri_casefold", str, 1L, PACKAGE="stringi")
}


#' Translate String to UPPERCASE
#' 
#' @param str character vector on which casefolding is applied
#' @return character vector
#' 
#' @export
#' @family casefold
stri_toupper <- function(str) {
   .Call("stri_casefold", str, 2L, PACKAGE="stringi")
}


#' Translate String to TitleCase
#' 
#' @param str character vector on which casefolding is applied
#' @return character vector
#' 
#' @export
#' @family casefold
stri_totitle <- function(str) {
   .Call("stri_casefold", str, 3L, PACKAGE="stringi")
}
