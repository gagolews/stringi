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
