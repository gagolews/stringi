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
#' Check If a String Is Possibly in ASCII
#'
#' @description
#' The function checks whether all character codes are in the set {1,2,...,127}.
#'
#' @details
#' This function is independent of the way R marks encodings in
#' character strings (see \link{Encoding} and \link{stringi-encoding}).
#'
#'
#' @param str character vector
#' @return logical vector; i-th element indicates whether the i-th string
#' corresponds to a valid ASCII byte sequence
#'
#' @examples
#' stri_enc_isascii(letters[1:3])
#' stri_enc_isascii("\u0105\u0104")
#'
#' @family encoding_detection
#' @export
stri_enc_isascii <- function(str) {
   .Call("stri_enc_isascii", str, PACKAGE="stringi")
}


#' @title
#' Check If a String Is Possibly in UTF-8
#'
#' @description
#' The function checks whether given sequences of bytes forms
#' a proper UTF-8 string.
#'
#' @details
#' Negative answer means that a string is surely not in UTF-8.
#' Positive result does not mean that we should be absolutely sure.
#'  E.g. (c4,85) properly
#' represents ("Polish a with ogonek") in UTF-8
#' as well as ("A umlaut", "Ellipsis") in WINDOWS-1250.
#'
#' However, the longer the sequence,
#' the bigger the possibility that the result
#' is indeed in UTF-8 -- this is because not all sequences of bytes
#' are valid UTF-8.
#'
#' note that \code{\link{stri_enc_isutf8}} => \code{\link{stri_enc_isascii}}
#'
#' This function is independent of the way R marks encodings in
#' character strings (see \link{Encoding} and \link{stringi-encoding}).
#'
#' @param str character vector
#' @return logical vector; i-th element indicates whether the i-th string
#' corresponds to a valid UTF-8 byte sequence
#'
#' @examples
#' stri_enc_isutf8(letters[1:3])
#' stri_enc_isutf8("\u0105\u0104")
#' stri_enc_isutf8("\u1234\u0222")
#'
#' @family encoding_detection
#' @export
stri_enc_isutf8 <- function(str) {
   .Call("stri_enc_isutf8", str, PACKAGE="stringi")
}


