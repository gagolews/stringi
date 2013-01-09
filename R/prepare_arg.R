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



#' Prepare a string argument (Internal method)
#' 
#' @param x argument to be checked
#' @return if x is a string, it is returned with no change.
#' if factor, as.character is called.
#' if atomic vector (also a matrix), it is coerced to character vector.
#' if name, a single string is generated.
#' otherwise the function throws an error.
stri_prepare_arg_string <- function(x) {
   .Call("stri_prepare_arg_string", x, PACKAGE="stringi")  
}


#' Prepare an integer argument (Internal method)
#' 
#' @param x argument to be checked
#' @return if x is an integer, it is returned with no change.
#' if factor, as.character is called.
#' if atomic vector (also a matrix), it is coerced to integer vector.
#' otherwise the function throws an error.
stri_prepare_arg_integer <- function(x) {
   .Call("stri_prepare_arg_integer", x, PACKAGE="stringi")  
}
