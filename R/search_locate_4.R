# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2024, Marek Gagolewski <https://www.gagolewski.com/>
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


#' @title Locate Pattern Occurrences
#'
#' @description
#' These functions find the indexes (positions) where
#' there is a match to some pattern.
#' The functions \code{stri_locate_all_*} locate all the matches.
#' \code{stri_locate_first_*} and \code{stri_locate_last_*}
#' give the first and the last matches, respectively.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern} (with recycling
#' of the elements in the shorter vector if necessary). This allows to,
#' for instance, search for one pattern in each string,
#' search for each pattern in one string,
#' and search for the i-th pattern within the i-th string.
#'
#' The matches may be extracted by calling
#' \code{\link{stri_sub}} or \code{\link{stri_sub_all}}.
#' Alternatively, you may call \code{\link{stri_extract}} directly.
#'
#' \code{stri_locate}, \code{stri_locate_all}, \code{stri_locate_first},
#' and \code{stri_locate_last} are convenience functions.
#' They just call \code{stri_locate_*_*}, depending on the arguments used.
#'
#'
#'
#' @param str character vector; strings to search in
#'
#' @param pattern,regex,fixed,coll,charclass character vector;
#'     search patterns; for more details refer to \link{stringi-search}
#'
#' @param opts_collator,opts_fixed,opts_regex named list used to tune up
#'     the selected search engine's settings; see
#'     \code{\link{stri_opts_collator}}, \code{\link{stri_opts_fixed}},
#'     and \code{\link{stri_opts_regex}}, respectively; \code{NULL}
#'     for the defaults
#'
#' @param merge single logical value;
#'     indicates whether consecutive sequences of indexes in the resulting
#'     matrix should be merged; \code{stri_locate_all_charclass} only
#'
#' @param omit_no_match single logical value; if \code{TRUE},
#'     a no-match will be indicated by a matrix with 0 rows
#'     \code{stri_locate_all_*} only
#'
#' @param get_length single logical value; if \code{FALSE} (default),
#'     generate \emph{from-to} matrices; otherwise, output
#'     \emph{from-length} ones
#'
#' @param capture_groups single logical value;
#'     whether positions of matches to parenthesized subexpressions
#'     should be returned too (as \code{capture_groups} attribute);
#'     \code{stri_locate_*_regex} only
#'
#' @param mode single string;
#'     one of: \code{'first'} (the default), \code{'all'}, \code{'last'}
#'
#' @param ... supplementary arguments passed to the underlying functions,
#'     including additional settings for \code{opts_collator},
#'     \code{opts_regex}, \code{opts_fixed}, and so on
#'
#'
#' @return
#' For \code{stri_locate_all_*},
#' a list of integer matrices is returned. Each list element
#' represents the results of a separate search scenario.
#' The first column gives the start positions
#' of the matches, and the second column gives the end positions.
#' Moreover, two \code{NA}s in a row denote \code{NA} arguments
#' or a no-match (the latter only if \code{omit_no_match} is \code{FALSE}).
#'
#' \code{stri_locate_first_*} and \code{stri_locate_last_*}
#' return an integer matrix with
#' two columns, giving the start and end positions of the first
#' or the last matches, respectively, and two \code{NA}s if and
#' only if they are not found.
#'
#' For \code{stri_locate_*_regex}, if the match is of zero length,
#' \code{end} will be one character less than \code{start}.
#' Note that \code{stri_locate_last_regex} searches from start to end,
#' but skips overlapping matches, see the example below.
#'
#' Setting \code{get_length=TRUE} results in the 2nd column representing
#' the length of the match instead of the end position. In this case,
#' negative length denotes a no-match.
#'
#' If \code{capture_groups=TRUE}, then the outputs are equipped with the
#' \code{capture_groups} attribute, which is a list of matrices
#' giving the start-end positions of matches to parenthesized subexpressions.
#' Similarly to \code{stri_match_regex}, capture group names are extracted
#' unless looking for first/last occurrences of many different patterns.
#'
#' @examples
#' stri_locate_all('stringi', fixed='i')
#'
#' stri_locate_first_coll('hladn\u00FD', 'HLADNY', strength=1, locale='sk_SK')
#'
#' stri_locate_all_regex(
#'     c('breakfast=eggs;lunch=pizza', 'breakfast=spam', 'no food here'),
#'    '(?<when>\\w+)=(?<what>\\w+)',
#'    capture_groups=TRUE
#' )  # named capture groups
#'
#' stri_locate_all_fixed("abababa", "ABA", case_insensitive=TRUE, overlap=TRUE)
#' stri_locate_first_fixed("ababa", "aba")
#' stri_locate_last_fixed("ababa", "aba")  # starts from end
#' stri_locate_last_regex("ababa", "aba")  # no overlaps, from left to right
#'
#' x <- c("yes yes", "no", NA)
#' stri_locate_all_fixed(x, "yes")
#' stri_locate_all_fixed(x, "yes", omit_no_match=TRUE)
#' stri_locate_all_fixed(x, "yes", get_length=TRUE)
#' stri_locate_all_fixed(x, "yes", get_length=TRUE, omit_no_match=TRUE)
#' stri_locate_first_fixed(x, "yes")
#' stri_locate_first_fixed(x, "yes", get_length=TRUE)
#'
#' # Use regex positive-lookahead to locate overlapping pattern matches:
#' stri_locate_all_regex('ACAGAGACTTTAGATAGAGAAGA', '(?=AGA)')
#' # note that start > end here (match of length zero)
#'
#'
#' @family search_locate
#' @family indexing
#'
#' @export
#' @rdname stri_locate
stri_locate_all <- function(str, ..., regex, fixed, coll, charclass)
{
    providedarg <- c(
        regex=!missing(regex),
        fixed=!missing(fixed),
        coll=!missing(coll),
        charclass=!missing(charclass))

    if (sum(providedarg) != 1)
        stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

    if (providedarg["regex"])
        stri_locate_all_regex(str, regex, ...)
    else if (providedarg["fixed"])
        stri_locate_all_fixed(str, fixed, ...)
    else if (providedarg["coll"])
        stri_locate_all_coll(str, coll, ...)
    else if (providedarg["charclass"])
        stri_locate_all_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_locate
stri_locate_first <- function(str, ..., regex, fixed, coll, charclass)
{
    providedarg <- c(
        regex=!missing(regex),
        fixed=!missing(fixed),
        coll=!missing(coll),
        charclass=!missing(charclass))

    if (sum(providedarg) != 1)
        stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

    if (providedarg["regex"])
        stri_locate_first_regex(str, regex, ...)
    else if (providedarg["fixed"])
        stri_locate_first_fixed(str, fixed, ...)
    else if (providedarg["coll"])
        stri_locate_first_coll(str, coll, ...)
    else if (providedarg["charclass"])
        stri_locate_first_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_locate
stri_locate_last <- function(str, ..., regex, fixed, coll, charclass)
{
    providedarg <- c(
        regex=!missing(regex),
        fixed=!missing(fixed),
        coll=!missing(coll),
        charclass=!missing(charclass))

    if (sum(providedarg) != 1)
        stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

    if (providedarg["regex"])
        stri_locate_last_regex(str, regex, ...)
    else if (providedarg["fixed"])
        stri_locate_last_fixed(str, fixed, ...)
    else if (providedarg["coll"])
        stri_locate_last_coll(str, coll, ...)
    else if (providedarg["charclass"])
        stri_locate_last_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_locate
stri_locate <- function(
    str, ..., regex, fixed, coll, charclass,
    mode=c("first", "all", "last")
) {
    # `first` is default for compatibility with stringr
    mode <- match.arg(mode)  # this is slow

    switch(mode,
        first=stri_locate_first(str, ..., regex=regex, fixed=fixed,
            coll=coll, charclass=charclass),
        last=stri_locate_last(str, ..., regex=regex,
            fixed=fixed, coll=coll, charclass=charclass),
        all=stri_locate_all(str, ..., regex=regex, fixed=fixed,
            coll=coll, charclass=charclass))
}


#' @export
#' @rdname stri_locate
stri_locate_all_charclass <- function(
    str, pattern, merge=TRUE, omit_no_match=FALSE, get_length=FALSE
) {
    .Call(C_stri_locate_all_charclass, str, pattern, merge, omit_no_match, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_first_charclass <- function(str, pattern, get_length=FALSE)
{
    .Call(C_stri_locate_first_charclass, str, pattern, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_last_charclass <- function(str, pattern, get_length=FALSE)
{
    .Call(C_stri_locate_last_charclass, str, pattern, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_all_coll <- function(
    str, pattern,
    omit_no_match=FALSE, get_length=FALSE, ..., opts_collator=NULL
) {
    if (!missing(...))
        opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))

    .Call(C_stri_locate_all_coll, str, pattern, omit_no_match, opts_collator, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_first_coll <- function(
    str, pattern, get_length=FALSE, ..., opts_collator=NULL
) {
    if (!missing(...))
        opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))

    .Call(C_stri_locate_first_coll, str, pattern, opts_collator, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_last_coll <- function(
    str, pattern, get_length=FALSE, ..., opts_collator=NULL
) {
    if (!missing(...))
        opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))

    .Call(C_stri_locate_last_coll, str, pattern, opts_collator, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_all_regex <- function(
    str, pattern,
    omit_no_match=FALSE,
    capture_groups=FALSE,
    get_length=FALSE,
    ..., opts_regex=NULL
) {
    if (!missing(...))
        opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))

    .Call(C_stri_locate_all_regex, str, pattern, omit_no_match, opts_regex, capture_groups, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_first_regex <- function(
    str, pattern, capture_groups=FALSE, get_length=FALSE, ..., opts_regex=NULL
) {
    if (!missing(...))
        opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))

    .Call(C_stri_locate_first_regex, str, pattern, opts_regex, capture_groups, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_last_regex <- function(
    str, pattern, capture_groups=FALSE, get_length=FALSE, ..., opts_regex=NULL
) {
    if (!missing(...))
        opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))

    .Call(C_stri_locate_last_regex, str, pattern, opts_regex, capture_groups, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_all_fixed <- function(
    str, pattern, omit_no_match=FALSE, get_length=FALSE, ..., opts_fixed=NULL
) {
    if (!missing(...))
        opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))

    .Call(C_stri_locate_all_fixed, str, pattern, omit_no_match, opts_fixed, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_first_fixed <- function(
    str, pattern, get_length=FALSE, ..., opts_fixed=NULL
) {
    if (!missing(...))
        opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))

    .Call(C_stri_locate_first_fixed, str, pattern, opts_fixed, get_length)
}


#' @export
#' @rdname stri_locate
stri_locate_last_fixed <- function(
    str, pattern, get_length=FALSE, ..., opts_fixed=NULL
) {
    if (!missing(...))
        opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))

    .Call(C_stri_locate_last_fixed, str, pattern, opts_fixed, get_length)
}
