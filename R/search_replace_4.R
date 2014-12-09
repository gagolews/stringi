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
#' Replace Occurrences of a Pattern
#'
#' @description
#' These functions replace with the given replacement string every/first/last
#' substring of the input that matches the specified \code{pattern}.
#'
#' @details
#' By default, all the functions are vectorized over
#' \code{str}, \code{pattern}, \code{replacement}. Then
#' these functions scan the input string for matches of the pattern.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the replacement string.
#'
#' However, for \code{stri_replace_all*}, if \code{vectorize_all} is \code{FALSE},
#' the each substring matching any of the supplied \code{pattern}s
#' is replaced by a corresponding \code{replacement} string.
#' In such a case, the vectorization is over \code{str},
#' and - independently - over \code{pattern} and \code{replacement}.
#' In other words, this is equivalent to something like
#' \code{for (i in 1:npatterns) str <- stri_replace_all(str, pattern[i], replacement[i]}.
#' Note that you must set \code{length(pattern) >= length(replacement)}.
#'
#' In case of \code{stri_replace_*_regex},
#' the replacement string may contain references to capture groups
#' (in round parentheses).
#' References are of the form \code{$n}, where \code{n} is the number
#' of the capture group (their numbering starts from 1).
#' In order to treat the \code{$} character literally,
#' escape it with a backslash.
#'
#' \code{stri_replace}, \code{stri_replace_all}, \code{stri_replace_first},
#' and \code{stri_replace_last} are convenience functions.
#' They just call \code{stri_replace_*_*}, depending on arguments used.
#' Unless you are a very lazy person, please call the underlying functions
#' directly for better performance.
#'
#' If you would like to get rid of e.g. whitespaces from the start or end
#' of a string, see \code{\link{stri_trim}}.
#'
#' @param str character vector with strings to search in
#' @param pattern,regex,fixed,coll,charclass character vector defining search patterns;
#' for more details refer to \link{stringi-search}
#' @param replacement character vector with replacements for matched patterns
#' @param opts_collator,opts_fixed,opts_regex a named list used to tune up
#' a search engine's settings; see
#' \code{\link{stri_opts_collator}}, \code{\link{stri_opts_fixed}},
#' and \code{\link{stri_opts_regex}}, respectively; \code{NULL}
#' for default settings;
#' @param merge single logical value;
#' should consecutive matches be merged into one string;
#' \code{stri_replace_all_charclass} only
#' @param vectorize_all single logical value;
#' should each occurrence of a pattern in every string
#' be replaced by a corresponding replacement string?;
#' \code{stri_replace_all_*} only
#' @param mode single string;
#' one of: \code{"first"} (the default), \code{"all"}, \code{"last"}
#' @param ... supplementary arguments passed to the underlying functions,
#' including additional settings for \code{opts_collator}, \code{opts_regex},
#' \code{opts_fixed}, and so on
#'
#' @return All the functions return a character vector.
#'
#' @examples
#' stri_replace_all_charclass("aaaa", "[a]", "b", merge=c(TRUE, FALSE))
#'
#' stri_replace_all_charclass("a\nb\tc   d", "\\p{WHITE_SPACE}", " ")
#' stri_replace_all_charclass("a\nb\tc   d", "\\p{WHITE_SPACE}", " ", merge=TRUE)
#'
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all_fixed(s, " ", "#")
#' stri_replace_all_fixed(s, "o", "0")
#'
#' stri_replace_all_regex(s, " .*? ", "#")
#' stri_replace_all_regex(s, "(el|s)it", "1234")
#' stri_replace_all_regex('abaca', 'a', c('!', '*'))
#' stri_replace_all_regex('123|456|789', '(\\p{N}).(\\p{N})', '$2-$1')
#' stri_replace_all_regex(c("stringi R", "REXAMINE", "123"), '( R|R.)', ' r ')
#'
#' # Compare the results:
#' stri_replace_all_fixed("The quick brown fox jumped over the lazy dog.",
#'      c("quick", "brown", "fox"), c("slow",  "black", "bear"), vectorize_all=TRUE)
#' stri_replace_all_fixed("The quick brown fox jumped over the lazy dog.",
#'      c("quick", "brown", "fox"), c("slow",  "black", "bear"), vectorize_all=FALSE)
#'
#' # Compare the results:
#' stri_replace_all_fixed("The quicker brown fox jumped over the lazy dog.",
#'      c("quick", "brown", "fox"), c("slow",  "black", "bear"), vectorize_all=FALSE)
#' stri_replace_all_regex("The quicker brown fox jumped over the lazy dog.",
#'      "\\b"%s+%c("quick", "brown", "fox")%s+%"\\b", c("slow",  "black", "bear"), vectorize_all=FALSE)
#'
#' @family search_replace
#' @export
#' @rdname stri_replace
stri_replace_all <- function(str, replacement, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_replace_all_regex(str, regex, replacement, ...)
   else if (providedarg["fixed"])
      stri_replace_all_fixed(str, fixed, replacement, ...)
   else if (providedarg["coll"])
      stri_replace_all_coll(str, coll, replacement, ...)
   else if (providedarg["charclass"])
      stri_replace_all_charclass(str, charclass, replacement, ...)
}


#' @export
#' @rdname stri_replace
stri_replace_first <- function(str, replacement, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_replace_first_regex(str, regex, replacement, ...)
   else if (providedarg["fixed"])
      stri_replace_first_fixed(str, fixed, replacement, ...)
   else if (providedarg["coll"])
      stri_replace_first_coll(str, coll, replacement, ...)
   else if (providedarg["charclass"])
      stri_replace_first_charclass(str, charclass, replacement, ...)
}


#' @export
#' @rdname stri_replace
stri_replace_last <- function(str, replacement, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_replace_last_regex(str, regex, replacement, ...)
   else if (providedarg["fixed"])
      stri_replace_last_fixed(str, fixed, replacement, ...)
   else if (providedarg["coll"])
      stri_replace_last_coll(str, coll, replacement, ...)
   else if (providedarg["charclass"])
      stri_replace_last_charclass(str, charclass, replacement, ...)
}


#' @export
#' @rdname stri_replace
stri_replace <- function(str, replacement, ..., regex, fixed, coll, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
          first=stri_replace_first(str, replacement, ..., regex=regex,
               fixed=fixed, coll=coll, charclass=charclass),
          last =stri_replace_last(str, replacement, ..., regex=regex,
               fixed=fixed, coll=coll, charclass=charclass),
          all  =stri_replace_all(str, replacement, ..., regex=regex,
               fixed=fixed, coll=coll, charclass=charclass)
   )
}


#' @export
#' @rdname stri_replace
stri_replace_all_charclass <- function(str, pattern, replacement, merge=FALSE, vectorize_all=TRUE) {
   .Call(C_stri_replace_all_charclass, str, pattern, replacement, merge, vectorize_all)
}


#' @export
#' @rdname stri_replace
stri_replace_first_charclass <- function(str, pattern, replacement) {
   .Call(C_stri_replace_first_charclass, str, pattern, replacement)
}


#' @export
#' @rdname stri_replace
stri_replace_last_charclass <- function(str, pattern, replacement) {
   .Call(C_stri_replace_last_charclass, str, pattern, replacement)
}


#' @export
#' @rdname stri_replace
stri_replace_all_coll <- function(str, pattern, replacement, vectorize_all=TRUE, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_replace_all_coll, str, pattern, replacement, vectorize_all, opts_collator)
}


#' @export
#' @rdname stri_replace
stri_replace_first_coll <- function(str, pattern, replacement, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_replace_first_coll, str, pattern, replacement, opts_collator)
}


#' @export
#' @rdname stri_replace
stri_replace_last_coll <- function(str, pattern, replacement, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_replace_last_coll, str, pattern, replacement, opts_collator)
}


#' @export
#' @rdname stri_replace
stri_replace_all_fixed <- function(str, pattern, replacement, vectorize_all=TRUE, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_replace_all_fixed, str, pattern, replacement, vectorize_all, opts_fixed)
}


#' @export
#' @rdname stri_replace
stri_replace_first_fixed <- function(str, pattern, replacement, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_replace_first_fixed, str, pattern, replacement, opts_fixed)
}


#' @export
#' @rdname stri_replace
stri_replace_last_fixed <- function(str, pattern, replacement, ..., opts_fixed=NULL) {
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_replace_last_fixed, str, pattern, replacement, opts_fixed)
}


#' @export
#' @rdname stri_replace
stri_replace_all_regex <- function(str, pattern, replacement, vectorize_all=TRUE, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_replace_all_regex, str, pattern, replacement, vectorize_all, opts_regex)
}


#' @export
#' @rdname stri_replace
stri_replace_first_regex <- function(str, pattern, replacement, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_replace_first_regex, str, pattern, replacement, opts_regex)
}


#' @export
#' @rdname stri_replace
stri_replace_last_regex <- function(str, pattern, replacement, ..., opts_regex=NULL) {
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_replace_last_regex, str, pattern, replacement, opts_regex)
}
