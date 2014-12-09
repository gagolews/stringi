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
#' Count the Number of Pattern Matches
#'
#' @description
#' These functions count the number of occurrences
#' of a pattern in a string.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' \code{stri_count} is a convenience function.
#' It calls either \code{stri_count_regex},
#' \code{stri_count_fixed}, \code{stri_count_coll},
#' or \code{stri_count_charclass}, depending on the argument used.
#' Unless you are a very lazy person, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector with strings to search in
#' @param pattern,regex,fixed,coll,charclass character vector defining search patterns;
#' for more details refer to \link{stringi-search}
#' @param opts_collator,opts_fixed,opts_regex a named list used to tune up
#' a search engine's settings; see
#' \code{\link{stri_opts_collator}}, \code{\link{stri_opts_fixed}},
#' and \code{\link{stri_opts_regex}}, respectively; \code{NULL}
#' for default settings;
#' @param ... supplementary arguments passed to the underlying functions,
#' including additional settings for \code{opts_collator}, \code{opts_regex},
#' \code{opts_fixed}, and so on
#'
#' @return All the functions return an integer vector.
#'
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_count(s, fixed="dolor")
#' stri_count(s, regex="\\p{L}+")
#'
#' stri_count_fixed(s, " ")
#' stri_count_fixed(s, "o")
#' stri_count_fixed(s, "it")
#' stri_count_fixed(s, letters)
#' stri_count_fixed("babab", "b")
#' stri_count_fixed(c("stringi", "123"), "string")
#'
#' stri_count_charclass(c("stRRRingi", "STrrrINGI", "123"),
#'    c("\\p{Ll}", "\\p{Lu}", "\\p{Zs}"))
#' stri_count_charclass(" \t\n", "\\p{WHITE_SPACE}") # white space - binary property
#' stri_count_charclass(" \t\n", "\\p{Z}") # whitespace - general category (note the difference)
#'
#' stri_count_regex(s, "(s|el)it")
#' stri_count_regex(s, "i.i")
#' stri_count_regex(s, ".it")
#' stri_count_regex("bab baab baaab", c("b.*?b", "b.b"))
#' stri_count_regex(c("stringi", "123"), "^(s|1)")
#'
#' @family search_count
#' @export
#' @rdname stri_count
stri_count <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_count_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_count_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_count_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_count_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_count
stri_count_charclass <- function(str, pattern) {
   .Call(C_stri_count_charclass, str, pattern)
}


#' @export
#' @rdname stri_count
stri_count_coll <- function(str, pattern, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_count_coll, str, pattern, opts_collator)
}


#' @export
#' @rdname stri_count
stri_count_fixed <- function(str, pattern, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_count_fixed, str, pattern, opts_fixed)
}


#' @export
#' @rdname stri_count
stri_count_regex <- function(str, pattern, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_count_regex, str, pattern, opts_regex)
}
