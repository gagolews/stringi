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


#' @title
#' Compare Strings with or without Collation
#'
#' @description
#' These functions  may be used to determine if two strings
#' are equal (this is performed in a way more clever fashion
#' than you may expect at a first glance) or to check whether they appear in
#' a specific lexicographic order.
#'
#'
#' @details
#' \code{stri_compare} is an alias to \code{stri_cmp}. They both
#' perform exactly the same operation.
#' Both functions provide give the same output
#' as the \code{strcmp()} function in the C programming language
#' standard library, see Value for details.
#'
#' \code{stri_cmp_eq} tests for equality of elements,
#' and \code{stri_cmp_neq} for inequality.
#' What is more,  \code{stri_cmp_le} tests whether
#' the elements in the first vector are less than or equal to
#' the corresponding elements in the second vector,
#' \code{stri_cmp_ge} whether they are greater or equal,
#' \code{stri_cmp_lt} if less,
#' and \code{stri_cmp_gt} if greater,
#' see also \code{\link{\%<\%}}.
#'
#' All the functions are vectorized over \code{e1} and \code{e2}.
#'
#' For more information on \pkg{ICU}'s Collator and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_opts_collator}}.
#' Please note that different locale settings may lead to different results
#' (see the examples below). If \code{opts_collator}
#' is not \code{NA} (the default), then the string comparison
#' is locale-sensitive.
#'
#' Note that \pkg{stringi} silently removes UTF-8 BOMs from input strings,
#' so \code{opts_collator=NA} does not take BOMs into account while
#' comparing strings.
#'
#' @param e1 character vector
#' @param e2 character vector
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options, or \code{NA} for locale-independent
#' Unicode code point comparison
#'
#' @return The \code{stri_cmp} and \code{stri_compare} functions
#' return an integer vector
#' with comparison results of corresponding
#' pairs of elements in \code{e1} and \code{e2}:
#' \code{-1} if \code{e1[...] < e2[...]},
#' \code{0} if they are equal, and \code{1} if greater.
#'
#' The other functions return a logical vector that indicates
#' whether a given relation holds between two corresponding elements
#' in \code{e1} and \code{e2}.
#'
#' @family locale_sensitive
#' @export
#' @rdname stri_compare
#'
#'
#' @examples
#' \dontrun{
#' stri_cmp_lt("hladny", "chladny", stri_opts_collator(locale="pl_PL")) # in Polish ch < h
#' stri_cmp_lt("hladny", "chladny", stri_opts_collator(locale="sk_SK")) # in Slovak ch > h
#' stri_cmp("hladny", "chladny") # < or > (depends on locale)
#' stri_cmp_eq("hladny", "HLADNY", stri_opts_collator(strength=2))
#' stri_cmp_eq("hladn\u00FD", "hladny", stri_opts_collator(strength=1, locale="sk_SK"))
#' stri_cmp_eq(stri_trans_nfkd('\u0105'), '\u105') # but cf. stri_trans_nfkd('\u0105') != '\u105'
#' }
stri_compare <- function(e1, e2, opts_collator=NULL) {
   .Call("stri_cmp", e1, e2, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_compare
stri_cmp <- stri_compare


#' @export
#' @rdname stri_compare
stri_cmp_eq <- function(e1, e2, opts_collator=NULL) {
   .Call("stri_cmp_logical", e1, e2, opts_collator, c(0L, 0L), PACKAGE="stringi")
}


#' @export
#' @rdname stri_compare
stri_cmp_neq <- function(e1, e2, opts_collator=NULL) {
   .Call("stri_cmp_logical", e1, e2, opts_collator, c(0L, 1L), PACKAGE="stringi")
}

#' @export
#' @rdname stri_compare
stri_cmp_lt <- function(e1, e2, opts_collator=NULL) {
   .Call("stri_cmp_logical", e1, e2, opts_collator, c(-1L, 0L), PACKAGE="stringi")
}


#' @export
#' @rdname stri_compare
stri_cmp_gt <- function(e1, e2, opts_collator=NULL) {
   .Call("stri_cmp_logical", e1, e2, opts_collator, c(1L, 0L), PACKAGE="stringi")
}

#' @export
#' @rdname stri_compare
stri_cmp_le <- function(e1, e2, opts_collator=NULL) {
   .Call("stri_cmp_logical", e1, e2, opts_collator, c(1L, 1L), PACKAGE="stringi")
}


#' @export
#' @rdname stri_compare
stri_cmp_ge <- function(e1, e2, opts_collator=NULL) {
   .Call("stri_cmp_logical", e1, e2, opts_collator, c(-1L, 1L), PACKAGE="stringi")
}


#' @title
#' Compare Two Character Vectors with Collation
#'
#' @description
#' Relational operators for comparing two character vectors,
#' with a typical \R look-and-feel.
#'
#' @details
#' These functions call \code{\link{stri_cmp_le}} or its
#' friends, using default collator options.
#'
#'
#' @param e1 character vector or an object coercible to a character vector
#' @param e2 character vector or an object coercible to a character vector
#'
#' @return All the functions return a logical vector
#' indicating the result of the element-by-element comparison.
#' As usual, the elements of shorter vectors are recycled as necessary.
#'
#'
#' @examples
#' \dontrun{
#' "a" %<% "b"
#' c("a", "b", "c") %>=% "b"
#' }
#'
#' @usage
#' e1 \%<\% e2
#'
#' @family locale_sensitive
#' @rdname oper_comparison
#' @export
"%<%" <- function(e1, e2) {
   stri_cmp_lt(e1, e2)
}


#' @usage
#' e1 \%<=\% e2
#' @rdname oper_comparison
#' @export
"%<=%" <- function(e1, e2) {
   stri_cmp_le(e1, e2)
}


#' @usage
#' e1 \%>\% e2
#' @rdname oper_comparison
#' @export
"%>%" <- function(e1, e2) {
   stri_cmp_gt(e1, e2)
}


#' @usage
#' e1 \%>=\% e2
#' @rdname oper_comparison
#' @export
"%>=%" <- function(e1, e2) {
   stri_cmp_ge(e1, e2)
}


#' @usage
#' e1 \%==\% e2
#' @rdname oper_comparison
#' @export
"%==%" <- function(e1, e2) {
   stri_cmp_eq(e1, e2)
}


#' @usage
#' e1 \%!=\% e2
#' @rdname oper_comparison
#' @export
"%!=%" <- function(e1, e2) {
   stri_cmp_neq(e1, e2)
}


#' @usage
#' e1 \%stri<\% e2
#' @rdname oper_comparison
#' @export
"%stri<%" <- function(e1, e2) {
   stri_cmp_lt(e1, e2)
}


#' @usage
#' e1 \%stri<=\% e2
#' @rdname oper_comparison
#' @export
"%stri<=%" <- function(e1, e2) {
   stri_cmp_le(e1, e2)
}


#' @usage
#' e1 \%stri>\% e2
#' @rdname oper_comparison
#' @export
"%stri>%" <- function(e1, e2) {
   stri_cmp_gt(e1, e2)
}


#' @usage
#' e1 \%stri>=\% e2
#' @rdname oper_comparison
#' @export
"%stri>=%" <- function(e1, e2) {
   stri_cmp_ge(e1, e2)
}


#' @usage
#' e1 \%stri==\% e2
#' @rdname oper_comparison
#' @export
"%stri==%" <- function(e1, e2) {
   stri_cmp_eq(e1, e2)
}


#' @usage
#' e1 \%stri!=\% e2
#' @rdname oper_comparison
#' @export
"%stri!=%" <- function(e1, e2) {
   stri_cmp_neq(e1, e2)
}


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
#' These functions use a stable sort algorithm (\pkg{STL}'s stable_sort),
#' which performs up to \eqn{N*log^2(N)} element comparisons,
#' where \eqn{N} is the length of \code{str}.
#'
#' Interestingly, our benchmarks indicate that \code{stri_order}
#' is most often faster that \R's \code{order}.
#'
#' @param str character vector
#' @param decreasing single logical value; should the sort order
#'    be nondecreasing (\code{FALSE}, default)
#'    or nonincreasing (\code{TRUE})?
#' @param na_last single logical value controlling the treatment of \code{NA}s
#'    in \code{str}. If \code{TRUE}, then missing values in \code{str} are put
#'    at the end; if \code{FALSE}, they are put first;
#'    if \code{NA}, then they are removed from the output.
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options, or \code{NA} for locale-independent
#' Unicode code point comparison
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
stri_order <- function(str, decreasing=FALSE, na_last=TRUE, opts_collator=NULL) {
   .Call("stri_order_or_sort", str, decreasing, na_last, opts_collator, 1L, PACKAGE="stringi")
}


#' @export
#' @rdname stri_order
stri_sort <-  function(str, decreasing=FALSE, na_last=NA, opts_collator=NULL) {
   .Call("stri_order_or_sort", str, decreasing, na_last, opts_collator, 2L, PACKAGE="stringi")
}


#' @title Extract Unique Elements
#'
#' @description
#' This function returns a character vector like \code{str},
#' but with duplicate elements removed.
#'
#' @details
#' As usual in \pkg{stringi}, no attributes are copied.
#' Unlike \code{\link{unique}}, this function may (if \code{opts_collator}
#' is not \code{NA}) detect
#' a correct locale-dependent string equivalence.
#'
#' @param str character vector
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options, or \code{NA} for locale-independent
#' Unicode code point comparison
#'
#' @return Returns a character vector.
#'
#' @examples
#' \dontrun{
#' stri_unique(c("\u0105", stri_trans_nfkd("\u0105")))
#' }
#'
#' @family locale_sensitive
#' @export
stri_unique <-  function(str, opts_collator=NULL) {
   .Call("stri_unique", str, opts_collator, PACKAGE="stringi")
}


#' @title
#' Determine Duplicated Elements
#'
#' @description
#' \code{stri_duplicated()} determines which strings in a character vector
#' are duplicates of other elements.
#'
#' \code{stri_duplicated_any()} determines if there are any duplicated
#' strings in a character vector.
#'
#' @details
#' Missing values are regarded as equal.
#'
#' @param str character vector
#' @param fromLast single logical value;
#'    indicating whether duplication should be considered from the
#'    reverse side
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options, or \code{NA} for locale-independent
#' Unicode code point comparison
#'
#' @return
#' \code{stri_duplicated()} returns a logical vector of the same length
#' as \code{str}. Each of its elements indicates if an equivalent string
#' already appeared in \code{str}.
#'
#' \code{stri_duplicated_any()} returns a single non-negative integer.
#' Value of 0 indicates that all the elements in \code{str} are unique.
#' Otherwise, it gives the index of the first non-unique element.
#'
#' @rdname stri_duplicated
#' @family locale_sensitive
#' @export
stri_duplicated <-  function(str, fromLast=FALSE, opts_collator=NULL) {
   .Call("stri_duplicated", str, fromLast, opts_collator, PACKAGE="stringi")
}


#' @rdname stri_duplicated
#' @family locale_sensitive
#' @export
stri_duplicated_any <-  function(str, fromLast=FALSE, opts_collator=NULL) {
   .Call("stri_duplicated_any", str, fromLast, opts_collator, PACKAGE="stringi")
}
