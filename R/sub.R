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
#' Vectorized over s, from and (to or length).
#' 
#' @param str character vector 
#' @param from integer vector 
#' @param to integer vector
#' @param length integer vector
#' 
#' @details to has priority over length
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_sub(s, from=1:3*6, to=21)
#' stri_sub(s, from=c(1,7,13), length=5)
#' stri_sub(s, from=1, length=1:3)
#' stri_sub(s, -17, -7)
#' 
#' @export
stri_sub <- function(str, from = 1L, to = -1L, length) {
	# prepare_arg done internally
   if(is.matrix(from) && ncol(from) == 2){
      if(!missing(to) || !missing(length))
         warning("'from' is matrix, so 'to' and 'length' are ignored")
      to   <- from[ , 2]
      from <- from[ , 1]
   }else if(missing(to) && !missing(length))
      #without pmax, when from=1, length=-1 -> to-1 and you get whole string
         to <- pmax(from + length - 1, 0)
	.Call("stri_sub", str, from, to, PACKAGE="stringi")
}

