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



#' List Available Locales
#'
#' @return Character vector
#' @seealso \code{\link{stri_locale_info}}
#' @export
stri_locale_list <- function() {
   .Call("stri_locale_list", PACKAGE="stringi")
}


#' Set Default Locale
#'
#' ICU4C API DOC: "Because a Locale is just an identifier for a region, 
#' no validity check is performed when you specify a Locale. 
#' If you want to see whether particular resources are available 
#' for the Locale you asked for, you must query those resources. (...)
#' Note: When you ask for a resource for a particular locale, you get
#' back the best available match, not necessarily precisely what you asked for.
#' 
#' TODO: More details needed on how to set the locale. Maybe we should create a separate man page on Locales....
#' 
#' @param loc a character string of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variang}, e.g. "en_US"
#' @return Previously set default locale
#' @seealso \code{\link{stri_localelist}}
#' @export
stri_locale_set <- function(loc) {
   previous <- stri_locale_get()
   .Call("stri_locale_set", loc, PACKAGE="stringi")
   
   # We call stri_info, be cause it generates some warnings if any problems
   # are found:
   message('Now you are working with ' %+% stri_info(short=TRUE))
   invisible(previous)
}


#' Get Default Locale
#' 
#' Same as \code{stri_locale_info(NULL)$Name}.
#' 
#' @return a character string of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variang}, e.g. "en_US" 
#' @seealso \code{\link{stri_locale_info}}
#' @export
stri_locale_get <- function(loc=NULL) {
   .Call("stri_locale_info", NULL, PACKAGE="stringi")$Name
}


#' Query Given Locale
#' 
#' If loc is missing, NULL (default locale) is used
#' 
#' @param loc \code{NULL}, \code{""}, or \code{NA} for default locale, or a single string with locale name
#' @return A list with the following elements: \code{Language}, \code{Country}, \code{Variant} and
#' their combination, \code{Name}. Each is a character string.
#' @seealso \code{\link{stri_locale_list}}
#' @export
stri_locale_info <- function(loc=NULL) {
   .Call("stri_locale_info", loc, PACKAGE="stringi")
}

