## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#' @title
#' Compare Strings with or without Collation
#'
#' @description
#' These functions  may be used to determine if two strings
#' are equal (this is performed more intelligently than you may
#' expect at a first glance) or to check whether they appear in
#' a specific lexicographic order.
#'
#'
#' @details
#' \link{stri_cmp} is an alias to \link{stri_compare}. They both
#' do the same operation.
#'
#'
#' Vectorized over \code{e1} and \code{e2}.
#'
#' For more information on \pkg{ICU}'s Collator and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_opts_collator}}.
#' Please note that different locale settings may lead to different results
#' (see the examples below).
#'
#' @param e1 character vector
#' @param e2 character vector
#' @param opts_collator a named list as generated with \code{\link{stri_opts_collator}}
#' with Collator's options, or \code{NA} for dummy Unicode code point comparison
#'
#' @return Each function returns an integer vector
#' with comparison results of corresponding
#' pairs of elements from \code{e1} and \code{e2}:
#' \code{-1} if \code{e1[...] < e2[...]},
#' \code{0} if they are equal, and \code{1} if greater.
#'
#' @family locale_sensitive
#' @export
#' @rdname stri_compare
#'
#'
#' @examples
#' \dontrun{
#' stri_cmp("hladny", "chladny", stri_opts_collator(locale="pl_PL")) # in Polish ch < h
#' stri_cmp("hladny", "chladny", stri_opts_collator(locale="sk_SK")) # in Slovak ch > h
#' stri_cmp("hladny", "HLADNY") # < or > (depends on locale)
#' stri_cmp("hladny", "HLADNY", stri_opts_collator(strength=2)) # ==
#' stri_cmp("hladn\u00FD", "hladny", stri_opts_collator(strength=1, locale="sk_SK")) # ==
#' stri_cmp(stri_enc_nfkd('\u0105'), '\u105') # but cf. stri_enc_nfkd('\u0105') != '\u105'
#' }
stri_compare <- function(e1, e2, opts_collator=list()) {
   .Call("stri_compare", e1, e2, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_compare
stri_cmp <- stri_compare



#' @title
#' Ordering Permutation and Sorting
#'
#'
#' @description
#' \link{stri_order} determines a permutation which rearranges
#' strings into ascending
#' or descending order. \link{stri_sort} sorts the vector
#' according to a lexicographic order.
#'
#'
#' @details
#' For more information on \pkg{ICU}'s Collator and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_opts_collator}}.
#'
#' Uses a stable sort algorithm (\pkg{STL}'s stable_sort);
#' performs up to \eqn{N*log^2(N)} element comparisons,
#' where \eqn{N} is the length of \code{str}.
#'
#' Interestingly, \code{stri_order} is most often faster that \R's \code{order}.
#'
#' Missing values are always put at the end of a character vector.
#'
#' \code{stri_sort} is a `black sheep` in \pkg{stringi}:
#' it does not always return UTF-8-encoded strings.
#' Moreover, it preserves many input object's attributes.
#' This is because it is defined as
#' \code{str[stri_order(str, decreasing, opts_collator)]}.
#'
#' @param str character vector
#' @param decreasing single logical value; should the sort order
#'    be nondecreasing (\code{FALSE}, default)
#'    or nonincreasing (\code{TRUE})?
#' @param opts_collator a named list as generated with \code{\link{stri_opts_collator}}
#' with Collator's options, or \code{NA} for dummy Unicode code point comparison
#'
#' @return For \code{stri_order}, an integer vector that gives the sort order
#' is returned.
#'
#' For \code{stri_order}, you get a sorted version of \code{str},
#' i.e. a character vector.
#'
#' @family locale_sensitive
#' @export
#' @rdname stri_order
#'
#' @examples
#' \dontrun{
#' stri_sort(c("hladny", "chladny"), opts_collator=stri_opts_collator(locale="pl_PL"))
#' stri_sort(c("hladny", "chladny"), opts_collator=stri_opts_collator(locale="sk_SK"))
#' }
stri_order <- function(str, decreasing=FALSE, opts_collator=list()) {
   .Call("stri_order", str, decreasing, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_order
stri_sort <-  function(str, decreasing=FALSE, opts_collator=list()) {
   str[stri_order(str, decreasing, opts_collator)]
}
