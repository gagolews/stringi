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
#' Get Current Date and Time
#' 
#' @details
#' The current date and time in \pkg{stringi} is represented as the (signed)
#' number of seconds since 1970-01-01, 00:00 UTC.
#' UTC leap seconds are ignored. 
#' 
#' @return
#' Returns an object of class \code{StringiTime},
#' which inherits from \code{POSIXct} and \code{POSIX}.
#' In fact, it is a numeric vector of length 1.
#' 
#' @family datetime
#' @export
stri_datetime_now <- function() {
   .Call(C_stri_datetime_now)
}


#' @title
#' Date and Time Arithmetic
#' 
#' @details
#' Vectorized over \code{time} and \code{delta}
#' 
#' t.b.d.
#' 
#' @param time
#' @param delta
#' @param units
#' @param calendar 
#' 
#' @return
#' Returns an object of class \code{StringiTime},
#' see \code{\link{stri_datetime_now}}.
#' 
#' @family datetime
#' @export
stri_datetime_add <- function(time, delta, units="secs", calendar="gregorian") {
   .Call(C_stri_datetime_now, time, delta, units, calendar)
}

