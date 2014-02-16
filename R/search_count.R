## This file is part of the 'stringi' library.
##
## Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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
#' Count the Number of Character Class Matches
#'
#' @description
#' This function counts the number of characters that falls into a given
#' character class (e.g. letters, digits, or white spaces).
#'
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#'
#'
#' @param str character vector to search in
#' @param pattern character vector; identifiers of character classes,
#' see \link{stringi-search-charclass}
#' @return Returns an integer vector.
#'
#' @examples
#' stri_count_charclass(c("stRRRingi","REXAMINE","123"), c("Ll", "Lu", "Zs"))
#' stri_count_charclass(" \t\n", "WHITE_SPACE") # white space - binary property
#' stri_count_charclass(" \t\n", "Z") # whitespace - general category (note the difference)
#'
#' @export
#' @family search_count
#' @family search_charclass
stri_count_charclass <- function(str, pattern) {
   .Call("stri_count_charclass", str, pattern, PACKAGE="stringi")
}




#' @title
#' Count the Number of Fixed Pattern Matches
#'
#' @description
#' This function counts the number of occurrences of a fixed pattern in a string.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' See \link{stringi-search-fixed} for more details on
#' Locale-Sensitive Text Searching in \pkg{stringi}.
#'
#' Pass \code{opts_collator} equal to \code{NA} for much faster, but
#' locale unaware, (exact) byte comparisons. For natural language text
#' this may be not what you really want.
#'
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named list as generated with \code{\link{stri_opts_collator}}
#' with Collator options, or \code{NA} for fast but locale-unaware byte comparison
#'
#' @return Returns an integer vector with the number of matches.
#'
#' @examples
#' \dontrun{
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_count_fixed(s, " ")
#' stri_count_fixed(s, "o")
#' stri_count_fixed(s, "it")
#' stri_count_fixed(s, letters)
#' stri_count_fixed("babab", "b")
#' stri_count_fixed(c("stringi w R","REXAMINE","123"), 'R')
#' }
#' 
#' @export
#' @family search_count
#' @family search_fixed
#' @family locale_sensitive
stri_count_fixed <- function(str, pattern, opts_collator=list()) {
   # prepare_arg done internally
   .Call("stri_count_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}



#' @title
#' Count the Number of Regex Pattern Matches
#'
#' @description
#' This function counts the number of occurrences of matches to a regex pattern.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions
#' @param opts_regex a named list as generated with \code{\link{stri_opts_regex}}
#' @return Returns an integer vector.
#'
#' @examples
#' \dontrun{
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_count_regex(s,"(s|el)it")
#' stri_count_regex(s,"i.i")
#' stri_count_regex(s,".it")
#' stri_count_regex("bab baab baaab",c("b.*?b","b.b"))
#' stri_count_regex(c("stringi w R","REXAMINE","123"), '( R|RE)')
#' stri_count_regex(c("stringi w R","REXAMINE","123"), '(i|I|1)')
#' }
#' 
#' @export
#' @family search_count
#' @family search_regex
stri_count_regex <- function(str, pattern, opts_regex=list()) {
   # prepare_arg done internally
   .Call("stri_count_regex", str, pattern, opts_regex, PACKAGE="stringi")
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
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns an integer vector.
#'
#' @examples
#' \dontrun{
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_count(s, fixed=letters)
#' stri_count(s, regex="[[:alpha:]]")
#' }
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
