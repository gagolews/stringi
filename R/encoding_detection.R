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
#' Check If a Data Stream Is Possibly in UTF16 or UTF32
#'
#' @description
#' These functions detect whether a given byte stream is
#' valid UTF-16LE, UTF-16BE, UTF-32LE, or UTF-32BE.
#'
#' @details
#' These functions are independent of the way \R marks encodings in
#' character strings (see \link{Encoding} and \link{stringi-encoding}).
#' Anyway, most often, you will provide input data as raw vectors here.
#'
#' Negative answer means that a string is surely not in valid UTF-16 or UTF-32.
#' Positive result does not mean that we should be absolutely sure.
#'
#' Also, note that sometimes a data stream may be classified
#' as both valid UTF-16LE and UTF-16BE.
#'
#' @param str character vector, a raw vector, or
#' a list of \code{raw} vectors
#'
#' @return Returns a logical vector.
#'
#' @rdname stri_enc_isutf16
#' @family encoding_detection
#' @export
stri_enc_isutf16be <- function(str) {
   .Call(C_stri_enc_isenc, str, 3L)
}


#' @rdname stri_enc_isutf16
#' @export
stri_enc_isutf16le <- function(str) {
   .Call(C_stri_enc_isenc, str, 4L)
}


#' @rdname stri_enc_isutf16
#' @export
stri_enc_isutf32be <- function(str) {
   .Call(C_stri_enc_isenc, str, 5L)
}


#' @rdname stri_enc_isutf16
#' @export
stri_enc_isutf32le <- function(str) {
   .Call(C_stri_enc_isenc, str, 6L)
}


#' @title
#' Check If a Data Stream Is Possibly in ASCII
#'
#' @description
#' The function checks whether all bytes in a string are in the set {1,2,...,127}.
#'
#' @details
#' This function is independent of the way \R marks encodings in
#' character strings (see \link{Encoding} and \link{stringi-encoding}).
#'
#' @param str character vector, a raw vector, or
#' a list of \code{raw} vectors
#'
#' @return Returns a logical vector.
#' Its i-th element indicates whether the i-th string
#' corresponds to a valid ASCII byte sequence.
#'
#' @examples
#' stri_enc_isascii(letters[1:3])
#' stri_enc_isascii("\u0105\u0104")
#'
#' @family encoding_detection
#' @export
stri_enc_isascii <- function(str) {
   .Call(C_stri_enc_isenc, str, 1L)
}


#' @title
#' Check If a Data Stream Is Possibly in UTF-8
#'
#' @description
#' The function checks whether given sequences of bytes forms
#' a proper UTF-8 string.
#'
#' @details
#' Negative answer means that a string is surely not valid UTF-8.
#' Positive result does not mean that we should be absolutely sure.
#'  E.g. \code{(c4,85)} properly
#' represents ("Polish a with ogonek") in UTF-8
#' as well as ("A umlaut", "Ellipsis") in WINDOWS-1250.
#' Also note that UTF-8, as well as most 8-bit encodings,
#' have ASCII as their subsets
#' (note that \code{\link{stri_enc_isascii}} => \code{\link{stri_enc_isutf8}}).
#'
#' However, the longer the sequence,
#' the bigger the possibility that the result
#' is indeed in UTF-8 -- this is because not all sequences of bytes
#' are valid UTF-8.
#'
#' This function is independent of the way \R marks encodings in
#' character strings (see \link{Encoding} and \link{stringi-encoding}).
#'
#' @param str character vector, a raw vector, or
#' a list of \code{raw} vectors
#'
#' @return Returns a logical vector.
#' Its i-th element indicates whether the i-th string
#' corresponds to a valid UTF-8 byte sequence.
#'
#' @examples
#' stri_enc_isutf8(letters[1:3])
#' stri_enc_isutf8("\u0105\u0104")
#' stri_enc_isutf8("\u1234\u0222")
#'
#' @family encoding_detection
#' @export
stri_enc_isutf8 <- function(str) {
   .Call(C_stri_enc_isenc, str, 2L)
}
