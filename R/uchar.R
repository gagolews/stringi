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



#' Get character types
#'
#' Returns the general category value for each *code point* in each string
#' Same as java.lang.Character.getType()
#' @param s character vector
#' @return list of numeric vectors
#' @export
stri_chartype <- function(s) {
   .Call("stri_chartype", s, PACKAGE="stringi")
}

#' Get character names
#'
#' Returns the "modern" names of each character in each string
#' @param s character vector
#' @return list of character vectors
#' @export
stri_charname <- function(s) {
   .Call("stri_charname", s, PACKAGE="stringi")
}
