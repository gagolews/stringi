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
#' Translate String with Case Mapping
#'
#' @description
#' These functions translate strings either to lower case,
#' UPPER CASE, or to Title Case.
#'
#' @details
#' \pkg{ICU} implements full Unicode string case mappings. In general,
#' \itemize{
#' \item case mapping can change the number of code points and/or code units
#'    of a string,
#' \item is language-sensitive (results may differ depending on locale), and
#' \item is context-sensitive (a character in the input string may map
#'    differently depending on surrounding characters).
#' }
#'
#' @param str character vector
#' @param locale \code{NULL} or \code{""} for case mapping following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}.
#' @return
#' Each function returns a character vector.
#'
#' @references
#' \emph{Case Mappings} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/transforms/casemappings}
#'
#' @family locale_sensitive
#' @export
#' @rdname stri_trans_case
#'
#' @examples
#' \dontrun{
#' stri_trans_toupper("\u00DF", "de_DE") # small German double s
#' stri_trans_toupper("i", "en_US") != stri_trans_toupper("i", "tr_TR")
#' stri_trans_toupper(c('abc','123','\u0105\u0104'))
#'
#' stri_trans_tolower(c('AbC','123','\u0105\u0104'))
#'
#' stri_trans_totitle(c('AbC','123','\u0105\u0104'))
#' stri_trans_totitle("aLA mA kOTA")
#'
#' stri_trans_totitle('taming of the shrew', locale='en_US') # TODO: we are working on this
#' }
stri_trans_tolower <- function(str, locale=NULL) {
   .Call("stri_trans_case", str, 1L, locale, PACKAGE="stringi")
}


#' @export
#' @rdname stri_trans_case
stri_trans_toupper <- function(str, locale=NULL) {
   .Call("stri_trans_case", str, 2L, locale, PACKAGE="stringi")
}


#' @export
#' @rdname stri_trans_case
stri_trans_totitle <- function(str, locale=NULL) {
   .Call("stri_trans_case", str, 3L, locale, PACKAGE="stringi")
}
