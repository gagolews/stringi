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
#' Count the Number of Fixed Pattern Matches
#'
#' @description
#' This function counts the number of occurrences
#' of a fixed pattern in a string.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' If \code{pattern} is empty, then the result is \code{NA}
#' and a warning is generated.
#'
#' For natural language processing this function may be not give
#' you desired results. Refer to \link{stringi-search-fixed} for more details.
#'
#' @param str character vector
#' @param pattern character vector
#'
#' @return Returns an integer vector with the number of matches.
#'
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_count_fixed(s, " ")
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_count_fixed(s, "o")
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_count_fixed(s, "it")
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_count_fixed(s, letters)
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_count_fixed("babab", "b")
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_count_fixed(c("stringi", "123"), "string")
#'
#' @export
#' @family search_count
#' @family search_fixed
stri_count_fixed <- function(str, pattern) {
   .Call("stri_count_fixed", str, pattern, PACKAGE="stringi")
}
