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


#' @title THE String Processing Package
#'
#' @description
#' \pkg{stringi} is an open source package for R.
#' It allows for correct, fast, and simple string manipulation in each locale
#' and any character encoding. 
#'
#' 
#' 
#' @details
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
#' \bold{Keywords}: internationalization, localization, ICU, ICU4C, i18n, l10n, Unicode
#'
#' \bold{Homepage}: \url{http://stringi.rexamine.com}
#'
#' @name stringi-package
#' @docType package
#' @author Marek Gagolewski \email{gagolews@@rexamine.com},\cr
#' Bartek Tartanus \email{bartektartanus@@rexamine.com},\cr
#' with contributions from Marcin Bujarski.
#' @references
#' \pkg{stringi} Package homepage, \url{http://stringi.rexamine.com}.\cr
#' ICU - International Components for Unicode, \url{http://www.icu-project.org/}.\cr
#' ICU4C API, \url{http://www.icu-project.org/apiref/icu4c/}.\cr
#' The Unicode Consortium, \url{http://www.unicode.org/}.\cr
#' RFC 3629: UTF-8, a transformation format of ISO 10646 \url{http://tools.ietf.org/html/rfc3629}.
#' @family stringi_general_topics
invisible(NULL)





.onLoad <- function(lib, pkg)
{
   if (.Platform$OS.type == "windows") {
      dll <- try(library.dynam("stringi", pkg, lib), silent=getOption("verbose"))
      
      if (class(dll) != "DLLInfo") {
         return(.install_ICU4C_windows(lib, pkg, .Platform$r_arch))
      }
   }
   else { # "unix"
      dll <- try(library.dynam("stringi", pkg, lib), silent=getOption("verbose"))
      if (class(dll) != "DLLInfo") {
         stop("Failed to load stringi dynamic library. 
              Perhaps ICU4C is not in your search path. 
              Please recompile the package.", call.=FALSE)
      }
   }
   
   # stri_info() produces a warning if current native charset
   # is problematic. The packageStartupMessage also indicates the user
   # whether ICU has guessed the locale used correctly. Leave it as is :)
   packageStartupMessage("stringi (" %+% stri_info(short=TRUE) %+% ")")
}


.install_ICU4C_windows <- function(lib, pkg, platform)
{
   ask1 <- "The ICU4C library has not been installed yet. Do you want to download it? [y/n] > ";
   ask2 <- "Do you want to reload the package? [y/n] > "
   
   ans <- as.character(readline(prompt = ask1))
   if (!identical(tolower(ans), "y"))
      stop("Failed to load stringi dynamic library.", call.=FALSE)
   
   fname <- tempfile()
   urlsrc <- paste0("http://static.rexamine.com/packages/windows/icu4c_51_2-mingw-distrib-",
                    platform, ".zip")
   download.file(urlsrc, fname)
   destdir <- file.path(lib, pkg, "libs", platform)
   unzip(fname, exdir=destdir) 
   
   cat('ICU4C 51.2 has been installed successfully.\n')
   ans <- as.character(readline(prompt = ask2))
   if (!identical(tolower(ans), "y"))
      stop("Failed to load stringi dynamic library.", call.=FALSE)
   
   .onLoad(lib, pkg)
}
