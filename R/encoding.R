# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
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
## 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
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
#' Character Encodings and \pkg{stringi}
#'
#' @description
#' This manual page explains how \pkg{stringi} deals with character
#' strings in various encodings.
#'
#' In particular we should note that:
#' \itemize{
#'    \item \R lets strings in ASCII, UTF-8, and your platform's
#'    native encoding coexist. A character vector printed on the console
#'    by calling \code{\link{print}} or \code{\link{cat}} is
#'    silently re-encoded to the native encoding.
#'    \item Functions in \pkg{stringi} process each string internally in
#'    Unicode, the most universal character encoding ever.
#'    Even if a string is given in the native encoding, i.e., your platform's
#'    default one, it will be converted to Unicode (precisely: UTF-8 or UTF-16).
#'    \item Most \pkg{stringi} functions always return UTF-8 encoded strings,
#'    regardless of the input encoding. What is more, the functions have been
#'    optimized for UTF-8/ASCII input (they have competitive, if not better
#'    performance, especially when performing more complex operations like
#'    string comparison, sorting, and even concatenation). Thus, it is
#'    best to rely on cascading calls to \pkg{stringi} operations solely.
#' }
#'
#' @details
#' Quoting the ICU User Guide,
#' 'Hundreds of encodings have been developed over the years, each for small
#' groups of languages and for special purposes. As a result,
#' the interpretation of text, input, sorting, display, and storage
#' depends on the knowledge of all the different types of character sets
#' and their encodings. Programs have been written to handle either
#' one single encoding at a time and switch between them, or to convert
#' between external and internal encodings.'
#'
#' 'Unicode provides a single character set that covers the major
#' languages of the world, and a small number of machine-friendly encoding
#' forms and schemes to fit the needs of existing applications and protocols.
#' It is designed for best interoperability with both ASCII and ISO-8859-1
#' (the most widely used character sets) to make it easier for Unicode to be
#' used in almost all applications and protocols' (see the ICU User Guide).
#'
#' The Unicode Standard determines the way to map any possible character
#' to a numeric value -- a so-called code point. Such code points, however,
#' have to be stored somehow in computer's memory.
#' The Unicode Standard encodes characters in the range U+0000..U+10FFFF,
#' which amounts to a 21-bit code space. Depending on the encoding
#' form (UTF-8, UTF-16, or UTF-32), each character will
#' then be represented either as a sequence of one to four 8-bit bytes,
#' one or two 16-bit code units, or a single 32-bit integer
#' (compare the ICU FAQ).
#'
#' Unicode can be thought of as a superset of the spectrum of characters
#' supported by any given code page.
#'
#' @section UTF-8 and UTF-16:
#'
#' For portability reasons, the UTF-8 encoding is the most natural choice
#' for representing Unicode character strings in \R. UTF-8 has ASCII as its
#' subset (code points 1--127 represent the same characters in both of them).
#' Code points larger than 127 are represented by multi-byte sequences
#' (from 2 to 4 bytes: Please note that not all sequences of bytes
#' are valid UTF-8, compare \code{\link{stri_enc_isutf8}}).
#'
#' Most of the computations in \pkg{stringi} are performed internally
#' using either UTF-8 or UTF-16 encodings (this depends on type of service
#' you request: some \pkg{ICU} services are designed only to work with UTF-16).
#' Due to such a choice, with \pkg{stringi} you get the same result on
#' each platform, which is -- unfortunately -- not the case of base \R's
#' functions (for instance, it is known that performing a regular expression
#' search under Linux on some texts may give you a different result
#' to those obtained under Windows). We really had portability in our minds
#' while developing our package!
#'
#' We have observed that \R correctly handles UTF-8 strings regardless of your
#' platform's native encoding (see below). Therefore, we decided that most
#' functions in \pkg{stringi} will output its results in UTF-8
#' -- this speeds ups computations on cascading calls to our functions:
#' the strings does not have to be re-encoded each time.
#'
#' Note that some Unicode characters may have an ambiguous representation.
#' For example, ``a with ogonek'' (one character) and ``a''+``ogonek''
#' (two graphemes) are semantically the same. \pkg{stringi} provides functions
#' to normalize character sequences, see \code{\link{stri_trans_nfc}}
#' for discussion. However, it is observed that denormalized strings
#' do appear very rarely in typical string processing activities.
#'
#' Additionally, do note that \pkg{stringi} silently removes byte order marks
#' (BOMs - they may incidentally appear in a string read from a text file)
#' from UTF8-encoded strings, see \code{\link{stri_enc_toutf8}}.
#'
#'
#' @section Character Encodings in \R:
#'
#' Data in memory are just bytes (small integer
#' values) -- an en\emph{coding} is a way to represent characters with such
#' numbers, it is a semantic 'key' to understand a given byte sequence.
#' For example, in ISO-8859-2 (Central European), the value 177 represents
#' Polish ``a with ogonek'', and in ISO-8859-1 (Western European),
#' the same value denotes the ``plus-minus'' sign. Thus, a character encoding
#' is a translation scheme: we need to communicate with \R somehow,
#' relying on how it represents strings.
#'
#' Overall, \R has a very simple encoding marking mechanism,
#' see \code{\link{stri_enc_mark}}. There is an implicit assumption
#' that your platform's default (native) encoding always extends
#' ASCII -- \pkg{stringi} checks that whenever your native encoding
#' is being detected automatically on \pkg{ICU}'s initialization and each time
#' when you change it manually by calling \code{\link{stri_enc_set}}.
#'
#' Character strings in \R (internally) can be declared to be in:
#' \itemize{
#' \item \code{UTF-8};
#' \item \code{latin1}, i.e., either ISO-8859-1 (Western European on
#' Linux, OS X, and other Unixes) or WINDOWS-1252 (Windows);
#' \item \code{bytes} -- for strings that
#'     should be manipulated as sequences of bytes.
#' }
#' Moreover, there are two other cases:
#' \itemize{
#' \item ASCII -- for strings consisting only of byte codes
#'                not greater than 127;
#' \item \code{native} (a.k.a. \code{unknown} in \code{\link{Encoding}};
#' quite a misleading name: no explicit encoding mark) -- for
#' strings that are assumed to be in your platform's native (default) encoding.
#' This can represent UTF-8 if you are an OS X user,
#' or some 8-bit Windows code page, for example.
#' The native encoding used by \R may be determined by examining
#' the LC_CTYPE category, see \code{\link{Sys.getlocale}}.
#' }
#'
#' Intuitively, ``native'' strings result from reading
#' a string from stdin (e.g., keyboard input). This makes sense: your operating
#' system works in some encoding and provides \R with some data.
#'
#' Each time when a \pkg{stringi} function encounters a string declared
#' in native encoding, it assumes that the input data should be translated
#' from the default encoding, i.e., the one returned by \code{\link{stri_enc_get}}
#' (unless you know what you are doing, the default encoding should only be
#' changed if the automatic encoding detection process fails on \pkg{stringi}
#' load).
#'
#' Functions which allow \code{'bytes'} encoding markings are very rare in
#' \pkg{stringi}, and were carefully selected. These are:
#' \code{\link{stri_enc_toutf8}} (with argument \code{is_unknown_8bit=TRUE}),
#' \code{\link{stri_enc_toascii}}, and \code{\link{stri_encode}}.
#'
#' Finally, note that \R lets strings in ASCII, UTF-8, and your platform's
#' native encoding coexist. A character vector printed with
#' \code{\link{print}}, \code{\link{cat}}, etc., is silently re-encoded
#' so that it can be properly shown, e.g., on the console.
#'
#'
#' @section Encoding Conversion:
#'
#' Apart from automatic conversion from the native encoding,
#' you may re-encode a string manually, for example
#' when you read it from a file created on a different platform.
#' Call \code{\link{stri_enc_list}} for the list of
#' encodings supported by \pkg{ICU}.
#' Note that converter names are case-insensitive
#' and \pkg{ICU} tries to normalize the encoding specifiers.
#' Leading zeroes are ignored in sequences of digits (if further digits follow),
#' and all non-alphanumeric characters are ignored. Thus the strings
#' 'UTF-8', 'utf_8', 'u*Tf08' and 'Utf 8' are equivalent.
#'
#' The \code{\link{stri_encode}} function
#' allows you to convert between any given encodings
#' (in some cases you will obtain \code{bytes}-marked
#' strings, or even lists of raw vectors (i.e., for UTF-16).
#' There are also some useful more specialized functions,
#' like \code{\link{stri_enc_toutf32}} (converts a character vector to a list
#' of integers, where one code point is exactly one numeric value)
#' or \code{\link{stri_enc_toascii}} (substitutes all non-ASCII
#' bytes with the SUBSTITUTE CHARACTER,
#' which plays a similar role as \R's \code{NA} value).
#'
#' There are also some routines for automated encoding detection,
#' see, e.g., \code{\link{stri_enc_detect}}.
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
#' sequence is quite rare (statistically speaking).
#'
#' Check out \code{\link{stri_enc_detect}} (among others) for a useful
#' function in this category.
#'
#' @name about_encoding
#' @rdname about_encoding
#' @aliases about_encoding stringi-encoding encoding
#' @family stringi_general_topics
#' @family encoding_management
#' @family encoding_detection
#' @family encoding_conversion
#'
#' @references
#' \emph{Unicode Basics} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/icu/unicode.html}
#'
#' \emph{Conversion} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/conversion/}
#'
#' \emph{Converters} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/conversion/converters.html}
#' (technical details)
#'
#' \emph{UTF-8, UTF-16, UTF-32 & BOM} -- ICU FAQ,
#' \url{https://www.unicode.org/faq/utf_bom.html}
invisible(NULL)
