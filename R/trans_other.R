## This file is part of the 'stringi' package for R.
## Copyright (C) 2013-2015, Marek Gagolewski and Bartek Tartanus
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
#' Translate Characters
#'
#' @description
#' Translates Unicode code points in each input string.
#'
#' @details
#' Vectorized over \code{str} and with respect to each code point
#' in \code{pattern} and \code{replacement}.
#'
#' If \code{pattern} and \code{replacement} consist of a different number
#' of code points, then the extra code points in the longer of the two are ignored,
#' with a warning.
#'
#' If code points in a given \code{pattern} are not unique,
#' last corresponding replacement code point is used.
#'
#' @param str character vector
#' @param pattern a single character string providing code points to be translated
#' @param replacement a single character string giving translated code points
#'
#' @return Returns a character vector.
#'
#' @export
#' @family transform
#' @examples
#' stri_trans_char("id.123", ".", "_")
#' stri_trans_char("babaab", "ab", "01")
stri_trans_char <- function(str, pattern, replacement) {
   .Call(C_stri_trans_char, str, pattern, replacement)
}
