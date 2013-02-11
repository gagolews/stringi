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



#' Extract substrings from a character vector
#' 
#' Vectorized over s, from and (to or length).
#' 
#' @param str character vector 
#' @param from
#' @param to
#' @param length
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_sub(s,1:3,11:13)
#' stri_sub(s,"o")
#' 
#' @export
stri_sub <- function(str, from = 1L, to, length) {
	# prepare_arg done internally
   # TODO:
   #if missing to or length do some magic and call:
	.Call("stri_sub", str, from, to, PACKAGE="stringi")
}

