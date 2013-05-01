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


#' Detect a Character Class in a String
#' 
#' Vectorized over \code{str} and \code{class}.
#' 
#' @param str character vector
#' @param class character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' @export
stri_detect_class <- function(str, class) {
   .Call("stri_detect_class", str, class, PACKAGE="stringi")
}


#' Detect a Pattern Match in a String
#' 
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector
#' @param pattern character vector 
#' @export
stri_detect_fixed <- function(str, pattern) {
   .Call("stri_detect_fixed", str, pattern, PACKAGE="stringi")
}


#' Detect a Regex Pattern Match in a String
#' 
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' @export
#' @family regex
stri_detect_regex <- function(str, pattern) {
   .Call("stri_detect_regex", str, pattern, PACKAGE="stringi")
}


#' Detect a Pattern Match in a String
#' 
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' @export
#' @family search
stri_detect <- function(str, regex, fixed, charclass) {
   if(!missing(regex))
      .Call("stri_detect_regex", str, regex, PACKAGE="stringi")
   else if(!missing(fixed))
      .Call("stri_detect_fixed", str, fixed, PACKAGE="stringi")
   else if(!missing(charclass))
      .Call("stri_detect_class", str, charclass, PACKAGE="stringi")
   else
      error("You have specify at least one of regex, fixed and charclass")
   
}

