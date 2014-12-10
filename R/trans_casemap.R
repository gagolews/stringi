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
#' Transform String with Case Mapping
#'
#' @description
#' These functions transform strings either to lower case,
#' UPPER CASE, or to Title Case.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' \pkg{ICU} implements full Unicode string case mappings. In general,
#' \itemize{
#' \item case mapping can change the number of code points and/or code units
#'    of a string,
#' \item is language-sensitive (results may differ depending on locale), and
#' \item is context-sensitive (a character in the input string may map
#'    differently depending on surrounding characters).
#' }
#'
#' With \code{stri_trans_totitle}, if \code{word} \code{BreakIterator}
#' is used (the default), then the first letter of each word will be capitalized
#' and the rest will be transformed to lower case.
#' With a break iterator of type \code{sentence}, the first letter
#' of each sentence will be capitalized only.
#' Note that according the \pkg{ICU} User Guide,
#' the string \code{"one. two. three."} consists of one sentence.
#'
#' For more general (but not locale dependent)
#' text transforms refer to \code{\link{stri_trans_general}}.
#'
#' @param str character vector
#' @param locale \code{NULL} or \code{""} for case mapping following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}.
#' @param opts_brkiter a named list with \pkg{ICU} BreakIterator's settings
#' as generated with \code{\link{stri_opts_brkiter}};
#' \code{NULL} for default break iterator, i.e. \code{word};
#' \code{stri_trans_totitle} only
#' @param ... additional settings for \code{opts_brkiter}
#'
#' @return
#' Each function returns a character vector.
#'
#' @references
#' \emph{Case Mappings} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/transforms/casemappings}
#'
#' @family locale_sensitive
#' @family transform
#' @export
#' @rdname stri_trans_casemap
#' @family text_boundaries
#'
#' @examples
#' stri_trans_toupper("\u00DF", "de_DE") # small German Eszett / scharfes S
#' stri_cmp_eq(stri_trans_toupper("i", "en_US"), stri_trans_toupper("i", "tr_TR"))
#' stri_trans_toupper(c('abc', '123', '\u0105\u0104'))
#' stri_trans_tolower(c('AbC', '123', '\u0105\u0104'))
#' stri_trans_totitle(c('AbC', '123', '\u0105\u0104'))
#' stri_trans_totitle("GOOD-OLD cOOkiE mOnSTeR IS watCHinG You. Here HE comes!") # word boundary
#' stri_trans_totitle("GOOD-OLD cOOkiE mOnSTeR IS watCHinG You. Here HE comes!", type="sentence")
stri_trans_tolower <- function(str, locale=NULL) {
   .Call(C_stri_trans_casemap, str, 1L, locale)
}


#' @export
#' @rdname stri_trans_casemap
stri_trans_toupper <- function(str, locale=NULL) {
   .Call(C_stri_trans_casemap, str, 2L, locale)
}


#' @export
#' @rdname stri_trans_casemap
stri_trans_totitle <- function(str, ..., opts_brkiter=NULL) {
   if (!missing(...))
       opts_brkiter <- do.call(stri_opts_brkiter, as.list(c(opts_brkiter, ...)))
   .Call(C_stri_trans_totitle, str, opts_brkiter)
}
