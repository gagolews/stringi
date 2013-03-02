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



#' Reverse string
#' 
#' @param str
#' 
#' @return character vector
#' @examples
#' stri_reverse("123","abc d e f") 
#' 
#' @export
stri_reverse <- function(str) {
   # prepare_arg done internally
   .Call("stri_reverse", str, PACKAGE="stringi")
}

