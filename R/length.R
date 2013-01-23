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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' ???
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_numbytes <- function(str) {
   # prepare_arg done internally
   .Call("stri_numbytes", str, PACKAGE="stringi")
}


#' The number of characters in a string
#' 
#' @param str character vector
#' @return integer vector giving the number of characters in each element of character vector
#' @export
stri_length <- function(str) {
   .Call("stri_length", str, PACKAGE="stringi")
}
