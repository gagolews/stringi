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
#' Extract Occurrences of a Pattern
#'
#' @description
#' These functions extract all substrings matching a given pattern.
#'
#' \code{stri_extract_all_*} extracts all the matches.
#' On the other hand, \code{stri_extract_first_*} and \code{stri_extract_last_*}
#' provide the first or the last matches, respectively.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' If you would like to extract regex capture groups individually,
#' check out \code{\link{stri_match}}.
#'
#' \code{stri_extract}, \code{stri_extract_all}, \code{stri_extract_first},
#' and \code{stri_extract_last} are convenience functions.
#' They just call \code{stri_extract_*_*}, depending on arguments used.
#' Unless you are a very lazy person, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector with strings to search in
#' @param pattern,regex,fixed,coll,charclass character vector defining search patterns;
#' for more details refer to \link{stringi-search}
#' @param opts_collator,opts_fixed,opts_regex a named list used to tune up
#' a search engine's settings; see \code{\link{stri_opts_collator}},
#' \code{\link{stri_opts_fixed}}, and \code{\link{stri_opts_regex}},
#' respectively; \code{NULL} for default settings;
#' @param merge single logical value;
#' should consecutive matches be merged into one string;  \code{stri_extract_all_charclass} only
#' @param simplify single logical value;
#' if \code{TRUE} or \code{NA}, then a character matrix is returned;
#' otherwise (the default), a list of character vectors is given, see Value;
#' \code{stri_extract_all_*} only
#' @param omit_no_match single logical value; if \code{FALSE},
#' then a missing value will indicate that there was no match;
#' \code{stri_extract_all_*} only
#' @param mode single string;
#' one of: \code{"first"} (the default), \code{"all"}, \code{"last"}
#' @param ... supplementary arguments passed to the underlying functions,
#' including additional settings for \code{opts_collator}, \code{opts_regex},
#' and so on
#'
#' @return
#' For \code{stri_extract_all*}, if \code{simplify=FALSE} (the default), then
#' a list of character vectors is returned. Each list element
#' represents the results of a separate search scenario.
#' If a pattern is not found and \code{omit_no_match=FALSE},
#' then a character vector of length 1,
#' with single \code{NA} value will be generated.
#' Otherwise, i.e. if \code{simplify} is not \code{FALSE},
#' then \code{\link{stri_list2matrix}} with \code{byrow=TRUE} argument
#' is called on the resulting object.
#' In such a case, a character matrix with an appropriate number of rows
#' (according to the length of \code{str}, \code{pattern}, etc.)
#' is returned. Note that \code{\link{stri_list2matrix}}'s \code{fill} argument is set
#' to an empty string and \code{NA},
#' for \code{simplify} equal to \code{TRUE} and \code{NA}, respectively.
#'
#' \code{stri_extract_first*} and \code{stri_extract_last*},
#' on the other hand, return a character vector.
#' A \code{NA} element indicates no match.
#'
#' @examples
#' stri_extract_all('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_all('Bartolini', coll='i')
#' stri_extract_all('stringi is so good!', charclass='\\p{Zs}') # all whitespaces
#'
#' stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}')
#' stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}', merge=FALSE)
#' stri_extract_first_charclass('AaBbCc', '\\p{Ll}')
#' stri_extract_last_charclass('AaBbCc', '\\p{Ll}')
#'
#' stri_extract_all_coll(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_extract_first_coll(c('Yy\u00FD', 'AAA'), 'y', strength=2, locale="sk_SK")
#' stri_extract_last_coll(c('Yy\u00FD', 'AAA'), 'y',  strength=1, locale="sk_SK")
#'
#' stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_first_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_last_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#'
#' stri_list2matrix(stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+')))
#' stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+'), simplify=TRUE)
#' stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+'), simplify=NA)
#'
#' stri_extract_all_fixed("abaBAba", "Aba", case_insensitive=TRUE)
#' stri_extract_all_fixed("abaBAba", "Aba", case_insensitive=TRUE, overlap=TRUE)
#'
#' @family search_extract
#'
#' @export
#' @rdname stri_extract
stri_extract_all <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"=!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_extract_all_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_extract_all_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_extract_all_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_extract_all_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_extract
stri_extract_first <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"=!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_extract_first_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_extract_first_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_extract_first_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_extract_first_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_extract
stri_extract_last <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"=!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_extract_last_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_extract_last_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_extract_last_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_extract_last_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_extract
stri_extract <- function(str, ..., regex, fixed, coll, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
          first=stri_extract_first(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass),
          last =stri_extract_last(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass),
          all  =stri_extract_all(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass)
   )
}


#' @export
#' @rdname stri_extract
stri_extract_all_charclass <- function(str, pattern, merge=TRUE, simplify=FALSE, omit_no_match=FALSE) {
   .Call(C_stri_extract_all_charclass, str, pattern, merge, simplify, omit_no_match)
}


#' @export
#' @rdname stri_extract
stri_extract_first_charclass <- function(str, pattern) {
   .Call(C_stri_extract_first_charclass, str, pattern)
}


#' @export
#' @rdname stri_extract
stri_extract_last_charclass <- function(str, pattern) {
   .Call(C_stri_extract_last_charclass, str, pattern)
}


#' @export
#' @rdname stri_extract
stri_extract_all_coll <- function(str, pattern, simplify=FALSE, omit_no_match=FALSE, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_extract_all_coll, str, pattern, simplify, omit_no_match, opts_collator)
}


#' @export
#' @rdname stri_extract
stri_extract_first_coll <- function(str, pattern, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_extract_first_coll, str, pattern, opts_collator)
}


#' @export
#' @rdname stri_extract
stri_extract_last_coll <- function(str, pattern, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_extract_last_coll, str, pattern, opts_collator)
}


#' @export
#' @rdname stri_extract
stri_extract_all_regex <- function(str, pattern, simplify=FALSE, omit_no_match=FALSE, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_extract_all_regex, str, pattern, simplify, omit_no_match, opts_regex)
}


#' @export
#' @rdname stri_extract
stri_extract_first_regex <- function(str, pattern, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_extract_first_regex, str, pattern, opts_regex)
}


#' @export
#' @rdname stri_extract
stri_extract_last_regex <- function(str, pattern, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_extract_last_regex, str, pattern, opts_regex)
}


#' @export
#' @rdname stri_extract
stri_extract_all_fixed <- function(str, pattern, simplify=FALSE, omit_no_match=FALSE, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_extract_all_fixed, str, pattern, simplify, omit_no_match, opts_fixed)
}


#' @export
#' @rdname stri_extract
stri_extract_first_fixed <- function(str, pattern, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_extract_first_fixed, str, pattern, opts_fixed)
}


#' @export
#' @rdname stri_extract
stri_extract_last_fixed <- function(str, pattern, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_extract_last_fixed, str, pattern, opts_fixed)
}
