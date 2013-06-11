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
#' Count the Number of Character Class Matches in a String
#' 
#' @description
#' ....
#' 
#' 
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' 
#' 
#' @param str character vector to search in
#' @param pattern character vector with character class identifiers, see \link{stringi-search-charclass}
#' @return integer vector
#' 
#' @examples
#' stri_count_charclass(c("stRRRingi","REXAMINE","123"), c("Ll", "Lu", "Zs"))
#' stri_count_charclass(" \t\n", "WHITE_SPACE")
#' stri_count_charclass(" \t\n", "Z") # whitespace - general category (note the difference)
#'
#' @export
#' @family search_count
#' @family search_charclass
stri_count_charclass <- function(str, pattern) {
   .Call("stri_count_charclass", str, pattern, PACKAGE="stringi")
}




#' @title
#' Count the Number of Fixed Pattern Matches in a String
#' 
#' @description
#' ....
#' 
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' If \str{pattern} is empty, then the result is \code{NA}.
#' 
#' See \link{stringi-search-fixed} for more details on
#' Locale-Sensitive Text Searching in \pkg{stringi}.
#' 
#' @param str character vector
#' @param pattern character vector
#' @param collator_opts a named R list as generated with \code{\link{stri_collator_genopts}}
#' with Collator's options, or \code{NA} for dummy byte comparison
#' @return integer vector, with number of matches for vectorized
#' search task
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_count_fixed(s, " ")
#' stri_count_fixed(s, "o")
#' stri_count_fixed(s, "it")
#' stri_count_fixed(s, letters)
#' stri_count_fixed("babab", "b")
#' stri_count_fixed(c("stringi w R","REXAMINE","123"), 'R')
#' 
#' @export
#' @family search_count
#' @family search_fixed
#' @family locale_sensitive
stri_count_fixed <- function(str, pattern, collator_opts=list()) {
	# prepare_arg done internally
	.Call("stri_count_fixed", str, pattern, collator_opts, PACKAGE="stringi")
}



#' @title
#' Count the Number of Regex Pattern Matches in a String
#' 
#' @description
#' ...
#' 
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' @return integer vector, with number of matches for vectorized
#' search task
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_count_regex(s,"(s|el)it")
#' stri_count_regex(s,"i.i")
#' stri_count_regex(s,".it")
#' stri_count_regex("bab baab baaab",c("b.*?b","b.b"))
#' stri_count_regex(c("stringi w R","REXAMINE","123"), '( R|RE)')
#' stri_count_regex(c("stringi w R","REXAMINE","123"), '(i|I|1)')
#' 
#' @export
#' @family search_count
#' @family search_regex
stri_count_regex <- function(str, pattern) {
   # prepare_arg done internally
   .Call("stri_count_regex", str, pattern, PACKAGE="stringi")
}



#' @title
#' Count the Number of Pattern Matches in a String
#' 
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_count_regex}},
#' \code{\link{stri_count_fixed}}, or \code{\link{stri_count_charclass}},
#' depending on the argument used.
#' 
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' @return logical vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_count(s, fixed=letters)
#' stri_count(s, regex="[[:alpha:]]")
#' 
#' @export
#' @family search_count
stri_count <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_count_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_count_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_count_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}

