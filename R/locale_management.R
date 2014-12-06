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
   .Call(C_stri_locale_list)
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
   .Call(C_stri_locale_set, locale)

   # We call stri_info, because it generates some warnings,
   # in case any problems are found:
   message(stri_paste('You are now working with ', stri_info(short=TRUE)))
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
#' \code{\link{as.list}(\link{stri_split_fixed}(locale, "_", 3L)[[1]])},
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
   .Call(C_stri_locale_info, locale)
}
