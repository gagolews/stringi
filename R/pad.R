## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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
