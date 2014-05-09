## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice,
## this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
## this list of conditions and the following disclaimer in the documentation
## and/or other materials provided with the distribution.
##
## 3. Neither the name of the copyright holder nor the names of its
## contributors may be used to endorse or promote products derived from
## this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
## BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
## FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
## OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
## WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
## OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
## EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#' @title
#' Extract All Regex Pattern Matches, Together with Capture Groups
#'
#' @description
#' A dummy function for compatibility with other search routines
#' in \pkg{stringi}. Calls \code{\link{stri_match_all_regex}}.
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
#' in \pkg{stringi}. Calls \code{\link{stri_match_first_regex}}.
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
#' in \pkg{stringi}. Calls \code{\link{stri_match_last_regex}}.
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
