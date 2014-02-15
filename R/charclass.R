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
