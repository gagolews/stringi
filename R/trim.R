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
#' Trim whitespaces from strings
#' 
#' @param str character vector
#' @return character vector
#' 
#' @family search_trim
#' @family search_charclass
#' @export
stri_trim <- function(str) {
   .Call("stri_trim", str, PACKAGE="stringi")
}


#' @title
#' Trim whitespaces from left side of strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' 
#' @family search_trim
#' @family search_charclass
#' @export
stri_ltrim <- function(str) {
  .Call("stri_ltrim", str, PACKAGE="stringi")
}


#' @title
#' Trim whitespaces from right side of strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' 
#' @family search_trim
#' @family search_charclass
#' @export
stri_rtrim <- function(str) {
  .Call("stri_rtrim", str, PACKAGE="stringi")
}


#' @title
#' Trim all unnecessary double whitespaces from string
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' 
#' @family search_trim
#' @family search_charclass
#' @export
stri_trim_all <- function(str) {
   # prepare_arg done internally
   .Call("stri_trim_all", str, PACKAGE="stringi")
}


