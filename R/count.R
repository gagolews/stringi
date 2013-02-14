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



#' Count the number of matches in a string
#' 
#' Vectorized over str and pattern.
#' 
#' @param str character vector
#' @param pattern character vector
#' @return integer vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_count(s," ")
#' stri_count(s,"o")
#' stri_count(s,"it")
#' stri_count("babab","b")
#' 
#' @export
stri_count <- function(str, pattern) {
	# prepare_arg done internally
	.Call("stri_count_fixed", str, pattern, PACKAGE="stringi")
}
