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
#' See the man page links below for the description of internal methods used
#' in all functions from the \pkg{stringi} package (just to get more insight,
#' in case you're interested in details).
#' 
#' When character vector argument is expected: factors and other coercible vectors
#' are converted with \code{as.character(...)}, otherwise an error is generated.
#' 
#' When logical, numeric or integer vector argument is expected:
#' factors are converted with \code{as.*(as.character(...))} and other coercible vectors
#' are converted with \code{as.character()}, otherwise an error is generated.
#' 
#' Some functions (like \code{\link{stri_join}}
#' assume that a vector with one element is given;
#' in that case, for empty vectors we get an error and for vectors with > 1
#' elements - a warning....
#' 
#' @name stringi-arguments
#' @family stringi_general_topics
#' @family prepare_arg
invisible(NULL)


#' Prepare a String Vector Argument (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
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
   .Call("stri_prepare_arg_string", x, NULL, PACKAGE="stringi")  
}


#' Prepare a Numeric Vector Argument (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
#' 
#' @param x argument to be checked
#' @return if x is a factor, as.character is called + coercion to numeric.
#' if a double, it is returned with no change.
#' if atomic vector (also a matrix), it is coerced to double vector.
#' otherwise the function throws an error.
#' 
#' @family prepare_arg
stri_prepare_arg_double <- function(x) {
   .Call("stri_prepare_arg_double", x, NULL, PACKAGE="stringi")  
}


#' Prepare an Integer Vector Argument (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
#' 
#' @param x argument to be checked
#' @return if x is a factor, as.character is called + coercion to integer.
#' if an integer, it is returned with no change.
#' if atomic vector (also a matrix), it is coerced to integer vector.
#' otherwise the function throws an error.
#' 
#' @family prepare_arg
stri_prepare_arg_integer <- function(x) {
   .Call("stri_prepare_arg_integer", x, NULL, PACKAGE="stringi")  
}



#' Prepare a Logical Vector Argument (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
#' 
#' @param x argument to be checked
#' @return if x is a logical vector, it is returned with no change.
#' if factor, as.character is called + coercion to logical.
#' if atomic vector (also a matrix), it is coerced to logical vector.
#' otherwise the function throws an error.
#' 
#' @family prepare_arg
stri_prepare_arg_logical <- function(x) {
   .Call("stri_prepare_arg_logical", x, NULL, PACKAGE="stringi")  
}


#' Prepare a Raw Vector Argument (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
#' 
#' @param x argument to be checked
#' @return if x is a raw vector, it is returned with no change.
#' if factor, as.character is called + coercion to raw.
#' if atomic vector (also a matrix), it is coerced to a raw vector.
#' otherwise the function throws an error.
#' 
#' @family prepare_arg
stri_prepare_arg_raw <- function(x) {
   .Call("stri_prepare_arg_raw", x, NULL, PACKAGE="stringi")  
}



#' Prepare a String Vector Argument [Single Value] (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
#' 
#' @param x argument to be checked
#' @return 
#' first \code{\link{stri_prepare_arg_string}} is called;
#' on empty vector, an error is generated;
#' if there are are > 1 elems, a warning is generated;
#' a vector with one (the first in \code{x}) is returned
#' 
#' @family prepare_arg
stri_prepare_arg_string_1 <- function(x) {
   .Call("stri_prepare_arg_string_1", x, NULL, PACKAGE="stringi")  
}


#' Prepare a Numeric Vector Argument [Single Value] (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
#' 
#' @param x argument to be checked
#' @return
#' first \code{\link{stri_prepare_arg_double}} is called;
#' on empty vector, an error is generated;
#' if there are are > 1 elems, a warning is generated;
#' a vector with one (the first in \code{x}) is returned
#' 
#' @family prepare_arg
stri_prepare_arg_double_1 <- function(x) {
   .Call("stri_prepare_arg_double_1", x, NULL, PACKAGE="stringi")  
}


#' Prepare an Integer Vector Argument [Single Value] (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
#' 
#' @param x argument to be checked
#' @return
#' first \code{\link{stri_prepare_arg_integer}} is called;
#' on empty vector, an error is generated;
#' if there are are > 1 elems, a warning is generated;
#' a vector with one (the first in \code{x}) is returned
#' 
#' @family prepare_arg
stri_prepare_arg_integer_1 <- function(x) {
   .Call("stri_prepare_arg_integer_1", x, NULL, PACKAGE="stringi")  
}



#' Prepare a Logical Vector Argument [Single Value] (Internal Method)
#' 
#' This is an internal function. However, the interested user may play with it
#' in order to get more insight on how \pkg{stringi} deals with its
#' functions' arguments.
#' 
#' @param x argument to be checked
#' @return 
#' first \code{\link{stri_prepare_arg_logical}} is called;
#' on empty vector, an error is generated;
#' if there are are > 1 elems, a warning is generated;
#' a vector with one (the first in \code{x}) is returned
#' 
#' @family prepare_arg
stri_prepare_arg_logical_1 <- function(x) {
   .Call("stri_prepare_arg_logical_1", x, NULL, PACKAGE="stringi")  
}

