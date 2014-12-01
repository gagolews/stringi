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
#' Replace Missing Values in a Character Vector
#'
#' @description
#' This function offers a convenient way to replace each \code{NA}
#' in a character vector with a given string.
#'
#' @details
#' This function is roughly equivalent to
#' \code{str2 <- stri_enc_toutf8(str);
#' str2[is.na(str2)] <- stri_enc_toutf8(replacement);
#' str2}.
#' It may be used e.g. wherever ``plain \R'' \code{NA} handling is
#' desired, see Examples.
#'
#' @param str character vector or an object coercible to
#' @param replacement single string
#'
#' @return Returns a character vector.
#'
#' @examples
#' x <- c('test', NA)
#' stri_paste(x, 1:2)                           # "test1" NA
#' paste(x, 1:2)                                # "test 1" "NA 2"
#' stri_paste(stri_replace_na(x), 1:2, sep=' ') # "test 1" "NA 2"
#'
#' @export
#' @family search_replace
stri_replace_na <- function(str, replacement="NA"){
   .Call(C_stri_replace_na, str, replacement)
}
