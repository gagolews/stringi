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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' \pkg{stringi} is an open source package for R.
#' It allows for correct, fast, and simple string manipulation in each locale
#' and any character encoding. 
#'
#' \bold{Keywords}: internationalization, localization, ICU, ICU4R, i18n, l10n, Unicode
#' 
#' 
#' Man pages on general topics:
#' \itemize{
#' \item \link{stringi-arguments} - how \pkg{stringi} deals with its functions' arguments, 
#' \item \link{stringi-encoding} - encoding management,
#' including encoding management, detection, conversion, and Unicode
#' normalization,
#' \item \link{stringi-locale} - locale management, 
#' and the list locale-sensitive operations, especially
#' \link{collator} for the description of string collation algorithm,
#' used for string comparing, ordering, sorting, casefolding, and searching.
#' \item \link{stringi-search} - string searching, especially
#' \link{stringi-search-regex}, \link{stringi-search-fixed}, and \link{stringi-search-charclass}
#' }
#' 
#' Other interesting stuff:
#' \itemize{
#' \item \link{stri_stats_general} and \link{stri_stats_latex}  for gathering some
#' statistics on character vector's contents.
#' }
#' 
#' Information on default encodings and locales....
#'
#' @name stringi-package
#' @docType package
#' @title THE String Processing Package
#' @author Marek Gagolewski \email{gagolews@@rexamine.com},\cr
#' Bartek Tartanus \email{bartektartanus@@rexamine.com},\cr
#' with contributions from Marcin Bujarski.
#' @references
#' \pkg{stringi} Package homepage, \url{http://www.rexamine.com/resources/stringi/}.\cr
#' ICU - International Components for Unicode, \url{http://www.icu-project.org/}.\cr
#' ICU4C API, \url{http://www.icu-project.org/apiref/icu4c/}.\cr
#' The Unicode Consortium, \url{http://www.unicode.org/}.\cr
#' RFC 3629: UTF-8, a transformation format of ISO 10646 \url{http://tools.ietf.org/html/rfc3629}.
#' @family stringi_general_topics
invisible(NULL)





#' @useDynLib stringi
.onAttach <- function(lib, pkg)
{
   # stri_info() produces a warning if current native charset
   # is problematic. The packageStartupMessage also indicates the user
   # whether ICU has guessed the locale used correctly. Leave it as is :)
   info <- stri_info(short=TRUE)
   packageStartupMessage("stringi (" %+% info %+% ")")
}
