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



#' Extract Substrings From a Character Vector
#' 
#' The indices given are, of course, Unicode codepoint-based,
#' and not byte-based.
#' 
#' @param str character vector 
#' @param from integer vector or two-column matrix
#' @param to integer vector, mutually exclusive with \code{length} and \code{from} being a matrix
#' @param length integer vector, mutually exclusive with \code{to} and \code{from} being a matrix
#' 
#' @details 
#' Vectorized over \code{s}, \code{from} and (\code{to} or \code{length}).
#' \code{to} and \code{length} are mutually exclusive.
#' 
#' \code{to} has priority over \code{length}. 
#' If \code{from} is a two column matrix, then the first column is used 
#' as \code{from} and second as \code{to}. Also in such case arguments
#' \code{to} and \code{length} are ignored.
#' 
#' The indices are 1-based, is index 1 denotes the first character
#' in a string. \code{to} means the last index of the substring, inclusive.
#' 
#' For negative indices in \code{from} or \code{to},
#' the counting starts at the end of the string.
#' E.g. index -1 denotes the last code point in the string.
#' Negative \code{length} means counting backwards.
#' 
#' In case of out-of-bound indices, they are silently corrected.
#' 
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_sub(s, from=1:3*6, to=21)
#' stri_sub(s, from=c(1,7,13), length=5)
#' stri_sub(s, from=1, length=1:3)
#' stri_sub(s, -17, -7)
#' stri_sub(s, -5, length=4)
#' 
#' @family indexing
#' @export
stri_sub <- function(str, from = 1L, to = -1L, length) {
#    # prepare_arg done internally
#    if(is.matrix(from) && ncol(from) == 2){
#       if(!missing(to) || !missing(length))
#          warning("'from' is matrix, so 'to' and 'length' are ignored")
#       to   <- from[ , 2]
#       from <- from[ , 1]
#    }else if(missing(to) && !missing(length)){
#       to <- from + length -1
#       # if from <0 then counting is done from the end of string, so if
#       #from=-3 and length=2 then from=-3 and to=-2 so it's ok, but if
#       #from=-3 and length=4 then from=-3 and to=0 => empty string(incorrect)
#       #that's why we need this:
#       w <- from < 0 & to >= 0
#       to[w] <- -1
#       #if length is negative then return an empty string
#       w <- length <= 0
#       to[w] <- 0
#    }
   # Whoaaa! One of the longest-code R functions in stringi :)
   if (missing(length)) {
      if (!missing(length))
         warning("argument `length` is ignored in given context")
      if (is.matrix(from) && !missing(to))
         warning("argument `to` is ignored in given context")
      .Call("stri_sub_from_to", str, from, to, PACKAGE="stringi")
   }
   else {
      if (!missing(to))
         warning("argument `to` is ignored in given context")
      .Call("stri_sub_from_length", str, from, length, PACKAGE="stringi")
   }
}


#' Replace substrings in a character vector
#' 
#' Vectorized over \code{s}, \code{from}, (\code{to} or \code{length}) and \code{value}.
#' 
#' @usage stri_sub(str, from=1, to=-1, length) <- value
#' @param str character vector 
#' @param from integer vector or two-column matrix
#' @param to integer vector
#' @param length integer vector
#' @param value
#' 
#' @details \code{to} has priority over \code{length}
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_sub(s, 1, 5) <- "stringi" ; s
#' stri_sub(s, -6, length=5) <- "." ; s
#' stri_sub(s, 1, 1:3) <- 1:2 ; s
#' 
#' @family indexing
#' 
#' @export
"stri_sub<-" <- function(str, from = 1L, to = -1L, length, value) {
   # prepare_arg done internally
   if(is.matrix(from) && ncol(from) == 2){
      if(!missing(to) || !missing(length))
         warning("'from' is matrix, so 'to' and 'length' are ignored")
      to   <- from[ , 2]
      from <- from[ , 1]
   }else if(missing(to) && !missing(length)){
      to <- from + length -1
      # if from <0 then counting is done from the end of string, so if
      #from=-3 and length=2 then from=-3 and to=-2 so it's ok, but if
      #from=-3 and length=4 then from=-3 and to=0 => empty string(incorrect)
      #that's why we need this:
      w <- from < 0 & to >= 0
      to[w] <- -1
      #if length is negative then return an empty string
      w <- length <= 0
      to[w] <- 0
   }
   .Call("stri_sub_op", str, from, to, value, PACKAGE="stringi")
}

