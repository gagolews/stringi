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



#' Character Encoding Management in \pkg{stringi}
#' 
#' This section explains how we deal with character encoding
#' issues in \pkg{stringi}.
#' 
#' 
#' ICU: Unicode provides a single character set that covers the major 
#' languages of the world, and a small number of machine-friendly encoding
#'  forms and schemes to fit the needs of existing applications and protocols. 
#'  It is designed for best interoperability with both ASCII and ISO-8859-1 
#'  (the most widely used character sets) to make it easier for Unicode to be 
#'  used in almost all applications and protocols.
#'  
#' Hundreds of encodings have been developed over the years, each for small 
#' groups of languages and for special purposes. As a result, 
#' the interpretation of text, input, sorting, display, and storage 
#' depends on the knowledge of all the different types of character sets
#'  and their encodings. Programs have been written to handle either 
#'  one single encoding at a time and switch between them, or to convert
#'   between external and internal encodings.
#'
#'
#' \bold{UTF-8}
#' 
#' UTF-8 has ASCII as its subset. bytes 0--127 are the same....
#' 
#' Code points larger than 127 are represented by multi-byte sequences
#' (from 2 to 4 bytes)
#' 
#' Not all sequences of bytes are valid UTF-8.
#' 
#' Unicode normalization..... see \code{\link{stri_enc_nfc}}
#' for discussion
#' 
#' ???Most functions in \pkg{stringi} output results in UTF-8???
#' 
#' 
#' \bold{Selecting Encodings in \pkg{stringi}}
#' 
#' Except for \code{\link{stri_enc_set}}, each function
#' selects default encoding if an empty string or \code{NULL} is given as
#' argument. Generally, an attempt to select an unsupported ICU character
#' encoder will finish with an error.
#' 
#' Please note that apart from given encodings, ICU tries to normalize
#' encoding specifiers.
#' ICU: Converter names are case-insensitive. 
#' Leading zeroes are ignored in sequences of digits (if further digits follow),
#'  and all non-alphanumeric characters are ignored. Thus the strings 
#'  "UTF-8", "utf_8", "u*T@f08" and "Utf 8" are equivalent. 
#'  
#'  
#' \bold{Character Encodings in R}
#' 
#' Most of the computations in \pkg{stringi} are performed internally
#' using either UTF-8 or UTF-16 encodings. However, we still need to communicate
#' with R somehow and give some trust in how it handles strings.
#' 
#' Basically, R has a very simple encoding-marking mechanism.
#' \code{ASCII} strings consist of bytes with values <= 127.
#' \code{UTF-8} strings...
#' \code{LATIN1} string....
#' \code{BYTES} strings...
#' Sometimes strings have no encoding marks. In this case one should
#' assume that he/she deals with natively-encoded data.
#' 
#' @references
#' Conversion - ICU User Guide, \url{http://userguide.icu-project.org/conversion} \cr
#' Converters - ICU User Guide, \url{http://userguide.icu-project.org/conversion/converters}  (technical details)
#' @name stringi_encoding
#' @family encoding
NULL


#' List Available Encodings
#'
#' Please note that apart from given encodings, ICU tries to normalize
#' encoding specifiers. E.g. \code{"UTF8"} is also valid,
#' see \link{stringi_encoding} for more information.
#'
#' @param simplified logical value TODO....
#' @return If \code{simplified} is \code{FALSE} (the default), a list of
#'  character vectors is returned: Each element represents one unique
#'  character encoding. The name of the list item gives the ICU canonical
#'  name of the encodings. The elements (character vectors) are
#'  its aliases.
#' 
#' When \code{simplified} is \code{TRUE}, then the resulting list
#' is coerced to a character vector, sorted, and its duplicates are removed.
#' 
#' @family encoding
#' @export
stri_enc_list <- function(simplified=FALSE) {
   simplified <- identical(simplified, TRUE)
   
   ret <- .Call("stri_enc_list", PACKAGE="stringi")
   if (simplified)
      return(sort(unique(unlist(ret))))
   else
      return(ret)
}


#' Query Given Encoding
#' 
#' 
#' @param enc \code{NULL} or \code{""} for default encoding,
#' or a single string with encoding name
#' 
#' @return If the encoding is unsupported, an error is generated.
#' Otherwise, you get a list with the following components:
#' \code{Name.friendly} - Friendly encoding name: MIME name or JAVA name or ICU Canonical name
#'    (selecting the first of supported ones, see below);
#' \code{Name.ICU} - Encoding name as identified by ICU;
#' \code{Name.*}, e.g. \code{Name.UTR22}, \code{Name.IBM}, \code{Name.WINDOWS},
#' \code{Name.JAVA}, \code{Name.IANA}, \code{Name.MIME} (some may be not
#' availiable for selected  encodings) - 
#' \code{ASCII.subset} - has this encoding ASCII as its subset?
#' \code{Unicode.1to1} - for 8-bit encodings only: does every character
#' translate into one Unicode codepoint and is this translation reversible?
#' \code{CharSize.8bit} - is this an 8-bit encoding, i.e. do we have
#'    \code{CharSize.min == CharSize.max} and \code{CharSize.min == 1}?
#' \code{CharSize.min} - minimal number of bytes used to represend a code point
#' \code{CharSize.max} - maximal number of bytes used to represend a code point
#' @family encoding
#' @export
stri_enc_info <- function(enc=NULL) {
   .Call("stri_enc_info", enc, PACKAGE="stringi")
}


#' Set Default Encoding
#'
#' @param enc character encoding name,
#' see \code{\link{stri_enc_list}}
#' @return Previously set default encoding, invisibly.
#' 
#' @family encoding
#' @export
stri_enc_set <- function(enc) {
   previous <- stri_enc_get()
   
   # We call stri_info, because it generates some warnings,
   # in case any problems are found:
   .Call("stri_enc_set", enc, PACKAGE="stringi")
   message('You are now working with ' %+% stri_info(short=TRUE))
   invisible(previous)
}


#' Get Default Encoding
#' 
#' Same as \code{stri_enc_info()$Name.friendly}.
#' 
#' @return a character string
#' @family encoding
#' @export
stri_enc_get <- function() {
   stri_enc_info(NULL)$Name.friendly
}





#' Check if string is possibly in ASCII
#'
#' The function checks whether all character codes are in the set {1,2,...,127}.
#'
#' This function is independent of the way R marks encodings in
#' character strings (see \code{\link{Encoding}} and \code{\link{stringi_encoding}}).
#' 
#' 
#' @param str character vector
#' @return logical vector; ith element indicates whether the ith string
#' corresponds to a valid ASCII byte sequence
#' 
#' @family encoding
#' @export
stri_enc_isascii <- function(str) {
   .Call("stri_enc_isascii", str, PACKAGE="stringi")
}


#' Check if string is possibly in UTF8
#' 
#' The function checks whether given sequences of bytes forms
#' a propert UTF-8 string. 
#' Negative answer means that a string is surely not in UTF-8.
#' Positive result does not mean that we should be absolutely sure.\
#'  E.g. (c4,85) properly
#' represents ("Polish a with ogonek") in UTF-8
#' as well as ("A umlaut", "Ellipsis") in WINDOWS-1250.
#' 
#' However, the longer the seqeuence,
#' the bigger the possibility that the result
#' is indeed in UTF-8 -- this is becaues not all sequences of bytes 
#' are valid UTF-8.
#' 
#' note that isascii => isutf8
#' 
#' This function is independent of the way R marks encodings in
#' character strings (see \code{\link{Encoding}} and \code{\link{stringi_encoding}}).
#' 
#' @param str character vector
#' @return logical vector; ith element indicates whether the ith string
#' corresponds to a valid UTF-8 byte sequence
#' 
#' @family encoding
#' @export
stri_enc_isutf8 <- function(str) {
   .Call("stri_enc_isutf8", str, PACKAGE="stringi")
}




#' Convert Character Vector Between Given Encodings 
#' 
#' If enc is missing, NULL (default encoding) is used
#' 
#' @param str character vector to be converted
#' @param from input encoding:
#'       \code{NULL} or \code{""} for default encoding,
#'       or a single string with encoding name
#' @param from target encoding:
#'       \code{NULL} or \code{""} for default encoding,
#'       or a single string with encoding name
#' @return A character vector with encoded strings.
#' @family encoding
#' @export
stri_encode <- function(str, from, to=NULL) {
   .Call("stri_encode", str, from, to, PACKAGE="stringi")
}



#' Convert To UTF-32
#' 
#' This is a vectorized version of \code{utf8ToInt(enc2utf8(str))},
#' but works - as usual in \pkg{stringi} - for many different
#' character encodings (native encoding is always converted to Unicode).
#' 
#' UTF-32 is a 32bit encoding in which each Unicode code point
#' corresponds to exactly one integer value.
#' 
#' NA_character_ are converted to NULL.
#' 
#' @param str character vector to be converted
#' @return list of integer vectors
#' 
#' @family encoding
#' @export
stri_enc_toutf32 <- function(str) {
   .Call("stri_enc_toutf32", str, PACKAGE="stringi")
}



#' Convert From UTF-32
#' 
#' This is a vectorized version of \code{intToUtf8},
#' as usual in \pkg{stringi}, it returns character strings
#' in UTF-8.
#' 
#' UTF-32 is a 32bit encoding in which each Unicode code point
#' corresponds to exactly one integer value.
#' 
#' Note that 0s are not allowed in \code{vec}, as they are used
#' to mark the end of a string (in C/C++/...).
#' 
#' If an incorrect codepoint is given, a warning is generated
#' and the corresponding element in the return vector is set to \code{NA}.
#' 
#' @param vec list of integer vectors or, for convenience, a single integer vector
#' @return character vector
#' 
#' @family encoding
#' @export
stri_enc_fromutf32 <- function(vec) {
   .Call("stri_enc_fromutf32", vec, PACKAGE="stringi")
}

