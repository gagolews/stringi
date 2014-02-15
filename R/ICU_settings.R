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
#' Query Default Settings for \pkg{stringi}
#'
#' @description
#' Presents current default settings used by the \pkg{ICU} library.
#'
#' @param short logical; whether or not the results should be given
#' in a concise form; defaults to \code{TRUE}
#'
#' @return If \code{short==TRUE}, then a single string containing
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

   info <- .Call("stri_info", PACKAGE="stringi")
   if (info$Charset.native$Name.friendly != "UTF-8") {
#       if (!info$Charset.native$CharSize.8bit)    # this should not cause problems, e.g. in the Big5 encoding
#          warning("You use a non-8bit native charset. " %+%
#             "This may cause serious problems. Consider switching to UTF-8.")
#       else
      if (!identical(info$Charset.native$ASCII.subset, TRUE))
         warning("Your native charset is not a superset of US-ASCII. " %+%
           "This may cause serious problems. Consider switching to UTF-8.")
      else if (!identical(info$Charset.native$Unicode.1to1, TRUE))
         warning("Your native charset does not convert to Unicode well. " %+%
            "This may cause serious problems. Consider switching to UTF-8.")
   }

   loclist <- stri_locale_list()
   if (!(info$Locale$Name %in% loclist))
      warning("Your current locale is not in the list of available " %+%
         "locales. Some functions may not work properly. " %+%
         "Refer to stri_locale_list() for more details " %+%
         "on known locale specifiers.")

   if (!short)
      return(info)
   else {
      locale <- info$Locale$Name
      charset <- info$Charset.native$Name.friendly
      return(stri_paste(locale, ".", charset,
         "; ICU4C ", info$ICU.version,
         "; Unicode ", info$Unicode.version))
   }
}
