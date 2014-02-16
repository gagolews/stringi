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
#' List Available Locales
#'
#' @description
#' Creates a character vector with all known locale identifies.
#'
#' @details
#' Note that not all services may be available for all locales.
#' Queries for locale-specific services are always performed
#' during the resource request.
#'
#' See \link{stringi-locale} for more information.
#'
#' @return
#' Returns a character vector with locale identifiers
#' that are known to \pkg{ICU}.
#'
#' @family locale_management
#' @export
stri_locale_list <- function() {
   .Call("stri_locale_list", PACKAGE="stringi")
}


#' @title
#' Set or Get Default Locale in \pkg{stringi}
#'
#' @description
#' \code{stri_locale_set} changes default locale for all  functions
#' in the \pkg{stringi} package,
#' i.e. establishes the meaning of the ``\code{NULL} locale'' argument
#' of locale-sensitive functions. On the other hand, \code{stri_locale_get}
#' gets current default locale.
#'
#' @details
#' See \link{stringi-locale} for more information on the effect of
#' changing default locale.
#'
#' \code{stri_locale_get} is the same as \code{\link{stri_locale_info}(NULL)$Name}.
#'
#' @param locale single string of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variant}, e.g. "en_US",
#' see \code{\link{stri_locale_list}}
#'
#' @return
#' \code{stri_locale_set} returns a string with
#' previously used locale, invisibly.
#'
#' \code{stri_locale_get} returns a string of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variant}, e.g. "en_US".
#'
#' @family locale_management
#' @rdname stri_locale_set
#' @examples
#' \dontrun{
#' oldloc <- stri_locale_set("pt_BR")
#' # ... some locale-dependent operations
#' # ... note that you may always modify a locale per-call
#' # ... changing default locale is convinient if you perform
#' # ... many operations
#' stri_locale_set(oldloc) # restore previous default locale
#' }
#' @export
stri_locale_set <- function(locale) {
   previous <- stri_locale_get()
   .Call("stri_locale_set", locale, PACKAGE="stringi")

   # We call stri_info, because it generates some warnings,
   # in case any problems are found:
   message('You are now working with ' %+% stri_info(short=TRUE))
   invisible(previous)
}


#' @rdname stri_locale_set
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
#' With this function you may obtain some basic information
#' on any provided locale identifier,
#' even if it is unsupported by \pkg{ICU} or if you pass a malformed locale
#' identifier (the one that is not e.g. of the form Language_Country).
#' See \link{stringi-locale} for discussion.
#'
#' This function does nothing complicated. In many
#' cases it is similar to a call to
#' \code{\link{as.list}(\link{stri_split_fixed}(locale, "_", 3L, opts_collator=NA)[[1]])},
#' with \code{locale} case mapped.
#' It may be used, however, to get insight on how ICU understands a provided
#' locale identifier.
#'
#' @param locale \code{NULL} or \code{""}
#' for default locale,
#' or a single string with locale identifier.
#'
#' @return
#' Returns a list with the following named character strings:
#' \code{Language}, \code{Country}, \code{Variant}, and
#' \code{Name}, being their underscore separated combination.
#'
#' @examples
#' stri_locale_info("pl_PL")
#' stri_locale_info("Pl_pL") # the same result
#'
#' @family locale_management
#' @export
stri_locale_info <- function(locale=NULL) {
   .Call("stri_locale_info", locale, PACKAGE="stringi")
}
