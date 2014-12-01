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
#' Reverse Each String
#'
#' @description
#' Reverses code points in every string.
#'
#' @details
#' Note that this operation may result in non-Unicode-normalized
#' strings and may give strange output for bidirectional strings.
#'
#' See also \code{\link{stri_rand_shuffle}} for a random permutation
#' of code points.
#'
#' @param str character vector
#'
#' @return Returns a character vector.
#'
#' @examples
#' stri_reverse(c("123", "abc d e f"))
#' stri_reverse("ZXY (\u0105\u0104123$^).")
#' stri_reverse(stri_trans_nfd('\u0105')) == stri_trans_nfd('\u0105') # A, ogonek -> agonek, A
#'
#' @export
stri_reverse <- function(str) {
   .Call(C_stri_reverse, str)
}
