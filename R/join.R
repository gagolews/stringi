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
#' Duplicate Strings
#'
#' @description
#' Duplicates each string \code{times} times
#' and concatenates the results.
#'
#' @details
#' Vectorized over \code{str} and \code{times}.
#'
#' @param str character vector of strings to be duplicated
#' @param times integer vector with the numbers of times to duplicate each string
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
#' However, note that joining 3 vectors, e.g. \code{e1 \%+\% e2 \%+\% e3}
#' is slower than \code{\link{stri_join}(e1, e2, e3, sep="")},
#' because it creates a new (temporary) result vector each time
#' the operator is applied.
#'
#'
#' @param e1 character vector or an object coercible to a character vector
#' @param e2 character vector or an object coercible to a character vector
#'
#' @return Returns a character vector.
#'
#'
#' @examples
#' c('abc', '123', '\u0105\u0104') %stri+% letters[1:6]
#' 'ID_' %stri+% 1:5
#'
#' @rdname oper_plus
#'
#' @usage
#' e1 \%s+\% e2
#'
#' @export
"%s+%" <- function(e1, e2) {
   .Call(C_stri_join2_nocollapse, e1, e2)
}

#' @usage
#' e1 \%stri+\% e2
#' @rdname oper_plus
#' @export
"%stri+%" <- function(e1, e2) {
   .Call(C_stri_join2_nocollapse, e1, e2)
}


#' @title
#' Concatenate Character Vectors
#'
#' @description
#' These are the \pkg{stringi}'s equivalents of the built-in
#' \code{\link{paste}} function.
#' \code{stri_c} and \code{stri_paste} are aliases for \code{stri_join}.
#' Use whichever you want, they are exactly the same.
#'
#' @details
#' Vectorized over each vector in `\code{...}`.
#'
#' If \code{collapse} is not \code{NULL}, then the result will be a single string.
#' Otherwise, you will get a character vector of length equal
#' to the length of the longest argument.
#'
#' If any of the arguments in `\code{...}` is a vector of length 0
#' (not to be confused with vectors of empty strings)
#' and \code{ignore_null=FALSE}, then
#' you will get a 0-length character vector in result.
#'
#' If \code{collapse} or \code{sep} has length > 1, then only first string
#' will be used.
#'
#' In case of any \code{NA} in an input vector,
#' \code{NA} is set to the corresponding element.
#' Note that this behavior is different from \code{\link{paste}},
#' which treats missing values as ordinary strings \code{"NA"}.
#' Moreover, as usual in \pkg{stringi}, the resulting strings are
#' always in UTF-8.
#'
#' @param ... character vectors (or objects coercible to character vectors)
#' which corresponding elements are to be concatenated
#' @param sep single string; separates terms
#' @param collapse single string or \code{NULL}; an optional
#' results separator
#' @param ignore_null single logical value; if \code{TRUE}, then empty
#' vectors on input are silently ignored
#'
#' @return Returns a character vector.
#'
#' @export
#' @examples
#' stri_join(1:13, letters)
#' stri_join(1:13, letters, sep='!')
#' stri_join(1:13, letters, collapse='?')
#' stri_join(1:13, letters, sep='!', collapse='?')
#' stri_join(c('abc', '123', '\u0105\u0104'),'###', 1:5, sep='...')
#' stri_join(c('abc', '123', '\u0105\u0104'),'###', 1:5, sep='...', collapse='?')
#'
#' do.call(stri_c, list(c("a", "b", "c"), c("1", "2"), sep='!'))
#' do.call(stri_c, list(c("a", "b", "c"), c("1", "2"), sep='!', collapse='$'))
#'
#' @family join
#' @rdname stri_join
stri_join <- function(..., sep="", collapse=NULL, ignore_null=FALSE) {
   .Call(C_stri_join_withcollapse, list(...), sep, collapse, ignore_null)
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
#' If you wish to use some more fancy (e.g. differing)
#' separators between flattened strings,
#' call \code{\link{stri_join}(str, separators, collapse='')}.
#'
#' If \code{str} is not empty, then a single string is returned.
#' If \code{collapse} has length > 1, then only first string
#' will be used.
#'
#' @param str vector of strings to be coerced to character
#' @param collapse single string denoting the separator
#'
#' @return
#' Returns a single string, i.e. a character
#' vector of length 1.
#'
#' @examples
#' stri_flatten(LETTERS)
#' stri_flatten(LETTERS, collapse=",")
#' stri_flatten(c('abc', '123', '\u0105\u0104'))
#' stri_flatten(stri_dup(letters[1:6],1:3))
#'
#' @export
#' @family join
stri_flatten <- function(str, collapse="") {
   .Call(C_stri_flatten_withressep, str, collapse)
}
