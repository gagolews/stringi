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
#' Convert Strings Between Given Encodings 
#' 
#' @description
#' ..TO DO...
#' 
#' @details
#' \code{stri_conv} is an alias for \code{stri_encode}.
#' 
#' If enc is missing, NULL (default encoding) is used
#' 
#' Note that possible problems may occur with \code{to}
#' set to UTF-16 and UTF-32, as the output strings may have embedded NULs.
#' In such cases use \code{to_raw=TRUE} and consider
#' specyfying a byte order marker (BOM) for portability reasons
#' (e.g. give \code{UTF-16LE} or \code{UTF-16BE}).
#' 
#' For \code{to_raw=FALSE}, the strings always have marked encodings
#' according to the converter
#' used (as specified by \code{to}) and the current default Encoding
#' (\code{ASCII}, \code{latin1}, \code{UTF-8}, \code{native},
#' or \code{bytes} in other cases).
#' 
#' @param str character vector or a list of \code{raw} vectors
#' to be converted
#' @param from input encoding:
#'       \code{NULL} or \code{""} for default encoding,
#'       or a single string with encoding name
#' @param to target encoding:
#'       \code{NULL} or \code{""} for default encoding,
#'       or a single string with encoding name
#' @param to_raw single logical value: should a list of raw vectors
#' be returned rather than a character vector?
#' @return A character vector with encoded strings
#' (if \code{to_raw} is \code{FALSE}) or a list of raw vectors
#' otherwise.
#' 
#' @family encoding_conversion
#' @rdname stri_encode
#' @export
stri_encode <- function(str, from, to=NULL, to_raw=FALSE) {
   .Call("stri_encode", str, from, to, to_raw, PACKAGE="stringi")
}


#' @rdname stri_encode
#' @export
stri_conv <- stri_encode


#' @title
#' Convert Strings To UTF-32
#' 
#' @description
#' This is a vectorized version of \code{utf8ToInt(enc2utf8(str))},
#' but works - as usual in \pkg{stringi} - for many different
#' character encodings (native encoding is always converted to Unicode).
#' 
#' @details
#' UTF-32 is a 32bit encoding in which each Unicode code point
#' corresponds to exactly one integer value.
#' 
#' NA_character_ are converted to NULL.
#' 
#' @param str character vector to be converted
#' @return list of integer vectors
#' 
#' @family encoding_conversion
#' @export
stri_enc_toutf32 <- function(str) {
   .Call("stri_enc_toutf32", str, PACKAGE="stringi")
}



#' @title
#' Convert From UTF-32 
#' 
#' @description
#' This is a vectorized version of \code{intToUtf8},
#' as usual in \pkg{stringi}, it returns character strings
#' in UTF-8.
#' 
#' @details
#' UTF-32 is a 32bit encoding in which each Unicode code point
#' corresponds to exactly one integer value.
#' 
#' Note that 0s are not allowed in \code{vec}, as they are used
#' to mark the end of a string (in C/C++/...).
#' 
#' If an incorrect codepoint is given, a warning is generated
#' and the corresponding element in the return vector is set to \code{NA}.
#' 
#' \code{NULL} list elems are converted to \code{NA_character_}.
#' 
#' @param vec list of integer vectors or, for convenience, a single integer vector
#' @return character vector
#' 
#' @family encoding_conversion
#' @export
stri_enc_fromutf32 <- function(vec) {
   .Call("stri_enc_fromutf32", vec, PACKAGE="stringi")
}



#' @title
#' Convert Strings To UTF-8
#' 
#' @description
#' Converts marked-encoding character strings to UTF-8 strings.
#' 
#' @details
#' If \code{is_unknown_8bit} is set to \code{TRUE},
#' the for strings marked by R as having neither ASCII
#' nor UTF-8 encoding, then all bytecodes > 127 are replaced with
#' the Unicode REPLACEMENT CHARACTER (\\Ufffd).
#' `Bytes' encoding-marked strings are treated as 8-bit strings.
#' 
#' Otherwise, R encoding marking is used (ASCII, UTF-8, Latin1, Native
#' set by \code{\link{stri_enc_set}}.
#' 
#' The REPLACEMENT CHARACTER may be interpreted as Unicode \code{NA} value
#' for single characters (and not vector elements, e.g. whole strings).
#' 
#' 
#' @param str character vector to be converted
#' @param is_unknown_8bit single logical value, see Details
#' @return character vector
#' 
#' @family encoding_conversion
#' @export
stri_enc_toutf8 <- function(str, is_unknown_8bit=FALSE) {
   .Call("stri_enc_toutf8", str, is_unknown_8bit, PACKAGE="stringi")
}



#' @title
#' Convert Strings To ASCII
#' 
#' @description
#' Converts character strings to ASCII, i.e. strings with all
#' codes <= 127.
#' 
#' @details
#' All charcodes > 127 are replaced with ASCII SUBSTITUTE
#' CHARACTER (0x1A).
#' Always R encoding marking is used, to determine whether
#' an 8-bit string
#' is given on input or maybe rather an UTF-8 string.
#' 
#' `Bytes' encoding-marked strings are treated as 8-bit strings.
#' 
#' The  SUBSTITUTE
#' CHARACTER may be interpreted as ASCII \code{NA} value
#' for single characters (and not vector elements, e.g. whole strings).
#' 
#' @param str character vector to be converted
#' @return character vector
#' 
#' @family encoding_conversion
#' @export
stri_enc_toascii <- function(str) {
   .Call("stri_enc_toascii", str, PACKAGE="stringi")
}

