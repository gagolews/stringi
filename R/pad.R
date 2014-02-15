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


invisible(NULL) # TO BE DONE, version >= 0.2
#
# #' Pad the start of a string
# #'
# #' Add whitespace at the begining or/and at the end of string.
# #' Works like str_pad but faster and it's vectorized not only over s, but
# #' also over width, side and pad. And works with NA value.
# #'
# #' @param str character vector
# #' @param width pad strings to this minimum width
# #' @param side side on which padding character is added (left, right or both)
# #' @param pad character vector of single padding character (default is space)
# #' @return character vector
# #' @details If string is longer than width, then string is returned unchanged. Look at the example.
# #' @examples
# #' stri_pad("stringi",10,"#")
# #' stri_pad("stringi",5:9,pad="$")
# #' stri_pad("1",3,pad=LETTERS)
# #' @export
# stri_pad <- function(str, length, pad = " ") {
#    # prepare_arg done internally
#    #side <- pmatch(side, c("left", "right", "both"),1,T)
#    .Call("stri_pad", str, length, pad, PACKAGE="stringi")
# }
