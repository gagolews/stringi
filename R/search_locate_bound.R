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
#' This function locates specific text boundaries
#' (like character, word, line, or sentence boundaries)
#' and splits strings at the indicated positions.
#'
#' @details
#' Vectorized over \code{str} and \code{boundary}.
#'
#' For more information on the text boundary analysis
#' performed by \pkg{ICU}'s \code{BreakIterator}, see
#' \code{\link{stri_split_boundaries}}.
#'
#' For locating words in a text using \pkg{ICU}'s word iterator,
#' see \code{\link{stri_locate_words}}.
#'
#'
#' @param str character vector or an object coercible to
#' @param boundary character vector, each string is one of \code{character},
#' \code{line_break}, \code{sentence}, or \code{word}
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
#' \donttest{
#' stri_locate_boundaries("The\u00a0above-mentioned packages are...", boundary="line")
#' }
#' 
#' @export
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
#' @family text_boundaries
stri_locate_boundaries <- function(str, boundary='line_break', locale=NULL) {
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
#' \donttest{
#' stri_locate_words("  stringi: THE string processing package 123.48...  ")
#' }
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
