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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.


#' @title
#' Character Encodings and \pkg{stringi}
#'
#' @description
#' This manual page explains how to deal with different character encodings
#' in \pkg{stringi}. In particular you should remember that:
#' \itemize{
#'    \item Functions in \pkg{stringi} process each string
#'    internally in Unicode encoding,
#'    which is a superset of all character coding schemes.
#'    Even if a string is given in Native encoding,
#'    it will be converted to Unicode.
#'    \item Most functions always return UTF-8 encoded strings,
#'    regardless of the input encoding.
#' }
#'
#' @details
#' Hundreds of encodings have been developed over the years, each for small
#' groups of languages and for special purposes. As a result,
#' the interpretation of text, input, sorting, display, and storage
#' depends on the knowledge of all the different types of character sets
#'  and their encodings. Programs have been written to handle either
#'  one single encoding at a time and switch between them, or to convert
#'   between external and internal encodings.
#'
#' Unicode provides a single character set that covers the major
#' languages of the world, and a small number of machine-friendly encoding
#'  forms and schemes to fit the needs of existing applications and protocols.
#'  It is designed for best interoperability with both ASCII and ISO-8859-1
#'  (the most widely used character sets) to make it easier for Unicode to be
#'  used in almost all applications and protocols (see the ICU User Guide).
#'
#' The Unicode Standard determines the way to map any possible character
#' to a numeric value -- a so-called code points.
#' Such code points, however, have to be stored
#' somehow in computer's memory.
#' The Unicode Standard encodes characters in the range U+0000..U+10FFFF,
#' which amounts to a 21-bit code space. Depending on the encoding
#' form (UTF-8, UTF-16, or UTF-32), each character will
#' then be represented either as a sequence of one to four 8-bit bytes,
#'  one or two 16-bit code units, or a single 32-bit code unit
#'  (cf. the ICU FAQ).
#'
#' @section UTF-8 and UTF-16:
#'
#' The UTF-8 encoding is the most natural choice in R.
#' UTF-8 has ASCII as its subset (code points 1--127 are the same
#' in both of them). Code points larger than 127
#' are represented by multi-byte sequences
#' (from 2 to 4 bytes:
#' not all sequences of bytes are valid UTF-8).
#'
#' Unicode normalization..... see \code{\link{stri_enc_nfc}}
#' for discussion
#'
#' Most of the computations in \pkg{stringi} are performed internally
#' using either UTF-8 or UTF-16 encodings
#' (this depends on type of service you request:
#' often ICU is designed to work only with UTF-16).
#' Thanks to that choice, with \pkg{stringi}
#' you get the same result on each platform,
#' which is -- unfortunately -- not the case of base R's functions
#' (it is for example known that performing a regular expression
#' search under Linux on some texts may give you a different results
#' to those obtained under Windows).
#' We really had portability in our minds while developing
#' our package!
#'
#' As R handles UTF-8 strings well regardless of your platform's Native encoding
#' (see below), most functions in \pkg{stringi} output results in UTF-8
#' -- this speeds ups computations on cascading calls to our functions:
#' the strings does not have to be re-encoded each time.
#'
#'
#' @section Character Encodings in R:
#'
#' You should keep in mind that data in memory are just bytes
#' (small integer values) -- an encoding is a way to represent
#' characters with such numbers. For example,
#' In ISO-8859-2 (Central European), the value 177 represents
#' Polish ``a with ogonek'',
#' and in ISO-8859-1 (Western European), the same value
#' meas the ``plus-minus'' sign.
#' Thus, a character encoding is a translation scheme
#' and we need to communicate
#' with R somehow, relying on how it represents strings.
#'
#' Basically, R has a very simple encoding-marking mechanism,
#' see \link{Encoding}. There is an implicit assumption
#' that your platform's default (native) encoding is
#' always an 8-bit one and it is a superset of ASCII --
#' \pkg{stringi} checks that when your native encoding
#' is being autodetected on ICU initialization and each time
#' when you change it manually by calling \code{\link{stri_enc_set}}.
#'
#' Character strings in R (internally) can be declared to be in:
#' \itemize{
#' \item ASCII -- strings consist only of bytes codes not greater than 127;
#' \item \code{"UTF-8"};
#' \item \code{"latin1"} -- strings are in ISO-8859-1 (Western European).
#' }
#' Moreover, there are two other cases:
#' \itemize{
#' \item \code{"bytes"} -- strings should be manipulated as bytes;
#' encoding is unknown;
#' \item \code{"unknown"} (quite misleading name: no explicit
#' encoding mark) -- strings are
#' assumed to be in platform's Native (default) encoding.
#' }
#'
#' Native strings often appear as result of inputing
#' a string from keyboard or file. This makes sense: you operating
#' system works in some encoding and provides R with some data.
#' Each time when a \pkg{stringi} function encounters a Native string,
#' it assumes that data should be translated from the default
#' encoding, i.e. that returned by \code{\link{stri_enc_get}}
#' (default encoding should only be changed if autodetect fails
#' on \pkg{stringi} load).
#'
#' Functions which allow \code{"bytes"} encoding marks are very rare in \pkg{stringi},
#' and were carefully selected. These are: \code{\link{stri_enc_toutf8}}
#' (with argument \code{is_unknown_8bit=TRUE}), \code{\link{stri_enc_toascii}},
#' and \code{\link{stri_encode}}.
#'
#' @section Encoding Management:
#'
#' ... TO DO ...
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
#'  "UTF-8", "utf_8", "u*Tf08" and "Utf 8" are equivalent.
#'
#'
#' @name stringi-encoding
#' @rdname string-encoding
#' @aliases encoding
#' @family stringi_general_topics
#' @family encoding_management
#' @family encoding_normalization
#' @family encoding_detection
#' @family encoding_conversion
#'
#' @references
#' \emph{Conversion} -- ICU User Guide, \url{http://userguide.icu-project.org/conversion}
#'
#' \emph{Converters} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/conversion/converters}  (technical details)
#'
#' \emph{UTF-8, UTF-16, UTF-32 & BOM} -- ICU FAQ, \url{http://www.unicode.org/faq/utf_bom.html}
invisible(NULL)
