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
#' Replace Occurrences of a Canonically Equivalent Pattern Matches
#'
#' @description
#' Replaces with the given replacement string every/first/last
#' substring of the input that matches the pattern.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' These are locale-sensitive operations.
#' See \link{stringi-search-coll} for more details on
#' locale-sensitive text searching in \pkg{stringi}.
#'
#' These functions scan the input string for matches of the pattern.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the replacement string.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of patterns to search for
#' @param replacement character vector of strings to replace with
#' @param opts_collator a named list with \pkg{ICU} Collator's settings
#' as generated with \code{\link{stri_opts_collator}}; \code{NULL}
#' for default settings
#'
#' @return Each function discussed returns a character vector.
#'
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_coll(s, " ", "#")
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_replace_all_coll(s, "o", "0")
#'
#' @export
#' @rdname stri_replace_coll
#' @aliases stri_replace_all_coll stri_replace_first_coll stri_replace_last_coll
#' @family search_coll
#' @family search_replace
#' @family locale_sensitive
stri_replace_all_coll <- function(str, pattern, replacement, opts_collator=NULL) {
   .Call("stri_replace_all_coll", str, pattern, replacement, opts_collator,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_coll
stri_replace_first_coll <- function(str, pattern, replacement, opts_collator=NULL) {
   .Call("stri_replace_first_coll", str, pattern, replacement, opts_collator,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_coll
stri_replace_last_coll <- function(str, pattern, replacement, opts_collator=NULL) {
   .Call("stri_replace_last_coll", str, pattern, replacement, opts_collator,
         PACKAGE="stringi")
}
