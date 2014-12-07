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
#' Query Default Settings for \pkg{stringi}
#'
#' @description
#' Presents current default settings used by the \pkg{ICU} library.
#'
#' @param short logical; whether or not the results should be given
#' in a concise form; defaults to \code{TRUE}
#'
#' @return If \code{short=TRUE}, then a single string containing
#' information on default character encoding, locale, and Unicode
#' as well as \pkg{ICU} version is returned.
#'
#' Otherwise, you a list with the following components is returned:
#' \itemize{
#' \item \code{Unicode.version} -- version of Unicode supported by the \pkg{ICU} library;
#' \item \code{ICU.version} -- \pkg{ICU} library version used;
#' \item \code{Locale} -- contains information on default locale,
#' as returned by \code{\link{stri_locale_info}};
#' \item \code{Charset.internal} -- always \code{c("UTF-8", "UTF-16")};
#' \item \code{Charset.native} -- information on default encoding,
#' as returned by \code{\link{stri_enc_info}}.
#' }
#'
#' @export
#' @family locale, encoding
stri_info <- function(short=FALSE) {
   stopifnot(is.logical(short), length(short) == 1)

   info <- .Call(C_stri_info)
   if (info$Charset.native$Name.friendly != "UTF-8") {
#       if (!info$Charset.native$CharSize.8bit)    # this should not cause problems, e.g. in the Big5 encoding
#          warning("You use a non-8bit native charset. " %s+%
#             "This may cause serious problems. Consider switching to UTF-8.")
#       else
      if (!identical(info$Charset.native$ASCII.subset, TRUE))
         warning(stri_paste("Your native charset is not a superset of US-ASCII. ",
           "This may cause serious problems. Consider switching to UTF-8."))
      else if (!identical(info$Charset.native$Unicode.1to1, TRUE))
         warning(stri_paste("Your native charset does not map to Unicode well. ",
            "This may cause serious problems. Consider switching to UTF-8."))
   }

   loclist <- stri_locale_list()
   if (!(info$Locale$Name %in% loclist))
      warning(stri_paste("Your current locale is not in the list of available ",
         "locales. Some functions may not work properly. ",
         "Refer to stri_locale_list() for more details ",
         "on known locale specifiers."))

   if (!short)
      return(info)
   else {
      locale <- info$Locale$Name
      charset <- info$Charset.native$Name.friendly
      return(stri_paste("stringi_", as.character(packageVersion("stringi")), "; ",
         locale, ".", charset,
         "; ICU4C ", info$ICU.version,
         "; Unicode ", info$Unicode.version))
   }
}
