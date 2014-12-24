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
#' and/or time zones corresponding to a given region.
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
#' stri_timezone_list(region="PL")
#' 
#' @family time
#' @family timezone
#'
#' @family transform
#' @export
stri_timezone_list <- function(region=NA_character_, offset=NA_integer_) {
   .Call(C_stri_timezone_list, region, offset)
}
