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
#' List Known Character Encodings
#'
#' @description
#' Gives the list of encodings that are supported by \pkg{ICU}.
#'
#' @details
#' Please note that apart from given encoding identifiers and their aliases,
#' some other specifiers will be available in your conversion tasks.
#' This is due to the fact that \pkg{ICU} tries to normalize
#' converter names. E.g. \code{"UTF8"} is also valid,
#' see \link{stringi-encoding} for more information.
#'
#' @param simplify single logical value; return a character vector or a
#' list of character vectors?
#'
#' @return If \code{simplify} is \code{FALSE} (the default), a list of
#'  character vectors is returned. Each list element represents a unique
#'  character encoding. The \code{name} attribute gives the \pkg{ICU} Canonical
#'  Name of an encoding family. The elements (character vectors) are
#'  its aliases.
#'
#' If \code{simplify} is \code{TRUE}, then the resulting list
#' is coerced to a character vector and sorted, and returned with
#' removed duplicated entries.
#'
#' @family encoding_management
#' @export
stri_enc_list <- function(simplify=FALSE) {
   simplify <- !identical(simplify, FALSE)

   ret <- .Call(C_stri_enc_list)
   if (simplify)
      return(stri_sort(unique(unlist(ret)))) # @TODO: use stri_unique
   else
      return(ret)
}


#' @title
#' Query a Character Encoding
#'
#' @description
#' Gets basic information on a character encoding.
#'
#' @details
#' An error is raised if the encoding provided is unknown to \pkg{ICU}
#' (see \code{\link{stri_enc_list}} for more details)
#'
#'
#' @param enc \code{NULL} or \code{""} for default encoding,
#' or a single string with encoding name
#'
#' @return
#' Returns a list with the following components:
#' \itemize{
#' \item \code{Name.friendly} -- Friendly encoding name:
#'     MIME Name or JAVA Name or \pkg{ICU} Canonical Name
#'    (the first of provided ones is selected, see below);
#' \item \code{Name.ICU} -- Encoding name as identified by \pkg{ICU};
#' \item \code{Name.*} -- other standardized encoding names,
#' e.g. \code{Name.UTR22}, \code{Name.IBM}, \code{Name.WINDOWS},
#' \code{Name.JAVA}, \code{Name.IANA}, \code{Name.MIME} (some of them
#' may be unavailable for all the encodings);
#' \item \code{ASCII.subset} -- is ASCII a subset of the given encoding?;
#' \item \code{Unicode.1to1} -- for 8-bit encodings only: are all characters
#' translated to exactly one Unicode code point and is the translation
#' scheme reversible?;
#' \item \code{CharSize.8bit} -- is this an 8-bit encoding, i.e. do we have
#'    \code{CharSize.min == CharSize.max} and \code{CharSize.min == 1}?;
#' \item \code{CharSize.min} -- minimal number of bytes used
#'    to represent an UChar (in UTF-16, this is not the same as UChar32)
#' \item \code{CharSize.max} -- maximal number of bytes used
#'    to represent an UChar (in UTF-16, this is not the same as UChar32,
#'    i.e. does not reflect the maximal code point representation size)
#' }
#'
#' @family encoding_management
#' @export
stri_enc_info <- function(enc=NULL) {
   .Call(C_stri_enc_info, enc)
}


#' @title
#' Set or Get Default Character Encoding in \pkg{stringi}
#'
#' @description
#' \code{stri_enc_set} sets the encoding used to re-encode strings
#' internally (i.e. by \R) declared to be in native encoding,
#' see \link{stringi-encoding} and \code{\link{stri_enc_mark}}.
#' \code{stri_enc_get} returns currently used default encoding.
#'
#' @details
#' \code{stri_enc_get} is the same as
#' \code{\link{stri_enc_info}(NULL)$Name.friendly}.
#'
#' Note that changing the default encoding may have undesired consequences.
#' Unless you are an expert user and you know what you are doing,
#' \code{stri_enc_set} should only be used if \pkg{ICU} fails to detect
#' your system's encoding correctly (while testing \pkg{stringi}
#' we only encountered such a situation on a very old Solaris machine, though).
#' Note that \pkg{ICU} tries to match the encoding part of the \code{LC_CTYPE}
#' category as given by \code{\link{Sys.getlocale}}.
#'
#' If you set a default encoding that is not a superset of ASCII
#' or it is not an 8-bit encoding, a warning will be generated,
#' see \link{stringi-encoding} for discussion.
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
   .Call(C_stri_enc_set, enc)
   message(stri_paste('You are now working with ', stri_info(short=TRUE)))
   invisible(previous)
}


#' @rdname stri_enc_set
#' @export
stri_enc_get <- function() {
   stri_enc_info(NULL)$Name.friendly
}


#' @title
#' Get Declared Encodings of Each String
#'
#' @description
#' Gets declared encodings for each string in a character vector
#' as seen by \pkg{stringi}.
#'
#' @details
#' According to \code{\link{Encoding}},
#' \R has a simple encoding marking mechanism:
#' strings can be declared to be in \code{latin1},
#' \code{UTF-8} or \code{bytes}.
#'
#' Moreover, via the C API we may check whether
#' a string is in ASCII (\R assumes that this holds if and only if
#' all bytes in a string are not greater than 127,
#' so there is an implicit assumption that your platform uses
#' an encoding which is an ASCII superset)
#' or in the system's default (a.k.a. \code{unknown} in \code{\link{Encoding}})
#' encoding.
#'
#' Intuitively, the default encoding should be equivalent to
#' the one you use when inputting data via keyboard.
#' In \code{stringi} we assume that such an encoding
#' is equivalent to the one returned by \code{\link{stri_enc_get}}.
#' It is automatically detected by \pkg{ICU}
#' to match -- by default -- the encoding part of the \code{LC_CTYPE} category
#' as given by \code{\link{Sys.getlocale}}.
#'
#'
#'
#' @param str character vector
#' or an object coercible to a character vector
#'
#' @return Returns a character vector of the same length as \code{str}.
#' Unlike in \code{\link{Encoding}}, possible encodings are:
#' \code{ASCII}, \code{latin1}, \code{bytes}, \code{native},
#' and \code{UTF-8}. Additionally, missing values are handled properly.
#'
#' This is exactly the same information which is used by
#' all the functions in \pkg{stringi} to re-encode their inputs.
#'
#' @family encoding_management
#' @export
stri_enc_mark <- function(str) {
   .Call(C_stri_enc_mark, str)
}
