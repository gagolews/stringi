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



#' Perform Unicode normalization (NFC)
#' 
#' @param str will be coerced to character
#' @export
stri_nfc <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 10L, PACKAGE="stringi")
}

#' Perform Unicode normalization (NFD)
#' 
#' @param str will be coerced to character
#' @export
stri_nfd <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 20L, PACKAGE="stringi")
}


#' Perform Unicode normalization (NFKD)
#' 
#' @param str will be coerced to character
#' @export
stri_nfkd <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 21L, PACKAGE="stringi")
}


#' Perform Unicode normalization (NFKC)
#' 
#' @param str will be coerced to character
#' @export
stri_nfkc <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 11L, PACKAGE="stringi")
}


#' Perform Unicode normalization (NFKC_Casefild)
#' 
#' @param str will be coerced to character
#' @export
stri_nfkc_casefold <- function(str) {
   .Call("stri_unicode_normalization", stri_prepare_arg_string(str), 12L, PACKAGE="stringi")
}
