# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2021, Marek Gagolewski <https://www.gagolewski.com>
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
#' C-Style Formatting with sprintf as a Binary Operator
#'
#' @description
#' Provides access to base R's \code{\link{sprintf}} in form of a binary
#' operator in a way similar to Python's \code{\%} overloaded for strings.
#'
#'
#'
#' @details
#' Vectorized over \code{e1} and \code{e2}.
#'
#' \code{e1 \%s$\% atomic_vector} is equivalent to
#' \code{e1 \%s$\% list(atomic_vector)}.
#'
#' Note that \code{\link{sprintf}} takes field width in bytes,
#' not Unicode code points. See Examples for a workaround.
#'
#'
#' @param e1 format strings, see \code{\link{sprintf}} for syntax
#' @param e2 a list of atomic vectors to be passed to \code{\link{sprintf}}
#' or a single atomic vector
#'
#' @return
#' Returns a character vector
#'
#'
#' @examples
#' "value='%d'" %s$% 3
#' "value='%d'" %s$% 1:3
#' "%s='%d'" %s$% list("value", 3)
#' "%s='%d'" %s$% list("value", 1:3)
#' "%s='%d'" %s$% list(c("a", "b", "c"), 1)
#' "%s='%d'" %s$% list(c("a", "b", "c"), 1:3)
#'
#' # sprintf field width:
#' x <- c("abcd", "\u00DF\u00B5\U0001F970", "abcdef")
#' cat(sprintf("%s%6s%s", "-", x, "-"), sep="\n")
#' cat(sprintf("%s%s%s", "-", stringi::stri_pad(x, 6), "-"), sep="\n")
#'
#' @rdname operator_dollar
#' @aliases operator_dollar oper_dollar
#'
#' @usage
#' e1 \%s$\% e2
#'
#' @export
`%s$%` <- function(e1, e2)
{
    if (!is.list(e2))
        e2 <- list(e2)

    # this is stringi, assure UTF-8 output and proper NA handling!
    e1 <- stri_enc_toutf8(as.character(e1))
    if (length(e1) == 0) return(character(0))

    for (i in seq_along(e2)) {
        stopifnot(is.atomic(e2[[i]]))  # factor is atomic
        if (length(e2[[i]]) == 0) return(character(0))
        if (is.character(e2[[i]]) || is.factor(e2[[i]])) {
            e2[[i]] <- stri_enc_toutf8(e2[[i]])
        }
    }

    ret <- stri_enc_toutf8(do.call(sprintf, as.list(c(list(e1), e2))))
    # for the time being, let stri_paste determine NAs
    # (it might be too greedy if there are unused strings)
    which_na <- do.call(stri_paste, e2)
    ret[is.na(which_na)] <- NA_character_

    ret[is.na(e1)] <- NA_character_

    ret
}


#' @usage
#' e1 \%stri$\% e2
#' @rdname operator_dollar
#' @export
`%stri$%` <- `%s$%`
