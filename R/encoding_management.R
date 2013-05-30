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



#' List Available Encodings
#'
#' Please note that apart from given encodings, ICU tries to normalize
#' encoding specifiers. E.g. \code{"UTF8"} is also valid,
#' see \link{stringi_encoding} for more information.
#'
#' @param simplified logical value TODO....
#' @return If \code{simplified} is \code{FALSE} (the default), a list of
#'  character vectors is returned: Each element represents one unique
#'  character encoding. The name of the list item gives the ICU canonical
#'  name of the encodings. The elements (character vectors) are
#'  its aliases.
#' 
#' When \code{simplified} is \code{TRUE}, then the resulting list
#' is coerced to a character vector, sorted, and its duplicates are removed.
#' 
#' @family encoding_management
#' @export
stri_enc_list <- function(simplified=FALSE) {
   simplified <- identical(simplified, TRUE)
   
   ret <- .Call("stri_enc_list", PACKAGE="stringi")
   if (simplified)
      return(sort(unique(unlist(ret))))
   else
      return(ret)
}


#' Query Given Encoding
#' 
#' 
#' @param enc \code{NULL} or \code{""} for default encoding,
#' or a single string with encoding name
#' 
#' @return If the encoding is unsupported, an error is generated.
#' Otherwise, you get a list with the following components:
#' \code{Name.friendly} - Friendly encoding name: MIME name or JAVA name or ICU Canonical name
#'    (selecting the first of supported ones, see below);
#' \code{Name.ICU} - Encoding name as identified by ICU;
#' \code{Name.*}, e.g. \code{Name.UTR22}, \code{Name.IBM}, \code{Name.WINDOWS},
#' \code{Name.JAVA}, \code{Name.IANA}, \code{Name.MIME} (some may be not
#' availiable for selected  encodings) - 
#' \code{ASCII.subset} - has this encoding ASCII as its subset?
#' \code{Unicode.1to1} - for 8-bit encodings only: does every character
#' translate into one Unicode codepoint and is this translation reversible?
#' \code{CharSize.8bit} - is this an 8-bit encoding, i.e. do we have
#'    \code{CharSize.min == CharSize.max} and \code{CharSize.min == 1}?
#' \code{CharSize.min} - minimal number of bytes used to represend a code point
#' \code{CharSize.max} - maximal number of bytes used to represend a code point
#' @family encoding_management
#' @export
stri_enc_info <- function(enc=NULL) {
   .Call("stri_enc_info", enc, PACKAGE="stringi")
}


#' Set Default Encoding
#'
#' @param enc character encoding name,
#' see \code{\link{stri_enc_list}}
#' @return Previously set default encoding, invisibly.
#' 
#' @family encoding_management
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
#' @family encoding_management
#' @export
stri_enc_get <- function() {
   stri_enc_info(NULL)$Name.friendly
}

