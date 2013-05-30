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


#' Locales and \pkg{stringi}
#'
#' In this section we explain how we deal with locales in \pkg{stringi}.
#' 
#' Locales are most conviniently identified by character strings
#' of the form \code{Language},
#' \code{Language_Country}, or \code{Language_Country_Variant}, e.g. "en_US"
#' 
#' ICU4C API DOC: "Because a Locale is just an identifier for a region, 
#' no validity check is performed when you specify a Locale. 
#' If you want to see whether particular resources are available 
#' for the Locale you asked for, you must query those resources. (...)
#' Note: When you ask for a resource for a particular locale, you get
#' back the best available match, not necessarily precisely what you asked for."
#' 
#' ICU4C API DOC: "ICU is implemented as a set of services. One example 
#' of a service is the formatting of a numeric value into a string. 
#' Another is the sorting of a list of strings. When client code wants 
#' to use a service, the first thing it does is request a service object 
#' for a given locale. The resulting object is then expected to perform 
#' its operations in a way that is culturally correct for the requested locale."
#' 
#' 
#' 
#' @section A Note on Default Locales:
#' 
#' Except for \code{\link{stri_locale_set}}, each function
#' selects default locale if an empty string or \code{NULL} is given as
#' argument.
#' 
#' "Default locales are available to all the objects in a program. 
#' If you set a new default locale for one section of code, it can affect 
#' the entire program [all other functions from \pkg{stringi}]. 
#' Application programs should not set the default locale 
#' as a way to request an international object. The default locale is set 
#' to be the system locale on that platform."
#' 
#' @section Collation:
#' 
#' See \code{\link{collator}} for the description
#' on how to tune the Collator, which performs
#' a locale-aware, natural-language
#' alike string comparison.
#' It is used for string casefolding, comparing, ordering,
#' sorting, and searching.
#' 
#' @references
#' Locale - ICU User Guide, \url{http://userguide.icu-project.org/locale}
#' 
#' @name stringi-locale
#' @rdname stringi-locale
#' @concepts locale language 
#' @family locale_management
#' @family locale_sensitive
#' @family stringi_general_topics
invisible(NULL)

