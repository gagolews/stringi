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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.


#' @title
#' Split up Each String By Elements of Given Character Class
#' 
#' @description
#' Splits each element of \code{str} into substring.
#' The characters falling into \code{charclass} stand for splitting
#' boundaries.
#' 
#' @details
#' Vectorized over \code{str}, \code{pattern}, TODO..............
#' 
#' @param str character vector with strings to search in
#' @param pattern character vector with character class identifiers 
#' to search for, see \link{stringi-search-charclass}
#' @param XXX TODO............................... merge? n?
#' @return a list of character vectors
#' 
#' 
#' @examples
#' stri_split_charclass("Lorem ipsum dolor sit amet", "WHITE_SPACE")
#' 
#' @export
#' @rdname stri_split_charclass
#' @aliases stri_split_charclass
#' @family search_charclass
#' @family search_split
stri_split_charclass <- function(str, pattern) {
#    .Call("stri_split_charclass", str, pattern, PACKAGE="stringi")
}


#' @title
#' Split the elements of a character vector
#' 
#' @description
#' Split the elements of a character vector str into substrings. Vectorized over str, split and omitempty.
#' 
#' @details If \code{n} is non-positive then empty vector is returned.
#' 
#' @param str character vector to split
#' @param split character vector
#' @param n integer vector which contains maximum nuber of pieces to return. Default (\code{Inf})
#' @param omitempty omit every empty string?
#' @param exact logical vector 
#' @return A list of the same length as the longest of vectors: str, split and omitempty. Shorter vectors are recycled. The i-th element of list contains splitted str[i] character vectors
#' 
#' 
#' @seealso \link{stri_split_pos} to split string by positions.
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_split(s," ")
#' stri_split(s,"o")
#' stri_split(s,"it")
#' stri_split("babab","b",c(TRUE,FALSE))
#' stri_split("babab","b",-1:4)
#' 
#' @export
#' @rdname stri_split_fixed
#' @aliases stri_split_fixed
#' @family search_fixed
#' @family search_split
stri_split_fixed <- function(str, split='\n', n=Inf, omitempty=FALSE, exact=FALSE) {
# 	.Call("stri_split_fixed", str, split, n, omitempty, exact, PACKAGE="stringi")
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
#    if(is.matrix(from) && ncol(from) == 2){
#       if(!missing(to))
#          warning("'from' is matrix, so 'to' is ignored")
#       to   <- from[ , 2]
#       from <- from[ , 1]
#    }
#    .Call("stri_split_pos", str, from, to, PACKAGE="stringi")
}




# TO DO: convenience function
