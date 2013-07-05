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
#' List Available Locales
#'
#' @description
#' Creates a character vector with all known locale identifies.
#'
#' @details
#' Note that not all services may be available for all locales.
#' Queries for locale-specific services are always performed
#' during resource request.
#'
#' See \link{stringi-locale} for more information.
#'
#' @return character vector of supported locale identifiers
#' @family locale_management
#' @export
stri_locale_list <- function() {
   .Call("stri_locale_list", PACKAGE="stringi")
}


#' @title
#' Set Default Locale
#'
#' @description
#' Changes default locale for all \pkg{stringi} functions,
#' i.e. establishes the meaning of the ``\code{NULL} locale''
#' (in locale-sensitive functions).
#'
#' @details
#' See \link{stringi-locale} for more information on the effect of
#' changing default locale.
#'
#' @param locale a character string of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variant}, e.g. "en_US",
#' see \code{\link{stri_locale_list}}
#' @return previously set default locale, invisibly
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


#' @title
#' Get Default Locale
#'
#' @description
#' Gets current default locale in \pkg{stringi}, e.g.
#' reveals the meaning of the ``\code{NULL} locale''
#' (in locale-sensitive functions).
#'
#' @details
#' Same as \code{\link{stri_locale_info}()$Name}.
#'
#' See \link{stringi-locale} for more information.
#'
#' @return a character string of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variant}, e.g. "en_US"
#' @family locale_management
#' @export
stri_locale_get <- function() {
   stri_locale_info(NULL)$Name
}


#' @title
#' Query Given Locale
#'
#' @description
#' Provides some basic information on a given locale identifier.
#'
#' @details
#' With this function you may obtain some basic information on any provided locale identifier,
#' even if it is unsupported by ICU or if you pass a malformed locale
#' identifier (e.g. not of the form Language_Country). See \link{stringi-locale}
#' for discussion.
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

