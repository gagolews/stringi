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
#' Translate String to with Full Case Mapping
#' 
#' @description
#' \code{stri_tolower} translates strings to lowercase,
#' \code{stri_toupper} -- to UPPERCASE,
#' and \code{stri_totitle} -- to Title Case.
#' 
#' @details
#' ICU implements full Unicode string case mappings. In general,
#' \itemize{
#' \item case mapping can change the number of code points and/or code units of a string,
#' \item is language-sensitive (results may differ depending on locale), and
#' \item is context-sensitive (a character in the input string may map differently depending on surrounding characters).
#' }
#' 
#' @param str character vector on which casefolding is applied
#' @param locale \code{NULL} or \code{""} for casefolding following
#' the conventions of the default locale, or a single string with locale identifier
#' @return character vector
#' 
#' @references
#' Case Mappings - ICU User Guide, http://userguide.icu-project.org/transforms/casemappings
#' @family locale_sensitive
#' @aliases casefold
#' @export
#' @rdname casefold
#' 
#' @examples
#' stri_toupper("\u00DF", "de_DE") # small german double s
#' stri_toupper("i", "en_US") != stri_toupper("i", "tr_TR")
#' stri_toupper(c('abc','123','\u0105\u0104'))
#' 
#' stri_tolower(c('AbC','123','\u0105\u0104'))
#' 
#' stri_totitle(c('AbC','123','\u0105\u0104'))
#' stri_totitle("aLA mA kOTA")
stri_tolower <- function(str, locale=NULL) {
   .Call("stri_casefold", str, 1L, locale, PACKAGE="stringi")
}


#' @export
#' @rdname casefold
stri_toupper <- function(str, locale=NULL) {
   .Call("stri_casefold", str, 2L, locale, PACKAGE="stringi")
}


#' @export
#' @rdname casefold
stri_totitle <- function(str, locale=NULL) {
   .Call("stri_casefold", str, 3L, locale, PACKAGE="stringi")
}
