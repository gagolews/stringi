## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
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
#' These functions return or modify a sub-vector where there is a match
#' a given pattern. In other words, they
#' are roughly equivalent (but faster and easier to use) to a call to
#' \code{str[\link{stri_detect}(str, ...)]} or
#' \code{str[\link{stri_detect}(str, ...)] <- value}.
#'
#' @details
#' Vectorized over \code{str}, and \code{pattern} or \code{value}
#' (replacement version) (with recycling
#' of the elements in the shorter vector if necessary).
#'
#' \code{stri_subset} and \code{stri_subset<-} are convenience functions.
#' They call either \code{stri_subset_regex},
#' \code{stri_subset_fixed}, \code{stri_subset_coll},
#' or \code{stri_subset_charclass},
#' depending on the argument used.
#'
#' @param str character vector; strings to search in
#' @param pattern,regex,fixed,coll,charclass character vector;
#'     search patterns; for more details refer to \link{stringi-search};
#'     the replacement functions accept only one pattern at a time
#' @param negate single logical value; whether a no-match is rather of interest
#' @param omit_na single logical value; should missing values be excluded
#' from the result?
#' @param opts_collator,opts_fixed,opts_regex a named list used to tune up
#' the search engine's settings; see
#' \code{\link{stri_opts_collator}}, \code{\link{stri_opts_fixed}},
#' and \code{\link{stri_opts_regex}}, respectively; \code{NULL}
#' for the defaults
#' @param ... supplementary arguments passed to the underlying functions,
#' including additional settings for \code{opts_collator}, \code{opts_regex},
#' \code{opts_fixed}, and so on
#' @param value character vector to be substituted with; replacement function only
#'
#' @return The \code{stri_subset} functions return a character vector.
#' As usual, the output encoding is always UTF-8.
#'
#' The \code{stri_subset<-} function modifies the \code{str} object
#' ``in-place''.
#'
#' @examples
#' stri_subset_regex(c("stringi R", "123", "ID456", ""), "^[0-9]+$")
#'
#' x <- c("stringi R", "123", "ID456", "")
#' stri_subset_regex(x, "[^0-9]+|^$") <- NA
#' print(x)
#'
#' x <- c("stringi R", "123", "ID456", "")
#' stri_subset_regex(x, "^[0-9]+$", negate=TRUE) <- NA
#' print(x)
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
#' @usage stri_subset(str, ..., regex, fixed, coll, charclass) <- value
"stri_subset<-" <- function(str, ..., regex, fixed, coll, charclass, value) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      `stri_subset_regex<-`(str, regex, ..., value=value)
   else if (providedarg["fixed"])
      `stri_subset_fixed<-`(str, fixed, ..., value=value)
   else if (providedarg["coll"])
      `stri_subset_coll<-`(str, coll, ..., value=value)
   else if (providedarg["charclass"])
      `stri_subset_charclass<-`(str, charclass, ..., value=value)
}


#' @export
#' @rdname stri_subset
stri_subset_fixed <- function(str, pattern, omit_na=FALSE, negate=FALSE, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_subset_fixed, str, pattern, omit_na, negate, opts_fixed)
}


#' @export
#' @rdname stri_subset
#' @usage stri_subset_fixed(str, pattern, negate=FALSE, ..., opts_fixed=NULL) <- value
"stri_subset_fixed<-" <- function(str, pattern, negate=FALSE, ..., opts_fixed=NULL, value) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_subset_fixed_replacement, str, pattern, negate, opts_fixed, value)
}


#' @export
#' @rdname stri_subset
stri_subset_charclass <- function(str, pattern, omit_na=FALSE, negate=FALSE) {
   .Call(C_stri_subset_charclass, str, pattern, omit_na, negate)
}


#' @export
#' @rdname stri_subset
#' @usage stri_subset_charclass(str, pattern, negate=FALSE) <- value
"stri_subset_charclass<-" <- function(str, pattern, negate=FALSE, value) {
   .Call(C_stri_subset_charclass_replacement, str, pattern, negate, value)
}


#' @export
#' @rdname stri_subset
stri_subset_coll <- function(str, pattern, omit_na=FALSE, negate=FALSE, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_subset_coll, str, pattern, omit_na, negate, opts_collator)
}


#' @export
#' @rdname stri_subset
#' @usage stri_subset_coll(str, pattern, negate=FALSE, ..., opts_collator=NULL) <- value
"stri_subset_coll<-" <- function(str, pattern, negate=FALSE, ..., opts_collator=NULL, value) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_subset_coll_replacement, str, pattern, negate, opts_collator, value)
}


#' @export
#' @rdname stri_subset
stri_subset_regex <- function(str, pattern, omit_na=FALSE, negate=FALSE, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_subset_regex, str, pattern, omit_na, negate, opts_regex)
}


#' @export
#' @rdname stri_subset
#' @usage stri_subset_regex(str, pattern, negate=FALSE, ..., opts_regex=NULL) <- value
"stri_subset_regex<-" <- function(str, pattern, negate=FALSE, ..., opts_regex=NULL, value) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_subset_regex_replacement, str, pattern, negate, opts_regex, value)
}
