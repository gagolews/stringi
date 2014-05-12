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
#' Locate All Occurrences of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_all_regex}},
#' \code{\link{stri_locate_all_fixed}}, \code{\link{stri_locate_all_coll}},
#' or \code{\link{stri_locate_all_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @return Returns a list of integer matrices. The first column gives the
#' start positions
#' of the matches, and the second one gives the end positions.
#' Double \code{NA}s iff not found or \code{NA} argument is given.
#'
#' @examples
#' stri_locate_all('XaaaaX',
#'    regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_all('Bartolini', fixed='i')
#' stri_locate_all('a b c', charclass='\\p{Zs}') # all white spaces
#'
#' @export
#' @family search_locate
#' @family indexing
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


#' @title
#' Locate First Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_first_regex}},
#' \code{\link{stri_locate_first_fixed}},
#' \code{\link{stri_locate_first_coll}},
#' or \code{\link{stri_locate_first_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @return Returns an integer matrix with two columns, with
#' double \code{NA}s in a row if a pattern not found.
#'
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_first('XaaaaX',
#'    regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_first('Bartolini', fixed=letters[1:3])
#' stri_locate_first('a b c', charclass='\\p{Zs}')
#'
#' @export
#' @family search_locate
#' @family indexing
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


#' @title
#' Locate Last Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_last_regex}},
#' \code{\link{stri_locate_last_fixed}},
#' \code{\link{stri_locate_last_coll}},
#' or \code{\link{stri_locate_last_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @return Returns an integer matrix with two columns, with
#' double \code{NA}s in a row if a pattern has not been found.
#'
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_last('XaaaaX',
#'    regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_last('Bartolini', fixed=letters[1:3])
#' stri_locate_last('a b c', charclass='\\p{Zs}')
#'
#' @export
#' @family search_locate
#' @family indexing
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


#' @title
#' Locate Occurrences of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_all}},
#' \code{\link{stri_locate_first}}, or \code{\link{stri_locate_last}},
#' depending on the argument used.
#' Note that this is slower than the direct call.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#' @param mode single string; whether to look for all, or only the first/last
#'             occurrence of the pattern
#'
#' @return The return value is the same as that of the underlying
#' functions called, i.e. a two-column matrix or a list of matrices.
#'
#'
#' @export
#' @family search_locate
#' @family indexing
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


#' @title
#' Locate Specific Text Boundaries
#'
#' @description
#' This function locates specific text boundaries
#' (like character, word, line, or sentence boundaries)
#' and splits strings at the indicated positions.
#'
#' @details
#' Vectorized over \code{str} and \code{boundary}.
#'
#' For more information on the text boundary analysis
#' performed by \pkg{ICU}'s \code{BreakIterator}, see
#' \code{\link{stri_locate_boundaries}}.
#'
#' For locating words in a text using \pkg{ICU}'s word iterator,
#' see \code{\link{stri_locate_words}}.
#'
#'
#' @param str character vector or an object coercible to
#' @param boundary character vector, each string is one of \code{character},
#' \code{line-break}, \code{sentence}, or \code{word}
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}.
#'
#' @return
#' A list of \code{max(length(str), length(boundary))} integer matrices
#' is returned. The first column gives the start positions
#' of substrings between located boundaries, and the second column gives
#' the end positions. The indices are code point-based, thus
#' they may be passed e.g. to the \code{\link{stri_sub}} function.
#'
#' Moreover, you may get two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' @examples
#' stri_locate_boundaries("The\u00a0above-mentioned packages are...", boundary='line')
#'
#' @export
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
#' @family text_boundaries
stri_locate_boundaries <- function(str, boundary='word', locale=NULL) {
   .Call("stri_locate_boundaries", str, boundary, locale, PACKAGE="stringi")
}


#' @title
#' Locate Words in a Text
#'
#' @description
#' This function locates all words in each string.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' Just like in \code{\link{stri_extract_words}},
#' \pkg{ICU}'s word \code{BreakIterator} iterator is used
#' to locate word boundaries, and all non-word characters
#' (\code{UBRK_WORD_NONE} rule status) are ignored.
#'
#'
#' @param str character vector or an object coercible to
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}.
#'
#' @return
#' A list of integer matrices
#' is returned. The first column gives the start positions
#' of the words, and the second column gives
#' the end positions. The indices are code point-based, thus
#' they may be passed e.g. to the \code{\link{stri_sub}} function.
#'
#' Moreover, you may get two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' @examples
#' stri_locate_words("  stringi: THE string processing package 123.48...  ")
#'
#' @references
#' \emph{Boundary Analysis} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/boundaryanalysis}
#'
#' @export
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
#' @family text_boundaries
stri_locate_words <- function(str, locale=NULL) {
   .Call("stri_locate_words", str, locale, PACKAGE="stringi")
}
