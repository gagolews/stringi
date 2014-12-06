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
#' Count the Number of Bytes
#'
#' @description
#' Counts the number of bytes needed to store
#' each string in computer's memory.
#'
#' @details
#' This is often not the function you would normally use
#' in your string processing activities. See rather \code{\link{stri_length}}.
#'
#' For 8-bit encoded strings, this is the same as \code{\link{stri_length}}.
#' For UTF-8 strings, the returned values may be greater
#' than the number of code points, as UTF-8 is not a fixed-byte encoding:
#' one code point may be encoded by 1-4 bytes
#' (according to the current Unicode standard).
#'
#' Missing values are handled properly,
#' as opposed to the built-in \code{\link{nchar}(str, "bytes")} function call.
#'
#' The strings do not need to be re-encoded to perform this operation.
#'
#' The returned values does not of course include the trailing NUL bytes,
#' which are used internally to mark the end of string data (in C).
#'
#' @param str character vector or an object coercible to
#'
#' @return Returns an integer vector of the same length as \code{str}.
#'
#' @examples
#' stri_numbytes(letters)
#' stri_numbytes(c('abc', '123', '\u0105\u0104'))
#'
#' \dontrun{
#' # this used to fail on Windows, as there was no native support for 4-bytes
#' # Unicode characters; see, however, stri_escape_unicode():
#' stri_numbytes('\U7fffffff') # compare stri_length('\U7fffffff')
#' }
#'
#' @export
#' @family length
stri_numbytes <- function(str) {
   .Call(C_stri_numbytes, str)
}


#' @title
#' Count the Number of Characters
#'
#' @description
#' This function returns the number of code points
#' in each string.
#'
#' @details
#' Note that the number of code points is
#' not the same as the `width` of the string when
#' printed on the screen.
#'
#' If a given string is in UTF-8 and  has not been properly normalized
#' (e.g. by \code{\link{stri_trans_nfc}}), the returned counts may sometimes be
#' misleading. See \code{\link{stri_count_boundaries}} for a method to count
#' \emph{Unicode characters}. Moreover, if an incorrect UTF-8 byte sequence is detected,
#' then a warning is generated and the corresponding output element
#' is set to \code{NA}, see also \code{\link{stri_enc_toutf8}} for a method
#' to deal with such cases.
#'
#' Missing values are handled properly,
#' as opposed to the built-in \code{\link{nchar}} function.
#' For `byte` encodings we get, as usual, an error.
#'
#' @param str character vector or an object coercible to
#' @return Returns an integer vector of the same length as \code{str}.
#'
#' @examples
#' stri_length(LETTERS)
#' stri_length(c('abc', '123', '\u0105\u0104'))
#' stri_length('\u0105') # length is one, but...
#' stri_numbytes('\u0105') # 2 bytes are used
#' stri_numbytes(stri_trans_nfkd('\u0105')) # 3 bytes here but...
#' stri_length(stri_trans_nfkd('\u0105')) # ...two code points (!)
#' stri_count_boundaries(stri_trans_nfkd('\u0105'), type="character") # ...and one Unicode character
#'
#' @export
#' @family length
stri_length <- function(str) {
   .Call(C_stri_length, str)
}


#' @title
#' Determine if a String is of Length Zero
#'
#' @description
#' This is the fastest way to find out
#' whether the elements of a character vector are empty strings.
#'
#' @details
#' Missing values are handled properly,
#' as opposed to the built-in \code{\link{nzchar}} function.
#'
#' @param str character vector or an object coercible to
#' @return Returns a logical vector of the same length as \code{str}.
#'
#' @examples
#' stri_isempty(letters[1:3])
#' stri_isempty(c(',', '', 'abc', '123', '\u0105\u0104'))
#' stri_isempty(character(1))
#'
#' @export
#' @family length
stri_isempty <- function(str) {
   .Call(C_stri_isempty, str)
}
