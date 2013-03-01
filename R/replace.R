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


#' Replace first
#' 
#' 
#' @param str character vector
#' @param pattern character vector
#' @param replacement 
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_first(s," ","123")
#' stri_replace_first(s,"o","!!!")
#' 
#' @export
stri_replace_first <- function(str, pattern, replacement) {
   # prepare_arg done internally
   .Call("stri_replace_first_fixed", str, pattern, replacement, PACKAGE="stringi")
}


#' Replace all
#' 
#' 
#' @param str character vector
#' @param pattern character vector
#' @param replacement 
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all(s," ","#")
#' stri_replace_all(s,"o","0")
#' 
#' @export
stri_replace_all <- function(str, pattern, replacement) {
	# prepare_arg done internally
	.Call("stri_replace_all_fixed", str, pattern, replacement, PACKAGE="stringi")
}

