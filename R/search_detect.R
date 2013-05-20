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
#' 
#' @param str character vector
#' @param class character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' @return logical vector
#' @examples
#' stri_detect_class(c("stringi w R","REXAMINE","123"),stri_char_getcategoryid("Ll"))
#' stri_detect_class(c("stringi w R","REXAMINE","123"),stri_char_getcategoryid("Lu"))
#' stri_detect_class(c("stringi w R","REXAMINE","123"),stri_char_getcategoryid("Zs"))
#' 
#' @export
#' @family detect, search
stri_detect_class <- function(str, class) {
   .Call("stri_detect_class", str, class, PACKAGE="stringi")
}


#' Detect a Pattern Match in a String
#' 
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' For more information on ICU's Collator & SearchEngine
#' and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_collator_genopts}}.
#' 
#' If \code{collator_opts} is \code{NA}, then a very fast (for small p)
#' bytewise (locale independent) search is performed, with time complexity of
#' O(n*p) (\code{n == length(str)}, \code{p == length(pattern)}).
#' For natural language, non-English text this is, however, not what
#' you probably want.
#' 
#' Otherwise, ICU's implementation of Boyer Moore's search is used, 
#' with time complexity of O(n+p), see \code{\link{stri_collator_genopts}}
#' for more details.
#' 
#' @param str character vector
#' @param pattern character vector
#' @param collator_opts a named R list as generated with \code{\link{stri_collator_genopts}}
#' with Collator's options, or \code{NA} for dummy byte comparison
#' 
#' @return logical vector 
#' @examples
#' stri_detect_fixed(c("stringi w R","REXAMINE","123"), c('i','R','0'), collator_opts=NA)
#' stri_detect_fixed(c("stringi w R","REXAMINE","123"), 'R', collator_opts=NA)
#' @export
#' 
#' @family detect, search, locale_dependent
stri_detect_fixed <- function(str, pattern, collator_opts=list()) {
   .Call("stri_detect_fixed", str, pattern, collator_opts, PACKAGE="stringi")
}


#' Detect a Regex Pattern Match in a String
#' 
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' 
#' @return logical vector
#' @examples
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), 'R.')
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '[[:alpha:]]*?')
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '[a-zC1]')
#' @export
#' @family detect, search, regex
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
#' @return logical vector
#' 
#' @export
#' @family detect, search
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

