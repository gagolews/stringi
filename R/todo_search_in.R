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


invisible(NULL) # TO DO: later (>0.3)

# #' @title
# #' Value Matching
# #'
# #' @description
# #' For each element in \code{str}, this function returns
# #' a position of the first matching element in \code{table}.
# #'
# #' @details
# #' Vectorized over \code{str}.
# #'
# #' This is a dummy wrapper for R's \code{\link{match}} function.
# #' The only difference is that it ensures that the comparison
# #' is made in UTF-8 (by calling \code{\link{stri_enc_toutf8}}).
# #'
# #' It is (most likely) impossible to implement an algorithm
# #' faster than the built-in \code{\link{match}}:
# #' this function uses R's clever, hash table-based, string caching
# #' system directly.
# #'
# #' @param str character vector of strings to search in
# #' @param table character vector of values to be matched against
# #' @param ... further arguments passed to \code{\link{match}}
# #'
# #' @return Returns an integer vector.
# #'
# #' @export
# #' @family search_in
# stri_in_fixed <- function(str, table, ...) {
#    match(stri_enc_toutf8(str), stri_enc_toutf8(table), ...)
# }
