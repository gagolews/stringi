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
#' List Available Time Zone Identifiers
#'
#' @description
#' Returns a list of available time zone identifiers.
#'
#' If  \code{offset} and \code{region} are \code{NA} (the default),
#' all time zones are returned. Otherwise,
#' only time zone IDs with a given raw offset from GMT are given
#' and/or time zones corresponding to a given region are provided.
#' Note that the effect of daylight savings time is ignored.
#' 
#' @param offset single numeric value;
#' a given raw offset from GMT, in hours
#' @param region single string;
#' a ISO 3166 two-letter country code or UN M.49 three-digit area code
#' 
#' @return Returns a character vector.
#'
#' @references
#' \emph{TimeZone} class -- ICU API Documentation,
#' \url{http://www.icu-project.org/apiref/icu4c/classicu_1_1TimeZone.html}
#' 
#' @examples
#' stri_timezone_list()
#' stri_timezone_list(offset=1)
#' stri_timezone_list(offset=5.5)
#' stri_timezone_list(offset=5.75)
#' stri_timezone_list(region="PL")
#' 
#' @family time
#' @family timezone
#' @export
stri_timezone_list <- function(region=NA_character_, offset=NA_integer_) {
   .Call(C_stri_timezone_list, region, offset)
}


#' @title
#' Set or Get Default Time Zone in \pkg{stringi}
#'
#' @description
#' \code{stri_timezone_set} changes default time zone for all  functions
#' in the \pkg{stringi} package,
#' i.e. establishes the meaning of the ``\code{NULL} time zone'' argument
#' of date/time processing functions. On the other hand, \code{stri_timezone_get}
#' gets current default time zone.
#'
#' @details
#' Unless the default time zone has already been set using \code{stri_timezone_set},
#' the default time zone is determined by querying the system using methods
#' in ICU's \code{TPlatformUtilities}. If the system routines fail,
#' or if they specify a TimeZone or TimeZone offset which is not recognized,
#' the TimeZone indicated by the ID kLastResortID is instantiated and made the default.
#'
#' @param tz single string; time zone identifier
#'
#' @return
#' \code{stri_timezone_set} returns a string with
#' previously used timezone, invisibly.
#'
#' \code{stri_timezone_get} returns a single string
#' with the current default time zone.
#' 
#' @references
#' \emph{TimeZone} class -- ICU API Documentation,
#' \url{http://www.icu-project.org/apiref/icu4c/classicu_1_1TimeZone.html}
#'
#' @examples
#' \dontrun{
#' oldtz <- stri_timezone_set("Europe/Warsaw")
#' # ... some time zone-dependent operations
#' stri_timezone_set(oldtz) # restore previous default time zone
#' }
#' 
#' @export
#' @family time
#' @family timezone
#' @rdname stri_timezone_set
#' @export
stri_timezone_get <- function() {
   stri_timezone_info()$ID
}


#' @rdname stri_timezone_set
#' @export
stri_timezone_set <- function(tz) {
    previous <- stri_timezone_get()
    .Call(C_stri_timezone_set, tz)
    invisible(previous)
}


#' @title
#' Query Given Time Zone
#'
#' @description
#' Provides some basic information on a given time zone identifier.
#'
#' @details
#' With this function you may obtain some basic information
#' on any supported time zone.
#'
#' @param tz \code{NULL} or \code{""} for default time zone,
#' a single string with time zone ID otherwise.
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier.
#'
#' @return
#' Returns a list with the following named components:
#' \enumerate{
#' \item \code{ID} (time zone identifier),
#' \item \code{Name} (localized human-readable time zone name),
#' \item \code{RawOffset} (raw GMT offset, in hours, before taking daylight savings int account), and
#' \item \code{UsesDaylightTime} (states whether a time zone uses daylight savings time
#'  in the current Gregorian calendar year).
#' }
#' 
#' @examples
#' stri_timezone_info()
#' stri_timezone_info(locale="sk_SK")
#'
#' @family time
#' @family timezone
#' @export
stri_timezone_info <- function(tz=NULL, locale=NULL) {
   .Call(C_stri_timezone_info, tz, locale)
}

