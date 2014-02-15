## This file is part of the 'stringi' library.
##
## Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.


#' @title
#' List Known Character Encodings
#'
#' @description
#' Gives encodings that are supported by \pkg{ICU}.
#'
#' @details
#' Please note that apart from given encodings, \pkg{ICU} tries to normalize
#' encoding specifiers. E.g. \code{"UTF8"} is also valid,
#' see \link{stringi-encoding} for more information.
#'
#' @param simplified single logical value; return a character vector or a
#' list of character vectors?
#'
#' @return If \code{simplified} is \code{FALSE} (the default), a list of
#'  character vectors is returned. Each list element represents a unique
#'  character encoding. The \code{name} attribute gives the \pkg{ICU} Canonical
#'  Name of an encoding family. The elements (character vectors) are
#'  its aliases.
#'
#' If \code{simplified} is \code{TRUE}, then the resulting list
#' is coerced to a character vector, sorted, and its duplicates are removed.
#'
#' @family encoding_management
#' @export
stri_enc_list <- function(simplified=FALSE) {
   simplified <- !identical(simplified, FALSE)

   ret <- .Call("stri_enc_list", PACKAGE="stringi")
   if (simplified)
      return(stri_sort(unique(unlist(ret))))
   else
      return(ret)
}


#' @title
#' Query Given Character Encoding
#'
#' @description
#' Gets basic information on a given character encoding.
#'
#' @details
#' If the encoding provided is unknown to \pkg{ICU} (see \code{\link{stri_enc_list}}),
#' an error is generated.
#'
#' If you set a default encoding that is not a superset of ASCII
#' or it is not an 8-bit encoding, a warning will be generated,
#' see \link{stringi-encoding} for discussion.
#'
#' @param enc \code{NULL} or \code{""} for default encoding,
#' or a single string with encoding name
#'
#' @return
#' Returns a list with the following components:
#' \itemize{
#' \item \code{Name.friendly} -- Friendly encoding name: MIME Name or JAVA Name
#'     or \pkg{ICU} Canonical Name
#'    (selecting the first of supported ones, see below);
#' \item \code{Name.ICU} -- Encoding name as identified by \pkg{ICU};
#' \item \code{Name.*} -- other standardized encoding names,
#' e.g. \code{Name.UTR22}, \code{Name.IBM}, \code{Name.WINDOWS},
#' \code{Name.JAVA}, \code{Name.IANA}, \code{Name.MIME} (some may be not
#' available for selected  encodings);
#' \item \code{ASCII.subset} -- is ASCII a subset of the given encoding?;
#' \item \code{Unicode.1to1} -- for 8-bit encodings only: are all characters
#' translated to exactly one Unicode code point and is this translation
#' well reversible?;
#' \item \code{CharSize.8bit} -- is this an 8-bit encoding, i.e. do we have
#'    \code{CharSize.min == CharSize.max} and \code{CharSize.min == 1}?;
#' \item \code{CharSize.min} -- minimal number of bytes used to represent a code point;
#' \item \code{CharSize.max} -- maximal number of bytes used to represent a code point.
#' }
#' @family encoding_management
#' @export
stri_enc_info <- function(enc=NULL) {
   .Call("stri_enc_info", enc, PACKAGE="stringi")
}


#' @title
#' Set or Get Default Character Encoding in \pkg{stringi}
#'
#' @description
#' \code{stri_enc_set} sets the encoding used to decode strings
#' internally (i.e. by \R) marked as Native, see \link{stringi-encoding}.
#' \code{stri_enc_get} returns currently used default encoding.
#'
#' @details
#' \code{stri_enc_get} is the same as
#' \code{\link{stri_enc_info}(NULL)$Name.friendly}.
#'
#' Note that changing the default encoding may have undesired consequences.
#'
#' @param enc single string; character encoding name,
#' see \code{\link{stri_enc_list}} for the list of supported encodings.
#'
#' @return
#' \code{stri_enc_set} returns a string with
#' previously used character encoding, invisibly.
#'
#' \code{stri_enc_get} returns a string with current default character
#' encoding.
#'
#' @family encoding_management
#' @rdname stri_enc_set
#' @export
stri_enc_set <- function(enc) {
   previous <- stri_enc_get()

   # We call stri_info, because it generates some warnings,
   # in case any problems are found:
   .Call("stri_enc_set", enc, PACKAGE="stringi")
   message('You are now working with ' %+% stri_info(short=TRUE))
   invisible(previous)
}


#' @rdname stri_enc_set
#' @export
stri_enc_get <- function() {
   stri_enc_info(NULL)$Name.friendly
}
