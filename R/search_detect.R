## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#' @title
#' Detect a Character Class Match
#'
#' @description
#' This function checks if any character matches a falls into a given character
#' class (e.g. letters, digits, or white spaces).
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#'
#' @param str character vector to search in
#' @param pattern character vector; identifiers of character classes,
#' see \link{stringi-search-charclass}
#' @return Returns a logical vector.
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
#' Detect a Fixed Pattern Match
#'
#' @description
#' This function checks if there is at least one occurrence of a fixed pattern
#' in a string.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' See \link{stringi-search-fixed} for more details on
#' locale-sensitive text searching in \pkg{stringi}.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
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
#' @return Returns a logical vector.
#'
#' @examples
#' \dontrun{
#' stri_detect_fixed(c("stringi w R","REXAMINE","123"), c('i','R','0'), opts_collator=NA)
#' stri_detect_fixed(c("stringi w R","REXAMINE","123"), 'R', opts_collator=NA)
#' }
#'
#' @export
#' @family search_detect
#' @family search_fixed
#' @family locale_sensitive
stri_detect_fixed <- function(str, pattern, opts_collator=list()) {
   .Call("stri_detect_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @title
#' Detect a Regex Pattern Match
#'
#' @description
#' This function checks if there is at least one match to a regex pattern
#' in a string.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' Vectorized over \code{str} and \code{pattern}.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions
#' @param opts_regex a named list as generated with \code{\link{stri_opts_regex}}
#'
#' @return Returns a logical vector.
#'
#' @examples
#' \dontrun{
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), 'R.')
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '[[:alpha:]]*?')
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '[a-zC1]')
#' stri_detect_regex(c("stringi w R","REXAMINE","123"), '( R|RE)')
#' stri_detect_regex("stringi", "STRING.", opts_regex=stri_opts_regex(case_insensitive=TRUE))
#' }
#'
#' @export
#' @family search_detect
#' @family search_regex
stri_detect_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_detect_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @title
#' Detect a Pattern Match
#'
#' @details
#' A convenience function.
#' Calls either \code{\link{stri_detect_regex}},
#' \code{\link{stri_detect_fixed}}, or \code{\link{stri_detect_charclass}},
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
#' @return Returns a logical vector.
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
