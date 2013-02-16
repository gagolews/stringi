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
   # prepare_arg done internally in stri_sub
   
   from <- stri_locate_first_class(str, stri_char_getpropertyid("^WHITE_SPACE"))
   to <- stri_locate_last_class(str,    stri_char_getpropertyid("^WHITE_SPACE"))
   from[is.na(from)] <- 0 # this will return an empty string
   to[is.na(to)] <- 0
   stri_sub(str, from, to)
   
#    .Call("stri_trim", str, PACKAGE="stringi")
}



#' Trim whitespaces from left side of strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_ltrim <- function(str) {
   # prepare_arg done internally in stri_sub
   
   from <- stri_locate_first_class(str, stri_char_getpropertyid("^WHITE_SPACE"))
   from[is.na(from)] <- 0 # this will return an empty string
   #any idea how to improve this two lines?
   to <- rep(-1,length(from))
   to[from==0] <- 0
   stri_sub(str, from, to)
#   .Call("stri_ltrim", str, PACKAGE="stringi")
}


#' Trim whitespaces from right side of strings
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_rtrim <- function(str) {
   # prepare_arg done internally in stri_sub
   
   to <- stri_locate_last_class(str,stri_char_getpropertyid("^WHITE_SPACE"))
   to[is.na(to)] <- 0 # this will return an empty string
   stri_sub(str, 1, to)
#   .Call("stri_rtrim", str, PACKAGE="stringi")
}

#' Trim all unnecessary double whitespaces from string
#' 
#' @param str will be coerced to character
#' @return trimmed character vector 
#' @export
stri_trim_all <- function(str) {
   # prepare_arg done internally
   subs <- stri_locate_all_class(str,stri_char_getpropertyid("^WHITE_SPACE"))
   n <- length(str)
   ret <- character(n)
   for(i in 1:n){
      if(is.na(str[i])){
         ret[i] <- NA
         next;
      }
      from <- subs[[i]][,1]
      to <- subs[[i]][,2]
      if(is.na(from) || is.na(to)){
         ret[i] <- ""
         next;
      }
      ret[i] <- stri_flatten(stri_split_pos(str[i],from,to)," ")
   }
      
   return(ret)
   #.Call("stri_trim_all", str, PACKAGE="stringi")
}

#' Pad a string
#' 
#' Add whitespace at the begining or/and at the end of string.
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

