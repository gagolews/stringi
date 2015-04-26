## This file is part of the 'stringi' package for R.
## Copyright (C) 2013-2015, Marek Gagolewski and Bartek Tartanus
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
#' [DRAFT API] List Localizable Date-Time Formatting Data
#'
#' @description
#' Returns a list of all localizable date-time formatting data,
#' including month and weekday names, localized AM/PM strings, etc.
#'
#' @details
#' \code{context} stands for a selector for date formatting context
#' and \code{width} - for date formatting width.
#'
#'
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier
#' @param context single string; one of: \code{"format"}, \code{"standalone"}
#' @param width single string; one of: \code{"abbreviated"}, \code{"wide"}, \code{"narrow"}
#'
#' @return Returns a list with the following named components:
#' \enumerate{
#' \item \code{Month} - month names,
#' \item \code{Weekday} - weekday names,
#' \item \code{Quarter} - quarter names,
#' \item \code{AmPm} - AM/PM names,
#' \item \code{Era} - era names.
#' }
#'
#' @examples
#' stri_datetime_symbols() # uses the Gregorian calendar in most locales
#' stri_datetime_symbols("@@calendar=hebrew")
#' stri_datetime_symbols("he_IL@@calendar=hebrew")
#' stri_datetime_symbols("@@calendar=islamic")
#' stri_datetime_symbols("@@calendar=persian")
#' stri_datetime_symbols("@@calendar=indian")
#' stri_datetime_symbols("@@calendar=coptic")
#' stri_datetime_symbols("@@calendar=japanese")
#'
#' stri_datetime_symbols("ja_JP_TRADITIONAL") # uses the Japanese calendar by default
#' stri_datetime_symbols("th_TH_TRADITIONAL") # uses the Buddhist calendar
#'
#' stri_datetime_symbols("pl_PL", context="format")
#' stri_datetime_symbols("pl_PL", context="standalone")
#'
#' stri_datetime_symbols(width="wide")
#' stri_datetime_symbols(width="abbreviated")
#' stri_datetime_symbols(width="narrow")
#'
#' @references
#' \emph{Calendar} - ICU User Guide,
#' \url{http://userguide.icu-project.org/datetime/calendar}
#'
#' \emph{DateFormatSymbols} class -- ICU API Documentation,
#' \url{http://icu-project.org/apiref/icu4c/classicu_1_1DateFormatSymbols.html}
#'
#' \emph{Formatting Dates and Times} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/formatparse/datetime}
#'
#' @family datetime
#' @export
stri_datetime_symbols <- function(locale=NULL, context="standalone", width="wide") {
   # Possibly @TODO:
   # get first day of week
   .Call(C_stri_datetime_symbols, locale, context, width)
}
