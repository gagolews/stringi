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
#' Select Elements with a Fixed Pattern Match
#'
#' @description
#' This function is roughly equivalent to a call to
#' \code{str[\link{stri_detect_fixed}(str, ...)]}.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' For natural language processing this function might not give
#' you desired results. Refer to \link{stringi-search-fixed} for more details.
#' 
#' The resulting vector is of course always in UTF-8.
#'
#' @param str character vector
#' @param pattern character vector
#'
#' @return Returns a character vector.
#'
#' @examples
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_subset_fixed(c("stringi R", "REXAMINE", "123"), c('i', 'R', '0'))
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_subset_fixed(c("stringi R", "REXAMINE", "123"), 'R')
#'
#' @export
#' @family search_subset
#' @family search_fixed
stri_subset_fixed <- function(str, pattern) {
   .Call("stri_subset_fixed", str, pattern, PACKAGE="stringi")
}
