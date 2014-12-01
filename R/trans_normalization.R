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
#' Perform or Check For Unicode Normalization
#'
#' @description
#' These functions convert strings to NFC, NFKC, NFD, NFKD, or NFKC_Casefold
#' Unicode Normalization Form or check whether strings are normalized.
#'
#' @details
#' Unicode Normalization Forms are formally defined normalizations of Unicode
#' strings which e.g. make possible to determine whether any two
#' strings are equivalent.
#' Essentially, the Unicode Normalization Algorithm puts all combining
#' marks in a specified order, and uses rules for decomposition
#' and composition to transform each string into one of the
#' Unicode Normalization Forms.
#'
#' The following Normalization Forms (NFs) are supported:
#' \itemize{
#' \item NFC (Canonical Decomposition, followed by Canonical Composition),
#' \item NFD (Canonical Decomposition),
#' \item NFKC (Compatibility Decomposition, followed by Canonical Composition),
#' \item NFKD (Compatibility Decomposition),
#' \item NFKC_Casefold (combination of NFKC, case folding, and removing ignorable
#'  characters which was introduced with Unicode 5.2).
#' }
#'
#' Note that many W3C Specifications recommend using NFC for all content,
#' because this form avoids potential interoperability problems arising
#' from the use of canonically equivalent, yet different,
#' character sequences in document formats on the Web.
#' Thus, you will rather not use these functions in typical
#' string processing activities. Most often you may assume
#' that a string is in NFC, see RFC\#5198.
#'
#' As usual in \pkg{stringi},
#' if the input character vector is in the native encoding,
#' it will be converted to UTF-8 automatically.
#'
#' For more general text transforms refer to \code{\link{stri_trans_general}}.
#'
#'
#' @param str character vector to be encoded
#'
#' @return The \code{stri_trans_nf*} functions return a character vector
#' of the same length as input (the output is always in UTF-8).
#'
#' On the other hand, \code{stri_trans_isnf*} return a logical vector.
#'
#' @references
#' \emph{Unicode Normalization Forms} -- Unicode Standard Annex #15,
#'    \url{http://unicode.org/reports/tr15}
#'
#' \emph{Unicode Format for Network Interchange}
#' -- RFC\#5198, \url{http://tools.ietf.org/rfc/rfc5198.txt}
#'
#' \emph{Character Model for the World Wide Web 1.0: Normalization}
#' -- W3C Working Draft, \url{http://www.w3.org/TR/charmod-norm/}
#'
#' \emph{Normalization} -- ICU User Guide,
#'    \url{http://userguide.icu-project.org/transforms/normalization}
#'    (technical details)
#'
#' \emph{Unicode Equivalence} -- Wikipedia,
#' \url{http://en.wikipedia.org/wiki/Unicode_equivalence}
#'
#' @examples
#' stri_trans_nfd("\u0105") # Polish a with ogonek -> a, ogonek
#' stri_trans_nfkc("\ufdfa") # 1 codepoint -> 18 codepoints
#'
#' @export
#' @rdname stri_trans_nf
#' @family transform
stri_trans_nfc <- function(str) {
   .Call(C_stri_trans_nf, str, 10L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_nfd <- function(str) {
   .Call(C_stri_trans_nf, str, 20L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_nfkd <- function(str) {
   .Call(C_stri_trans_nf, str, 21L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_nfkc <- function(str) {
   .Call(C_stri_trans_nf, str, 11L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_nfkc_casefold <- function(str) {
   .Call(C_stri_trans_nf, str, 12L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_isnfc <- function(str) {
   .Call(C_stri_trans_isnf, str, 10L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_isnfd <- function(str) {
   .Call(C_stri_trans_isnf, str, 20L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_isnfkd <- function(str) {
   .Call(C_stri_trans_isnf, str, 21L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_isnfkc <- function(str) {
   .Call(C_stri_trans_isnf, str, 11L)
}


#' @rdname stri_trans_nf
#' @export
stri_trans_isnfkc_casefold <- function(str) {
   .Call(C_stri_trans_isnf, str, 12L)
}
