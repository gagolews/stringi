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
#' Note that not all services may be available for all locales.
#' 
#' @return Character vector of supported locale indentifiers
#' @family locale_management
#' @export
stri_locale_list <- function() {
   .Call("stri_locale_list", PACKAGE="stringi")
}


#' Set Default Locale
#'
#' See \link{stringi-locale} for more information on the effect of
#' changing default locale.
#' 
#' @param locale a character string of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variant}, e.g. "en_US",
#' see \code{\link{stri_locale_list}}
#' @return Previously set default locale, invisibly.
#' @family locale_management
#' @export
stri_locale_set <- function(locale) {
   previous <- stri_locale_get()
   .Call("stri_locale_set", locale, PACKAGE="stringi")
   
   # We call stri_info, because it generates some warnings,
   # in case any problems are found:
   message('You are now working with ' %+% stri_info(short=TRUE))
   invisible(previous)
}


#' Get Default Locale
#' 
#' Same as \code{stri_locale_info()$Name}.
#' 
#' @return a character string of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variant}, e.g. "en_US" 
#' @family locale_management
#' @export
stri_locale_get <- function() {
   stri_locale_info(NULL)$Name
}


#' Query Given Locale
#' 
#' Note that here you may gen info on any desired locale,
#' even if it is unsupported by ICU or if you pass a malformed locale
#' identified (e.g. not of the form Language_Country). See \link{stringi-locale}
#' for the discussion.
#' 
#' @param locale \code{NULL} or \code{""} for default locale, or a single string with locale identifier
#' 
#' @return A list with the following elements: \code{Language}, \code{Country}, \code{Variant} and
#' their combination, \code{Name}. Each is a character string.
#' @family locale_management
#' @export
stri_locale_info <- function(locale=NULL) {
   .Call("stri_locale_info", locale, PACKAGE="stringi")
}

