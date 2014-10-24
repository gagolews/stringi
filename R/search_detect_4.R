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
#' Detect a Pattern Match
#'
#' @description
#' These functions determine, for each string in \code{str},
#' if there is at least one match to a corresponding \code{pattern}.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' \code{stri_detect} is a convenience function.
#' It calls either \code{stri_detect_regex},
#' \code{stri_detect_fixed}, \code{stri_detect_coll},
#' or \code{stri_detect_charclass}, depending on the argument used.
#' Unless you are a very lazy person, please call the underlying functions
#' directly for better performance.
#'
#'
#' @param str character vector with strings to search in
#' @param pattern,regex,fixed,coll,charclass character vector defining search patterns;
#' for more details refer to \link{stringi-search}
#' @param opts_regex a named list with \pkg{ICU} Regex settings
#' as generated with \code{\link{stri_opts_regex}}; \code{NULL}
#' for default settings; \code{stri_detect_regex} only
#' @param opts_collator a named list with \pkg{ICU} Collator's settings
#' as generated with \code{\link{stri_opts_collator}}; \code{NULL}
#' for default settings; \code{stri_detect_coll} only
#' @param ... additional arguments passed to the underlying functions;
#' \code{stri_detect} only
#'
#' @return All the functions return a logical vector.
#'
#' @examples
#' \donttest{
#' stri_detect_fixed(c("stringi R", "REXAMINE", "123"), c('i', 'R', '0'))
#' stri_detect_fixed(c("stringi R", "REXAMINE", "123"), 'R')
#' 
#' stri_detect_charclass(c("stRRRingi","REXAMINE","123"),
#'    c("\\p{Ll}", "\\p{Lu}", "\\p{Zs}"))
#'    
#' stri_detect_regex(c("stringi R", "REXAMINE","123"), 'R.')
#' stri_detect_regex(c("stringi R", "REXAMINE","123"), '[[:alpha:]]*?')
#' stri_detect_regex(c("stringi R", "REXAMINE","123"), '[a-zC1]')
#' stri_detect_regex(c("stringi R", "REXAMINE","123"), '( R|RE)')
#' stri_detect_regex("stringi", "STRING.", opts_regex=stri_opts_regex(case_insensitive=TRUE))
#' }
#'
#' @family search_detect
#' @export
#' @rdname stri_detect
stri_detect <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_detect_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_detect_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_detect_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_detect_charclass(str, charclass, ...)
}

#' @export
#' @rdname stri_detect
stri_detect_fixed <- function(str, pattern) {
   .Call("stri_detect_fixed", str, pattern, PACKAGE="stringi")
}

#' @export
#' @rdname stri_detect
stri_detect_charclass <- function(str, pattern) {
   .Call("stri_detect_charclass", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_detect
stri_detect_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_detect_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_detect
stri_detect_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_detect_regex", str, pattern, opts_regex, PACKAGE="stringi")
}