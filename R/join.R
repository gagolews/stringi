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




#' Duplicate Strings
#'
#' @param str character vector of strings to be duplicated
#' @param times integer vector with number of times to duplicate each string
#' @return character vector
#' 
#' @export
#' @family paste
#' @examples
#' stri_dup("a", 1:5)
#' stri_dup(c("a", NA, "ba"), 4)
#' stri_dup(c("abc", "pqrst"), c(4, 2))
stri_dup <- function(str, times) {
   # prepare_arg done internally
   .Call("stri_dup", str, times, PACKAGE="stringi")
}



#' Join two character vectors
#' 
#' This is ca. 1.5x faster than \code{paste(e1, e2, sep="")}
#' However, joining 3 vectors, e.g. \code{e1 \%+\% e2 \%+\% e3}
#' is slower than \code{paste(e1, e2, e3, sep="")}, 
#' because it creates a new result each time
#' 
#' @param e1 character vector
#' @param e2 character vector
#' 
#' @TODO add family `paste` (now roxygen is broken)
#' @rdname oper_plus
#' @export
"%+%" <- function(e1, e2) {
   # prepare_arg done internally
   .Call("stri_join2", e1, e2, PACKAGE="stringi")
}


#' Join character vectors
#' 
#' 
#' 
#' @param sep separator
#' @param collapse collapse
#' 
#' @export
#' @family paste
stri_join <- function(..., sep="", collapse=NULL) {
   .Call("stri_join", list(...), PACKAGE="stringi")
}

# TO DO: stri_join alias stri_c - like paste(...)



#' Flatten a string
#' 
#' Joins each element of a character vector into one string;
#' this works like \code{paste(str, collapse="", sep="")}, but ca. 3x faster
#' 
#' @param str will be coerced to character
#' @param sep separator
#' 
#' @export
#' @family paste
stri_flatten <- function(str, sep="") {
   # prepare_arg done internally
   .Call("stri_flatten", str, sep, PACKAGE="stringi")
}


