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
#' number of seconds since 1970-01-01, 00:00 UTC.
#' UTC leap seconds are ignored.
#'
#' @return
#' Returns an object of class \code{POSIXst},
#' which (for compatibility with other base R functions)
#' also inherits from \code{POSIXct} and \code{POSIX}.
#' In fact, it is a numeric vector.
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
#' is ignored.
#'
#'
#' Note that e.g. January, 31 + 1 month = Feburary, 28 or 29.
#'
#'
#'
#' @param time a \code{POSIXct} object
#' @param value integer vector; signed number of units to add to a given time
#' @param units single string; one of \code{"years"}, \code{"months"},
#' \code{"weeks"}, \code{"days"}, \code{"hours"}, \code{"minutes"},
#' \code{"seconds"}, or \code{"milliseconds"}
#' @param calendar single string; currently only
#' the \code{"gregorian"} calendar is supported
#'
#' @return
#' Returns an object of class \code{POSIXst},
#' which (for compatibility with other base R functions)
#' also inherits from \code{POSIXct} and \code{POSIX}.
#' In fact, it is a numeric vector representing the number of seconds
#' since the UNIX Epoch.
#'
#' The replacement version of \code{stri_datetime_add} modifies
#' the state of the \code{time} object.
#'
#'
#' @examples
#' x <- stri_datetime_now()
#' stri_datetime_add(x, units="months") <- 2
#' x
#' stri_datetime_add(x, -2, units="months")
#'
#' @family datetime
#' @rdname stri_datetime_add
#' @export
stri_datetime_add <- function(time, value=1L, units="seconds", calendar="gregorian") {
   .Call(C_stri_datetime_add, time, value, units, calendar)
}


#' @rdname stri_datetime_add
#' @export
"stri_datetime_add<-" <- function(time, value, units="seconds", calendar="gregorian") {
   .Call(C_stri_datetime_add, time, value, units, calendar)
}
