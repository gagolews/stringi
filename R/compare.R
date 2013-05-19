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
#' Vectorized over \code{e1} and \code{e2}.
#'
#' For more information on ICU's Collator and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_collator_genopts}}.
#' 
#' @param e1 character vector
#' @param e2 character vector
#' @param collator_opts a named R list as generated with \code{\link{stri_collator_genopts}}
#' with Collator's options, or \code{NA} for dummy byte comparison
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
#' 
#' @examples
#' stri_cmp("hladny", "chladny", stri_collator_genopts(locale="pl_PL")) # in Polish ch < h
#' stri_cmp("hladny", "chladny", stri_collator_genopts(locale="sk_SK")) # in Slovak ch > h
#' stri_cmp("hladny", "HLADNY") # < or > (depends on locale)
#' stri_cmp("hladny", "HLADNY", stri_collator_genopts(strength=2)) # ==
#' stri_cmp("hladný", "hladny", stri_collator_genopts(strength=1, locale="sk_SK")) # ==
#' stri_cmp(stri_enc_nfkd('\u0105'), '\u105') # but cf. stri_enc_nfkd('\u0105') != '\u105'
stri_compare <- function(e1, e2, collator_opts=list()) {
   .Call("stri_compare", e1, e2, collator_opts, PACKAGE="stringi")
}


#' @export
#' @rdname stri_compare
stri_cmp <- stri_compare



#' Ordering Permutation and Sorting, String Comparisons with Collation
#' 
#' For more information on ICU's Collator and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_collator_genopts}}.
#' 
#' Uses a stable sort algorithm (STL's stable_sort);
#' performs up to \eqn{N*log^2(N)} element comparisons,
#' where \eqn{N} is the length of \code{str}.
#' 
#' \code{stri_order} is slightly slower than \code{order} only for
#' already sorted data. In other cases it outperforms the base-R function
#' (test yourself).
#' 
#' \code{NA}s are always put at the end.
#' 
#' @param str character vector
#' @param decreasing single logical value; should the sort order be increasing or decreasing?
#' @param collator_opts a named R list as generated with \code{\link{stri_collator_genopts}}
#' with Collator's options, or \code{NA} for dummy byte comparison
#' 
#' @return for \code{stri_order} - an integer vector that gives the sort order;
#' for \code{stri_order} - a sorted version of \code{str}
#' 
#' @family locale_dependent
#' @export
#' @rdname stri_order
#' 
#' @examples
#' stri_sort(c("hladny", "chladny"), stri_collator_genopts(locale="pl_PL"))
#' stri_sort(c("hladny", "chladny"), stri_collator_genopts(locale="sk_SK"))
stri_order <- function(str, decreasing=FALSE, collator_opts=list()) {
   .Call("stri_order", str, decreasing, collator_opts, PACKAGE="stringi")
}


#' @export
#' @rdname stri_order
stri_sort <-  function(str, decreasing=FALSE, strength=3L, locale=NULL) {
   str[stri_order(str, decreasing, strength, locale)]
}
