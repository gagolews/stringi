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
#' Determine if the Start or End of a String Matches a Pattern
#'
#' @description
#' These functions check if a string starts or ends with a
#' pattern occurrence.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern},
#' and \code{from} or \code{to}.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' Argument \code{start} controls the start position in \code{str}
#' at which the \code{pattern} is matched.
#' On the other hand, \code{to} gives the end position.
#'
#' Indices given by \code{from} or \code{to} are 1-based,
#' i.e. an index equal to 1 denotes the first character
#' in a string, which gives a typical R look-and-feel.
#'
#' For negative indices in \code{from} or \code{to}, counting starts
#' at the end of the string. E.g. index -1 denotes the last code point
#' in the string.
#'
#' If you would like to test for a pattern match at \emph{any}
#' position in \code{str}, use \code{\link{stri_detect}}.
#'
#' \code{stri_startswith} and \code{stri_endswith} are convenience functions.
#' They call either \code{stri_*_fixed}, \code{stri_*_coll},
#' or \code{stri_*_charclass}, depending on the argument used.
#' Unless you are a very lazy person, please refer to the underlying functions
#' directly for better performance.
#'
#' Note that testing for a pattern match at the start or end of a string
#' has not been implemented separately for regex patterns.
#' For that you may use the "\code{^}" and "\code{$}" metacharacters,
#' see \link{stringi-search-regex}.
#'
#' @param str character vector
#' @param pattern,fixed,coll,charclass character vector defining search patterns;
#' for more details refer to \link{stringi-search}
#' @param from integer vector
#' @param to integer vector
#' @param opts_collator,opts_fixed a named list used to tune up
#' a search engine's settings; see \code{\link{stri_opts_collator}}
#' and \code{\link{stri_opts_fixed}}, respectively; \code{NULL}
#' for default settings;
#' @param ... supplementary arguments passed to the underlying functions,
#' including additional settings for \code{opts_collator}, \code{opts_fixed},
#' and so on.
#'
#' @return All the functions return a logical vector.
#'
#'
#' @examples
#' stri_startswith_charclass(" trim me! ", "\\p{WSpace}")
#' stri_startswith_fixed(c("a1", "a2", "b3", "a4", "c5"), "a")
#' stri_detect_regex(c("a1", "a2", "b3", "a4", "c5"), "^a")
#' stri_startswith_fixed("ababa", "ba")
#' stri_startswith_fixed("ababa", "ba", from=2)
#' stri_startswith_coll(c("a1", "A2", "b3", "A4", "C5"), "a", strength=1)
#' pat <- stri_paste("\u0635\u0644\u0649 \u0627\u0644\u0644\u0647 ",
#'                   "\u0639\u0644\u064a\u0647 \u0648\u0633\u0644\u0645XYZ")
#' stri_endswith_coll("\ufdfa\ufdfa\ufdfaXYZ", pat, strength=1)
#'
#' @family search_detect
#' @export
#' @rdname stri_startsendswith
stri_startswith <- function(str, ..., fixed, coll, charclass) {
   providedarg <- c("fixed" =!missing(fixed),
                    "coll"  =!missing(coll),
                    "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `fixed`, `coll`, or `charclass`")

   if (providedarg["fixed"])
      stri_startswith_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_startswith_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_startswith_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_startsendswith
stri_endswith <- function(str, ..., fixed, coll, charclass) {
   providedarg <- c("fixed" =!missing(fixed),
                    "coll"  =!missing(coll),
                    "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `fixed`, `coll`, or `charclass`")

   if (providedarg["fixed"])
      stri_endswith_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_endswith_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_endswith_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_startsendswith
stri_startswith_fixed <- function(str, pattern, from=1L, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_startswith_fixed, str, pattern, from, opts_fixed)
}


#' @export
#' @rdname stri_startsendswith
stri_endswith_fixed <- function(str, pattern, to=-1L, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_endswith_fixed, str, pattern, to, opts_fixed)
}


#' @export
#' @rdname stri_startsendswith
stri_startswith_charclass <- function(str, pattern, from=1L) {
   .Call(C_stri_startswith_charclass, str, pattern, from)
}


#' @export
#' @rdname stri_startsendswith
stri_endswith_charclass <- function(str, pattern, to=-1L) {
   .Call(C_stri_endswith_charclass, str, pattern, to)
}


#' @export
#' @rdname stri_startsendswith
stri_startswith_coll <- function(str, pattern, from=1L, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_startswith_coll, str, pattern, from, opts_collator)
}


#' @export
#' @rdname stri_startsendswith
stri_endswith_coll <- function(str, pattern, to=-1L, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_endswith_coll, str, pattern, to, opts_collator)
}
