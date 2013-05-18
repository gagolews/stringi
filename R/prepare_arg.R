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



#' Passing Arguments to Functions in \pkg{stringi}
#'
#' Some notes:
#' * How do we treat character vectors on input? What objects are automatically coerced?
#' * Do we treat NA values consistently? Yes.
#' * Do we preserve objects' attributes? No.
#' 
#' When character vector argument is expected: factors and other coercible vectors
#' are converted with \code{as.character(...)}, otherwise an error is generated.
#' 
#' When logical, numeric or integer vector argument is expected:
#' factors are converted with \code{as.*(as.character(...))} and other coercible vectors
#' are converted with \code{as.character()}, otherwise an error is generated.
#' 
#' @name stringi_arguments
#' @family prepare_arg
NULL


#' Prepare a string argument (Internal method)
#' 
#' @param x argument to be checked
#' @return if x is a string, it is returned with no change.
#' if factor, as.character is called.
#' if atomic vector (also a matrix), it is coerced to character vector.
#' if name, a single string is generated.
#' otherwise the function throws an error.
#' 
#' @family prepare_arg
stri_prepare_arg_string <- function(x) {
   .Call("stri_prepare_arg_string", x, PACKAGE="stringi")  
}


#' Prepare a numeric argument (Internal method)
#' 
#' @param x argument to be checked
#' @return if x is a factor, as.character is called.
#' if a double, it is returned with no change.
#' if atomic vector (also a matrix), it is coerced to double vector.
#' otherwise the function throws an error.
#' 
#' @family prepare_arg
stri_prepare_arg_double <- function(x) {
   .Call("stri_prepare_arg_double", x, PACKAGE="stringi")  
}


#' Prepare an integer argument (Internal method)
#' 
#' @param x argument to be checked
#' @return if x is a factor, as.character is called.
#' if an integer, it is returned with no change.
#' if atomic vector (also a matrix), it is coerced to integer vector.
#' otherwise the function throws an error.
#' 
#' @family prepare_arg
stri_prepare_arg_integer <- function(x) {
   .Call("stri_prepare_arg_integer", x, PACKAGE="stringi")  
}



#' Prepare a logical argument (Internal method)
#' 
#' @param x argument to be checked
#' @return if x is a logical, it is returned with no change.
#' if factor, as.character is called.
#' if atomic vector (also a matrix), it is coerced to logical vector.
#' otherwise the function throws an error.
#' 
#' @family prepare_arg
stri_prepare_arg_logical <- function(x) {
   .Call("stri_prepare_arg_logical", x, PACKAGE="stringi")  
}
