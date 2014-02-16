## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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
