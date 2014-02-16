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
#' Trim Characters from the Left and/or Right Side of a String
#'
#' @description
#' These functions may be used e.g. to get rid of unnecessary
#' whitespaces from strings. Trimming ends at the first or
#' starts at the last \code{pattern} match.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' \code{stri_trim} is a convenience function, which dispatches
#' control to \code{stri_trim_*}. Unless you are very lazy, do not use it:
#' it is slower.
#'
#' Contrary to many other string processing libraries,
#' our trimming functions are quite general. A character class,
#' given by \code{pattern},
#' may be adjusted to suit your needs (most often you will use the default
#' value or a negation of some character class, i.e. with \code{^}
#' at the beginning).
#'
#' With these functions you may very quickly extract data, which
#' in some cases require using regular expressions. E.g. you may get
#' \code{"23.5"} out of \code{"total of 23.5 bitcoins"}.
#'
#' For trimming whitespaces, please note the difference
#' between Unicode binary property `\code{WHITE_SPACE}` (more general)
#' and general character category `\code{Z}`,
#' see \link{stringi-search-charclass}
#'
#' @param str character vector
#' @param pattern character vector with character class identifiers that
#' should be preserved, see \link{stringi-search-charclass},
#' defaults `\code{^WHITE_SPACE}`
#' @param side character [\code{stri_trim} only]; defaults to \code{"both"}
#'
#' @return All these functions return a character vector.
#'
#' @examples
#' stri_trim_left("               aaa")
#' stri_trim_right("rexamine.com/", "^P")
#' stri_trim_both(" Total of 23.5 bitcoins. ", "N")
#' stri_trim_both(" Total of 23.5 bitcoins. ", "L")
#'
#' @aliases stri_trim
#' @family search_trim
#' @family search_charclass
#' @rdname stri_trim
#' @export
stri_trim_both <- function(str, pattern="^WHITE_SPACE") {
   .Call("stri_trim_both", str, pattern, PACKAGE="stringi")
}


#' @rdname stri_trim
#' @export
stri_trim_left <- function(str, pattern="^WHITE_SPACE") {
  .Call("stri_trim_left", str, pattern, PACKAGE="stringi")
}


#' @rdname stri_trim
#' @export
stri_trim_right <- function(str, pattern="^WHITE_SPACE") {
  .Call("stri_trim_right", str, pattern, PACKAGE="stringi")
}


#' @rdname stri_trim
#' @export
stri_trim <- function(str, side=c("both", "left", "right"), pattern="^WHITE_SPACE") {
   # `both` is default for compatibility with stringr
   side <- match.arg(side) # this is slow

   switch(side,
          both  =stri_trim_both(str, pattern),
          left  =stri_trim_left(str, pattern),
          right =stri_trim_right(str, pattern)
   )
}





invisible(NULL) # TO BE DONE, version >= 0.2
# #' @title
# #' Trim All Unnecessary Consecutive Characters
# #'
# #' @description
# #' The function may be used e.g. to get substitute all multiple
# #' whitespaces with a single space.
# #'
# #' @details
# #' Vectorized over \code{str}, \code{pattern}, and \code{leave_first}.
# #'
# #' Hint: to make single `ordinary` spaces to be word separators in a sentence,
# #' call \code{stri_replace_all_charclass(stri_trim_double(str), "WHITE_SPACE", " ")}.
# #' For more complex operations, feel free to use \link{stringi-search-regex}.
# #'
# #' @param str character vector
# #' @param pattern character vector with character class identifiers that
# #' should be preserved, see !!TODO!!
# #' @param leave_first logical; should we leave the first or the last
# #' occurence of \code{pattern} in each seqence?
# #' @return character vector
# #'
# #' @family search_trim
# #' @family search_charclass
# #' @export
# stri_trim_double <- function(str, pattern="^WHITE_SPACE", leave_first=TRUE) {
#    warning("TO DO")
#    .Call("stri_trim_double", str, pattern, leave_first, PACKAGE="stringi")
# }
