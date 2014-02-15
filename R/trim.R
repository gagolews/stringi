## This file is part of the 'stringi' library.
##
## Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.


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
