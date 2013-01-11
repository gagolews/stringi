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



#' Get list of available encodings
#'
#' @return A list with...
#' @seealso \code{\link{stri_encode}}, \code{\link{stri_encinfo}}
#' @export
stri_enclist <- function() {
   .Call("stri_enclist", PACKAGE="stringi")
}


#' Get info on given encoding
#' 
#' If enc is missing, NULL (default encoding) is used
#' 
#' @param enc NULL/""/missing for default encoding, or a single string with encoding name
#' @return A list with...
#' @seealso \code{\link{stri_encode}}, \code{\link{stri_enclist}}
#' @export
stri_encinfo <- function(enc) {
   if (missing(enc)) enc <- NULL
   # prepare_arg done internally
   .Call("stri_encinfo", enc, PACKAGE="stringi")
}


#' Convert character vector between given encodings 
#' 
#' If enc is missing, NULL (default encoding) is used
#' 
#' @param str strings to encode
#' @param from input encoding:
#'       NULL/"" for default encoding, or a single string with encoding name
#' @param from target encoding:
#'       NULL/"" for default encoding, or a single string with encoding name
#' @return A list with...
#' @seealso \code{\link{stri_enclist}}, \code{\link{stri_encinfo}}
#' @export
stri_encode <- function(str, from, to) {
   # prepare_arg done internally
   .Call("stri_encode", str, from, to, PACKAGE="stringi")
}
