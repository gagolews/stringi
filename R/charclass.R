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


invisible(NULL) # version >= 0.2


# #' Get character types (general character category identifier)
# #'
# #' Returns the general category value for each *code point* in each string
# #' Same as java.lang.Character.getType()
# #' @param s character vector
# #' @return list of numeric vectors
# #' @seealso \code{\link{stri_charcategories}}, \code{\link{stri_char_getcategoryid}}
# # @export
# #' @family charclass
# stri_chartype <- function(s) {
#    .Call("stri_chartype", s, PACKAGE="stringi")
# }


# #' Get general character categories
# #'
# #' Returns the "modern" names of each Unicode character category
# #' Based on ICU4C/uchar.h
# #' U_UNASSIGNED (id=0) is omitted
# #' @return data frame with 2 columns...
# #' @seealso \code{\link{stri_chartype}}, \code{\link{stri_char_getcategoryid}}
# # @export
# #' @family charclass
# stri_charcategories <- function() {
#    categories <- as.data.frame(.Call("stri_charcategories", PACKAGE="stringi"),
#       stringsAsFactors=FALSE)
#    rownames(categories) <- categories[,2]
#    categories[,-2]
# }
