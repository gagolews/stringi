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
#' Select Elements with a Regex Pattern Match
#'
#' @description
#' This function is roughly equivalent to a call to
#' \code{str[\link{stri_detect_regex}(str, ...)]}.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' The resulting vector is of course always in UTF-8.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions
#' @param opts_regex a named list with \pkg{ICU} Regex settings
#' as generated with \code{\link{stri_opts_regex}}; \code{NULL}
#' for default settings
#'
#' @return Returns a character vector.
#'
#' @examples
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_subset_regex(c("stringi R", "REXAMINE", "123"), c('i', 'R', '0'))
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_subset_regex(c("stringi R", "REXAMINE", "123"), '[a-z]')
#'
#' @export
#' @family search_subset
#' @family search_regex
stri_subset_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_subset_regex", str, pattern, opts_regex, PACKAGE="stringi")
}
