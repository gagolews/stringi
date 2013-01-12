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



#' Get list of available locales
#'
#' @return Character vector
#' @seealso \code{\link{stri_localeinfo}}
#' @export
stri_localelist <- function() {
   .Call("stri_localelist", PACKAGE="stringi")
}


#' Set default ICU locale
#'
#' ICU4C API DOC: "Because a Locale is just an identifier for a region, 
#' no validity check is performed when you specify a Locale. 
#' If you want to see whether particular resources are available 
#' for the Locale you asked for, you must query those resources. (...)
#' Note: When you ask for a resource for a particular locale, you get
#' back the best available match, not necessarily precisely what you asked for.
#' @return result of stri_info(short=TRUE)
#' @seealso \code{\link{stri_localelist}}
#' @export
stri_localeset <- function(loc) {
   .Call("stri_localeset", loc, PACKAGE="stringi")
   stri_info(short=TRUE)
}


#' Get info on given locale
#' 
#' If loc is missing, NULL (default locale) is used
#' 
#' @param loc NULL/""/missing for default locale, or a single string with locale name
#' @return A list with...
#' @seealso \code{\link{stri_localelist}}
#' @export
stri_localeinfo <- function(loc) {
   if (missing(loc)) loc <- NULL
   # prepare_arg done internally
   .Call("stri_localeinfo", loc, PACKAGE="stringi")
}

