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
#' Locate Specific Text Boundaries
#'
#' @description
#' These functions locate specific text boundaries
#' (like character, word, line, or sentence boundaries).
#' \code{stri_locate_all_*} locate all the matches.
#' On the other hand, \code{stri_locate_first_*} and \code{stri_locate_last_*}
#' give the first or the last matches, respectively.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' For more information on the text boundary analysis
#' performed by \pkg{ICU}'s \code{BreakIterator}, see
#' \link{stringi-search-boundaries}.
#'
#' In case of \code{stri_locate_*_words},
#' just like in \code{\link{stri_extract_all_words}} and \code{\link{stri_count_words}},
#' \pkg{ICU}'s word \code{BreakIterator} iterator is used
#' to locate word boundaries, and all non-word characters
#' (\code{UBRK_WORD_NONE} rule status) are ignored.
#' This is function is equivalent to a call to
#' \code{stri_locate_*_boundaries(str, type="word", skip_word_none=TRUE, locale=locale)}
#'
#'
#' @param str character vector or an object coercible to
#' @param omit_no_match single logical value; if \code{FALSE},
#' then 2 missing values will indicate that there are no text boundaries;
#' \code{stri_locate_all_*} only
#' @param opts_brkiter a named list with \pkg{ICU} BreakIterator's settings
#' as generated with \code{\link{stri_opts_brkiter}};
#' \code{NULL} for default break iterator, i.e. \code{line_break};
#' \code{stri_locate_all_boundaries} only
#' @param ... additional settings for \code{opts_brkiter}
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale};
#' \code{stri_locate_all_words} only
#'
#' @return
#' For \code{stri_locate_all_*}, a list of \code{length(str)} integer matrices
#' is returned. The first column gives the start positions
#' of substrings between located boundaries, and the second column gives
#' the end positions. The indices are code point-based, thus
#' they may be passed e.g. to the \code{\link{stri_sub}} function.
#' Moreover, you may get two \code{NA}s in one row
#' for no match (if \code{omit_no_match} is \code{FALSE})
#' or \code{NA} arguments.
#'
#' \code{stri_locate_first_*} and \code{stri_locate_last_*},
#' on the other hand, return an integer matrix with
#' two columns, giving the start and end positions of the first
#' or the last matches, respectively, and two \code{NA}s if and
#' only if they are not found.
#'
#' @examples
#' test <- "The\u00a0above-mentioned    features are very useful. Warm thanks to their developers."
#' stri_locate_all_boundaries(test, type="line")
#' stri_locate_all_boundaries(test, type="word")
#' stri_locate_all_boundaries(test, type="sentence")
#' stri_locate_all_boundaries(test, type="character")
#' stri_locate_all_words(test)
#'
#' @export
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
#' @family text_boundaries
#' @rdname stri_locate_boundaries
stri_locate_all_boundaries <- function(str, omit_no_match=FALSE, ..., opts_brkiter=NULL) {
   if (!missing(...))
       opts_brkiter <- do.call(stri_opts_brkiter, as.list(c(opts_brkiter, ...)))
   .Call(C_stri_locate_all_boundaries, str, omit_no_match, opts_brkiter)
}


#' @export
#' @rdname stri_locate_boundaries
stri_locate_last_boundaries <- function(str, ..., opts_brkiter=NULL) {
   if (!missing(...))
       opts_brkiter <- do.call(stri_opts_brkiter, as.list(c(opts_brkiter, ...)))
   .Call(C_stri_locate_last_boundaries, str, opts_brkiter)
}


#' @export
#' @rdname stri_locate_boundaries
stri_locate_first_boundaries <- function(str, ..., opts_brkiter=NULL) {
   if (!missing(...))
       opts_brkiter <- do.call(stri_opts_brkiter, as.list(c(opts_brkiter, ...)))
   .Call(C_stri_locate_first_boundaries, str, opts_brkiter)
}


#' @export
#' @rdname stri_locate_boundaries
stri_locate_all_words <- function(str, omit_no_match=FALSE, locale=NULL) {
   stri_locate_all_boundaries(str, omit_no_match,
      opts_brkiter=stri_opts_brkiter(type="word", skip_word_none=TRUE, locale=locale))
}


#' @export
#' @rdname stri_locate_boundaries
stri_locate_last_words <- function(str, locale=NULL) {
   stri_locate_last_boundaries(str,
      opts_brkiter=stri_opts_brkiter(type="word", skip_word_none=TRUE, locale=locale))
}


#' @export
#' @rdname stri_locate_boundaries
stri_locate_first_words <- function(str, locale=NULL) {
   stri_locate_first_boundaries(str,
      opts_brkiter=stri_opts_brkiter(type="word", skip_word_none=TRUE, locale=locale))
}
