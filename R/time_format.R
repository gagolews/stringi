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
#' Date and Time Formatting
#'
#' @description
#' t.b.d
#'
#' @details
#' t.b.d
#'
#' @param time a \code{POSIXct} object
#' @param format single string, see Details; defaults to a ISO 8601 guideline
#' @param tz t.b.d
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting \code{@@calendar=name} keyword
#' @param usetz this argument is purposely ignored
#'
#' @return
#' Returns a character vector.
#' 
#' @references
#' \emph{Formatting Dates and Times} - ICU User Guide,
#' \url{http://userguide.icu-project.org/formatparse/datetime}
#'
#'
#' @examples
#' # to do
#' 
#' @rdname stri_datetime_format
#' @family datetime
#' @export
stri_datetime_format <- function(time, format="uuuu-MM-dd'T'HH:mm:ssxxx", tz=NULL, locale=NULL) {
   .Call(C_stri_datetime_format, time, format, tz, locale)
}


#' @rdname stri_datetime_format
#' @export
format.POSIXst <- function(x, ..., usetz=TRUE) {
   stopifnot(identical(usetz, TRUE))
   stri_datetime_format(x, ...)
}

# seq.POSIXst

# rep.POSIXst

# diff.POSIXt

# cut

# round

# trunc
