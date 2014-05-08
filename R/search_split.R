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
#' Split up a String by a Character Class
#'
#' @description
#' Splits each element of \code{str} into substrings.
#' \code{pattern} indicates delimiters that separate
#' the input into fields. The input data between the matches become
#' the fields themselves.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max},
#' and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during the split process: if it is
#' set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector specifying character classes to match,
#' see \link{stringi-search-charclass}
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#'
#' @return Returns a list of character vectors.
#'
#'
#' @examples
#' stri_split_charclass("Lorem ipsum dolor sit amet", "\\p{WHITE_SPACE}")
#' stri_split_charclass(" Lorem  ipsum dolor", "\\p{WHITE_SPACE}", n=3,
#'    omit_empty=c(FALSE, TRUE))
#'
#' @export
#' @rdname stri_split_charclass
#' @aliases stri_split_charclass
#' @family search_charclass
#' @family search_split
stri_split_charclass <- function(str, pattern, n_max=-1L, omit_empty=FALSE) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   .Call("stri_split_charclass", str, pattern, n_max, omit_empty, PACKAGE="stringi")
}


#' @title
#' Split up a String By Regex Pattern Matches
#'
#' @description
#' Splits each element of \code{str} into substrings.
#' A \code{pattern} indicates delimiters that separate
#' the input into fields. The input data between the matches become
#' the fields themselves.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max},
#' and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#'
#' Note that if you want to split a string by characters from a
#' specific class (e.g. whitespaces), \code{\link{stri_split_charclass}}
#' will be a little bit faster.
#'
#' @param str character vector with strings to search in
#' @param pattern pattern character; regular expressions
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#' @param opts_regex a named list as generated with \code{\link{stri_opts_regex}}
#'
#' @return Returns a list of character vectors.
#'
#'
#' @examples
#' \dontrun{
#' stri_split_regex("Lorem ipsum dolor sit amet",
#'    "\\p{Z}+") # see also stri_split_charclass
#' }
#'
#' @export
#' @rdname stri_split_regex
#' @aliases stri_split_regex
#' @family search_regex
#' @family search_split
stri_split_regex <- function(str, pattern, n_max=-1L, omit_empty=FALSE, opts_regex=list())  {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   .Call("stri_split_regex", str, pattern, n_max, omit_empty, opts_regex, PACKAGE="stringi")
}


#' @title
#' Split up a String By Fixed Pattern Matches
#'
#' @description
#' Splits each element of \code{str} into substrings.
#' \code{pattern} indicates delimiters that separate
#' the input into fields. The input data between the matches become
#' the fields themselves.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max}, and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#'
#' For natural language processing this function may be not give
#' you desired results. Refer to \link{stringi-search-fixed} for more details.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector with fixed patterns
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#'
#' @return Returns a list of character vectors.
#'
#'
#' @examples
#' \dontrun{
#' stri_split_fixed("Lorem ipsum dolor sit amet", " ")
#' }
#'
#' @export
#' @family search_fixed
#' @family search_split
stri_split_fixed <- function(str, pattern, n_max=-1L, omit_empty=FALSE) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   .Call("stri_split_fixed", str, pattern, n_max, omit_empty, PACKAGE="stringi")
}


#' @title
#' Split up a String By Canonically Equivalent Pattern Matches
#'
#' @description
#' Splits each element of \code{str} into substrings.
#' \code{pattern} indicates delimiters that separate
#' the input into fields. The input data between the matches become
#' the fields themselves. 
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max}, and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#' 
#' This is a locale-sensitive text operation.
#' See \link{stringi-search-coll} for more details on
#' locale-sensitive text searching in \pkg{stringi}.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector with fixed patterns
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options.
#'
#' @return Returns a list of character vectors.
#'
#' @export
#' @family search_coll
#' @family search_split
#' @family locale_sensitive
stri_split_coll <- function(str, pattern, n_max=-1L, omit_empty=FALSE, opts_collator=NULL) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   .Call("stri_split_coll", str, pattern, n_max, omit_empty, opts_collator, PACKAGE="stringi")
}


#' @title
#' Split a String Into Fields
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_split_regex}},
#' \code{\link{stri_split_fixed}}, \code{\link{stri_split_coll}},
#' or \code{\link{stri_split_charclass}},
#' depending on the argument used.
#'
#' Unless you are a very lazy person, please call the underlying functions
#' directly for better performance.
#'
#'
#' @param str character vector of strings to be split
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns a list of character vectors.
#'
#'
#' @export
#' @family search_split
stri_split <- function(str, ..., regex, fixed, coll, charclass) {
   if (!missing(regex))
      stri_split_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_split_fixed(str, fixed, ...)
   else if (!missing(coll))
      stri_split_coll(str, coll, ...)
   else if (!missing(charclass))
      stri_split_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")
}


#' @title
#' Split Strings into Text Lines
#'
#' @description
#' These functions split each character string
#' into text lines.
#'
#' @details
#' Vectorized over \code{str}, \code{n_max}, and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
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
#' @param n_max integer vector, maximal number of pieces to return
#'    [\code{stri_split_lines}  only]
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
#' @export
#' @rdname stri_split_lines
#' @aliases stri_split_lines stri_split_lines1
stri_split_lines <- function(str, n_max=-1L, omit_empty=FALSE) {
   .Call("stri_split_lines", str, n_max, omit_empty, PACKAGE="stringi")
}


#' @rdname stri_split_lines
#' @export
stri_split_lines1 <- function(str) {
   .Call("stri_split_lines1", str, PACKAGE="stringi")
}


#' @title
#' Split Strings at Specific Text Boundaries
#'
#' @description
#' This function locates specific text boundaries
#' (like character, word, line, or sentence boundaries)
#' and splits strings at the indicated positions.
#'
#' @details
#' Vectorized over \code{str} and \code{boundary}.
#'
#' Text boundary analysis is the process of locating linguistic boundaries
#' while formatting and handling text. Examples of this process include:
#'
#' \itemize{
#' \item Locating appropriate points to word-wrap text to fit
#' within specific margins while displaying or printing.
#' \item Counting characters, words, sentences, or paragraphs.
#' \item Making a list of the unique words in a document.
#' \item Capitalizing the first letter of each word.
#' \item Locating a particular unit of the text (For example,
#' finding the third word in the document).
#' }
#'
#' This function uses \pkg{ICU}'s \code{BreakIterator} to split given
#' strings at specific boundaries.
#' The \code{character} boundary iterator tries to match what a user would think
#' of as a ``character''  -- a basic unit of a writing system for a
#' language -- which may be more than just a single Unicode code point.
#' The \code{word} boundary iterator locates the boundaries of words, for purposes
#' such as ``Find whole words'' operations.
#' The \code{line_break} iterator locates positions that would
#' be appropriate points to wrap lines when displaying the text.
#' On the other hand, a \code{sentence}-break iterator
#' locates sentence boundaries.
#'
#' For technical details on different classes of text boundaries refer
#' to the \pkg{ICU} User Guide, see below.
#' For extracting individual words from the text
#' using a \code{BreakIterator}, see \code{\link{stri_extract_words}}.
#'
#' @param str character vector or an object coercible to
#' @param boundary character vector, each string is one of \code{character},
#' \code{line-break}, \code{sentence}, or \code{word}
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}.
#'
#' @return
#' Returns a list of character vectors.
#'
#' @examples
#' \dontrun{
#' stri_split_boundaries("The\u00a0above-mentioned packages are...", boundary='line')
#' }
#'
#' @export
#' @family search_split
#' @family locale_sensitive
#' @family text_boundaries
#' @references
#' \emph{Boundary Analysis} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/boundaryanalysis}
stri_split_boundaries <- function(str, boundary='line-break', locale=NULL) {
   .Call("stri_split_boundaries", str, boundary, locale, PACKAGE="stringi")
}


# @TODO: ADD stri_split_chars - split into chars
# @TODO: ADD stri_split_pos


# #' Split the elements of a character vector by position
# #'
# #'
# #' @param str character vector to split
# #' @param split character element
# #' @param from integer vector
# #' @param to integer vector
# #' @return A list of the same length as the longest of vectors: str, split and omitempty. Shorter vectors are recycled. The i-th element of list contains splitted str[i] character vectors
# #'
# #' @examples
# #' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
# #' stri_split_pos(s,c(1,4),c(3,6))
# #'
# #' @export
# stri_split_pos <- function(str, from, to) {
# #    if(is.matrix(from) && ncol(from) == 2){
# #       if(!missing(to))
# #          warning("'from' is matrix, so 'to' is ignored")
# #       to   <- from[ , 2]
# #       from <- from[ , 1]
# #    }
# #    .Call("stri_split_pos", str, from, to, PACKAGE="stringi")
# }
