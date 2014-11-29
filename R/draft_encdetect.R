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
#' [DRAFT API] Detect Character Set and Language
#'
#' @description
#' This function uses the \pkg{ICU} engine to determine the character set,
#' or encoding, of character data in an unknown format.
#'
#' @details
#' Vectorized over \code{str} and \code{filter_angle_brackets}.
#'
#' This is, at best, an imprecise operation using statistics and heuristics.
#' Because of this, detection works best if you supply at least a few hundred
#' bytes of character data that's mostly in a single language.
#' However, Because the detection only looks at a limited amount of the input
#' byte data, some of the returned charsets may fail to handle the
#' all of input data. Note that in some cases,
#' the language can be determined along with the encoding.
#'
#' Several different techniques are used for character set detection.
#' For multi-byte encodings, the sequence of bytes is checked for legal patterns.
#' The detected characters are also check against a list of frequently
#' used characters in that encoding. For single byte encodings, the data
#' is checked against a list of the most commonly occurring three letter groups
#' for each language that can be written using that encoding.
#'
#' The detection process can be configured to optionally ignore
#' HTML or XML style markup (using \pkg{ICU}'s internal facilities),
#' which can interfere with the detection
#' process by changing the statistics.
#'
#' This function should most often be used for byte-marked input strings,
#' especially after loading them from text files and before the main
#' conversion with \code{\link{stri_encode}}.
#' The input encoding is of course not taken into account here, even
#' if marked.
#'
#' The following table shows all the encodings that can be detected:
#'
#' \tabular{ll}{
#' \strong{Character_Set} \tab \strong{Languages}\cr
#' UTF-8 \tab -- \cr
#' UTF-16BE \tab -- \cr
#' UTF-16LE \tab -- \cr
#' UTF-32BE \tab -- \cr
#' UTF-32LE \tab -- \cr
#' Shift_JIS \tab Japanese \cr
#' ISO-2022-JP \tab Japanese \cr
#' ISO-2022-CN \tab Simplified Chinese \cr
#' ISO-2022-KR \tab Korean \cr
#' GB18030 \tab Chinese \cr
#' Big5 \tab Traditional Chinese \cr
#' EUC-JP \tab Japanese \cr
#' EUC-KR \tab Korean \cr
#' ISO-8859-1 \tab Danish, Dutch, English, French, German, Italian, Norwegian, Portuguese, Swedish \cr
#' ISO-8859-2 \tab Czech, Hungarian, Polish, Romanian \cr
#' ISO-8859-5 \tab Russian \cr
#' ISO-8859-6 \tab Arabic \cr
#' ISO-8859-7 \tab Greek \cr
#' ISO-8859-8 \tab Hebrew \cr
#' ISO-8859-9 \tab Turkish \cr
#' windows-1250 \tab Czech, Hungarian, Polish, Romanian \cr
#' windows-1251 \tab Russian \cr
#' windows-1252 \tab Danish, Dutch, English, French, German, Italian, Norwegian, Portuguese, Swedish \cr
#' windows-1253 \tab Greek \cr
#' windows-1254 \tab Turkish \cr
#' windows-1255 \tab Hebrew \cr
#' windows-1256 \tab Arabic \cr
#' KOI8-R \tab Russian \cr
#' IBM420 \tab Arabic \cr
#' IBM424 \tab Hebrew \cr
#' }
#'
#' If you have some initial guess on language and encoding, try with
#' \code{\link{stri_enc_detect2}}.
#'
#' @param str character vector, a raw vector, or
#' a list of \code{raw} vectors
#'
#' @param filter_angle_brackets logical; If filtering is enabled,
#' text within angle brackets ("<" and ">") will be removed before detection,
#' which will remove most HTML or XML markup.
#'
#' @return Returns a list of length equal to the length of \code{str}.
#' Each list element is a list with the following three named vectors
#' representing all guesses:
#' \itemize{
#'    \item \code{Encoding} -- string; guessed encodings; \code{NA} on failure,
#'    \item \code{Language} -- string; guessed languages; \code{NA} if the language could
#'    not be determined (e.g. in case of UTF-8),
#'    \item \code{Confidence} -- numeric in [0,1]; the higher the value,
#'    the more confidence there is in the match; \code{NA} on failure.
#' }
#' The guesses are ordered w.r.t. nonincreasing confidence.
#'
#' @examples
#' \dontrun{
#' f <- rawToChar(readBin("test.txt", "raw", 100000))
#' stri_enc_detect(f)
#' }
#'
#' @references
#' \emph{Character Set Detection} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/conversion/detection}
#'
#' @family encoding_detection
#' @export
stri_enc_detect <- function(str, filter_angle_brackets=FALSE) {
   .Call(C_stri_enc_detect, str, filter_angle_brackets)
}


#' @title
#' [DRAFT API] Detect Locale-Sensitive Character Encoding
#'
#' @description
#' This function tries to detect character encoding
#' in case the language of text is known.
#'
#' \bold{[THIS IS AN EXPERIMENTAL FUNCTION]}
#'
#' @details
#' Vectorized over \code{str}.
#'
#' First, the text is checked whether it is valid
#' UTF-32BE, UTF-32LE, UTF-16BE, UTF-16LE, UTF-8
#' (as in \code{\link{stri_enc_detect}},
#' this slightly bases on \pkg{ICU}'s \code{i18n/csrucode.cpp},
#' but we do it in our own way, however) or ASCII.
#'
#'
#' If \code{locale} is not \code{NA} and the above fails,
#' the text is checked for the number of occurrences
#' of language-specific code points (data provided by the \pkg{ICU} library)
#' converted to all possible 8-bit encodings
#' that fully cover the indicated language.
#' The encoding is selected basing on the greatest number of total
#' byte hits.
#'
#' The guess is of course imprecise
#' [\bold{This is DRAFT API - still does not work as expected}],
#' as it is obtained using statistics.
#' Because of this, detection works best if you supply at least a few hundred
#' bytes of character data that's in a single language.
#'
#'
#' If you have no initial guess on language and encoding, try with
#' \code{\link{stri_enc_detect}} (uses \pkg{ICU} facilities).
#' However, it turns out that (empirically) \code{stri_enc_detect2}
#' works better than the \pkg{ICU}-based one if UTF-* text
#' is provided. Test yourself.
#'
#' @param str character vector, a raw vector, or
#' a list of \code{raw} vectors
#' @param locale \code{NULL} or \code{""}
#' for default locale,
#' \code{NA} for just checking the UTF-* family,
#' or a single string with locale identifier.
#'
#' @return
#' Just like \code{\link{stri_enc_detect}},
#' this function returns a list of length equal to the length of \code{str}.
#' Each list element is a list with the following three named components:
#' \itemize{
#'    \item \code{Encoding} -- string; guessed encodings; \code{NA} on failure
#'    (iff \code{encodings} is empty),
#'    \item \code{Language} -- always \code{NA},
#'    \item \code{Confidence} -- numeric in [0,1]; the higher the value,
#'    the more confidence there is in the match; \code{NA} on failure.
#' }
#' The guesses are ordered w.r.t. nonincreasing confidence.
#'
#' @family locale_sensitive
#' @family encoding_detection
#' @export
stri_enc_detect2 <- function(str, locale=NULL) {
   .Call(C_stri_enc_detect2, str, locale)
}
