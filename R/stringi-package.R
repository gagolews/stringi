## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
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



#' \pkg{stringi} is an open source (LGPL 3) package for R.
#' It allows for correct, fast, and simple string manipulation in each locale. 
#'
#' \bold{Keywords}: internationalization, ICU, ICU4R, i18n, l10n
#'
#' @name stringi-package
#' @docType package
#' @title Correct, fast, and simple string manipulation in each locale
#' @author Marek Gagolewski \email{gagolews@@ibspan.waw.pl},\cr
#' Bartek Tartanus \email{bartektartanus@@gmail.com},\cr
#' Marcin Bujarski \email{marcin.bujarski@@gmail.com}
#' @references
#' Package homepage, \url{http://www.ibspan.waw.pl/~gagolews/?page=resources&subpage=stringi}.\cr
#' ICU - International Components for Unicode, \url{http://www.icu-project.org/}.\cr
#' ICU4C API, \url{http://www.icu-project.org/apiref/icu4c/}.\cr
#' The Unicode Consortium, \url{http://www.unicode.org/}.\cr
#' RFC 3629: UTF-8, a transformation format of ISO 10646 \url{http://tools.ietf.org/html/rfc3629}.\cr
invisible(NULL)





#' TO DO
#' @useDynLib stringi
.onAttach <- function(lib, pkg)
{
   # stri_info() produces a warning if current native charset
   # is problematic. the packageStartupMessage also indicates the user
   # whether ICU has guessed the locale used correctly. Leave it as is :)
   info <- stri_info(short=TRUE)
   packageStartupMessage("stringi (" %+% info %+% ")")
}
