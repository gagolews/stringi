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
#' These functions may be used to determine if two strings
#' are equal, canonically equivalent (this is performed in a much more clever
#' fashion than when testing for equality),
#' or to check whether they appear in
#' a specific lexicographic order.
#'
#'
#' @details
#' All the functions listed here are vectorized over \code{e1} and \code{e2}.
#'
#' \code{stri_cmp_eq} tests whether two corresponding strings
#' consist of exactly the same code points, while \code{stri_cmp_neq} allow
#' to check whether there is any difference between them. These are
#' locale-independent operations: for natural language text processing, 
#' in which the notion of canonical equivalence is more valid, this might
#' not be exactly what you are looking for, see Examples.
#' By the way, note that \pkg{stringi} always silently removes UTF-8
#' BOMs from input strings, so e.g. \code{stri_cmp_eq} does not take
#' BOMs into account while comparing strings.
#'
#' On the other hand, \code{stri_cmp_equiv} tests for
#' canonical equivalence of two strings and is locale-dependent.
#' Additionally, the \pkg{ICU}'s Collator may be tuned up so that
#' e.g. the comparison is case-insensitive.
#' To test whether two strings are not canonically equivalent,
#' call \code{stri_cmp_nequiv}.
#'
#' What is more,  \code{stri_cmp_le} tests whether
#' the elements in the first vector are less than or equal to
#' the corresponding elements in the second vector,
#' \code{stri_cmp_ge} tests whether they are greater or equal,
#' \code{stri_cmp_lt} if less, and \code{stri_cmp_gt} if greater,
#' see also e.g. \code{\link{\%s<\%}}.
#'
#' Finally, \code{stri_compare} is an alias to \code{stri_cmp}. They both
#' perform exactly the same locale-dependent operation.
#' Both functions provide a C library's \code{strcmp()} look-and-feel,
#' see Value for details.
#'
#'
#' For more information on \pkg{ICU}'s Collator and how to tune it up
#' in \pkg{stringi}, refer to \code{\link{stri_opts_collator}}.
#' Please note that different locale settings may lead to different results
#' (see the examples below).
#'
#'
#' @param e1,e2 character vectors or objects coercible to character vectors
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options.
#' @param ... additional settings for \code{opts_collator}
#'
#' @return The \code{stri_cmp} and \code{stri_compare} functions
#' return an integer vector with comparison results of corresponding
#' pairs of elements in \code{e1} and \code{e2}:
#' \code{-1} if \code{e1[...] < e2[...]},
#' \code{0} if they are canonically equivalent, and \code{1} if greater.
#'
#' The other functions return a logical vector that indicates
#' whether a given relation holds between two corresponding elements
#' in \code{e1} and \code{e2}.
#'
#' @examples
#' # in Polish ch < h:
#' stri_cmp_lt("hladny", "chladny", locale="pl_PL")
#'
#' # in Slovak ch > h:
#' stri_cmp_lt("hladny", "chladny", locale="sk_SK")
#'
#' # < or > (depends on locale):
#' stri_cmp("hladny", "chladny")
#'
#' # ignore case differences:
#' stri_cmp_equiv("hladny", "HLADNY", strength=2)
#'
#' # also ignore diacritical differences:
#' stri_cmp_equiv("hladn\u00FD", "hladny", strength=1, locale="sk_SK")
#'
#' # non-Unicode-normalized vs normalized string:
#' stri_cmp_equiv(stri_trans_nfkd("\u0105"), "\u105")
#'
#' # note the difference:
#' stri_cmp_eq(stri_trans_nfkd("\u0105"), "\u105")
#'
#' # ligatures:
#' stri_cmp_equiv("\ufb00", "ff", strength=2)
#'
#' @family locale_sensitive
#' @export
#' @rdname stri_compare
stri_compare <- function(e1, e2, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_cmp_integer, e1, e2, opts_collator)
}


#' @export
#' @rdname stri_compare
stri_cmp <- stri_compare


#' @export
#' @rdname stri_compare
stri_cmp_eq <- function(e1, e2) {
   .Call(C_stri_cmp_codepoints, e1, e2, 0L)
}


#' @export
#' @rdname stri_compare
stri_cmp_neq <- function(e1, e2) {
   .Call(C_stri_cmp_codepoints, e1, e2, 1L)
}


#' @export
#' @rdname stri_compare
stri_cmp_equiv <- function(e1, e2, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_cmp_logical, e1, e2, opts_collator, c(0L, 0L))
}


#' @export
#' @rdname stri_compare
stri_cmp_nequiv <- function(e1, e2, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_cmp_logical, e1, e2, opts_collator, c(0L, 1L))
}

#' @export
#' @rdname stri_compare
stri_cmp_lt <- function(e1, e2, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_cmp_logical, e1, e2, opts_collator, c(-1L, 0L))
}


#' @export
#' @rdname stri_compare
stri_cmp_gt <- function(e1, e2, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_cmp_logical, e1, e2, opts_collator, c(1L, 0L))
}

#' @export
#' @rdname stri_compare
stri_cmp_le <- function(e1, e2, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_cmp_logical, e1, e2, opts_collator, c(1L, 1L))
}


#' @export
#' @rdname stri_compare
stri_cmp_ge <- function(e1, e2, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_cmp_logical, e1, e2, opts_collator, c(-1L, 1L))
}


#' @title
#' Compare Strings with or without Collation
#'
#' @description
#' Relational operators for comparing corresponding strings in
#' two character vectors, with a typical \R look-and-feel.
#'
#' @details
#' These functions call \code{\link{stri_cmp_le}} or its
#' friends, using default collator options.
#' Thus, they are vectorized over \code{e1} and \code{e2}.
#'
#' \code{\%stri==\%} tests for canonical equivalence of strings
#' (see \code{\link{stri_cmp_equiv}}) and is a locale-dependent operation.
#' On the other hand, \code{\%stri===\%} performs a locale-independent,
#' code point-based comparison.
#'
#'
#' @param e1,e2 character vectors or objects coercible to character vectors
#'
#' @return All the functions return a logical vector
#' indicating the result of a pairwise comparison.
#' As usual, the elements of shorter vectors are recycled if necessary.
#'
#'
#' @examples
#' "a" %stri<% "b"
#' c("a", "b", "c") %stri>=% "b"
#'
#' @usage
#' e1 \%s<\% e2
#'
#' @family locale_sensitive
#' @rdname oper_comparison
#' @export
"%s<%" <- function(e1, e2) {
   stri_cmp_lt(e1, e2)
}


#' @usage
#' e1 \%s<=\% e2
#' @rdname oper_comparison
#' @export
"%s<=%" <- function(e1, e2) {
   stri_cmp_le(e1, e2)
}


#' @usage
#' e1 \%s>\% e2
#' @rdname oper_comparison
#' @export
"%s>%" <- function(e1, e2) {
   stri_cmp_gt(e1, e2)
}


#' @usage
#' e1 \%s>=\% e2
#' @rdname oper_comparison
#' @export
"%s>=%" <- function(e1, e2) {
   stri_cmp_ge(e1, e2)
}


#' @usage
#' e1 \%s==\% e2
#' @rdname oper_comparison
#' @export
"%s==%" <- function(e1, e2) {
   stri_cmp_equiv(e1, e2)
}


#' @usage
#' e1 \%s!=\% e2
#' @rdname oper_comparison
#' @export
"%s!=%" <- function(e1, e2) {
   stri_cmp_nequiv(e1, e2)
}


#' @usage
#' e1 \%s===\% e2
#' @rdname oper_comparison
#' @export
"%s===%" <- function(e1, e2) {
   stri_cmp_eq(e1, e2)
}


#' @usage
#' e1 \%s!==\% e2
#' @rdname oper_comparison
#' @export
"%s!==%" <- function(e1, e2) {
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
   stri_cmp_equiv(e1, e2)
}


#' @usage
#' e1 \%stri!=\% e2
#' @rdname oper_comparison
#' @export
"%stri!=%" <- function(e1, e2) {
   stri_cmp_nequiv(e1, e2)
}


#' @usage
#' e1 \%stri===\% e2
#' @rdname oper_comparison
#' @export
"%stri===%" <- function(e1, e2) {
   stri_cmp_eq(e1, e2)
}


#' @usage
#' e1 \%stri!==\% e2
#' @rdname oper_comparison
#' @export
"%stri!==%" <- function(e1, e2) {
   stri_cmp_neq(e1, e2)
}


#' @title
#' Ordering Permutation and Sorting
#'
#'
#' @description
#' \link{stri_order} determines a permutation which rearranges
#' strings into an ascending or descending order.
#' \link{stri_sort} sorts the vector according to a lexicographic order.
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
#' @param na_last single logical value; controls the treatment of \code{NA}s
#'    in \code{str}. If \code{TRUE}, then missing values in \code{str} are put
#'    at the end; if \code{FALSE}, they are put at the beginning;
#'    if \code{NA}, then they are removed from the output.
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options
#' @param ... additional settings for \code{opts_collator}
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
#' stri_sort(c("hladny", "chladny"), locale="pl_PL")
#'
#' stri_sort(c("hladny", "chladny"), locale="sk_SK")
stri_order <- function(str, decreasing=FALSE, na_last=TRUE, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_order_or_sort, str, decreasing, na_last, opts_collator, 1L)
}


#' @export
#' @rdname stri_order
stri_sort <-  function(str, decreasing=FALSE, na_last=NA, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_order_or_sort, str, decreasing, na_last, opts_collator, 2L)
}


#' @title Extract Unique Elements
#'
#' @description
#' This function returns a character vector like \code{str},
#' but with duplicate elements removed.
#'
#' @details
#' As usual in \pkg{stringi}, no attributes are copied.
#' Unlike \code{\link{unique}}, this function
#' tests for canonical equivalence of strings (and not
#' whether the strings are just bytewise equal). Such an operation
#' is locale-dependent. Hence, \code{stri_unique} is significantly
#' slower (but much better suited for natural language processing)
#' than its base R counterpart.
#'
#' See also \code{\link{stri_duplicated}} for indicating non-unique elements.
#'
#' @param str character vector
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options
#' @param ... additional settings for \code{opts_collator}
#'
#' @return Returns a character vector.
#'
#' @examples
#' # normalized and non-Unicode-normalized version of the same code point:
#' stri_unique(c("\u0105", stri_trans_nfkd("\u0105")))
#' unique(c("\u0105", stri_trans_nfkd("\u0105")))
#'
#' stri_unique(c("gro\u00df", "GROSS", "Gro\u00df", "Gross"), strength=1)
#'
#' @family locale_sensitive
#' @export
stri_unique <-  function(str, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_unique, str, opts_collator)
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
#' Unlike \code{\link{duplicated}} and \code{\link{anyDuplicated}},
#' these functions test for canonical equivalence of strings
#' (and not whether the strings are just bytewise equal)
#' Such operations are locale-dependent.
#' Hence, \code{stri_duplicated} and \code{stri_duplicated_any}
#' are significantly slower (but much better suited for natural language
#' processing) than their base R counterpart.
#'
#' See also \code{\link{stri_unique}} for extracting unique elements.
#'
#' @param str character vector
#' @param fromLast single logical value;
#'    indicating whether duplication should be considered from the
#'    reverse side
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}, \code{NULL}
#' for default collation options
#' @param ... additional settings for \code{opts_collator}
#'
#' @return
#' \code{stri_duplicated()} returns a logical vector of the same length
#' as \code{str}. Each of its elements indicates whether a canonically
#' equivalent string was already found in \code{str}.
#'
#' \code{stri_duplicated_any()} returns a single non-negative integer.
#' Value of 0 indicates that all the elements in \code{str} are unique.
#' Otherwise, it gives the index of the first non-unique element.
#'
#' @examples
#' # In the following examples, we have 3 duplicated values,
#' # "a" - 2 times, NA - 1 time
#' stri_duplicated(c("a", "b", "a", NA, "a", NA))
#' stri_duplicated(c("a", "b", "a", NA, "a", NA), fromLast=TRUE)
#' stri_duplicated_any(c("a", "b", "a", NA, "a", NA))
#'
#' # compare the results:
#' stri_duplicated(c("\u0105", stri_trans_nfkd("\u0105")))
#' duplicated(c("\u0105", stri_trans_nfkd("\u0105")))
#'
#' stri_duplicated(c("gro\u00df", "GROSS", "Gro\u00df", "Gross"), strength=1)
#' duplicated(c("gro\u00df", "GROSS", "Gro\u00df", "Gross"))
#'
#' @rdname stri_duplicated
#' @family locale_sensitive
#' @export
stri_duplicated <-  function(str, fromLast=FALSE, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_duplicated, str, fromLast, opts_collator)
}


#' @rdname stri_duplicated
#' @family locale_sensitive
#' @export
stri_duplicated_any <-  function(str, fromLast=FALSE, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_duplicated_any, str, fromLast, opts_collator)
}
