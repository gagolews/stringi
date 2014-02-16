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
