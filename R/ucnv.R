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



#' Character Encoding Management
#'
#' Most of the computations in \pkg{stringi} are performed internally
#' using either UTF-8 or UTF-16 encodings. However, we still need to communicate
#' with R somehow and give some trust in how it handles strings.
#' 
#' Basically, R has a very simple encoding-marking mechanism.
#' \code{ASCII} strings consist of bytes with values <= 127.
#' \code{UTF-8} strings...
#' \code{LATIN1} string....
#' \code{BYTES} strings...
#' Sometimes strings have no encoding marks. In this case one should
#' assume that he/she deals with natively-encoded data.
#' 
#' @references
#' Conversion - ICU User Guide, \url{http://userguide.icu-project.org/conversion} (technical details)
#' @name encoding-main
#' @family encoding
NULL


#' List Available Encodings
#'
#' @return A list with...
#' @family encoding
#' @export
stri_enc_list <- function() {
   .Call("stri_enc_list", PACKAGE="stringi")
}


#' Quert Given Encoding
#' 
#' 
#' @param enc \code{NULL} or \code{""} for default encoding,
#' or a single string with encoding name
#' @return A list with...
#' @family encoding
#' @export
stri_enc_info <- function(enc=NULL) {
   .Call("stri_enc_info", enc, PACKAGE="stringi")
}


#' Set Default Encoding
#'
#' @param enc character encoding name,
#' see \code{\link{stri_enc_list()}}
#' @return Previously set default encoding, invisibly.
#' @family encoding
#' @export
stri_enc_set <- function(enc) {
   previous <- stri_enc_get()
   
   # We call stri_info, because it generates some warnings,
   # in case any problems are found:
   .Call("stri_enc_set", enc, PACKAGE="stringi")
   message('You are now working with ' %+% stri_info(short=TRUE))
   invisible(previous)
}


#' Get Default Encoding
#' 
#' Same as \code{stri_enc_info()$Name.friendly}.
#' 
#' @return a character string
#' @family encoding
#' @export
stri_enc_get <- function() {
   stri_enc_info(NULL)$Name.friendly
}


#' Convert Character Vector Between Given Encodings 
#' 
#' If enc is missing, NULL (default encoding) is used
#' 
#' @param str character vector to be converted
#' @param from input encoding:
#'       \code{NULL} or \code{""} for default encoding,
#'       or a single string with encoding name
#' @param from target encoding:
#'       \code{NULL} or \code{""} for default encoding,
#'       or a single string with encoding name
#' @return A character vector with encoded strings.
#' @family encoding
#' @export
stri_encode <- function(str, from, to=NULL) {
   .Call("stri_encode", str, from, to, PACKAGE="stringi")
}


#' Check if string is possibly in ASCII
#'
#' This function is independent of the way R marks encodings in
#' character strings (see \code{\link{Encoding}} and \code{\link{encoding-main}}).
#' 
#' @param str character vector
#' @return logical vector
#' @family encoding
#' @export
stri_enc_isascii <- function(str) {
   .Call("stri_enc_isascii", str, PACKAGE="stringi")
}


#' Check if string is possibly in UTF8
#'
#' This function is independent of the way R marks encodings in
#' character strings (see \code{\link{Encoding}} and \code{\link{encoding-main}}).
#' @param str character vector
#' @return logical vector
#' @family encoding
#' @export
stri_enc_isutf8 <- function(str) {
   .Call("stri_enc_isutf8", str, PACKAGE="stringi")
}



# Check R encoding marking
# 
# This is an internal function (no-export & no-manual) - test how R marks
# ASCII/LATIN1/UTF8/BYTES encodings (see also \code{?Encoding}).
# @param str character vector
stri_enc_Rmark <- function(str) {
   invisible(.Call("stri_enc_Rmark", str, PACKAGE="stringi"))
}
