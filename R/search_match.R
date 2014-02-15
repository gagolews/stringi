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
