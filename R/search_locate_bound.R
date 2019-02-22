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
#' Locate Text Boundaries
#'
#' @description
#' These functions locate text boundaries
#' (like character, word, line, or sentence boundaries).
#' Use \code{stri_locate_all_*} to locate all the matches.
#' \code{stri_locate_first_*} and \code{stri_locate_last_*}
#' give the first or the last matches, respectively.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' For more information on text boundary analysis
#' performed by \pkg{ICU}'s \code{BreakIterator}, see
#' \link{stringi-search-boundaries}.
#'
#' In case of \code{stri_locate_*_words},
#' just like in \code{\link{stri_extract_all_words}} and \code{\link{stri_count_words}},
#' \pkg{ICU}'s word \code{BreakIterator} iterator is used
#' to locate the word boundaries, and all non-word characters
#' (\code{UBRK_WORD_NONE} rule status) are ignored.
#' This is function is equivalent to a call to
#' \code{stri_locate_*_boundaries(str, type="word", skip_word_none=TRUE, locale=locale)}
#'
#'
#' @param str character vector or an object coercible to
#' @param omit_no_match single logical value; if \code{FALSE},
#' then 2 missing values will indicate that there are no text boundaries
#' @param opts_brkiter a named list with \pkg{ICU} BreakIterator's settings,
#' see \code{\link{stri_opts_brkiter}};
#' \code{NULL} for default break iterator, i.e., \code{line_break}
#' @param ... additional settings for \code{opts_brkiter}
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}
#'
#' @return
#' For \code{stri_locate_all_*}, a list of \code{length(str)} integer matrices
#' is returned. The first column gives the start positions
#' of substrings between located boundaries, and the second column gives
#' the end positions. The indexes are code point-based, thus
#' they may be passed, e.g., to \code{\link{stri_sub}} or \code{\link{stri_sub_all}}.
#' Note that you get two \code{NA}s in one row
#' if there is no match (and \code{omit_no_match} is \code{FALSE})
#' or there are missing data in the input vector.
#'
#' \code{stri_locate_first_*} and \code{stri_locate_last_*},
#' return an integer matrix with
#' two columns, giving the start and end positions of the first
#' or the last matches, respectively, and two \code{NA}s if there is no match.
#'
#' @examples
#' test <- "The\u00a0above-mentioned    features are very useful. Kudos to their developers."
#' stri_locate_all_boundaries(test, type="line")
#' stri_locate_all_boundaries(test, type="word")
#' stri_locate_all_boundaries(test, type="sentence")
#' stri_locate_all_boundaries(test, type="character")
#' stri_locate_all_words(test)
#'
#' stri_extract_all_boundaries("Mr. Jones and Mrs. Brown are very happy.
#' So am I, Prof. Smith.", type="sentence", locale="en_US@ss=standard") # ICU >= 56 only
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
