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
#' \item \link{stringi-arguments} - how \pkg{stringi} 
#' deals with its functions' arguments,
#' 
#' \item \link{stringi-encoding} - character encoding issues,
#' including information on encoding management in \pkg{stringi}, as well as
#' encoding detection, conversion, and Unicode normalization,
#' 
#' \item \link{stringi-locale} - locale issues, i.a. locale management and
#' specification in \pkg{stringi} and the list locale-sensitive operations.
#' See \code{\link{stri_opts_collator}}  for the description 
#' of string collation algorithm, used for string comparing, ordering, 
#' sorting, casefolding, and searching.
#' 
#' \item \link{stringi-search} - string searching facilities
#' by 3 separate search engines:
#' \link{stringi-search-regex}, \link{stringi-search-fixed}, 
#' and \link{stringi-search-charclass}
#' - includes pattern searching, matching, string splitting, and so on.
#' }
#'
#' Other interesting stuff:
#' \itemize{
#' \item \code{\link{stri_stats_general}} and \code{\link{stri_stats_latex}} 
#' for gathering some statistics on character vector's contents.
#'
#' \item \code{\link{stri_join}}, \code{\link{stri_dup}}, 
#' and \code{\link{stri_flatten}} for concatenation-based operations.
#'
#' \item \code{\link{stri_sub}} for extracting and replacing substrings,
#' and \code{\link{stri_reverse}} for a funny function
#' to reverse all characters in a string.
#'
#' \item \code{\link{stri_trim}} (among others) for 
#' trimming characters from the beginning or/and end of a string, 
#' see also \link{stringi-search-charclass}.
#'
#' \item \code{\link{stri_length}} (among others) for determining the number
#' of code points in a string.
#'
#' \item \code{\link{stri_trans_tolower}} (among others) - case mapping,
#' i.e. conversion to lower, UPPER, or Title case.
#'
#' \item \code{\link{stri_compare}}, \code{\link{stri_order}},
#' and \code{\link{stri_sort}} for comparison-based,
#' locale-aware operations, see also \link{stringi-locale}.
#' 
#' \item \code{\link{stri_split_lines}} to split a string into text lines.
#' 
#' \item DRAFT API: \code{\link{stri_read_raw}},
#' \code{\link{stri_read_lines}}, and  \code{\link{stri_write_lines}}
#' for reading and writing text files.
#'
#' \item TO DO [these will appear in future versions
#' of \pkg{stringi}]: pad, wrap, justify, HTML entities,
#' character translation,
#' escape characters, MIME Base 64 encode/decode,
#' random string generation, number and data/time formatting,
#' and many more.
#' }
#'
#' Information on default encodings and locales....
#'
#' \bold{Keywords}: internationalization, localization, ICU, ICU4C, i18n, l10n, Unicode
#'
#' \bold{Homepage}: \url{http://stringi.rexamine.com}
#'
#' @name stringi-package
#' @rdname stringi-package
#' @docType package
#' @author Marek Gagolewski \email{gagolews@@rexamine.com},\cr
#' Bartek Tartanus \email{bartektartanus@@rexamine.com},\cr
#' with contributions from Marcin Bujarski.
#' @references
#' \emph{\pkg{stringi} Package homepage}, \url{http://stringi.rexamine.com}
#'
#' \emph{ICU -- International Components for Unicode}, \url{http://www.icu-project.org/}
#'
#' \emph{ICU4C API Documentation}, \url{http://www.icu-project.org/apiref/icu4c/}
#'
#' \emph{The Unicode Consortium}, \url{http://www.unicode.org/}
#'
#' \emph{UTF-8, a transformation format of ISO 10646} - RFC 3629, \url{http://tools.ietf.org/html/rfc3629}
#'
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
