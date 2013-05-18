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



#' Compare Strings, with Collation
#' 
#' Performs a locale-aware, natural-language alike string comparison.
#' This is a more intelligent form than that provided by R.
#' 
#' Vectorized over \code{e1} and \code{e2}.
#' 
#' \code{strength} set to 3 is the least permissive (the default).
#' Set to 2 to ignore case differences.
#' Set to 1 to also ignore diacritical differences.
#' 
#' The strings are Unicode-normalized before the comparison.
#' 
#' @param e1 character vector
#' @param e2 character vector
#' @param strength collation strength, defaults to 3
#' @param locale \code{NULL} or \code{""} for casefolding following
#' the conventions of the default locale, or a single string with locale identifier
#' 
#' @return integer vector, elements are comparison results of corresponding
#' pairs;
#' \code{-1} if \code{e1[...] < e2[...]},
#' \code{0} if equal, and \code{1} if greater.
#' 
#' @family locale_dependent
#' @export
#' @rdname stri_compare
#' 
#' @references
#' Collation - ICU User Guide - http://userguide.icu-project.org/collation
#' http://www.icu-project.org/apiref/icu4c/classicu_1_1Collator.html
#' 
#' @examples
#' stri_cmp("hladny", "chladny", locale="pl_PL") # in Polish ch < h
#' stri_cmp("hladny", "chladny", locale="sk_SK") # in Slovak ch > h
#' stri_cmp("hladny", "HLADNY") # <
#' stri_cmp("hladny", "HLADNY", strength=2) # ==
#' stri_cmp("hladný", "hladny", strength=1, locale="sk_SK") # ==
#' stri_cmp(stri_enc_nfkd('\u0105'), '\u105') # but cf. stri_enc_nfkd('\u0105') != '\u105'
stri_compare <- function(e1, e2, strength=3L, locale=NULL) {
   .Call("stri_compare", e1, e2, strength, locale, PACKAGE="stringi")
}


#' @export
#' @rdname stri_compare
stri_cmp <- stri_compare
