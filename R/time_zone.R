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
#' [DRAFT API] List Available Time Zone Identifiers
#'
#' @description
#' Returns a list of available time zone identifiers.
#'
#' @details
#' If  \code{offset} and \code{region} are \code{NA} (the default), then
#' all time zones are returned. Otherwise,
#' only time zone identifiers with a given raw offset from GMT
#' and/or time zones corresponding to a given region are provided.
#' Note that the effect of daylight savings time is ignored.
#'
#' A time zone represents an offset applied to the Greenwich Mean Time (GMT)
#' to obtain local time (Universal Coordinated Time, or UTC, is similar,
#' but not precisely identical, to GMT; in \pkg{ICU} the two terms
#' are used interchangeably since \pkg{ICU} does not concern itself with
#' either leap seconds or historical behavior).
#' The offset might vary throughout the year, if daylight savings time (DST)
#' is used, or might be the same all year long.
#' Typically, regions closer to the equator do not use DST.
#' If DST is in use, then specific rules define the point at which
#' the offset changes and the amount by which it changes.
#'
#' If DST is observed, then three additional bits of information are needed:
#' \enumerate{
#' \item The precise date and time during the year when DST begins.
#' In the first half of the year it's in the northern hemisphere,
#' and in the second half of the year it's in the southern hemisphere.
#' \item The precise date and time during the year when DST ends.
#' In the first half of the year it's in the southern hemisphere,
#' and in the second half of the year it's in the northern hemisphere.
#' \item The amount by which the GMT offset changes when DST is in effect.
#' This is almost always one hour.
#' }
#'
#'
#' @param offset single numeric value;
#' a given raw offset from GMT, in hours;
#' \code{NA} for all offsets
#' @param region single string;
#' a ISO 3166 two-letter country code or UN M.49 three-digit area code;
#' \code{NA} for all regions
#'
#' @return Returns a character vector.
#'
#' @references
#' \emph{TimeZone} class -- ICU API Documentation,
#' \url{http://www.icu-project.org/apiref/icu4c/classicu_1_1TimeZone.html}
#'
#' \emph{ICU 4.8 Time Zone Names}.
#' \url{http://site.icu-project.org/design/formatting/timezone/icu-4-8-time-zone-names}
#'
#' \emph{ICU TimeZone classes} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/datetime/timezone}
#'
#' \emph{Date/Time Services} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/datetime}
#'
#' @examples
#' stri_timezone_list()
#' stri_timezone_list(offset=1)
#' stri_timezone_list(offset=5.5)
#' stri_timezone_list(offset=5.75)
#' stri_timezone_list(region="PL")
#' stri_timezone_list(region="US", offset=-10)
#'
#' # Fetch info on all time zones
#' do.call(rbind.data.frame,
#'    lapply(stri_timezone_list(), function(tz) stri_timezone_info(tz)))
#'
#' @family datetime
#' @family timezone
#' @export
stri_timezone_list <- function(region=NA_character_, offset=NA_integer_) {
   .Call(C_stri_timezone_list, region, offset)
}


#' @title
#' [DRAFT API] Set or Get Default Time Zone in \pkg{stringi}
#'
#' @description
#' \code{stri_timezone_set} changes the current default time zone for all functions
#' in the \pkg{stringi} package, i.e. establishes the meaning of the
#' ``\code{NULL} time zone'' argument to date/time processing functions.
#' On the other hand, \code{stri_timezone_get} gets the current default time zone.
#'
#' For more information on time zone representation in \pkg{ICU}
#' and \pkg{stringi}, refer to \code{\link{stri_timezone_list}}.
#'
#' @details
#' Unless the default time zone has already been set using
#' \code{stri_timezone_set}, the default time zone is determined
#' by querying the OS with methods in \pkg{ICU}'s internal platform utilities.
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
#' # ... many time zone-dependent operations
#' stri_timezone_set(oldtz) # restore previous default time zone
#' }
#'
#' @export
#' @family datetime
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
#' [DRAFT API] Query a Given Time Zone
#'
#' @description
#' Provides some basic information on a given time zone identifier.
#'
#' @details
#' With this function you may fetch some basic information
#' on any supported time zone.
#'
#' For more information on time zone representation in \pkg{ICU},
#' see \code{\link{stri_timezone_list}}.
#'
#' @param tz \code{NULL} or \code{""} for default time zone,
#' or a single string with time zone ID otherwise
#' @param display_type single string;
#' one of \code{"short"}, \code{"long"}, \code{"generic_short"},
#' \code{"generic_long"}, \code{"gmt_short"}, \code{"gmt_long"},
#' \code{"common"}, \code{"generic_location"}
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier
#'
#' @return
#' Returns a list with the following named components:
#' \enumerate{
#' \item \code{ID} (time zone identifier),
#' \item \code{Name} (localized human-readable time zone name),
#' \item \code{Name.Daylight} (localized human-readable time zone name when DST is used, if available),
#' \item \code{Name.Windows} (Windows time zone ID, if available),
#' \item \code{RawOffset} (raw GMT offset, in hours, before taking
#' daylight savings into account), and
#' \item \code{UsesDaylightTime} (states whether a time zone uses
#' daylight savings time in the current Gregorian calendar year).
#' }
#'
#' @examples
#' stri_timezone_info()
#' stri_timezone_info(locale="sk_SK")
#' sapply(c("short", "long", "generic_short", "generic_long",
#'          "gmt_short", "gmt_long", "common", "generic_location"),
#'   function(e) stri_timezone_info("Europe/London", display_type=e))
#'
#' @family datetime
#' @family timezone
#' @export
stri_timezone_info <- function(tz=NULL, locale=NULL, display_type="long") {
   .Call(C_stri_timezone_info, tz, locale, display_type)
   ### TO DO: when DST starts???
}
