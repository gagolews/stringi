## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#' @title
#' Perform or Check For Unicode Normalization
#'
#' @description
#' These functions convert strings to NFC, NFKC, NFD, NFKD, or NFKC_Casefold
#' Unicode Normalization Form
#' or check whether strings are normalized.
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
#' stringi processing activities. Most often you may assume
#' that a string is in NFC.
#'
#' As usual in \pkg{stringi},
#' if the input character vector is in the native encoding,
#' it will be converted to UTF-8 automatically.
#'
#'
#' @param str character vector to be encoded
#'
#' @return The \code{stri_enc_nf*} functions return a character vector
#' of the same length as input (the output is always in UTF-8).
#'
#' On the other hand, \code{stri_enc_isnf*} return a logical vector.
#'
#' @references
#' \emph{Unicode Normalization Forms} -- Unicode Standard Annex #15,
#'    \url{http://unicode.org/reports/tr15}
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
#' @export
#' @rdname stri_enc_nf
#' @family encoding_normalization
stri_enc_nfc <- function(str) {
   .Call("stri_enc_nf", str, 10L, PACKAGE="stringi")
}



#' @rdname stri_enc_nf
#' @export
stri_enc_nfd <- function(str) {
   .Call("stri_enc_nf", str, 20L, PACKAGE="stringi")
}




#' @rdname stri_enc_nf
#' @export
stri_enc_nfkd <- function(str) {
   .Call("stri_enc_nf", str, 21L, PACKAGE="stringi")
}




#' @rdname stri_enc_nf
#' @export
stri_enc_nfkc <- function(str) {
   .Call("stri_enc_nf", str, 11L, PACKAGE="stringi")
}




#' @rdname stri_enc_nf
#' @export
stri_enc_nfkc_casefold <- function(str) {
   .Call("stri_enc_nf", str, 12L, PACKAGE="stringi")
}




#' @rdname stri_enc_nf
#' @export
stri_enc_isnfc <- function(str) {
   .Call("stri_enc_isnf", str, 10L, PACKAGE="stringi")
}


#' @rdname stri_enc_nf
#' @export
stri_enc_isnfd <- function(str) {
   .Call("stri_enc_isnf", str, 20L, PACKAGE="stringi")
}




#' @rdname stri_enc_nf
#' @export
stri_enc_isnfkd <- function(str) {
   .Call("stri_enc_isnf", str, 21L, PACKAGE="stringi")
}




#' @rdname stri_enc_nf
#' @export
stri_enc_isnfkc <- function(str) {
   .Call("stri_enc_isnf", str, 11L, PACKAGE="stringi")
}




#' @rdname stri_enc_nf
#' @export
stri_enc_isnfkc_casefold <- function(str) {
   .Call("stri_enc_isnf", str, 12L, PACKAGE="stringi")
}
