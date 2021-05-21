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
#' Format Strings
#'
#' @description
#' A Unicode-aware replacement for the built-in \code{\link[base]{sprintf}}
#' function. Moreover, \code{stri_printf} prints formatted strings.
#'
#' @details
#' Vectorized over \code{format} and all vectors passed via \code{...}.
#'
#' \code{stri_string_format} is a synonym for \code{stri_sprintf}.
#'
#' Note that \code{stri_printf} treats missing values in \code{...}
#' as \code{"NA"} strings by default.
#'
#' Note that Unicode code points may have various widths when
#' printed on the console and that, by default, the function takes that
#' into account. By changing the state of the \code{use_length}
#' argument, this function act as if each code point was of width 1.
#'
#' For \code{\%d} and \code{\%f} formats, factors are treated as integer
#' vectors (underlying codes) and so are date and time objects, etc.
#'
#' This function is not locale sensitive. For instance, numbers are
#' always formatted in the "POSIX" style, e.g., \code{-123456.789}.
#' Such a feature might be added at a later date, though.
#'
#' All arguments passed via \code{...} are evaluated. If some of them
#' are unused, a warning is generated. Too few arguments result in an error.
#'
#'
#' @param format character vector of format strings
#' @param ... vectors (coercible to integer, real, or character)
#' @param na_string single string to represent missing values;
#'     if \code{NA}, missing values in \code{...}
#'     result in the corresponding outputs be missing too;
#'     use \code{"NA"} for compatibility with base R
#' @param inf_string single string to represent the (unsigned) infinity
#' @param na_string single string to represent the not-a-number
#' @param use_length single logical value; should the number of code
#' points be used when applying modifiers such as \code{\%20s}
#' instead of the total code point width (see \code{\link{stri_width}})?
#' @param file see \code{\link[base]{cat}}
#' @param sep see \code{\link[base]{cat}}
#' @param append see \code{\link[base]{cat}}
#'
#' @return
#' \code{stri_printf} is used for its side effect, which is printing
#' text on the standard output or other connection/file. Hence, it returns
#' \code{invisible(NULL)}.
#'
#' The other functions return a character vector.
#'
#'
#' @examples
#' #...
#' #stri_printf("%4s=%.3f", c("e", "e\u00b2", "\u03c0", "\u03c0\u00b2"),
#' #    c(exp(1), exp(2), pi, pi^2))
#'
#' # vectorization wrt all arguments:
#' #p <- runif(10)
#' #stri_sprintf(ifelse(p > 0.5, "P(Y=1)=%1$.2f", "P(Y=0)=%2$.2f"), p, 1-p)
#'
#' # using a "preformatted" logical vector:
#' #x <- c(TRUE, FALSE, FALSE, NA, TRUE, FALSE)
#' #stri_sprintf("%s) %s", letters[seq_along(x)], c("\u2718", "\u2713")[x+1])
#'
#'
#' @rdname stri_sprintf
#' @export
stri_sprintf <- function(
    format, ...,
    na_string=NA_character_,
    inf_string="Inf",
    nan_string="NaN",
    use_length=FALSE
) {
    # force eval of ... here
    .Call(C_stri_sprintf, format, list(...),
        na_string, inf_string, nan_string, use_length)
}


#' @rdname stri_sprintf
#' @export
stri_string_format <- stri_sprintf


#' @export
stri_printf <- function(
    format, ...,
    file="",
    sep="\n",
    append=FALSE,
    na_string="NA",
    inf_string="Inf",
    nan_string="NaN",
    use_length=FALSE
) {
    # force eval of ... here
    str <- .Call(C_stri_sprintf, format, list(...),
        na_string, inf_string, nan_string, use_length)
    cat(str, file=file, sep=sep, append=append)
}

### TODO: update


#' @title
#' C-Style Formatting with sprintf as a Binary Operator TODO: call stri_sprintf
#'
#' @description
#' Provides access to base R's \code{\link[base]{sprintf}} in form of a binary
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
#' Note that \code{\link[base]{sprintf}} takes field width in bytes,
#' not Unicode code points. See Examples for a workaround.
#'
#'
#' @param e1 format strings, see \code{\link[base]{sprintf}} for syntax
#' @param e2 a list of atomic vectors to be passed to \code{\link[base]{sprintf}}
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
