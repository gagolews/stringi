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
#' Split a String By Regex Pattern Matches
#'
#' @description
#' Splits each element of \code{str} into substrings.
#' A \code{pattern} indicates delimiters that separate
#' the input into fields. The input data between the matches become
#' the fields themselves.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max},
#' and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#'
#' Note that if you want to split a string by characters from a
#' specific class (e.g. whitespaces), \code{\link{stri_split_charclass}}
#' will be a little bit faster.
#'
#' @param str character vector with strings to search in
#' @param pattern pattern character; regular expressions
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#' @param opts_regex a named list with \pkg{ICU} Regex settings
#' as generated with \code{\link{stri_opts_regex}}; \code{NULL}
#' for default settings
#'
#' @return Returns a list of character vectors.
#'
#'
#' @examples
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_split_regex("Lorem ipsum dolor sit amet",
#'    "\\p{Z}+") # see also stri_split_charclass
#'
#' @export
#' @rdname stri_split_regex
#' @aliases stri_split_regex
#' @family search_regex
#' @family search_split
stri_split_regex <- function(str, pattern, n_max=-1L, omit_empty=FALSE, opts_regex=NULL)  {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   .Call("stri_split_regex", str, pattern, n_max, omit_empty, opts_regex, PACKAGE="stringi")
}
