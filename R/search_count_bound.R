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
#' Count the Number of Text Boundaries
#'
#' @description
#' This function determines the number of specific text boundaries
#' (like character, word, line, or sentence boundaries) in a string.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' For more information on the text boundary analysis
#' performed by \pkg{ICU}'s \code{BreakIterator}, see
#' \link{stringi-search-boundaries}.
#'
#' In case of \code{stri_count_words},
#' just like in \code{\link{stri_extract_all_words}} and
#' \code{\link{stri_locate_all_words}},
#' \pkg{ICU}'s word \code{BreakIterator} iterator is used
#' to locate word boundaries, and all non-word characters
#' (\code{UBRK_WORD_NONE} rule status) are ignored.
#' This is function is equivalent to a call to
#' \code{\link{stri_count_boundaries}(str, type="word", skip_word_none=TRUE, locale=locale)}
#'
#' Note that a \code{BreakIterator} of type \code{character}
#' may be used to count the number of \emph{Unicode characters} in a string.
#' This may lead to different results than that returned by the
#' \code{\link{stri_length}} function, which is designed to return
#' the number of \emph{Unicode code points}.
#'
#' On the other hand, a \code{BreakIterator} of type \code{sentence}
#' may be used to count the number of sentences in a piece of text.
#'
#'
#' @param str character vector or an object coercible to
#' @param opts_brkiter a named list with \pkg{ICU} BreakIterator's settings
#' as generated with \code{\link{stri_opts_brkiter}};
#' \code{NULL} for default break iterator, i.e. \code{line_break};
#' \code{stri_count_boundaries} only
#' @param ... additional settings for \code{opts_brkiter}
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale};
#' \code{stri_count_words} only
#'
#' @return
#' Both functions return an integer vector.
#'
#' @examples
#' test <- "The\u00a0above-mentioned    features are very useful. Warm thanks to their developers."
#' stri_count_boundaries(test, type="word")
#' stri_count_boundaries(test, type="sentence")
#' stri_count_boundaries(test, type="character")
#' stri_count_words(test)
#'
#' test2 <- stri_trans_nfkd("\u03c0\u0153\u0119\u00a9\u00df\u2190\u2193\u2192")
#' stri_count_boundaries(test2, type="character")
#' stri_length(test2)
#' stri_numbytes(test2)
#'
#' @export
#' @family search_count
#' @family locale_sensitive
#' @family text_boundaries
#' @rdname stri_count_boundaries
stri_count_boundaries <- function(str, ..., opts_brkiter=NULL) {
   if (!missing(...))
       opts_brkiter <- do.call(stri_opts_brkiter, as.list(c(opts_brkiter, ...)))
   .Call(C_stri_count_boundaries, str, opts_brkiter)
}


#' @export
#' @rdname stri_count_boundaries
stri_count_words <- function(str, locale=NULL) {
   stri_count_boundaries(str,
      opts_brkiter=stri_opts_brkiter(type="word", skip_word_none=TRUE, locale=locale))
}
