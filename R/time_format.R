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
#' This function converts a given date/time object
#' to a character vector.
#'
#' @details
#' Vectorized over \code{time}.
#' 
#' \code{format} may be one of \code{DT_STYLE} or \code{DT_relative_STYLE},
#' where \code{DT} is equal to \code{date}, \code{time}, or \code{datetime},
#' and \code{STYLE} is equal to \code{full}, \code{long}, \code{medium}, or \code{short}.
#' This gives a locale-dependent date and/or time format.
#' Note that currently ICU does not support \code{relative} \code{time} formats,
#' so this flag is currently ignored in such context.
#' 
#' Otherwise, \code{format} is a pattern:
#' a string of characters, where specific strings of characters are replaced
#' with date and time data from a calendar when formatting or used 
#' to generate data for a calendar when parsing.
#' For example, \code{y} stands for the year. Characters 
#' may be used multiple times. For instance, if \code{y} is used for the year,
#' \code{yy} might produce \code{99}, whereas \code{yyyy} produces \code{1999}.
#' For most numerical fields, the number of characters specifies
#' the field width. For example, if \code{h} is the hour, \code{h} might
#' produce \code{5}, but \code{hh} produces \code{05}.
#' For some characters, the count specifies whether an abbreviated
#' or full form should be used, but may have other choices, as given below.
#' 
#' Two single quotes represents a literal single quote, either
#' inside or outside single quotes. Text within single quotes 
#' is not interpreted in any way (except for two adjacent single quotes).
#' Otherwise all ASCII letter from \code{a} to \code{z} and \code{A} to \code{Z}
#' are reserved as syntax characters, and require quoting if 
#' they are to represent literal characters. In addition, certain 
#' ASCII punctuation characters may become variable in the future
#' (eg \code{:} being interpreted as the time separator and \code{/}
#' as a date separator, and replaced by respective
#' locale-sensitive characters in display).
#' 
#' TO DO: add table / formats
#' 
#' TO DO: add examples
#'
#' @param time a \code{POSIXct} object
#' @param format single string, see Details; defaults to the ISO 8601 guideline
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
stri_datetime_format <- function(time, format="uuuu'-'MM'-'dd'T'HH':'mm':'ssxxx", tz=NULL, locale=NULL) {
   .Call(C_stri_datetime_format, time, format, tz, locale)
}


#' @rdname stri_datetime_format
#' @export
format.POSIXst <- function(x, ..., usetz=TRUE) {
   stopifnot(identical(usetz, TRUE))
   stri_datetime_format(x, ...)
}


#' @title
#' t.b.d.
#' 
#' @description
#' t,b,d,
#' 
#' @details
#' t.b.d.
#' 
#' 
#' @param str character vector
#' @param format single string, see \code{\link{stri_datetime_format}};
#' defaults to the ISO 8601 guideline
#' @param tz t.b.d
#' @param locale \code{NULL} or \code{""} for default locale,
#' or a single string with locale identifier; a non-Gregorian calendar
#' may be specified by setting \code{@@calendar=name} keyword
#' 
#' @return
#' Returns an object of class \code{\link{POSIXst}}.
#' 
#' @examples
#' stri_datetime_parse(c("2015-02-28", "2015-02-29"), "yyyy-MM-dd")
#' stri_datetime_parse("19 lipca 2015", "date_long", locale="pl_PL")
#' 
#' @export
#' @family datetime
stri_datetime_parse <- function(str, format="uuuu'-'MM'-'dd'T'HH':'mm':'ssxxx", tz=NULL, locale=NULL) {
   .Call(C_stri_datetime_parse, str, format, tz, locale)
}

# seq.POSIXst

# rep.POSIXst

# diff.POSIXt

# cut

# round

# trunc
