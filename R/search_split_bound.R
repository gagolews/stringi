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
#' These functions split each character string into text lines.
#'
#' @details
#' Vectorized over \code{str} and \code{omit_empty}.
#'
#' \code{omit_empty} is applied during splitting. If it is set to \code{TRUE},
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
#' Each match is used to split a text line. For efficiency reasons, the search
#' here is not performed by the regex engine, however.
#'
#'
#' @param str character vector (\code{stri_split_lines})
#'        or a single string (\code{stri_split_lines1})
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#'    [\code{stri_split_lines} only]
#'
#' @return \code{stri_split_lines} returns a list of character vectors.
#' If any input string is \code{NA}, then the corresponding list element
#' is a single \code{NA} string.
#'
#' \code{stri_split_lines1(str)} is equivalent to
#' \code{stri_split_lines(str[1])[[1]]} (with default parameters),
#' thus it returns a character vector. Moreover, if the input string ends at
#' a newline sequence, the last empty string is omitted from the result.
#' Therefore, this function may be handy if you wish to split a loaded text
#' file into text lines.
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
   .Call(C_stri_split_lines, str, omit_empty)
}


#' @rdname stri_split_lines
#' @export
stri_split_lines1 <- function(str) {
   .Call(C_stri_split_lines1, str)
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
#' Vectorized over \code{str} and \code{n}.
#'
#' If \code{n} is negative (default), then all pieces are extracted.
#' Otherwise, if \code{tokens_only} is \code{FALSE} (this is the default,
#' for compatibility with the \pkg{stringr} package), then \code{n-1}
#' tokes are extracted (if possible) and the \code{n}-th string
#' gives the (non-split) remainder (see Examples).
#' On the other hand, if \code{tokens_only} is \code{TRUE},
#' then only full tokens (up to \code{n} pieces) are extracted.
#'
#' For more information on the text boundary analysis
#' performed by \pkg{ICU}'s \code{BreakIterator}, see
#' \link{stringi-search-boundaries}.
#'
#' @param str character vector or an object coercible to
#' @param n integer vector, maximal number of strings to return
#' @param tokens_only single logical value; may affect the result if \code{n}
#' is positive, see Details
#' @param simplify single logical value; if \code{TRUE} or \code{NA},
#' then a character matrix is returned; otherwise (the default), a list of
#' character vectors is given, see Value
#' @param opts_brkiter a named list with \pkg{ICU} BreakIterator's settings
#' as generated with \code{\link{stri_opts_brkiter}}; \code{NULL} for the
#' default break iterator, i.e. \code{line_break}
#' @param ... additional settings for \code{opts_brkiter}
#'
#' @return If \code{simplify=FALSE} (the default),
#' then the functions return a list of character vectors.
#'
#' Otherwise, \code{\link{stri_list2matrix}} with \code{byrow=TRUE}
#' and \code{n_min=n} arguments is called on the resulting object.
#' In such a case, a character matrix with \code{length(str)} rows
#' is returned. Note that \code{\link{stri_list2matrix}}'s \code{fill}
#' argument is set to an empty string and \code{NA},
#' for \code{simplify} equal to \code{TRUE} and \code{NA}, respectively.
#'
#' @examples
#' test <- "The\u00a0above-mentioned    features are very useful. " %s+%
#'    "Warm thanks to their developers. 123 456 789"
#' stri_split_boundaries(test, type="line")
#' stri_split_boundaries(test, type="word")
#' stri_split_boundaries(test, type="word", skip_word_none=TRUE)
#' stri_split_boundaries(test, type="word", skip_word_none=TRUE, skip_word_letter=TRUE)
#' stri_split_boundaries(test, type="word", skip_word_none=TRUE, skip_word_number=TRUE)
#' stri_split_boundaries(test, type="sentence")
#' stri_split_boundaries(test, type="sentence", skip_sentence_sep=TRUE)
#' stri_split_boundaries(test, type="character")
#'
#' @export
#' @family search_split
#' @family locale_sensitive
#' @family text_boundaries
stri_split_boundaries <- function(str, n=-1L,
      tokens_only=FALSE, simplify=FALSE, ..., opts_brkiter=NULL) {
   if (!missing(...))
       opts_brkiter <- do.call(stri_opts_brkiter, as.list(c(opts_brkiter, ...)))
   .Call(C_stri_split_boundaries, str, n, tokens_only, simplify, opts_brkiter)
}
