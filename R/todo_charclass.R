## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2014, Marek Gagolewski and Bartek Tartanus
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## 1. Redistributions of source code must retain the above copyright notice,
## this list of conditions and the following disclaimer.
##
## 2. Redistributions in binary form must reproduce the above copyright notice,
## this list of conditions and the following disclaimer in the documentation
## and/or other materials provided with the distribution.
##
## 3. Neither the name of the copyright holder nor the names of its
## contributors may be used to endorse or promote products derived from
## this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
## "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
## BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
## FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
## OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
## WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
## OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
## EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


invisible(NULL) # TO BE DONE, version >= 0.3


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
#    .Call(C_stri_chartype, s)
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
#    categories <- as.data.frame(.Call(C_stri_charcategories),
#       stringsAsFactors=FALSE)
#    rownames(categories) <- categories[,2]
#    categories[,-2]
# }
