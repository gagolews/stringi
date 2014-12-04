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


#' @title
#' Convert a List to a Character Matrix
#'
#' @description
#' This function converts a given list of atomic vectors to
#' a character matrix.
#'
#' @details
#' This function is similar to the built-in \code{\link{simplify2array}}
#' function. However, it always returns a character matrix,
#' even if each element in \code{x} is of length 1
#' or if elements in \code{x} are not of the same lengths.
#' Moreover, the elements in \code{x} are always coerced to character vectors.
#'
#' If \code{byrow} is \code{FALSE}, then a matrix with \code{length(x)}
#' columns is returned.
#' The number of rows is the length of the
#' longest vector in \code{x}, but no less than \code{n_min}. Basically, we have
#' \code{result[i,j] == x[[j]][i]} if \code{i <= length(x[[j]])}
#' and \code{result[i,j] == fill} otherwise, see Examples.
#'
#' If \code{byrow} is \code{TRUE}, then the resulting matrix is
#' a transposition of the above-described one.
#'
#' This function may be useful e.g. in connection with \code{\link{stri_split}}
#' and \code{\link{stri_extract_all}}.
#'
#' @param x a list of atomic vectors
#' @param byrow single logical value; should the resulting matrix be
#' transposed?
#' @param fill single string, see Details
#' @param n_min single integer value; minimal number of rows (\code{byrow==FALSE})
#' or columns (otherwise) in the resulting matrix
#'
#' @return
#' Always returns a character matrix.
#'
#' @examples
#' simplify2array(list(c("a", "b"), c("c", "d"), c("e", "f")))
#' stri_list2matrix(list(c("a", "b"), c("c", "d"), c("e", "f")))
#' stri_list2matrix(list(c("a", "b"), c("c", "d"), c("e", "f")), byrow=TRUE)
#'
#' simplify2array(list("a", c("b", "c")))
#' stri_list2matrix(list("a", c("b", "c")))
#' stri_list2matrix(list("a", c("b", "c")), fill="")
#' stri_list2matrix(list("a", c("b", "c")), fill="", n_min=5)
#'
#' @family utils
#' @export
stri_list2matrix <- function(x, byrow=FALSE, fill=NA_character_, n_min=0) {
   .Call(C_stri_list2matrix, x, byrow, stri_enc_toutf8(fill), n_min)
}
