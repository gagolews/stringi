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


#' Detect a Character Class Match in a String
#' 
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' 
#' @param str character vector to search in
#' @param pattern character vector with character class identifiers, see !!TODO!!
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


#' Detect a Fixed Pattern Match in a String
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
#' @family search_detect
#' @family search_fixed
#' @family locale_sensitive
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
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '( R|RE)')
#' @export
#' @family search_detect
#' @family search_regex
stri_detect_regex <- function(str, pattern) {
   .Call("stri_detect_regex", str, pattern, PACKAGE="stringi")
}


#' Detect a Pattern Match in a String
#' 
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

