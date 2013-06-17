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


#' @title
#' Detect a Character Class Match in a String
#' 
#' @description
#' ....
#' 
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' 
#' @param str character vector to search in
#' @param pattern character vector with character class identifiers, see \link{stringi-search-charclass}
#' @return logical vector
#' 
#' @examples
#' stri_detect_charclass(c("stRRRingi","REXAMINE","123"), c("Ll", "Lu", "Zs"))
#' 
#' @export
#' @family search_detect
#' @family search_charclass
stri_detect_charclass <- function(str, pattern) {
   .Call("stri_detect_charclass", str, pattern, PACKAGE="stringi")
}


#' @title
#' Detect a Fixed Pattern Match in a String
#' 
#' @description
#' ...
#' 
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' See \link{stringi-search-fixed} for more details on
#' Locale-Sensitive Text Searching in \pkg{stringi}.
#' 
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#' 
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named R list as generated with \code{\link{stri_opts_collator}}
#' with Collator's options, or \code{NA} for dummy byte comparison
#' 
#' @return logical vector 
#' @examples
#' stri_detect_fixed(c("stringi w R","REXAMINE","123"), c('i','R','0'), opts_collator=NA)
#' stri_detect_fixed(c("stringi w R","REXAMINE","123"), 'R', opts_collator=NA)
#' @export
#' 
#' @family search_detect
#' @family search_fixed
#' @family locale_sensitive
stri_detect_fixed <- function(str, pattern, opts_collator=list()) {
   .Call("stri_detect_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @title
#' Detect a Regex Pattern Match in a String
#' 
#' @description
#' ...
#' 
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' 
#' @return logical vector
#' @examples
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), 'R.')
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '[[:alpha:]]*?')
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '[a-zC1]')
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '( R|RE)')
#' @export
#' @family search_detect
#' @family search_regex
stri_detect_regex <- function(str, pattern) {
   .Call("stri_detect_regex", str, pattern, PACKAGE="stringi")
}


#' @title
#' Detect a Pattern Match in a String
#' 
#' @details
#' A convenience function.
#' Calls either \code{\link{stri_detect_regex}},
#' \code{\link{stri_detect_fixed}}, or \code{\link{stri_detect_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' @return logical vector
#' 
#' @export
#' @family search_detect
stri_detect <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_detect_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_detect_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_detect_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}

