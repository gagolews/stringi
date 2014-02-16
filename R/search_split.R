## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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
#' @param pattern character vector; identifiers of character classes,
#' see \link{stringi-search-charclass}
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#'
#' @return Returns a list of character vectors.
#'
#'
#' @examples
#' stri_split_charclass("Lorem ipsum dolor sit amet", "WHITE_SPACE")
#' stri_split_charclass(" Lorem  ipsum dolor", "WHITE_SPACE", n=3,
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
#' will be much faster.
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
#' Splits each element of \code{str} into substring.
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
#'
#' Pass \code{opts_collator} that is equal to \code{NA} for a much faster, but
#' locale unaware, (exact) bitwise string comparisons. For natural language text,
#' however, this may not be  what you really want.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector with fixed patterns
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#' @param opts_collator a named list as generated with \code{\link{stri_opts_collator}}
#' with Collator options, or \code{NA} for fast but locale-unaware byte comparison
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
#' @rdname stri_split_fixed
#' @aliases stri_split_fixed
#' @family search_fixed
#' @family search_split
#' @family locale_sensitive
stri_split_fixed <- function(str, pattern, n_max=-1L, omit_empty=FALSE, opts_collator=list()) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   .Call("stri_split_fixed", str, pattern, n_max, omit_empty, opts_collator, PACKAGE="stringi")
}



#' @title
#' Split a String Into Fields
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_split_regex}},
#' \code{\link{stri_split_fixed}}, or \code{\link{stri_split_charclass}},
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
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns a list of character vectors.
#'
#'
#' @export
#' @family search_split
stri_split <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_split_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_split_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_split_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' @title
#' Split a String into Text Lines
#'
#' @description
#' These functions split each character string
#' into text lines.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max}, and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#'
#'
#' Newlines are represented on different platforms e.g. by carriage return
#' (CR, 0x0D), line feed (LF, 0x0A), CRLF, or next line (NEL, 0x85).
#' Moreover, the Unicode Standard defines two unambiguous separator characters,
#' Paragraph Separator (PS, 0x2029) and Line Separator (LS, 0x2028).
#' Sometimes also vertical tab (VT, 0x0B) and form feed (FF, 0x0C)
#' are used.
#'
#' This function follows UTR#18 rules, where a newline sequence
#' corresponds to the following regular expression:
#' \code{(?:\\u\{D A\}|(?!\\u\{D A\})[\\u\{A\}-\\u\{D\}\\u\{85\}\\u\{2028\}\\u\{2029\}]}.
#' Each match is used to split a text line.
#' Of course, the search is not performed via regexes here, for efficiency
#' reasons.
#'
#'
#' @param str character vector
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; determines whether empty
#' strings should be removed from the result
#'
#' @return \code{stri_split_lines} returns a list of character vectors.
#' If any input string is \code{NA}, then the corresponding list element
#' is a \code{NA} string.
#'
#' \code{stri_split_lines1(str)} is like \code{stri_split_lines(str[1])[[1]]}
#' (with default parameters),
#' thus it returns a character vector. Moreover, if the input string ends at
#' a newline sequence, the last empty string is omitted from the result.
#' Therefore, this function is convenient for splitting a loaded text file
#' into lines.
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
