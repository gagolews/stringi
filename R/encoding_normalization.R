## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' @title
#' Perform Unicode Normalization
#' 
#' @description
#' Converts a string to NFC, NFKC, NFD, NFKD, or NFKC_Casefold.
#' 
#' @details
#' Unicode Normalization Forms are formally defined normalizations of Unicode 
#' strings which make it possible to determine whether any two Unicode 
#' strings are equivalent to each other.
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
#'  characters which was introduced with Unicode 5.2)
#' }
#' 
#' Note that many W3C Specifications recommend using NFC for all content,
#' because this form avoids potential interoperability problems arising 
#' from the use of canonically equivalent, yet different,
#' character sequences in document formats on the Web.
#' 
#' The input character vector can be in any encoding.
#'
#' 
#' @param str character vector to be encoded
#' @return For \code{stri_enc_nf*}, a character vector
#' of the same lenght as input will be returned. The output will always be in UTF-8.
#' 
#' @references
#' {Unicode Normalization Forms} - Unicode Standard Annex #15,
#'    \url{http://unicode.org/reports/tr15}\cr
#' {Character Model for the World Wide Web 1.0: Normalization}
#'    - W3C Working Draft, \url{http://www.w3.org/TR/charmod-norm/}\cr
#' {Normalization} - ICU User Guide,
#'    \url{http://userguide.icu-project.org/transforms/normalization} (technical details)
#'    
#' @export
#' @rdname normalization
#' @family encoding_normalization
stri_enc_nfc <- function(str) {
   .Call("stri_enc_nf", str, 10L, PACKAGE="stringi")
}



#' @rdname normalization
#' @export
stri_enc_nfd <- function(str) {
   .Call("stri_enc_nf", str, 20L, PACKAGE="stringi")
}




#' @rdname normalization
#' @export
stri_enc_nfkd <- function(str) {
   .Call("stri_enc_nf", str, 21L, PACKAGE="stringi")
}




#' @rdname normalization
#' @export
stri_enc_nfkc <- function(str) {
   .Call("stri_enc_nf", str, 11L, PACKAGE="stringi")
}




#' @rdname normalization
#' @export
stri_enc_nfkc_casefold <- function(str) {
   .Call("stri_enc_nf", str, 12L, PACKAGE="stringi")
}




#' @rdname normalization
#' @export
stri_enc_isnfc <- function(str) {
   .Call("stri_enc_isnf", str, 10L, PACKAGE="stringi")
}


#' @rdname normalization
#' @export
stri_enc_isnfd <- function(str) {
   .Call("stri_enc_isnf", str, 20L, PACKAGE="stringi")
}




#' @rdname normalization
#' @export
stri_enc_isnfkd <- function(str) {
   .Call("stri_enc_isnf", str, 21L, PACKAGE="stringi")
}




#' @rdname normalization
#' @export
stri_enc_isnfkc <- function(str) {
   .Call("stri_enc_isnf", str, 11L, PACKAGE="stringi")
}




#' @rdname normalization
#' @export
stri_enc_isnfkc_casefold <- function(str) {
   .Call("stri_enc_isnf", str, 12L, PACKAGE="stringi")
}

