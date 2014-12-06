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
#' Extract Words from a Text
#'
#' @description
#' This function extracts all words from each string.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' Just like in the case of \code{\link{stri_locate_all_words}}
#' and \code{\link{stri_count_words}},
#' \pkg{ICU}'s word \code{BreakIterator} iterator is used
#' to locate word boundaries, and all non-word characters
#' (\code{UBRK_WORD_NONE} rule status) are ignored.
#' This is function is equivalent to a call to
#' \code{\link{stri_split_boundaries}(str, type="word", skip_word_none=TRUE, locale=locale)}
#'
#'
#' @param str character vector or an object coercible to
#' @param omit_no_match single logical value; if \code{FALSE},
#' then a missing value will indicate that there are no words
#' @param simplify single logical value;
#' if \code{TRUE} or \code{NA}, then a character matrix is returned;
#' otherwise (the default), a list of character vectors is given, see Value
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}.
#'
#' @return
#' If \code{simplify=FALSE} (the default), then a
#'  list of character vectors is returned. Each string consists of
#' a separate word. In case of \code{omit_no_match=FALSE} and
#' if there are no words or if a string is missing,
#' a single \code{NA} is provided on output.
#'
#' Otherwise, \code{\link{stri_list2matrix}} with \code{byrow=TRUE} argument
#' is called on the resulting object.
#' In such a case, a character matrix with \code{length(str)} rows
#' is returned. Note that \code{\link{stri_list2matrix}}'s \code{fill} argument
#' is set to an empty string and \code{NA},
#' for \code{simplify} equal to \code{TRUE} and \code{NA}, respectively.
#'
#'
#' @examples
#' stri_extract_all_words("stringi: THE string processing package 123.48...")
#'
#' @export
#' @family search_extract
#' @family locale_sensitive
#' @family text_boundaries
#' @rdname stri_extract_words
stri_extract_all_words <- function(str, simplify=FALSE, omit_no_match=FALSE, locale=NULL) {
   res <- stri_split_boundaries(str, simplify=FALSE,
      opts_brkiter=stri_opts_brkiter(type="word", skip_word_none=TRUE, locale=locale))
   if (!omit_no_match) # auto arg check
      res[sapply(res, length) == 0] <- NA_character_
   if (simplify) # auto arg check
      stri_list2matrix(res, byrow=TRUE)
   else
      res
}


#' @export
#' @rdname stri_extract_words
stri_extract_first_words <- function(str, locale=NULL) {
   stri_sub(str, stri_locate_first_boundaries(str,
      opts_brkiter=stri_opts_brkiter(type="word", skip_word_none=TRUE, locale=locale)))
}


#' @export
#' @rdname stri_extract_words
stri_extract_last_words <- function(str, locale=NULL) {
   stri_sub(str, stri_locate_last_boundaries(str,
      opts_brkiter=stri_opts_brkiter(type="word", skip_word_none=TRUE, locale=locale)))
}
