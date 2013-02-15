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



#' Split the elements of a character vector
#' 
#' Split the elements of a character vector str into substrings. Vectorized over str, split and omitempty.
#' 
#' @param str character vector to split
#' @param split character vector
#' @param omitempty omit every empty string?
#' @return A list of the same length as the longest of vectors: str, split and omitempty. Shorter vectors are recycled. The i-th element of list contains splitted str[i] character vectors
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_split(s," ")
#' stri_split(s,"o")
#' stri_split(s,"it")
#' stri_split("babab","b",c(TRUE,FALSE))
#' 
#' @export
stri_split <- function(str, split='\n', omitempty=FALSE) {
	# prepare_arg done internally
	.Call("stri_split_fixed", str, split, omitempty, PACKAGE="stringi")
}

# TODO
# correct :
# stri_split("ala","") != strsplit("ala","")
#
# determine: which result is better?
# strsplit("lalal","l") or stri_split("lalal","l")
# 

#' Split the elements of a character vector by position
#' 
#' 
#' @param str character vector to split
#' @param split character element
#' @param from integer vector
#' @param to integer vector
#' @return A list of the same length as the longest of vectors: str, split and omitempty. Shorter vectors are recycled. The i-th element of list contains splitted str[i] character vectors
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_split_pos(s,c(1,4),c(3,6))
#' 
#' @export
stri_split_pos <- function(str, from, to) {
   # prepare_arg done internally
   .Call("stri_split_pos", str, from, to, PACKAGE="stringi")
}
