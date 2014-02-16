## This file is part of the 'stringi' library.
##
## Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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
