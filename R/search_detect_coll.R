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
#' Detect a Canonically Equivalent Pattern Match
#'
#' @description
#' This function checks if there is at least one occurrence of a pattern
#' in a string.  This is a locale-sensitive text operation.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' See \link{stringi-search-coll} for more details on
#' locale-sensitive text searching in \pkg{stringi}.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named list with \pkg{ICU} Collator's settings
#' as generated with \code{\link{stri_opts_collator}}; \code{NULL}
#' for default settings
#'
#' @return Returns a logical vector.
#'
#' @export
#' @family search_detect
#' @family search_coll
#' @family locale_sensitive
stri_detect_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_detect_coll", str, pattern, opts_collator, PACKAGE="stringi")
}
