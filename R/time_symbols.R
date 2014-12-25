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
#' List Localizable Date-Time Formatting Data 
#'
#' @description
#' Returns a list of all localizable date-time formatting data,
#' including month and weeday names, localized AM/PM strings, etc.
#' 
#' \code{context} stands for a selector for date formatting context
#' and \code{width} - for  date formatting width.
#'
#' 
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier.
#' @param context single string; one of: \code{"format"}, \code{"standalone"}.
#' @param width single string; one of: \code{"abbreviated"}, \code{"wide"}, \code{"narrow"}.
#' 
#' @return Returns a list with the following named components:
#' \enumerate{
#' \item \code{Months} - month names,
#' \item \code{Weekdays} - weekday names,
#' \item \code{Quarters} - quarter names,
#' \item \code{AmPm} - AM/PM names,
#' \item \code{Era} - era names.
#' }
#'
#' @references
#' \emph{DateFormatSymbols} class -- ICU API Documentation,
#' \url{http://icu-project.org/apiref/icu4c/classicu_1_1DateFormatSymbols.html}
#' 
#' \emph{Formatting Dates and Times} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/formatparse/datetime}
#' 
#' @family datetime
#' @export
stri_datetime_symbols <- function(locale=NULL, context="standalone", width="wide") {
   .Call(C_stri_datetime_symbols, locale, context, width)
}
