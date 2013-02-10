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



#' Trim whitespaces from strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_trim <- function(str) {
   # prepare_arg done internally
   .Call("stri_trim", str, PACKAGE="stringi")
}


# TO DO: stri_rtrim

# TO DO: stri_ltrim

#' Trim whitespaces from left side of strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_ltrim <- function(str) {
   # prepare_arg done internally
   .Call("stri_ltrim", str, PACKAGE="stringi")
}


#' Pad a string
#' 
#' Works like str_pad but faster and it's vectorized not only over s, but also over width and side. And works with NA value.
#' 
#' @param str character vector
#' @param width pad strings to this minimum width
#' @param side side on which padding character is added (left, right or both)
#' @param pad single padding character (default is space)
#' @return character vector 
#' @details If string is longer than width, then string is returned unchanged. Look at the example.
#' @examples
#' stri_pad("stringi",10,c("l","r","b"),"#")
#' stri_pad("stringi",5:9,pad="$")
#' @export
stri_pad <- function(str, width, side = "left", pad = " ") {
   # prepare_arg done internally
   side <- pmatch(side, c("left", "right", "both"),1,T)
   .Call("stri_pad", str, width, side, pad, PACKAGE="stringi")
}

