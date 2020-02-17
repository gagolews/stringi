## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2020, Marek Gagolewski and other contributors.
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
#' Duplicate Strings
#'
#' @description
#' Duplicates each string \code{times} times
#' and concatenates the results.
#'
#' @details
#' Vectorized over \code{str} and \code{times}.
#'
#' @param str a character vector of strings to be duplicated
#' @param times an integer vector with the numbers of times to duplicate each string
#'
#' @return Returns a character vector of the same length as \code{str}.
#'
#' @export
#' @family join
#' @examples
#' stri_dup("a", 1:5)
#' stri_dup(c("a", NA, "ba"), 4)
#' stri_dup(c("abc", "pqrst"), c(4, 2))
stri_dup <- function(str, times) {
   .Call(C_stri_dup, str, times)
}


#' @title
#' Concatenate Two Character Vectors
#'
#' @description
#' Binary operators for joining (concatenating) two character vectors,
#' with a typical \R look-and-feel.
#'
#' @details
#' Vectorized over \code{e1} and \code{e2}.
#'
#' These operators act like a call to \code{\link{stri_join}(e1, e2, sep="")}.
#' However, note that joining 3 vectors, e.g., \code{e1 \%+\% e2 \%+\% e3}
#' is slower than \code{\link{stri_join}(e1, e2, e3, sep="")},
#' because it creates a new (temporary) result vector each time
#' the operator is applied.
#'
#'
#' @param e1 a character vector or an object coercible to a character vector
#' @param e2 a character vector or an object coercible to a character vector
#'
#' @return Returns a character vector.
#'
#'
#' @examples
#' c('abc', '123', 'xy') %s+% letters[1:6]
#' 'ID_' %s+% 1:5
#'
#' @rdname oper_plus
#' @family join
#'
#' @usage
#' e1 \%s+\% e2
#'
#' @export
"%s+%" <- function(e1, e2) {
   .Call(C_stri_join2, e1, e2)
}


#' @usage
#' e1 \%stri+\% e2
#' @rdname oper_plus
#' @export
"%stri+%" <- function(e1, e2) {
   .Call(C_stri_join2, e1, e2)
}


#' @title
#' Concatenate Character Vectors
#'
#' @description
#' These are the \pkg{stringi}'s equivalents of the built-in
#' \code{\link{paste}} function.
#' \code{stri_c} and \code{stri_paste} are aliases for \code{stri_join}.
#'
#' @details
#' Vectorized over each atomic vector in `\code{...}`.
#'
#' Unless \code{collapse} is \code{NULL}, the result will be a single string.
#' Otherwise, you get a character vector of length equal
#' to the length of the longest argument.
#'
#' If any of the arguments in `\code{...}` is a vector of length 0
#' (not to be confused with vectors of empty strings)
#' and \code{ignore_null=FALSE}, then
#' you will get a 0-length character vector in result.
#'
#' If \code{collapse} or \code{sep} has length greater than 1,
#' then only the first string will be used.
#'
#' In case where there are missing values in any of the input vectors,
#' \code{NA} is set to the corresponding element.
#' Note that this behavior is different from \code{\link{paste}},
#' which treats missing values as ordinary strings like \code{"NA"}.
#' Moreover, as usual in \pkg{stringi}, the resulting strings are
#' always in UTF-8.
#'
#' @param ... character vectors (or objects coercible to character vectors)
#' which corresponding elements are to be concatenated
#' @param sep a single string; separates terms
#' @param collapse a single string or \code{NULL}; an optional
#' results separator
#' @param ignore_null a single logical value; if \code{TRUE}, then empty
#' vectors provided via \code{...} are silently ignored
#'
#' @return Returns a character vector.
#'
#' @export
#' @examples
#' stri_join(1:13, letters)
#' stri_join(1:13, letters, sep=',')
#' stri_join(1:13, letters, collapse='; ')
#' stri_join(1:13, letters, sep=',', collapse='; ')
#' stri_join(c('abc', '123', 'xyz'),'###', 1:6, sep=',')
#' stri_join(c('abc', '123', 'xyz'),'###', 1:6, sep=',', collapse='; ')
#'
#' @family join
#' @rdname stri_join
stri_join <- function(..., sep="", collapse=NULL, ignore_null=FALSE) {
   .Call(C_stri_join, list(...), sep, collapse, ignore_null)
}


#' @rdname stri_join
#' @export
stri_c <- stri_join


#' @rdname stri_join
#' @export
stri_paste <- stri_join


#' @title
#' Flatten a String
#'
#' @description
#' Joins the elements of a character vector into one string.
#'
#' @details
#' The \code{stri_flatten(str, collapse='XXX')} call
#' is equivalent to \code{\link{paste}(str, collapse='XXX', sep="")}.
#'
#' If you wish to use some more fancy (e.g., differing)
#' separators between flattened strings,
#' call \code{\link{stri_join}(str, separators, collapse='')}.
#'
#' If \code{str} is not empty, then a single string is returned.
#' If \code{collapse} has length > 1, then only the first string
#' will be used.
#'
#' @param str a vector of strings to be coerced to character
#' @param collapse a single string denoting the separator
#' @param na_empty single logical value; should missing values
#' in \code{str} be treated as empty strings?
#' @param omit_empty single logical value; should missing values
#' in \code{str} be omitted?
#'
#' @return
#' Returns a single string, i.e., a character
#' vector of length 1.
#'
#' @examples
#' stri_flatten(LETTERS)
#' stri_flatten(LETTERS, collapse=",")
#' stri_flatten(stri_dup(letters[1:6], 1:3))
#' stri_flatten(c(NA, "", "A", "", "B", NA, "C"), collapse=",", na_empty=TRUE, omit_empty=TRUE)
#'
#' @export
#' @family join
stri_flatten <- function(str, collapse="", na_empty=FALSE, omit_empty=FALSE) {
   .Call(C_stri_flatten, str, collapse, na_empty, omit_empty)
}


#' @title
#' Concatenate Strings in a List
#'
#' @description
#' These functions concatenate all the strings in each character vector
#' in a given list.
#' \code{stri_c_list} and \code{stri_paste_list} are aliases for
#' \code{stri_join_list}.
#'
#' @details
#' Unless \code{collapse} is \code{NULL}, the result will be a single string.
#' Otherwise, you get a character vector of length equal
#' to the length of \code{x}.
#'
#' Vectors in \code{x} of length 0 are silently ignored.
#'
#' If \code{collapse} or \code{sep} has length greater than 1,
#' then only the first string will be used.
#'
#' @param x a list consisting of character vectors
#' @param sep a single string; separates strings in each of the character
#' vectors in \code{x}
#' @param collapse a single string or \code{NULL}; an optional
#' results separator
#'
#' @return Returns a character vector.
#'
#' @export
#' @examples
#' stri_join_list(
#'    stri_extract_all_words(c("Lorem ipsum dolor sit amet.",
#'    "Spam spam bacon sausage and spam.")),
#' sep=", ")
#'
#' stri_join_list(
#'    stri_extract_all_words(c("Lorem ipsum dolor sit amet.",
#'    "Spam spam bacon sausage and spam.")),
#' sep=", ", collapse=". ")
#'
#' stri_join_list(
#'    stri_extract_all_regex(
#'       c("spam spam bacon", "123 456", "spam 789 sausage"), "\\p{L}+"
#'    ),
#' sep=",")
#'
#' stri_join_list(
#'    stri_extract_all_regex(
#'       c("spam spam bacon", "123 456", "spam 789 sausage"), "\\p{L}+",
#'       omit_no_match=TRUE
#'    ),
#' sep=",", collapse="; ")
#'
#' @family join
#' @rdname stri_join_list
stri_join_list <- function(x, sep="", collapse=NULL) {
   .Call(C_stri_join_list, x, sep, collapse)
}


#' @rdname stri_join_list
#' @export
stri_c_list <- stri_join_list


#' @rdname stri_join_list
#' @export
stri_paste_list <- stri_join_list
