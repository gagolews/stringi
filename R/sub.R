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



#' Extract substrings from a character vector
#' 
#' Vectorized over \code{s}, \code{from} and (\code{to} or \code{length}).
#' 
#' @param str character vector 
#' @param from integer vector or two-column matrix
#' @param to integer vector
#' @param length integer vector
#' 
#' @details \code{to} has priority over \code{length}. If \code{from} is two column matrix then first column is used as \code{from} and second as \code{to}. Also in such case given \code{to} and \code{length} are ignored.
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
#' @seealso \link{stri_sub<-}
#' 
#' @export
stri_sub <- function(str, from = 1L, to = -1L, length) {
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
   .Call("stri_sub", str, from, to, PACKAGE="stringi")
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
#' @seealso \link{stri_sub}, \link{stri_replace_first},
#'          \link{stri_replace_last}, \link{stri_replace_all}.
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

