## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' Get list of available locales
#'
#' @return Character vector
#' @seealso \code{\link{stri_localeinfo}}
#' @export
stri_localelist <- function() {
   .Call("stri_localelist", PACKAGE="stringi")
}



#' Get info on given locale
#' 
#' If loc is missing, NULL (default locale) is used
#' 
#' @param loc NULL/""/missing for default locale, or a single string with locale name
#' @return A list with...
#' @seealso \code{\link{stri_localeinfo}}
#' @export
stri_localeinfo <- function(loc) {
   if (missing(loc)) loc <- NULL
   # prepare_arg done internally
   .Call("stri_localeinfo", loc, PACKAGE="stringi")
}

