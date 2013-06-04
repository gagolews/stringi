## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus
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
#' Trim Characters from Left or Right Side of a String
#' 
#' @description
#' These functions may e.g. be used to get rid of unnecessary
#' whitespaces from strings. Trimming stops at the first
#' \code{pattern} match.
#' 
#' @details
#' \code{stri_trim} is a convenience function, which dispatches
#' control to \code{stri_trim_*}. Unless you are very lazy, don't use it:
#' it's slower.
#' 
#' Unlike in many other string processing libraries,
#' our trim functions are quite general. A character class
#' given by \code{pattern} 
#' may be adjusted to suit your needs (most often you will use the default
#' value or a charclass negation, e.g. with \code{^} at the begining).
#' 
#' With this function in some cases you may extract very quickly data, which
#' normally requires using regular expressions. E.g. you may get
#' \code{"23.5"} out of \code{"total of 23.5 bitcoins"}.
#' 
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' For trimming whitespaces, please note the difference
#' between Unicode binary property `\code{WHITE_SPACE}` (more general)
#' and general character category `\code{Z}`.
#' 
#' @param str character vector
#' @param pattern character vector with character class identifiers that
#' should be preserved, see !!TODO!!
#' @param mode character [\code{stri_trim} only]; defaults \code{both}
#' @return character vector
#' 
#' @examples
#' stri_trim_left("               aaa")
#' stri_trim_left("total of 23.5 bitcoins", "N")
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



#' @title
#' Trim all unnecessary double whitespaces from string
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' 
#' @family search_trim
#' @family search_charclass
#' @export
stri_trim_all <- function(str) { # rename to stri_trim_double, add pattern
   warning("stri_trim_all: v0.2 TO DO")
   .Call("stri_trim_all", str, PACKAGE="stringi")
}


