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
#' stri_count_fixed(s," ")
#' stri_count_fixed(s,"o")
#' stri_count_fixed(s,"it")
#' stri_count_fixed("babab","b")
#' 
#' @export
stri_count_fixed <- function(str, pattern) {
	# prepare_arg done internally
	.Call("stri_count_fixed", str, pattern, PACKAGE="stringi")
}

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
#' stri_count_regex(s,"(s|el)it")
#' stri_count_regex(s,"i.i")
#' stri_count_regex(s,".it")
#' stri_count_regex("bab baab baaab",c("b.*?b","b.b"))
#' 
#' @export
stri_count_regex <- function(str, pattern) {
   # prepare_arg done internally
   .Call("stri_count_regex", str, pattern, PACKAGE="stringi")
}
