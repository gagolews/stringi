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
#' Character Encodings and \pkg{stringi}
#'
#' @description
#' This manual page explains how to deal with different character encodings
#' in \pkg{stringi}. In particular you should note that:
#' \itemize{
#'    \item Functions in \pkg{stringi} process each string
#'    internally in Unicode,
#'    which is a superset of all character representation schemes.
#'    Even if a string is given in the native encoding, i.e. your platform's
#'    default one,
#'    it will be converted to Unicode.
#'    \item Most functions always return UTF-8 encoded strings,
#'    regardless of the input encoding.
#' }
#'
#' @details
#' "Hundreds of encodings have been developed over the years, each for small
#' groups of languages and for special purposes. As a result,
#' the interpretation of text, input, sorting, display, and storage
#' depends on the knowledge of all the different types of character sets
#' and their encodings. Programs have been written to handle either
#' one single encoding at a time and switch between them, or to convert
#' between external and internal encodings."
#'
#' "Unicode provides a single character set that covers the major
#' languages of the world, and a small number of machine-friendly encoding
#' forms and schemes to fit the needs of existing applications and protocols.
#' It is designed for best interoperability with both ASCII and ISO-8859-1
#' (the most widely used character sets) to make it easier for Unicode to be
#' used in almost all applications and protocols" (see the ICU User Guide).
#'
#' The Unicode Standard determines the way to map any possible character
#' to a numeric value -- a so-called code point.
#' Such code points, however, have to be stored
#' somehow in computer's memory.
#' The Unicode Standard encodes characters in the range U+0000..U+10FFFF,
#' which amounts to a 21-bit code space. Depending on the encoding
#' form (UTF-8, UTF-16, or UTF-32), each character will
#' then be represented either as a sequence of one to four 8-bit bytes,
#' one or two 16-bit code units, or a single 32-bit integer
#' (cf. the ICU FAQ).
#'
#'  In most cases, Unicode is a superset of the characters
#' supported by any given codepage.
#'
#' @section UTF-8 and UTF-16:
#'
#' The UTF-8 encoding is the most natural choice for representing
#' Unicode characters in \R.
#' UTF-8 has ASCII as its subset (code points 1--127 are the same
#' in both of them). Code points larger than 127
#' are represented by multi-byte sequences
#' (from 2 to 4 bytes:
#' not all sequences of bytes are valid UTF-8,
#' cf. \code{\link{stri_enc_isutf8}}).
#'
#' Most of the computations in \pkg{stringi} are performed internally
#' using either UTF-8 or UTF-16 encodings
#' (this depends on type of service you request:
#' some \pkg{ICU} services are designed to work only with UTF-16).
#' Thanks to that choice, with \pkg{stringi}
#' you get the same result on each platform,
#' which is -- unfortunately -- not the case of base \R's functions
#' (it is for example known that performing a regular expression
#' search under Linux on some texts may give you a different result
#' to those obtained under Windows).
#' We really had portability in our minds while developing
#' our package!
#'
#' We have observed that \R correctly handles UTF-8 strings regardless of your
#' platform's Native encoding (see below).
#' Therefore, we decided that most functions
#' in \pkg{stringi} will output its results in UTF-8
#' -- this speeds ups computations on cascading calls to our functions:
#' the strings does not have to be re-encoded each time.
#'
#' Note that some Unicode characters may have an
#' ambiguous representation. For example, ``a with ogonek'' (one character)
#' and ``a''+``ogonek'' (two graphemes) are semantically the same.
#' \pkg{stringi} provides functions to normalize
#' character sequences, \code{\link{stri_enc_nfc}}
#' for discussion. However, denormalized strings
#' do appear very rarely in typical string processing activities.
#'
#'
#' @section Character Encodings in \R:
#'
#' You should keep in mind that data in memory are just bytes
#' (small integer values) -- an en\emph{coding} is a way to represent
#' characters with such numbers, it is a semantic "key" to understand
#' a given byte sequence. For example,
#' in ISO-8859-2 (Central European), the value 177 represents
#' Polish ``a with ogonek'',
#' and in ISO-8859-1 (Western European), the same value
#' meas the ``plus-minus'' sign.
#' Thus, a character encoding is a translation scheme:
#' we need to communicate
#' with \R somehow, relying on how it represents strings.
#'
#' Basically, \R has a very simple encoding-marking mechanism,
#' see \link{Encoding}. There is an implicit assumption
#' that your platform's default (native) encoding is
#' always an 8-bit one and it is a superset of ASCII --
#' \pkg{stringi} checks that when your native encoding
#' is being detected automatically on \pkg{ICU} initialization and each time
#' when you change it manually by calling \code{\link{stri_enc_set}}.
#'
#' Character strings in \R (internally) can be declared to be in:
#' \itemize{
#' \item ASCII (here, strings consist only of bytes codes not greater than 127);
#' \item \code{"UTF-8"};
#' \item \code{"latin1"}, i.e. ISO-8859-1 (Western European).
#' }
#' Moreover, there are two other cases:
#' \itemize{
#' \item \code{"bytes"} -- strings should be manipulated as bytes;
#' encoding is not set;
#' \item \code{"unknown"} (quite misleading name: no explicit
#' encoding mark) -- strings are
#' assumed to be in your platform's native (default) encoding.
#' }
#'
#' Native strings often appear as result of inputing
#' a string from keyboard or file. This makes sense: you operating
#' system works in some encoding and provides \R with some data.
#' Each time when a \pkg{stringi} function encounters a native string,
#' it assumes that data should be translated from the default
#' encoding, i.e. the one returned by \code{\link{stri_enc_get}}
#' (default encoding should only be changed if autodetect fails
#' on \pkg{stringi} load).
#'
#' Functions which allow \code{"bytes"} encoding markings are very rare in \pkg{stringi},
#' and were carefully selected. These are: \code{\link{stri_enc_toutf8}}
#' (with argument \code{is_unknown_8bit=TRUE}), \code{\link{stri_enc_toascii}},
#' and \code{\link{stri_encode}}.
#'
#' @section Encoding Conversion:
#'
#' Apart from automatic conversion from the native encoding,
#' you may re-encode a string manually, for example
#' when you load it from a file saved in different platform.
#' Call \code{\link{stri_enc_list}} for the list of
#' encodings supported by \pkg{ICU}.
#' Note that converter names are case-insensitive
#' and \pkg{ICU} tries to normalize the encoding specifiers.
#' Leading zeroes are ignored in sequences of digits (if further digits follow),
#' and all non-alphanumeric characters are ignored. Thus the strings
#' "UTF-8", "utf_8", "u*Tf08" and "Utf 8" are equivalent.
#'
#' The \code{\link{stri_encode}} function
#' allows you to convert between any given encodings
#' (in some cases you will obtain \code{"bytes"}-marked
#' strings, or even lists of raw vectors (i.e. for UTF-16).
#' There are also some useful more specialized functions,
#' like \code{\link{stri_enc_toutf32}} (converts a character vector to a list
#' of integers, where one code point is exactly one numeric value)
#' or \code{\link{stri_enc_toascii}} (substitutes all non-ASCII
#' bytes with the SUBSTITUTE CHARACTER,
#' which plays a similar role as \R's \code{NA} value).
#'
#' There are also some routines for automated encoding detection,
#' see e.g. \code{\link{stri_enc_detect}} (for \pkg{ICU}-provided facilities)
#' or \code{\link{stri_enc_detect2}} for our own, locale-sensitive solution.
#'
#'
#' @section Encoding Detection:
#'
#' Given a text file, one has to know how to interpret (encode)
#' raw data in order to obtain meaningful information.
#'
#' Encoding detection is always an imprecise operation and
#' needs a considerable amount of data. However, in case of some
#' encodings (like UTF-8, ASCII, or UTF-32) a ``false positive'' byte
#' sequence is quite rare (statistically).
#'
#' Check out \code{\link{stri_enc_detect}} and
#' \code{\link{stri_enc_detect2}} (among others) for useful
#' functions from this category.
#'
#' @name stringi-encoding
#' @rdname stringi-encoding
#' @family stringi_general_topics
#' @family encoding_management
#' @family encoding_normalization
#' @family encoding_detection
#' @family encoding_conversion
#'
#' @references
#' \emph{Unicode Basics} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/unicode}
#'
#' \emph{Conversion} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/conversion}
#'
#' \emph{Converters} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/conversion/converters}  (technical details)
#'
#' \emph{UTF-8, UTF-16, UTF-32 & BOM} -- ICU FAQ, \url{http://www.unicode.org/faq/utf_bom.html}
invisible(NULL)
