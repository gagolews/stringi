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
#' Get Current Date and Time
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
#' Returns an object of class \code{\link{POSIXst}}.
#'
#' @family datetime
#' @export
stri_datetime_now <- function() {
   .Call(C_stri_datetime_now)
}


#' @title
#' Date and Time Arithmetic
#'
#' @description
#' Modifies a date-time object by adding a specific amount of time units.
#'
#' @details
#' Vectorized over \code{time} and \code{value}.
#'
#' These date-time arithmetic operations are performed under the current
#' default time zone and locale. The \code{tzone} argument of \code{time}
#' is ignored. TO DO......................................................................
#'
#'
#' Note that e.g. January, 31 + 1 month = February, 28 or 29. TO DO ...........................
#'
#' @param time a \code{POSIXct} object
#' @param value integer vector; signed number of units to add to a given time
#' @param units single string; one of \code{"years"}, \code{"months"},
#' \code{"weeks"}, \code{"days"}, \code{"hours"}, \code{"minutes"},
#' \code{"seconds"}, or \code{"milliseconds"}
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting \code{@@calendar=name} keyword
#'
#' @return
#' Both functions return an object of class \code{\link{POSIXst}}.
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
#' x
#' stri_datetime_add(x, -2, units="months")
#' stri_datetime_add(as.POSIXct("2014-04-20 12:00:00"), 1, units="years")
#' stri_datetime_add(as.POSIXct("2014-04-20 12:00:00"), 1, units="years", locale="@@calendar=hebrew")
#' 
#' @family datetime
#' @rdname stri_datetime_add
#' @export
stri_datetime_add <- function(time, value=1L, units="seconds", locale=NULL) {
   .Call(C_stri_datetime_add, time, value, units, locale)
}


#' @rdname stri_datetime_add
#' @export
"stri_datetime_add<-" <- function(time, units="seconds", locale=NULL, value) {
   .Call(C_stri_datetime_add, time, value, units, locale)
}


#' @title
#' Get Values for Date and Time Fields
#'
#' @description
#' Calculates and returns values for all date and time fields.
#'
#' @details
#' Vectorized over \code{time}.
#'
#'
#' @param time a \code{POSIXct} object
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting \code{@@calendar=name} keyword
#'
#' @return
#' Returns a data frame with the following columns: TO DO...................................
#' \enumerate{
#' \item year - 0 is 1BC, -1 is 2BC, etc.
#' \item month... months are 1-based
#' }
#' 
#' @examples
#' stri_datetime_fields(stri_datetime_now())
#'
#' @family datetime
#' @export
stri_datetime_fields <- function(time, locale=NULL) {
   as.data.frame(.Call(C_stri_datetime_fields, time, locale))
}


#' @title
#' Crate a Date-Time Object
#' 
#' @description
#' ...
#' 
#' @details
#' Vectorized over \code{year}, \code{month}, \code{hour},
#' \code{hour}, \code{minute}, and \code{second}.
#' 
#' @param year iteger vector; 0 is 1BC, -1 is 2BC, etc.
#' @param month iteger vector; months are 1-based
#' @param day iteger vector
#' @param hour iteger vector
#' @param minute iteger vector
#' @param second numeric vetor; fractional seconds are allowed
#' @param tz \code{NULL} or \code{""} for default time zone,
#' a single string with time zone ID otherwise
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting \code{@@calendar=name} keyword
#' 
#' @return
#' Returns an object of class \code{\link{POSIXst}}.
#' 
#' @examples
#' stri_datetime_create(2015, 12, 31, 23, 59, 59.999)
#' stri_datetime_create(5775, 8, 1, locale="@@calendar=hebrew") # 1 Nisan 5775 -> 2015-03-21
#' 
#' @family datetime
#' @export
stri_datetime_create <- function(year, month, day, hour=12L, minute=0L, second=0.0, tz=NULL, locale=NULL) {
   .Call(C_stri_datetime_create, year, month, day, hour, minute, second, tz, locale)
}


#' @title
#' Date-Time Objects in \pkg{stringi}
#' 
#' @description
#' t.b.d.
#' 
#' @details
#' An object of class \code{\link{POSIXst}},
#' inherits from (for compatibility with other base R functions)
#' \code{POSIXct} and \code{POSIX} classes.
#' In fact, it is a numeric vector representing the (signed) number of seconds
#' since the UNIX Epoch, i.e. 1970-01-01 00:00:00 UTC.
#' UTC leap seconds are ignored.
#' 
#' Thanks to this property, standard comparison operators, e.g. \code{<}, \code{==},
#' etc. or the \code{sort()} function may be used.
#' 
#' @param x ...
#' 
#' @return
#' t.b.d.
#' 
#' @export
#' @rdname as.POSIXst
#' @family datetime
#' @aliases as.POSIXst POSIXst
as.POSIXst <- function(x) {
   stop("TO DO")
}

# TO DO: field difference

