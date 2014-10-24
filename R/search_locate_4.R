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
#' Locate Occurrences of a Pattern
#'
#' @description
#' These functions may be used e.g. to find the indices (positions), at which
#' a given pattern is matched.
#' \code{stri_locate_all_*} locates all the matches.
#' On the other hand, \code{stri_locate_first_*} and \code{stri_locate_last_*}
#' give the first or the last matches, respectively.
#' 
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{merge}.
#' 
#' The matched string(s) may be extracted by calling
#' the \code{\link{stri_sub}} function.
#' Alternatively, you may call \code{\link{stri_extract}} directly.
#' 
#' \code{stri_locate}, \code{stri_locate_all}, \code{stri_locate_first},
#' and \code{stri_locate_last} are convenience functions.
#' They just call \code{stri_locate_*_*}, depending on arguments used.
#' Unless you are a very lazy person, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector with strings to search in
#' @param pattern,regex,fixed,coll,charclass character vector defining search patterns;
#' for more details refer to \link{stringi-search}
#' @param opts_regex a named list with \pkg{ICU} Regex settings
#' as generated with \code{\link{stri_opts_regex}}; \code{NULL}
#' for default settings;
#' \code{stri_locate_*_regex} only
#' @param opts_collator a named list with \pkg{ICU} Collator's settings
#' as generated with \code{\link{stri_opts_collator}}; \code{NULL}
#' for default settings; \code{stri_locate_*_coll} only
#' @param merge logical;
#' indicates whether consecutive sequences of indices in the resulting
#' matrix shall be merged;  \code{stri_locate_all_charclass} only
#' @param mode single string;
#' one of: \code{"first"} (the default), \code{"all"}, \code{"last"}
#' @param ... additional arguments passed to the underlying functions
#'
#' @return
#' For \code{stri_locate_all*},
#' a list of integer matrices is returned. Each list element
#' represents the results of a separate search scenario.
#' The first column gives the start positions
#' of matches, and the second column gives the end positions.
#' Moreover, you may get two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#' 
#' \code{stri_locate_first*} and \code{stri_locate_last*},
#' on the other hand, return an integer matrix with
#' two columns, giving the start and end positions of the first
#' or the last matches, respectively, and two \code{NA}s iff not found.
#'
#' @examples
#' \donttest{
#' stri_locate_all('XaaaaX',
#'    regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_all('Bartolini', fixed='i')
#' stri_locate_all('a b c', charclass='\\p{Zs}') # all white spaces
#' 
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}')
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}', merge=FALSE)
#' stri_locate_first_charclass('AaBbCc', '\\p{Ll}')
#' stri_locate_last_charclass('AaBbCc', '\\p{Ll}')
#' stri_locate_all_charclass(c('REXAMINE'), '\\p{Lu}', merge=c(TRUE, FALSE))
#' 
#' stri_locate_all_coll(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_locate_first_coll(c('Yy\u00FD', 'AAA'), 'y',
#'    stri_opts_collator(strength=2, locale="sk_SK"))
#' stri_locate_last_coll(c('Yy\u00FD', 'AAA'), 'y',
#'    stri_opts_collator(strength=1, locale="sk_SK"))
#'    
#' stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_locate_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' stri_locate_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#'
#' #first row is 1-2 like in locate_first
#' stri_locate_all_fixed('bbbbb', 'bb')
#' stri_locate_first_fixed('bbbbb', 'bb')
#'
#' # but last row is 3-4, unlike in locate_last,
#' # keep this in mind [overlapping pattern match OK]!
#' stri_locate_last_fixed('bbbbb', 'bb')
#' 
#' stri_locate_all_regex('XaaaaX',
#'    c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_first_regex('XaaaaX',
#'    c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_last_regex('XaaaaX',
#'    c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' }
#'
#' @family search_locate
#' @family indexing
#' 
#' @export
#' @rdname stri_locate
stri_locate_all <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_locate_all_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_locate_all_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_locate_all_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_locate_all_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_locate
stri_locate_first <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_locate_first_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_locate_first_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_locate_first_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_locate_first_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_locate
stri_locate_last <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_locate_last_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_locate_last_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_locate_last_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_locate_last_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_locate
stri_locate <- function(str, ..., regex, fixed, coll, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
      first=stri_locate_first(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass),
      last =stri_locate_last(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass),
      all  =stri_locate_all(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass)
   )
}


#' @export
#' @rdname stri_locate
stri_locate_all_charclass <- function(str, pattern, merge=TRUE) {
   .Call("stri_locate_all_charclass", str, pattern, merge, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_first_charclass <- function(str, pattern) {
   .Call("stri_locate_first_charclass", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_last_charclass <- function(str, pattern) {
   .Call("stri_locate_last_charclass", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_all_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_all_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_first_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_first_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_last_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_last_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_all_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_locate_all_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_first_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_locate_first_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_last_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_locate_last_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_all_fixed <- function(str, pattern) {
   .Call("stri_locate_all_fixed", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_first_fixed <- function(str, pattern) {
   .Call("stri_locate_first_fixed", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate
stri_locate_last_fixed <- function(str, pattern) {
   .Call("stri_locate_last_fixed", str, pattern, PACKAGE="stringi")
}