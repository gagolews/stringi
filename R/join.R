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
#' Duplicates each string \code{times} times. This is done by
#' copying the contents of \code{str} at the end of \code{str}.
#'
#' @details
#' Vectorized over \code{str} and \code{times}.
#'
#' @param str character vector of strings to be duplicated
#' @param times integer vector with the numbers of times to duplicate each string
#'
#' @return Returns a character vector.
#'
#' @export
#' @family join
#' @examples
#' stri_dup("a", 1:5)
#' stri_dup(c("a", NA, "ba"), 4)
#' stri_dup(c("abc", "pqrst"), c(4, 2))
stri_dup <- function(str, times) {
   # prepare_arg done internally
   .Call("stri_dup", str, times, PACKAGE="stringi")
}



#' @title
#' Concatenate Two Character Vectors
#'
#' @description
#' A binary operator for joining (concatenating) two character vectors,
#' with a typical \R look-and-feel.
#'
#' @details
#' Vectorized over \code{e1} and \code{e2}.
#'
#' This operator works like a call to \code{\link{stri_join}(e1, e2, sep="")}
#' (but is slightly faster).
#' However, note that joining 3 vectors, e.g. \code{e1 \%+\% e2 \%+\% e3}
#' is slower than \code{\link{stri_join}(e1, e2, e3, sep="")},
#' because it creates a new (temporary) result vector each time
#' the operator is applied.
#'
#' @usage
#' e1 \%+\% e2
#'
#' @param e1 character vector
#' @param e2 character vector
#'
#' @return Returns a character vector.
#'
#'
#' @examples
#' c('abc','123','\u0105\u0104')%+%letters[1:6]
#' 'ID_'%+%1:5
#' @rdname oper_plus
#' @export
"%+%" <- function(e1, e2) {
   .Call("stri_join2", e1, e2, PACKAGE="stringi")
}


#' @title
#' Concatenate Character Vectors
#'
#' @description
#' This is the \pkg{stringi}'s equivalents of the built-in \code{\link{paste}} function.
#'
#' @details
#' \code{stri_c} and \code{stri_paste} are aliases for \code{stri_join}.
#' Use whichever you want, they are equivalent.
#'
#' If \code{collapse} is not \code{NULL}, then the result will be a single string.
#' Otherwise, you will get a character vector of length equal
#' to the length of the longest argument.
#'
#' If any of the arguments in `\code{...}` is a vector of length 0
#' (not to be confused with vectors of empty strings), then
#' you will get a 0-length character vector in result.
#'
#' If \code{collapse} or \code{sep} has length > 1, then only first string
#' will be used.
#'
#' In case of any \code{NA}, \code{NA} is set to the corresponding element.
#'
#' @param ... character vectors which corresponding elements should be concatenated
#' @param sep single string; separates terms
#' @param collapse single string; separates the results
#'
#' @return Returns a character vector.
#'
#' @export
#' @examples
#' stri_join(1:13, letters)
#' stri_join(c('abc','123','\u0105\u0104'),'###', 1:5, sep='...')
#' stri_join(c('abc','123','\u0105\u0104'),'###', 1:5, sep='...', collapse='?')
#' @family join
#' @rdname stri_join
stri_join <- function(..., sep="", collapse=NULL) {
   .Call("stri_join", list(...), sep, collapse, PACKAGE="stringi")
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
#' \code{stri_flatten(str, collapse='XXX')} works like
#' \code{\link{paste}(str, collapse='XXX', sep="")}.
#'
#' If you wish to use some more fancy \code{collapse} separators
#' between flattened strings,
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
#' stri_flatten(c('abc','123','\u0105\u0104'))
#' stri_flatten(stri_dup(letters[1:6],1:3))
#'
#' @export
#' @family join
stri_flatten <- function(str, collapse="") {
   # prepare_arg done internally
   .Call("stri_flatten", str, collapse, PACKAGE="stringi")
}
