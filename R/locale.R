# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
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
## 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
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
#' Locales and \pkg{stringi}
#'
#' @description
#' In this section we explain how we specify locales in \pkg{stringi}.
#' Locale is a fundamental concept in \pkg{ICU}.
#' It identifies a specific user community, i.e., a group of users
#' who have similar culture and language expectations
#' for human-computer interaction.
#'
#'
#' @details
#' Because a locale is just an identifier of a region,
#' no validity check is performed when you specify a Locale.
#' \pkg{ICU} is implemented as a set of services.
#' If you want to verify whether particular resources are available
#' in the locale you asked for, you must query those resources.
#' Note: when you ask for a resource for a particular locale, you get back
#' the best available match, not necessarily precisely the one you requested.
#'
#' @section Locale Identifiers:
#'
#' \pkg{ICU} services are parametrized by locale,
#' to deliver culturally correct results.
#' Locales are identified by character strings
#' of the form \code{Language} code,
#' \code{Language_Country} code, or \code{Language_Country_Variant}
#' code, e.g., 'en_US'.
#'
#' The two-letter \code{Language} code uses the ISO-639-1 standard,
#' e.g., 'en' stands for English, 'pl' -- Polish, 'fr' -- French,
#' and 'de' for German.
#'
#' \code{Country} is a two-letter code following the ISO-3166 standard.
#' This is to reflect different language conventions within the same language,
#' for example in US-English ('en_US') and Australian-English ('en_AU').
#'
#' Differences may also appear in language conventions used within
#' the same country. For example, the Euro currency may be used in several European
#' countries while the individual country's currency is still in circulation.
#' In such a case, \pkg{ICU} \code{Variant} '_EURO' could be used for selecting
#' locales that support the Euro currency.
#'
#' The final (optional) element of a locale is a list of
#' keywords together with their values. Keywords must be unique.
#' Their order is not significant. Unknown keywords are ignored.
#' The handling of keywords depends on the specific services that
#' utilize them. Currently, the following keywords are recognized:
#' \code{calendar}, \code{collation}, \code{currency}, and \code{numbers},
#' e.g., \code{fr@@collation=phonebook;}\code{calendar=islamic-civil} is a valid
#' French locale specifier together with keyword arguments. For
#' more information, refer to the ICU user guide.
#'
#' For a list of locales that are recognized by \pkg{ICU},
#' call \code{\link{stri_locale_list}}.
#'
#' Note that in \pkg{stringi}, 'C' is a synonym of `en_US_POSIX`.
#'
#'
#' @section A Note on Default Locales:
#'
#' Each locale-sensitive function in \pkg{stringi}
#' selects the current default locale if an empty string or \code{NULL}
#' is provided as its \code{locale} argument. Default locales are available
#' to all the functions; initially, the system locale on that platform is used,
#' but it may be changed by calling \code{\link{stri_locale_set}}.
#'
#' Your program should avoid changing the default locale.
#' All locale-sensitive functions may request
#' any desired locale per-call (by specifying the \code{locale} argument),
#' i.e., without referencing to the default locale.
#' During many tests, however, we did not observe any improper
#' behavior of \pkg{stringi} while using a modified default locale.
#'
#'
#'
#'
#' @section Locale-Sensitive Functions in \pkg{stringi}:
#'
#' One of many examples of locale-dependent services is the Collator, which
#' performs a locale-aware string comparison. It is used for string comparing,
#' ordering, sorting, and searching. See \code{\link{stri_opts_collator}}
#' for the description on how to tune its settings, and its \code{locale}
#' argument in particular.
#'
#' When choosing a resource bundle that is not available in the explicitly
#' requested locale (but not when using the default locale)
#' nor in its more general variants (e.g., `es_ES` vs `es`),
#' a warning is emitted.
#'
#' Other locale-sensitive functions include, e.g.,
#' \code{\link{stri_trans_tolower}} (that does character case mapping).
#'
#' @references
#' \emph{Locale} -- ICU User Guide,
#' \url{https://unicode-org.github.io/icu/userguide/locale/}
#'
#' \emph{ISO 639: Language Codes},
#' \url{https://www.iso.org/iso-639-language-codes.html}
#'
#' \emph{ISO 3166: Country Codes},
#' \url{https://www.iso.org/iso-3166-country-codes.html}
#'
#' @name about_locale
#' @rdname about_locale
#' @aliases about_locale locale stringi-locale
#' @family locale_management
#' @family locale_sensitive
#' @family stringi_general_topics
invisible(NULL)
