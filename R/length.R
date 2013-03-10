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



#' Count the Number of Bytes
#' 
#' Missing values are handled properly.
#' 
#' @param str character vector, or a vector to be coerced to a character vector
#' @return an integer vector giving the sizes of each element 
#' @export
#' @seealso \code{\link{stri_length}}, \code{\link{stri_isempty}}, \code{\link{stri_width}}
stri_numbytes <- function(str) {
   .Call("stri_numbytes", str, PACKAGE="stringi")
}


#' Count the Number of Characters
#' 
#' Missing values are handled properly.
#' 
#' @param str character vector, or a vector to be coerced to a character vector
#' @return an integer vector giving the sizes of each element
#' @export
#' @seealso \code{\link{stri_numbytes}}, \code{\link{stri_isempty}}, \code{\link{stri_width}}
stri_length <- function(str) {
   .Call("stri_length", str, PACKAGE="stringi")
}


#' Determine if String is Empty
#' 
#' Missing values are handled properly.
#' This is a fast way to find out if elements of a character vector are empty strings.
#' 
#' @param str character vector, or a vector to be coerced to a character vector
#' @return a logical vector
#' @export
#' @seealso \code{\link{stri_length}}, \code{\link{stri_numbytes}}, \code{\link{stri_width}}
stri_isempty <- function(str) {
   .Call("stri_isempty", str, PACKAGE="stringi")
}



#' Count the Width of Characters
#' 
#' Missing values are handled properly.
#' This is equivalent to the number of columns the cat() function will use
#' to print the string in a monospaced font. 
#' 
#' @param str character vector, or a vector to be coerced to a character vector
#' @return an integer vector giving the sizes of each element
#' @export
#' @seealso \code{\link{stri_length}}, \code{\link{stri_isempty}}, \code{\link{stri_numbytes}}
stri_width <- function(str) {
   .Call("stri_width", str, PACKAGE="stringi")
}


