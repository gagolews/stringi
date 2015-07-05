## This file is part of the 'stringi' package for R.
## Copyright (C) 2013-2015, Marek Gagolewski and Bartek Tartanus
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
#' @param str a character vector
#' @param decreasing a single logical value; should the sort order
#'    be nondecreasing (\code{FALSE}, default)
#'    or nonincreasing (\code{TRUE})?
#' @param na_last a single logical value; controls the treatment of \code{NA}s
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
#' @references
#' \emph{Collation} - ICU User Guide,
#' \url{http://userguide.icu-project.org/collation}
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
   .Call(C_stri_order, str, decreasing, na_last, opts_collator)
}


#' @export
#' @rdname stri_order
stri_sort <-  function(str, decreasing=FALSE, na_last=NA, ..., opts_collator=NULL) {
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_sort, str, decreasing, na_last, opts_collator)
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
#' @param str a character vector
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
#' @references
#' \emph{Collation} - ICU User Guide,
#' \url{http://userguide.icu-project.org/collation}
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
#' @param str a character vector
#' @param fromLast a single logical value;
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
#' @references
#' \emph{Collation} - ICU User Guide,
#' \url{http://userguide.icu-project.org/collation}
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
