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
#' Convert Strings Between Given Encodings
#'
#' @description
#' These functions convert a character vector between encodings.
#'
#' @details
#' These two functions aim to replace \R's \link{iconv} --
#' note only it is slightly faster,
#' and works in the same manner on all platforms.
#' \code{stri_conv} is an alias for \code{stri_encode}.
#'
#' Please, refer to \code{\link{stri_enc_list}} for the list
#' of supported encodings and \link{stringi-encoding}
#' for general discussion.
#'
#' If \code{from} is either missing, \code{""}, or \code{NULL}
#' and \code{str} is an atomic vector,
#' then the input strings' encoding marks are used
#' (just like in almost all \pkg{stringi} functions:
#' bytes marks are disallowed).
#' In other words, the input string will be converted from
#' ASCII, UTF-8, or current default encoding, see \code{\link{stri_enc_get}}.
#' Otherwise, the internal encoding marks are overridden
#' by the given encoding.
#' On the other hand, for \code{str} being a list of raw vectors,
#' we assume that the input encoding is the current default encoding.
#'
#' For \code{to_raw=FALSE}, the output
#' strings always have marked encodings according to the target converter
#' used (as specified by \code{to}) and the current default Encoding
#' (\code{ASCII}, \code{latin1}, \code{UTF-8}, \code{native},
#' or \code{bytes} in all other cases).
#'
#'
#' Note that possible problems may occur when \code{to} is
#' set to e.g. UTF-16 and UTF-32, as the output strings may have embedded NULs.
#' In such cases use \code{to_raw=TRUE} and consider
#' specifying a byte order marker (BOM) for portability reasons
#' (e.g. set \code{UTF-16} or \code{UTF-32} which automatically
#' adds BOMs).
#'
#' Note that \code{stri_encode(as.raw(data), "8bitencodingname")}
#' is a wise substitute for \code{\link{rawToChar}}.
#'
#' Currently, if an incorrect code point is found
#' on input, it is replaced by the default (for that target encoding)
#' substitute character and a warning is generated.
#'
#'
#' @param str character vector, a raw vector, or
#' a list of \code{raw} vectors to be converted
#' @param from input encoding:
#'       \code{NULL} or \code{""} for default encoding
#'       or internal encoding marks usage (see Details);
#'       otherwise, a single string with encoding name,
#'       see \code{\link{stri_enc_list}}
#' @param to target encoding:
#'       \code{NULL} or \code{""} for default encoding
#'       (see \code{\link{stri_enc_get}}),
#'       or a single string with encoding name
#' @param to_raw single logical value; indicates whether a list of raw vectors
#' shall be returned rather than a character vector
#'
#' @return If \code{to_raw} is \code{FALSE},
#' then a character vector with encoded strings (and sensible
#' encoding marks) is returned.
#' Otherwise, you get a list of raw vectors.
#'
#' @references
#' \emph{Conversion} -- ICU User Guide, \url{http://userguide.icu-project.org/conversion}
#'
#' \emph{Converters} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/conversion/converters}  (technical details)
#'
#' @family encoding_conversion
#' @rdname stri_encode
#' @export
stri_encode <- function(str, from=NULL, to=NULL, to_raw=FALSE) {
   .Call("stri_encode", str, from, to, to_raw, PACKAGE="stringi")
}


#' @rdname stri_encode
#' @export
stri_conv <- stri_encode


#' @title
#' Convert Strings To UTF-32
#'
#' @description
#' UTF-32 is a 32bit encoding in which each Unicode code point
#' corresponds to exactly one integer value.
#' This function converts a character vector to a list
#' of integer vectors.
#' The individual code points then may easily be manipulated.
#'
#' @details
#' \code{NA_character_}s are converted to \code{NULL}.
#'
#' This function is roughly equivalent to a vectorized call
#' to \code{utf8ToInt(enc2utf8(str))}.
#' If you want a list of raw vector on output,
#' use \code{\link{stri_encode}}.
#'
#' @param str character vector to be converted
#' @return Returns a list of integer vectors.
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
#' This function converts a list of integer vectors,
#' representing UTF-32 code points, to a character vector.
#'
#' @details
#' UTF-32 is a 32bit encoding in which each Unicode code point
#' corresponds to exactly one integer value.
#'
#' This functions roughly acts like a vectorized version of
#' \code{\link{intToUtf8}},
#' as usual in \pkg{stringi}, it returns character strings
#' in UTF-8.
#' If you have a list of raw vectors on input,
#' use \code{\link{stri_encode}}.
#'
#'
#' Note that \code{0}s are not allowed in \code{vec}, as they are used
#' to internally mark the end of a string (in the C API).
#'
#' If an incorrect code point is given, a warning is generated
#' and a string is set to \code{NA}.
#'
#' \code{NULL}s in the input list are converted to \code{NA_character_}.
#'
#' @param vec list of integer vectors or,
#' for convenience, a single integer vector
#' @return Returns a character vector (in UTF-8).
#'
#' @family encoding_conversion
#' @export
stri_enc_fromutf32 <- function(vec) {
   .Call("stri_enc_fromutf32", vec, PACKAGE="stringi")
}



#' @title
#' Convert To UTF-8
#'
#' @description
#' Converts character strings with (possibly) internally marked encodings
#' to UTF-8 strings.
#'
#' @details
#' If \code{is_unknown_8bit} is set to \code{TRUE}
#' and a string is marked (internally) as being neither ASCII
#' nor UTF-8-encoded, then all bytecodes > 127 are replaced with
#' the Unicode REPLACEMENT CHARACTER (\\Ufffd).
#' Bytes-marked strings are treated as 8-bit strings.
#'
#' Otherwise, R encoding marks is assumed
#' to be trustworthy (ASCII, UTF-8, Latin1, or Native).
#' Bytes encoding fail here.
#'
#' Note that the REPLACEMENT CHARACTER may be interpreted as Unicode
#' \code{NA} value for single characters.
#'
#'
#' @param str character vector to be converted
#' @param is_unknown_8bit single logical value, see Details
#' @return Returns a character vector.
#'
#' @family encoding_conversion
#' @export
stri_enc_toutf8 <- function(str, is_unknown_8bit=FALSE) {
   .Call("stri_enc_toutf8", str, is_unknown_8bit, PACKAGE="stringi")
}



#' @title
#' Convert To ASCII
#'
#' @description
#' Converts input strings to ASCII, i.e. to strings with all
#' codes <= 127.
#'
#' @details
#' All charcodes > 127 are replaced with ASCII SUBSTITUTE
#' CHARACTER (0x1A).
#' \R encoding marking is always used, to determine whether
#' an 8-bit encoding or rather UTF-8 is used on input.
#'
#' Bytes-marked strings are treated as 8-bit strings.
#'
#' The SUBSTITUTE CHARACTER (\code{\\x1a == \\032}) may be interpreted
#' as ASCII missing value for single characters.
#'
#' @param str character vector to be converted
#' @return Returns a character vector.
#'
#' @family encoding_conversion
#' @export
stri_enc_toascii <- function(str) {
   .Call("stri_enc_toascii", str, PACKAGE="stringi")
}
