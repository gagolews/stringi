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
#' Randomly Shuffle Code Points in Each String
#'
#' @description
#' Generates a (pseudo)random permutation of code points
#' in each string.
#'
#' @details
#' This operation may result in non-Unicode-normalized
#' strings and may give strange output for bidirectional strings.
#'
#' See also \code{\link{stri_reverse}} for a reverse permutation
#' of code points.
#'
#' @param str character vector
#'
#' @return Returns a character vector.
#'
#' @examples
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_rand_shuffle(c("abcdefghi", "0123456789"))
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' # you can do better than this with stri_rand_strings:
#' stri_rand_shuffle(rep(stri_paste(letters, collapse=''), 10))
#'
#' @family random
#' @export
stri_rand_shuffle <- function(str) {
   .Call("stri_rand_shuffle", str, PACKAGE="stringi")
}


#' @title
#' Generate Random Strings
#'
#' @description
#' Generates (pseudo)random strings of desired lengths.
#'
#' @details
#' Vectorized over \code{length} and \code{pattern}.
#' If length of \code{length} or \code{pattern} is greater than \code{n},
#' then redundant elements are ignored. Otherwise,
#' these vectors are recycled if necessary.
#'
#' This operation may result in non-Unicode-normalized
#' strings and may give strange output for bidirectional strings.
#'
#' Sampling of code points from the set specified by \code{pattern}
#' is always done with replacement and each code point appears with equal
#' probability.
#'
#' @param n single integer, number of observations
#' @param length integer vector, desired string lengths
#' @param pattern character vector specifying character classes to draw
#' elements from, see \link{stringi-search-charclass}
#'
#' @return Returns a character vector.
#'
#' @examples
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_rand_strings(5, 10) # 5 strings of length 10
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_rand_strings(5, sample(1:10, 5, replace=TRUE)) # 5 strings of random lengths
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_rand_strings(10, 5, "[\\p{script=latin}&\\p{Ll}]") # small letters from the Latin script
#'
#' \dontrun{
#' # generate n random passwords of length in [8, 14]
#' # consisting of at least one digit, small and big ASCII letter:
#' n <- 10
#' stri_rand_shuffle(stri_paste(
#'    stri_rand_strings(n, 1, '[0-9]'),
#'    stri_rand_strings(n, 1, '[a-z]'),
#'    stri_rand_strings(n, 1, '[A-Z]'),
#'    stri_rand_strings(n, sample(5:11, 5, replace=TRUE), '[a-zA-Z0-9]')
#' ))
#' }
#'
#' @family random
#' @export
stri_rand_strings <- function(n, length, pattern="[A-Za-z0-9]") {
   .Call("stri_rand_strings", n, length, pattern, PACKAGE="stringi")
}
