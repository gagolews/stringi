## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2019, Marek Gagolewski and other contributors.
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
#' Extract a Substring From or Replace a Substring In a Character Vector
#'
#' @description
#' \code{stri_sub} extracts substrings at code point-based
#' index ranges provided. Its replacement version allows to substitute parts of
#' a string with given strings. \code{stri_sub_replace} is its \pkg{magrittr}'s
#' pipe-operator-friendly version.
#'
#' @details
#' Vectorized over \code{str}, [\code{value}], \code{from} and
#' (\code{to} or \code{length}). Parameters
#' \code{to} and \code{length} are mutually exclusive.
#'
#' Indexes are 1-based, i.e., the start of a string is at index 1.
#' Argument \code{from} gives the start of a substring to extract.
#' Argument \code{to} defines the last index of the substring, inclusive.
#' Alternatively, the substring's \code{length} can be provided.
#'
#' For negative indexes in \code{from} or \code{to},
#' counting starts at the end of the string.
#' For instance, index -1 denotes the last code point in the string.
#' Non-positive \code{length} gives an empty string.
#'
#' In \code{stri_sub}, out-of-bound indexes are silently
#' corrected. If \code{from} > \code{to}, then an empty string is returned.
#'
#' In \code{stri_sub<-}, some configurations of indexes may work as
#' substring "injection" at the front, back, or in middle.
#'
#' If \code{from} is a two-column matrix, then these two columns are
#' used as \code{from} and \code{to}, respectively, and anything passed
#' explicitly as \code{from} or \code{to} is ignored.
#'
#' If both \code{to} and \code{length} are provided,
#' \code{length} has priority over \code{to}.
#'
#' Note that for some Unicode strings, the extracted substrings might not
#' be well-formed, especially if input strings are not NFC-normalized
#' (see \code{\link{stri_trans_nfc}}),
#' include byte order marks, Bidirectional text marks, and so on.
#' Handle with care.
#'
#'
#'
#'
#' @param str a character vector
#' @param from an integer vector giving the start indexes or a two-column matrix
#'   of type \code{cbind(from, to)}
#' @param to an integer vector giving the end indexes; mutually exclusive with
#'   \code{length} and \code{from} being a matrix
#' @param length an integer vector giving the substring lengths;
#'   mutually exclusive with \code{to} and \code{from} being a matrix
#' @param omit_na a single logical value; indicates whether missing values
#'   in any of the arguments provided leave the corresponding input string
#'   unchanged [replacement function only]
#' @param value a character vector defining the replacement strings
#'   [replacement function only]
#'
#'
#' @return \code{stri_sub} and \code{stri_sub_replace} return a character vector.
#' \code{stri_sub<-} changes the \code{str} object in-place.
#'
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_sub(s, from=1:3*6, to=21)
#' stri_sub(s, from=c(1,7,13), length=5)
#' stri_sub(s, from=1, length=1:3)
#' stri_sub(s, -17, -7)
#' stri_sub(s, -5, length=4)
#' (stri_sub(s, 1, 5) <- "stringi")
#' (stri_sub(s, -6, length=5) <- ".")
#' (stri_sub(s, 1, 1:3) <- 1:2)
#'
#' x <- c("a;b", "c:d")
#' (stri_sub(x, stri_locate_first_fixed(x, ";"), omit_na=TRUE) <- "_")
#'
#' \dontrun{x %>% stri_sub_replace(1, 5, value="new_substring")}
#' @family indexing
#' @rdname stri_sub
#' @export
stri_sub <- function(str, from = 1L, to = -1L, length) {
   if (missing(length)) {
      if (is.matrix(from) && !missing(to))
         warning("argument `to` is ignored in the current context")
      .Call(C_stri_sub, str, from, to, NULL)
   }
   else {
      if (!missing(to))
         warning("argument `to` is ignored in the current context")
      if (is.matrix(from))
         warning("argument `length` is ignored in the current context")
      .Call(C_stri_sub, str, from, NULL, length)
   }
}


#' @rdname stri_sub
#' @export
#' @usage stri_sub(str, from = 1L, to = -1L, length, omit_na=FALSE) <- value
"stri_sub<-" <- function(str, from = 1L, to = -1L, length, omit_na=FALSE, value) {
   if (missing(length)) {
      if (is.matrix(from) && !missing(to))
         warning("argument `to` is ignored in the current context")
      .Call(C_stri_sub_replacement, str, from, to, NULL, omit_na, value)
   }
   else {
      if (!missing(to))
         warning("argument `to` is ignored in the current context")
      if (is.matrix(from))
         warning("argument `length` is ignored in the current context")
      .Call(C_stri_sub_replacement, str, from, NULL, length, omit_na, value)
   }
}


#' @rdname stri_sub
#' @export
#' @usage stri_sub_replace(str, from = 1L, to = -1L, length, omit_na=FALSE, value)
stri_sub_replace <- `stri_sub<-`
