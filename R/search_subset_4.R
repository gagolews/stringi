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
#' Select Elements that Match a Given Pattern
#'
#' @description
#' These functions return a subvector consisting of
#' strings that match a given pattern. In other words, they
#' are roughly equivalent (but faster and easier to use) to a call to
#' \code{str[\link{stri_detect}(str, ...)]}.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' Of course, normally you will use that function in case
#' of \code{length(str) >= length(pattern)}.
#'
#' \code{stri_subset} is a convenience function.
#' It calls either \code{stri_subset_regex},
#' \code{stri_subset_fixed}, \code{stri_subset_coll},
#' or \code{stri_subset_charclass},
#' depending on the argument used.
#' Unless you are a very lazy person, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector with strings to search in
#' @param pattern,regex,fixed,coll,charclass character vector defining search patterns;
#' for more details refer to \link{stringi-search}
#' @param omit_na single logical value; should missing values be excluded
#' from the result?
#' @param opts_collator,opts_fixed,opts_regex a named list used to tune up
#' a search engine's settings; see
#' \code{\link{stri_opts_collator}}, \code{\link{stri_opts_fixed}},
#' and \code{\link{stri_opts_regex}}, respectively; \code{NULL}
#' for default settings;
#' @param ... supplementary arguments passed to the underlying functions,
#' including additional settings for \code{opts_collator}, \code{opts_regex},
#' \code{opts_fixed}, and so on
#'
#' @return All the functions return a character vector.
#' As usual, the output encoding is always UTF-8.
#'
#' @examples
#' stri_subset_fixed(c("stringi R", "REXAMINE", "123"), c('i', 'R', '0'))
#' stri_subset_fixed(c("stringi R", "REXAMINE", "123"), 'R')
#' stri_subset_charclass(c("stRRRingi","REXAMINE","123"),
#'    c("\\p{Ll}", "\\p{Lu}", "\\p{Zs}"))
#'
#' @family search_subset
#' @export
#' @rdname stri_subset
stri_subset <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_subset_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_subset_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_subset_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_subset_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_subset
stri_subset_fixed <- function(str, pattern, omit_na=FALSE, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_subset_fixed, str, pattern, omit_na, opts_fixed)
}


#' @export
#' @rdname stri_subset
stri_subset_charclass <- function(str, pattern, omit_na=FALSE) {
   .Call(C_stri_subset_charclass, str, pattern, omit_na)
}


#' @export
#' @rdname stri_subset
stri_subset_coll <- function(str, pattern, omit_na=FALSE, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_subset_coll, str, pattern, omit_na, opts_collator)
}


#' @export
#' @rdname stri_subset
stri_subset_regex <- function(str, pattern, omit_na=FALSE, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_subset_regex, str, pattern, omit_na, opts_regex)
}
