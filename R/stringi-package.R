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


#' @title THE String Processing Package
#'
#' @description
#' \pkg{stringi} is THE \R package for fast, correct, consistent,
#' and convenient string/text manipulation in each locale and any
#' character encoding. We put great effort to create software that
#' gives predictable results on any platform, in each locale, and any
#' ``native'' system encoding.
#'
#' \bold{Keywords}: R, text processing, character strings, internationalization,
#'     localization, ICU, ICU4C, i18n, l10n, Unicode.
#'
#' \bold{Homepage}: \url{http://stringi.rexamine.com}
#'
#' \bold{License}: The BSD-3-clause license for the package code,
#' the ICU license for the accompanying ICU4C distribution,
#' and the UCD license for the Unicode Character Database.
#' See the COPYRIGHTS and LICENSE file for more details.
#'
#'
#' @details
#' Manual pages on general topics (must-read):
#' \itemize{
#' \item \link{stringi-encoding} -- character encoding issues, including
#'    information on encoding management in \pkg{stringi}, as well as
#'    on encoding detection and conversion.
#'
#' \item \link{stringi-locale} -- locale issues, including i.a. locale
#'    management and specification in \pkg{stringi}, and the list of
#'    locale-sensitive operations. In particular, see
#'    \code{\link{stri_opts_collator}} for a description of the string
#'    collation algorithm, which is used for string comparing, ordering,
#'    sorting, case-folding, and searching.
#'
#' \item \link{stringi-arguments} -- how \pkg{stringi} deals with its
#'    functions' arguments.
#' }
#'
#'
#' @section Facilities available:
#'
#' Refer to the following:
#' \itemize{
#' \item \link{stringi-search} for string searching facilities;
#' these include pattern searching, matching, string splitting, and so on.
#' The following independent search engines are provided:
#' \itemize{
#' \item \link{stringi-search-regex} -- with ICU (Java-like) regular expressions;
#' \item \link{stringi-search-fixed} -- fast, locale-independent, bytewise pattern
#'    matching,
#' \item \link{stringi-search-coll} -- locale-aware pattern matching
#'    for natural language processing tasks;
#' \item \link{stringi-search-charclass} -- for finding elements of
#' particular character classes, like ``all whitespaces'' or ``all digits'';
#' \item \link{stringi-search-boundaries} -- text boundary analysis.
#' }
#'
#'
#' \item \code{\link{stri_stats_general}} and \code{\link{stri_stats_latex}}
#' for gathering some fancy statistics on a character vector's contents.
#'
#' \item \code{\link{stri_join}}, \code{\link{stri_dup}}, \code{\link{\%s+\%}},
#' and \code{\link{stri_flatten}} for concatenation-based operations.
#'
#' \item \code{\link{stri_sub}} for extracting and replacing substrings,
#' and \code{\link{stri_reverse}} for a joyful function
#' to reverse all code points in a string.
#'
#' \item \code{\link{stri_trim}} (among others) for
#' trimming characters from the beginning or/and end of a string,
#' see also \link{stringi-search-charclass},
#' and \code{\link{stri_pad}} for padding strings so that
#' they have the same minimal number of code points.
#' Additionally, \code{\link{stri_wrap}} wraps text into lines.
#'
#' \item \code{\link{stri_length}} (among others) for determining the number
#' of code points in a string. See also \code{\link{stri_count_boundaries}}
#' for counting the number of \code{Unicode characters}.
#'
#' \item \code{\link{stri_trans_tolower}} (among others) for case mapping,
#' i.e. conversion to lower, UPPER, or Title Case,
#' \item \code{\link{stri_trans_nfc}} (i.a.) for Unicode normalization,
#' and \code{\link{stri_trans_general}} for other very general yet powerful
#' text transforms, including transliteration.
#'
#' \item \code{\link{stri_cmp}}, \code{\link{\%s<\%}}, \code{\link{stri_order}},
#' \code{\link{stri_sort}}, \code{\link{stri_unique}}, and
#' \code{\link{stri_duplicated}} for collation-based,
#' locale-aware operations, see also \link{stringi-locale}.
#'
#' \item \code{\link{stri_split_lines}} (among others)
#' to split a string into text lines.
#'
#' \item \code{\link{stri_escape_unicode}} (among others) for escaping
#' certain code points.
#'
#' \item \code{\link{stri_rand_strings}}, \code{\link{stri_rand_shuffle}},
#' and \code{\link{stri_rand_lipsum}} for generating (pseudo)random strings.
#'
#' \item DRAFT API: \code{\link{stri_read_raw}},
#' \code{\link{stri_read_lines}}, and  \code{\link{stri_write_lines}}
#' for reading and writing text files.
#'
#' \item TO DO [these will appear in future versions
#' of \pkg{stringi}]: HTML entities,
#' MIME Base 64 encode/decode,
#' number and data/time formatting,
#' number spellout, and many more.
#' }
#'
#' Note that each man page has many links to other interesting facilities.
#'
#' You are encouraged to call \code{\link{stri_install_check}}
#' after the package installation or update.
#'
#' @name stringi-package
#' @rdname stringi-package
#' @docType package
#' @author Marek Gagolewski \email{gagolews@@rexamine.com},\cr
#' Bartek Tartanus \email{bartektartanus@@rexamine.com},\cr
#' with some contributions from Marcin Bujarski at the early stage
#' of package development.
#' ICU4C was developed by IBM and others.
#' The Unicode Character Database is due to Unicode, Inc.;
#' see the COPYRIGHTS file for more details.
#' @references
#' \emph{\pkg{stringi} Package homepage}, \url{http://stringi.rexamine.com}
#'
#' \emph{ICU -- International Components for Unicode}, \url{http://www.icu-project.org/}
#'
#' \emph{ICU4C API Documentation}, \url{http://www.icu-project.org/apiref/icu4c/}
#'
#' \emph{The Unicode Consortium}, \url{http://www.unicode.org/}
#'
#' \emph{UTF-8, a transformation format of ISO 10646} -- RFC 3629,
#' \url{http://tools.ietf.org/html/rfc3629}
#'
#' @family stringi_general_topics
#' @useDynLib stringi, .registration = TRUE
invisible(NULL)
