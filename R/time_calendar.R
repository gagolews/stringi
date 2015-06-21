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
#' [DRAFT API] Create a Date-Time Object
#'
#' @description
#' This function constructs date-time objects from numeric representations.
#'
#' @details
#' Vectorized over \code{year}, \code{month}, \code{hour},
#' \code{hour}, \code{minute}, and \code{second}.
#'
#' @param year integer vector; 0 is 1BC, -1 is 2BC, etc.
#' @param month integer vector; months are 1-based
#' @param day integer vector
#' @param hour integer vector
#' @param minute integer vector
#' @param second numeric vector; fractional seconds are allowed
#' @param tz \code{NULL} or \code{""} for the default time zone or
#' a single string with time zone identifier, see \code{\link{stri_timezone_list}}
#' @param lenient single logical value; should the operation be lenient?
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting \code{@@calendar=name} keyword
#'
#' @return
#' Returns an object of class \code{\link{POSIXct}}.
#'
#' @examples
#' stri_datetime_create(2015, 12, 31, 23, 59, 59.999)
#' stri_datetime_create(5775, 8, 1, locale="@@calendar=hebrew") # 1 Nisan 5775 -> 2015-03-21
#' stri_datetime_create(2015, 02, 29)
#' stri_datetime_create(2015, 02, 29, lenient=TRUE)
#'
#' @family datetime
#' @export
stri_datetime_create <- function(year, month, day, hour=12L, minute=0L, second=0.0, lenient=FALSE, tz=NULL, locale=NULL) {
   .Call(C_stri_datetime_create, year, month, day, hour, minute, second, lenient, tz, locale)
}


#' @title
#' [DRAFT API] Get Current Date and Time
#'
#' @description
#' Returns current date and time.
#'
#' @details
#' The current date and time in \pkg{stringi} is represented as the (signed)
#' number of seconds since 1970-01-01 00:00:00 UTC.
#' UTC leap seconds are ignored.
#'
#' @return
#' Returns an object of class \code{\link{POSIXct}}.
#'
#' @family datetime
#' @export
stri_datetime_now <- function() {
   .Call(C_stri_datetime_now)
}


#' @title
#' [DRAFT API] Get Values for Date and Time Fields
#'
#' @description
#' Calculates and returns values for all date and time fields.
#'
#' @details
#' Vectorized over \code{time}.
#'
#'
#' @param time an object of class \code{\link{POSIXct}} or an object coercible to
#' @param tz \code{NULL} or \code{""} for the default time zone or
#' a single string with time zone identifier, see \code{\link{stri_timezone_list}}
#' @param locale \code{NULL} or \code{""} for the current default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting \code{@@calendar=name} keyword
#'
#' @return
#' Returns a data frame with the following columns:
#' \enumerate{
#' \item Year (0 is 1BC, -1 is 2BC, etc.)
#' \item Month (1-based, i.e. 1 stands for the first month, e.g. January;
#' note that the number of months depends on the selected calendar,
#' see \code{\link{stri_datetime_symbols}})
#' \item Day
#' \item Hour (24-h clock)
#' \item Minute
#' \item Second
#' \item Millisecond
#' \item WeekOfYear (this is locale-dependent)
#' \item WeekOfMonth (this is locale-dependent)
#' \item DayOfYear
#' \item DayOfWeek (1-based, 1 denotes Sunday; see \code{\link{stri_datetime_symbols}})
#' \item Hour12 (12-h clock)
#' \item AmPm (see \code{\link{stri_datetime_symbols}})
#' \item Era (see \code{\link{stri_datetime_symbols}})
#' }
#'
#' @examples
#' stri_datetime_fields(stri_datetime_now())
#' stri_datetime_fields(stri_datetime_now(), locale="@@calendar=hebrew")
#' stri_datetime_symbols(locale="@@calendar=hebrew")$Month[
#'    stri_datetime_fields(stri_datetime_now(), locale="@@calendar=hebrew")$Month
#' ]
#'
#' @family datetime
#' @export
stri_datetime_fields <- function(time, tz=attr(time, "tzone"), locale=NULL) {
   # POSSIBLY @TODO:
   # TimeZone
   # GMT Offset CAL_ZONE_OFFSET + UCAL_DST_OFFSET
   # isDST: UBool    inDaylightTime (UErrorCode &status) const =0
   # isWeekend: virtual UBool    isWeekend (void) const
   as.data.frame(.Call(C_stri_datetime_fields, time, tz, locale))
}


#' @title
#' [DRAFT API] Date and Time Arithmetic
#'
#' @description
#' Modifies a date-time object by adding a specific amount of time units.
#'
#' @details
#' Vectorized over \code{time} and \code{value}.
#'
#'
#' Note that e.g. January, 31 + 1 month = February, 28 or 29.
#'
#' @param time an object of class \code{\link{POSIXct}} or an object coercible to
#' @param value integer vector; signed number of units to add to \code{time}
#' @param units single string; one of \code{"years"}, \code{"months"},
#' \code{"weeks"}, \code{"days"}, \code{"hours"}, \code{"minutes"},
#' \code{"seconds"}, or \code{"milliseconds"}
#' @param tz  \code{NULL} or \code{""} for the default time zone
#' or a single string with a timezone identifier,
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting the \code{@@calendar=name} keyword
#'
#' @return
#' Both functions return an object of class \code{\link{POSIXct}}.
#'
#' The replacement version of \code{stri_datetime_add} modifies
#' the state of the \code{time} object.
#'
#' @references
#' \emph{Calendar Classes} - ICU User Guide,
#' \url{http://userguide.icu-project.org/datetime/calendar}
#'
#'
#' @examples
#' x <- stri_datetime_now()
#' stri_datetime_add(x, units="months") <- 2
#' print(x)
#' stri_datetime_add(x, -2, units="months")
#' stri_datetime_add(stri_datetime_create(2014, 4, 20), 1, units="years")
#' stri_datetime_add(stri_datetime_create(2014, 4, 20), 1, units="years", locale="@@calendar=hebrew")
#'
#' stri_datetime_add(stri_datetime_create(2016, 1, 31), 1, units="months")
#'
#' @family datetime
#' @rdname stri_datetime_add
#' @export
stri_datetime_add <- function(time, value=1L, units="seconds", tz=NULL, locale=NULL) {
   .Call(C_stri_datetime_add, time, value, units, tz, locale)
}


#' @rdname stri_datetime_add
#' @export
"stri_datetime_add<-" <- function(time, units="seconds", tz=NULL, locale=NULL, value) {
   .Call(C_stri_datetime_add, time, value, units, tz, locale)
}


# #' @title
# #' [DRAFT API] Date-Time Objects in \pkg{stringi}
# #'
# #' @description
# #' Date-time objects' representation in \pkg{stringi} may change
# #' in future versions of the package. This is DRAFT API.
# #'
# #' @details
# #' An object of class \code{\link{POSIXst}},
# #' inherits from (for compatibility with other base R functions)
# #' \code{POSIXct} and \code{POSIX} classes.
# #' In fact, it is a numeric vector representing the (signed) number of seconds
# #' since the UNIX Epoch, i.e. 1970-01-01 00:00:00 UTC.
# #' UTC leap seconds are ignored.
# #'
# #' Thanks to this property, standard comparison operators, e.g. \code{<}, \code{==},
# #' etc. or the \code{sort()} function may be used.
# #'
# #' An object of class \code{\link{POSIXst}} may be equipped with
# #' an attribute called \code{tzone}. Its value is used for date/time
# #' formatting (e.g. when objects are printed in the console),
# #' see \code{\link{format.POSIXst}} and \code{\link{stri_datetime_fields}}.
# #'
# #' @param x ...
# #' @param tz \code{NULL} or \code{""} for the default time zone or
# #' a single string with time zone identifier, see \code{\link{stri_timezone_list}}
# #' @param recursive,... further arguments to be passed to or from other methods.
# #'
# #' @return
# #' \code{as.POSIXst} returns an object of class \code{POSIXst}.
# #'
# #' @export
# #' @rdname as.POSIXst
# #' @family datetime
# #' @aliases as.POSIXst POSIXst
# as.POSIXst <- function(x, tz=attr(time, "tzone"), ...) {
#    # UseMethod("as.POSIXct")
#    stop("TO DO")
# }


# #' @export
# #' @rdname as.POSIXst
# c.POSIXst <- function (..., recursive=FALSE) {
#    stopifnot(identical(recursive, FALSE))
#    .Call(C_stri_c_posixst, list(...))
# }

# TO DO: field difference
