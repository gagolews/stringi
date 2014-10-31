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
#' Split a String Into Text Lines
#'
#' @description
#' These functions split each character string
#' into text lines.
#'
#' @details
#' Vectorized over \code{str} and \code{omit_empty}.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#'
#' Newlines are represented on different platforms e.g. by carriage return
#' (CR, 0x0D), line feed (LF, 0x0A), CRLF, or next line (NEL, 0x85).
#' Moreover, the Unicode Standard defines two unambiguous separator characters,
#' Paragraph Separator (PS, 0x2029) and Line Separator (LS, 0x2028).
#' Sometimes also vertical tab (VT, 0x0B) and form feed (FF, 0x0C)
#' are used. These functions follow UTR#18 rules, where a newline sequence
#' corresponds to the following regular expression:
#' \code{(?:\\u\{D A\}|(?!\\u\{D A\})[\\u\{A\}-\\u\{D\}\\u\{85\}\\u\{2028\}\\u\{2029\}]}.
#' Each match is used to split a text line.
#' For efficiency reasons, the search is not performed via regexes here,
#' however.
#'
#'
#' @param str character vector (\code{stri_split_lines})
#'        or a single string (\code{stri_split_lines1})
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#'    [\code{stri_split_lines}  only]
#'
#' @return \code{stri_split_lines} returns a list of character vectors.
#' If any input string is \code{NA}, then the corresponding list element
#' is a single \code{NA} string.
#'
#' \code{stri_split_lines1(str)} is equivalent to
#' \code{stri_split_lines(str[1])[[1]]} (with default parameters),
#' thus it returns a character vector. Moreover, if the input string ends at
#' a newline sequence, the last empty string is omitted from the result.
#' Therefore, this function is convenient for splitting a loaded text file
#' into text lines.
#'
#' @references
#' \emph{Unicode Newline Guidelines} -- Unicode Technical Report #13,
#' \url{http://www.unicode.org/standard/reports/tr13/tr13-5.html}
#'
#' \emph{Unicode Regular Expressions} -- Unicode Technical Standard #18,
#' \url{http://www.unicode.org/reports/tr18/}
#'
#' @family search_split
#' @family text_boundaries
#' @export
#' @rdname stri_split_lines
#' @aliases stri_split_lines stri_split_lines1
stri_split_lines <- function(str, omit_empty=FALSE) {
   .Call("stri_split_lines", str, omit_empty, PACKAGE="stringi")
}


#' @rdname stri_split_lines
#' @export
stri_split_lines1 <- function(str) {
   .Call("stri_split_lines1", str, PACKAGE="stringi")
}


#' @title
#' Split a String at Specific Text Boundaries
#'
#' @description
#' This function locates specific text boundaries
#' (like character, word, line, or sentence boundaries)
#' and splits strings at the indicated positions.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' For more information on the text boundary analysis
#' performed by \pkg{ICU}'s \code{BreakIterator}, see
#' \link{stringi-search-boundaries}.
#'
#' @param str character vector or an object coercible to
#' @param opts_brkiter a named list with \pkg{ICU} BreakIterator's settings
#' as generated with \code{\link{stri_opts_brkiter}};
#' \code{NULL} for default break iterator, i.e. \code{line_break}
#'
#' @return
#' Returns a list of character vectors.
#'
#' @examples
#' \donttest{
#' test <- "The\u00a0above-mentioned    features are very useful. " %s+%
#'    "Warm thanks to their developers. 123 456 789"
#' stri_split_boundaries(test, stri_opts_brkiter(type="line"))
#' stri_split_boundaries(test, stri_opts_brkiter(type="word"))
#' stri_split_boundaries(test, stri_opts_brkiter(type="word", skip_word_none=TRUE))
#' stri_split_boundaries(test, stri_opts_brkiter(type="word",
#'    skip_word_none=TRUE, skip_word_letter=TRUE))
#' stri_split_boundaries(test, stri_opts_brkiter(type="word",
#'    skip_word_none=TRUE, skip_word_number=TRUE))
#' stri_split_boundaries(test, stri_opts_brkiter(type="sentence"))
#' stri_split_boundaries(test, stri_opts_brkiter(type="sentence", skip_sentence_sep=TRUE))
#' stri_split_boundaries(test, stri_opts_brkiter(type="character"))
#' }
#'
#' @export
#' @family search_split
#' @family locale_sensitive
#' @family text_boundaries
stri_split_boundaries <- function(str, opts_brkiter=NULL) {
   .Call("stri_split_boundaries", str, opts_brkiter, PACKAGE="stringi")
}
