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
#' Replace Occurrences of a Character Class
#'
#' @description
#' Replaces with a replacement string every/first/last
#' the characters that fall into a class specified by \code{pattern}.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' These functions scan the input string for matches of a character class.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the same (fixed) replacement string.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector specifying character classes to match,
#' see \link{stringi-search-charclass}
#' @param replacement character vector of strings to replace with
#' @param merge logical [\code{stri_replace_all_charclass} only];
#' should consecutive matches be merged into a single one?
#'
#' @return Each function returns a character vector.
#'
#' @export
#' @rdname stri_replace_charclass
#' @aliases stri_replace_all_charclass stri_replace_first_charclass stri_replace_last_charclass
#' @family search_charclass
#' @family search_replace
#'
#' @examples
#' stri_replace_all_charclass("a\nb\tc   d", "\\p{WHITE_SPACE}", " ")
#' stri_replace_all_charclass("a\nb\tc   d", "\\p{WHITE_SPACE}", " ", TRUE)
stri_replace_all_charclass <- function(str, pattern, replacement, merge=FALSE) {
   .Call("stri_replace_all_charclass", str, pattern, replacement, merge,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_charclass
stri_replace_first_charclass <- function(str, pattern, replacement) {
   .Call("stri_replace_first_charclass", str, pattern, replacement,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_charclass
stri_replace_last_charclass <- function(str, pattern, replacement) {
   .Call("stri_replace_last_charclass", str, pattern, replacement,
         PACKAGE="stringi")
}
