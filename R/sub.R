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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' @title
#' Extract Substrings From or Replace Substring In a Character Vector
#' 
#' @description
#' The first function extracts substrings under given codepoint-based
#' index ranges. The second one allows us to substitute substrings
#' with given strings.
#' 
#' @details 
#' Vectorized over \code{str}, [\code{value}], \code{from} and (\code{to} or \code{length}).
#' \code{to} and \code{length} are mutually exclusive.
#' 
#' \code{to} has priority over \code{length}. 
#' If \code{from} is a two column matrix, then the first column is used 
#' as \code{from} and second as \code{to}. Also in such case arguments
#' \code{to} and \code{length} are ignored.
#' 
#' The indices given are, of course, Unicode codepoint-based,
#' and not byte-based.
#' Note that for some Unicode strings, the extracted substrings may not
#' be well-formed, especially if the input is not in the NFC normalization
#' from, includes byte order marks, Bidirectional text marks, and so on.
#' Handle with care.
#' 
#' Moreover, indices are 1-based, is index 1 denotes the first character
#' in a string, which gives a typical R look-and-feel.
#' Argument \code{to} defines the last index of the substring, inclusive.
#' 
#' For negative indices in \code{from} or \code{to},
#' the counting starts at the end of the string.
#' E.g. index -1 denotes the last code point in the string.
#' Negative \code{length} means counting backwards.
#' 
#' 
#' For \code{stri_sub}, in case of out-of-bound indices, they are silently corrected.
#' If \code{from} > \code{to}, then an empty string is returned.
#' 
#' For \code{stri_sub<-}, and strange configurations of indices, you'll get
#' string concatenation to front, back, or middle.
#' 
#' @param str character vector 
#' @param from integer vector or two-column matrix
#' @param to integer vector, mutually exclusive with \code{length} and \code{from} being a matrix
#' @param length integer vector, mutually exclusive with \code{to} and \code{from} being a matrix
#' @param value character vector to be substituted [replacement function]
#' 
#' 
#' @return character vector
#' 
#' Standard extract function
#' returns the desired substrings. The replacement function
#' returns the character vector with given substrings substituted
#' with \code{value}.
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_sub(s, from=1:3*6, to=21)
#' stri_sub(s, from=c(1,7,13), length=5)
#' stri_sub(s, from=1, length=1:3)
#' stri_sub(s, -17, -7)
#' stri_sub(s, -5, length=4)
#' (stri_sub(s, 1, 5) <- "stringi")
#' (stri_sub(s, -6, length=5) <- ".")
#' (stri_sub(s, 1, 1:3) <- 1:2)
#' 
#' @family indexing
#' @rdname stri_sub
#' @export
stri_sub <- function(str, from = 1L, to = -1L, length) {
   # Whoaaa! One of the longest-code R functions in stringi :)
   if (missing(length)) {
      if (is.matrix(from) && !missing(to))
         warning("argument `to` is ignored in given context")
      .Call("stri_sub", str, from, to, NULL, PACKAGE="stringi")
   }
   else {
      if (!missing(to))
         warning("argument `to` is ignored in given context")
      if (is.matrix(from))
         warning("argument `length` is ignored in given context")
      .Call("stri_sub", str, from, NULL, length, PACKAGE="stringi")
   }
}


#' @rdname stri_sub
#' @export
#' @usage stri_sub(str, from = 1L, to = -1L, length) <- value
"stri_sub<-" <- function(str, from = 1L, to = -1L, length, value) {
   # Whoaaa! One of the longest-code R functions in stringi :)
   if (missing(length)) {
      if (is.matrix(from) && !missing(to))
         warning("argument `to` is ignored in given context")
      .Call("stri_sub_replacement", str, from, to, NULL, value, PACKAGE="stringi")
   }
   else {
      if (!missing(to))
         warning("argument `to` is ignored in given context")
      if (is.matrix(from))
         warning("argument `length` is ignored in given context")
      .Call("stri_sub_replacement", str, from, NULL, length, value, PACKAGE="stringi")
   }
}

