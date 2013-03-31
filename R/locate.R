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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.


#' Locate All Occurences of a Character Class
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param class character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#'    
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Consecutive sequences of characters from a class are merged.
#' \code{NA}s for no match.
#' 
#' @export
#' @family charclass
stri_locate_all_class <- function(str, class) {
   .Call("stri_locate_all_class", str, class, PACKAGE="stringi")
}


#' Locate First Occurence of a Character Class
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param class character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#'    
#' @return Integer vector of length n, where n is the length of \code{str}.
#' \code{NA} iff not found.
#' The returned indices are Unicode-code point-based
#' 
#' @export
#' @family charclass
stri_locate_first_class <- function(str, class) {
   .Call("stri_locate_first_or_last_class", str, class, TRUE, PACKAGE="stringi")
}


#' Locate Last Occurence of a Character Class
#'
#' Vectorized over s and class
#' @param str character vector of strings to search in
#' @param class character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' 
#' @return Integer vector of length n, where n is the length of \code{str}.
#' \code{NA} iff not found.
#' The returned indices are Unicode-code point-based
#' 
#' @export
#' @family charclass
stri_locate_last_class <- function(str, class) {
   .Call("stri_locate_first_or_last_class", str, class, FALSE, PACKAGE="stringi")
}


#' Locate all occurences of each character pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector
#' @param pattern character vector
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Consecutive sequences of characters from a pattern are merged.
#' NAs for no match.
#' @seealso \code{\link{stri_locate_first_fixed}}, \code{\link{stri_locate_last_fixed}}
#' @export
stri_locate_all_fixed <- function(str, pattern) {
   .Call("stri_locate_all_fixed", str, pattern, PACKAGE="stringi")
}


#' Locate first occurence of character pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector
#' @param pattern character vector
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Consecutive sequences of characters from a pattern are merged.
#' NAs for no match.
#' @seealso \code{\link{stri_locate_all_fixed}}, \code{\link{stri_locate_last_fixed}}
#' @export
stri_locate_first_fixed <- function(str, pattern) {
   .Call("stri_locate_first_or_last_fixed", str, pattern, TRUE, PACKAGE="stringi")
}


#' Locate last occurence of character pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector
#' @param pattern character vector
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Consecutive sequences of characters from a pattern are merged.
#' NAs for no match.
#' @seealso \code{\link{stri_locate_all_fixed}}, \code{\link{stri_locate_first_fixed}}
#' @export
stri_locate_last_fixed <- function(str, pattern) {
   .Call("stri_locate_first_or_last_fixed", str, pattern, FALSE, PACKAGE="stringi")
}


#' Locate All Occurences of a Regex Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' 
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Consecutive sequences of characters from a pattern are merged.
#' NAs for no match.
#' @seealso \code{\link{stri_locate_first_regex}}, \code{\link{stri_locate_last_regex}}
#' @export
#' @family regex
stri_locate_all_regex <- function(str, pattern) {
   .Call("stri_locate_all_regex", str, pattern, PACKAGE="stringi")
}


#' Locate First Occurence of A Regex Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' 
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Consecutive sequences of characters from a pattern are merged.
#' NAs for no match.
#' @seealso \code{\link{stri_locate_all_regex}}, \code{\link{stri_locate_last_regex}}
#' @export
#' @family regex
stri_locate_first_regex <- function(str, pattern) {
   .Call("stri_locate_first_regex", str, pattern, PACKAGE="stringi")
}

