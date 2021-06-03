# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2021, Marek Gagolewski <https://www.gagolewski.com>
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
#' General Text Transforms, Including Transliteration
#'
#' @description
#' \pkg{ICU} General transforms provide different ways
#' for processing Unicode text. They are useful in handling a variety
#' of different tasks, including:
#' \itemize{
#' \item    Upper Case, Lower Case, Title Case, Full/Halfwidth conversions,
#' \item    Normalization,
#' \item    Hex and Character Name conversions,
#' \item    Script to Script conversion/transliteration.
#' }
#'
#'
#' @details
#' \pkg{ICU} Transforms were mainly designed to transliterate characters
#' from one script to another (for example, from Greek to Latin,
#' or Japanese Katakana to Latin).
#' However, these services are also capable of handling a much
#' broader range of tasks.
#' In particular, the Transforms include pre-built transformations
#' for case conversions, for normalization conversions, for the removal
#' of given characters, and also for a variety of language and script
#' transliterations. Transforms can be chained together to perform
#' a series of operations and each step of the process can use a
#' UnicodeSet to restrict the characters that are affected.
#'
#' To get the list of available transforms,
#' call \code{\link{stri_trans_list}}.
#'
#' Note that transliterators are often combined in sequence
#' to achieve a desired transformation.
#' This is analogous to the composition of mathematical functions.
#' For example, given a script that converts lowercase ASCII characters
#' from Latin script to Katakana script, it is convenient to first
#' (1) separate input base characters and accents, and then (2)
#' convert uppercase to lowercase.
#' To achieve this, a compound transform can be specified as follows:
#' \code{NFKD; Lower; Latin-Katakana;} (with the default \code{rules=FALSE}).
#'
#' Custom rule-based transliteration is also supported, see the \pkg{ICU}
#' manual and below for some examples.
#'
#' @param str character vector
#' @param id a single string with transform identifier,
#'     see \code{\link{stri_trans_list}}, or custom transliteration rules
#' @param rules if \code{TRUE}, treat \code{id} as a string with
#'     semicolon-separated transliteration rules (see the \pkg{ICU} manual);
#' @param forward transliteration direction (\code{TRUE} for forward,
#'     \code{FALSE} for reverse)
#'
#' @return
#' Returns a character vector.
#'
#' @examples
#' stri_trans_general('gro\u00df', 'latin-ascii')
#' stri_trans_general('stringi', 'latin-greek')
#' stri_trans_general('stringi', 'latin-cyrillic')
#' stri_trans_general('stringi', 'upper') # see stri_trans_toupper
#' stri_trans_general('\u0104', 'nfd; lower') # compound id; see stri_trans_nfd
#' stri_trans_general('Marek G\u0105golewski', 'pl-pl_FONIPA')
#' stri_trans_general('\u2620', 'any-name') # character name
#' stri_trans_general('\\N{latin small letter a}', 'name-any') # decode name
#' stri_trans_general('\u2620', 'hex/c') # to hex
#'
#' x <- "\uC11C\uC6B8\uD2B9\uBCC4\uC2DC\u0020\uC885\uB85C\uAD6C\u0020\uC0AC\uC9C1\uB3D9"
#' stringi::stri_trans_general(x, "Hangul-Latin")
#' # Deviate from the ICU rules of Romanisation of Korean,
#' # see https://en.wikipedia.org/wiki/%E3%84%B1
#' id <- "
#'     :: NFD;
#'     \u11A8 > k;
#'     \u11AE > t;
#'     \u11B8 > p;
#'     \u1105 > r;
#'     :: Hangul-Latin;
#' "
#' stringi::stri_trans_general(x, id, rules=TRUE)
#'
#'
#' @references
#' \emph{General Transforms} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/transforms/general/}
#'
#' @family transform
#' @export
stri_trans_general <- function(str, id, rules=FALSE, forward=TRUE)
{
    .Call(C_stri_trans_general, str, id, rules, forward)
}


#' @title
#' List Available Text Transforms and Transliterators
#'
#' @description
#' Returns a list of available text transform identifiers.
#' Each of them may be used in \code{\link{stri_trans_general}}
#' tasks.
#'
#' @return Returns a character vector.
#'
#' @references
#' \emph{General Transforms} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/transforms/general/}
#'
#' @examples
#' stri_trans_list()
#'
#' @family transform
#' @export
stri_trans_list <- function()
{
    stri_sort(
        .Call(C_stri_trans_list), locale="en_US", numeric=TRUE, strength=1
    )
}
