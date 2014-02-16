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
#' Extract Regex Pattern Matches, Together with Capture Groups
#'
#' @description
#' These functions extract substrings of \code{str} that
#' match a given \code{pattern}, and also give matches for capture
#' groups, i.e. subpatterns given in round parentheses.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions to search for
#' @param opts_regex a named list as generated with \code{\link{stri_opts_regex}}
#'
#' @return
#' For \code{stri_match_all_regex},
#' a list of character matrices is returned.
#' Otherwise, a character matrix is given.
#' \code{NA} if not found or if given capture group is unavailable.
#'
#' The first column gives the whole match. The second one corresponds to
#' the first capture group, the third -- the second capture group, and so on.
#'
#'
#' @export
#' @rdname stri_match_regex
#' @aliases stri_match_all_regex stri_match_first_regex stri_match_last_regex
#' @family search_regex
#' @family search_match
stri_match_all_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_match_all_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_match_regex
stri_match_first_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_match_first_regex", str, pattern, opts_regex, PACKAGE="stringi")
}



#' @export
#' @rdname stri_match_regex
stri_match_last_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_match_last_regex", str, pattern, opts_regex, PACKAGE="stringi")
}



#' @title
#' Extract All Regex Pattern Matches, Together with Capture Groups
#'
#' @description
#' A dummy function for compatibility with other search routines
#' in \pkg{stringi}.
#' Calls \code{\link{stri_match_all_regex}}.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying function
#' @param regex character vector of regular expressions to search for
#'
#' @return list of character matrices
#'
#' @export
#' @family search_match
stri_match_all <- function(str, ..., regex) {
   if (!missing(regex))
      stri_match_all_regex(str, regex, ...)
   else
      stop("you have to specify `regex`")
}



#' @title
#' Extract First Regex Pattern Matches, Together with Capture Groups
#'
#' @description
#' A dummy function for compatibility with other search routines
#' in \pkg{stringi}.
#' Calls \code{\link{stri_match_first_regex}}.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying function
#' @param regex character vector of regular expressions to search for
#'
#' @return character matrix
#'
#' @export
#' @family search_match
stri_match_first <- function(str, ..., regex) {
   if (!missing(regex))
      stri_match_first_regex(str, regex, ...)
   else
      stop("you have to specify `regex`")
}



#' @title
#' Extract Last Regex Pattern Matches, Together with Capture Groups
#'
#' @description
#' A dummy function for compatibility with other search routines
#' in \pkg{stringi}.
#' Calls \code{\link{stri_match_last_regex}}.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying function
#' @param regex character vector of regular expressions to search for
#'
#' @return character matrix
#'
#'
#' @export
#' @family search_match
stri_match_last <- function(str, ..., regex) {
   if (!missing(regex))
      stri_match_last_regex(str, regex, ...)
   else
      stop("you have to specify `regex`")
}



#' @title
#' Extract Regex Pattern Matches, Together with Capture Groups
#'
#' @description
#' A dummy function for compatibility with other search routines
#' in \pkg{stringi}.
#' Calls either \code{\link{stri_match_all}},
#' \code{\link{stri_match_first}}, or \code{\link{stri_match_last}},
#' depending on the argument used.
#' Note that this is slower than the direct call.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regular expressions to search for
#' @param mode single string; whether to look for all, or only the first/last
#'             occurrence of the pattern
#'
#' @return same as the underlying functions called, i.e.
#' a character matrix or a list of character matrices.
#'
#'
#' @export
#' @family search_match
stri_match <- function(str, ..., regex,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
          first=stri_match_first(str, ..., regex=regex),
          last =stri_match_last(str, ..., regex=regex),
          all  =stri_match_all(str, ..., regex=regex)
   )
}
