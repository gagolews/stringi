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

invisible(NULL)


# # Check R encoding marking [internal, DEBUG only]
# #
# # This is an internal function (no-export & no-manual) - test how R marks
# # ASCII/LATIN1/UTF8/BYTES encodings (see also \code{?Encoding}).
# #
# # Results are printed on STDERR
# #
# # @param str character vector
# # @return who cares
# stri_test_Rmark <- function(str) {
#    invisible(.Call("stri_test_Rmark", str, PACKAGE="stringi"))
# }
#
#
#
# # For testing StriContainerUTF16's performance [internal, DEBUG only]
# #
# # @param str character vector
# # @return who cares
# stri_test_UnicodeContainer16 <- function(str) {
#    .Call("stri_test_UnicodeContainer16", str, PACKAGE="stringi")
# }
#
#
# # For testing StriContainerUTF8's performance [internal, DEBUG only]
# #
# # @param str character vector
# # @return who cares
# stri_test_UnicodeContainer8 <- function(str) {
#    .Call("stri_test_UnicodeContainer8", str, PACKAGE="stringi")
# }
#
#
#
# # For testing .Call performance [internal, DEBUG only]
# #
# # @param str some object
# # @return \code{str}
# stri_test_returnasis <- function(x) {
#    .Call("stri_test_returnasis", x, PACKAGE="stringi")
# }
