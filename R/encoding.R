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
#' Character Encodings and \pkg{stringi}
#'
#' @description
#' This section explains how we deal with character encodings
#' in \pkg{stringi}.
#'
#' @details
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
#' @section UTF-8:
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
#' codepoints input in R: uxxxxxx vs Uxxxxxx
#'
#'
#'
#' @section Encoding Management:
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
#'  "UTF-8", "utf_8", "u*Tf08" and "Utf 8" are equivalent.
#'
#'
#' @section Character Encodings in R:
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
#' Functions which allow `bytes` encoding marks are very rare in \pkg{stringi},
#' and were carefully selected. These are: \code{\link{stri_enc_toutf8}}
#' (with argument \code{is_unknown_8bit=TRUE}), \code{\link{stri_enc_toascii}},
#' and \code{\link{stri_encode}}.
#'
#' @section Encoding Conversion and Detection:
#'
#' TO DO ....
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
#' \emph{Conversion} - ICU User Guide, \url{http://userguide.icu-project.org/conversion}
#' 
#' \emph{Converters} - ICU User Guide, 
#' \url{http://userguide.icu-project.org/conversion/converters}  (technical details)
invisible(NULL)
