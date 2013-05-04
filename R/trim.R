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
#    if (length(str) == 0) return(str)
#    from <- as.integer(stri_locate_first_class(str, stri_char_getpropertyid("^WHITE_SPACE"))[,1])
#    to   <- as.integer(stri_locate_last_class(str,  stri_char_getpropertyid("^WHITE_SPACE"))[,1])
#    from[is.na(from)] <- 0 # this will return an empty string
#    to[is.na(to)] <- 0
#    stri_sub(str, from, to)
   .Call("stri_trim", str, PACKAGE="stringi")
}



#' Trim whitespaces from left side of strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_ltrim <- function(str) {
#    if (length(str) == 0) return(str)
#    from <- as.integer(stri_locate_first_class(str, stri_char_getpropertyid("^WHITE_SPACE"))[,1])
#    from[is.na(from)] <- 0 # this will return an empty string
#    to <- rep(-1,length(from))
#    to[from==0] <- 0
#    stri_sub(str, from, to)
  .Call("stri_ltrim", str, PACKAGE="stringi")
}


#' Trim whitespaces from right side of strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_rtrim <- function(str) {
#    if (length(str) == 0) return(str)
#    to <- as.integer(stri_locate_last_class(str,stri_char_getpropertyid("^WHITE_SPACE"))[,1])
#    to[is.na(to)] <- 0 # this will return an empty string
#    stri_sub(str, 1, to)
  .Call("stri_rtrim", str, PACKAGE="stringi")
}

#' Trim all unnecessary double whitespaces from string
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_trim_all <- function(str) {
   # prepare_arg done internally
   .Call("stri_trim_all", str, PACKAGE="stringi")
}

#' Pad a string
#' 
#' Add whitespace at the begining or/and at the end of string.
#' Works like str_pad but faster and it's vectorized not only over s, but 
#' also over width, side and pad. And works with NA value.
#' 
#' @param str character vector
#' @param width pad strings to this minimum width
#' @param side side on which padding character is added (left, right or both)
#' @param pad character vector of single padding character (default is space)
#' @return character vector 
#' @details If string is longer than width, then string is returned unchanged. Look at the example.
#' @examples
#' stri_pad("stringi",10,c("l","r","b"),"#")
#' stri_pad("stringi",5:9,pad="$")
#' stri_pad("1",3,"b",pad=LETTERS)
#' @export
stri_pad <- function(str, width, side = "left", pad = " ") {
   # prepare_arg done internally
   side <- pmatch(side, c("left", "right", "both"),1,T)
   .Call("stri_pad", str, width, side, pad, PACKAGE="stringi")
}

