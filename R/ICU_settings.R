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



#' Get currently used ICU settings
#' 
#' @param short should only current locale and charset be returned?
#' @return a list of TODO.... (short=FALSE) or a string (short=TRUE)
#' @export
stri_info <- function(short=FALSE) {
   stopifnot(is.logical(short), length(short) == 1)
   
   info <- .Call("stri_info", PACKAGE="stringi")
   if (info$Charset.native$Name.friendly != "UTF-8") {
      if (!info$Charset.native$CharSize.8bit)
         warning("you use a non-8bit native charset. \
            this may cause serious problems. consider switching to UTF-8")
      else if (!info$Charset.native$Unicode.1to1)
         warning("your native charset does not convert well to Unicode. \
            this may cause serious problems. consider switching to UTF-8")
      else if (!info$Charset.native$ASCII.subset)
         warning("your native charset is not a superset of US-ASCII. \
            this may cause serious problems. consider switching to UTF-8")
   }
   
   loclist <- stri_localelist()
   if (!(info$Locale$Name %in% loclist))
      warning("your current locale is not on the list of available \
         locales. see stri_localelist()")
   
   if (!short)
      info
   else {
      locale <- info$Locale$Language %+% "_" %+% info$Locale$Country
      charset <- info$Charset.native$Name.friendly
      locale %+% "." %+% charset
   }
}
