# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
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
#' \code{stri_sprintf} (synonym: \code{stri_string_format})
#' is a Unicode-aware replacement for and enhancement of
#' the built-in \code{\link[base]{sprintf}} function.
#' Moreover, \code{stri_printf} prints formatted strings.
#'
#' @details
#' Vectorized over \code{format} and all vectors passed via \code{...}.
#'
#' Unicode code points may have various widths when
#' printed on the console (compare \code{\link{stri_width}}).
#' These functions, by default (see the \code{use_length} argument), take this
#' into account.
#'
#' These functions are not locale sensitive. For instance, numbers are
#' always formatted in the "POSIX" style, e.g., \code{-123456.789}
#' (no thousands separator, dot as a fractional separator).
#' Such a feature might be added at a later date, though.
#'
#' All arguments passed via \code{...} are evaluated. If some of them
#' are unused, a warning is generated. Too few arguments result in an error.
#'
#' Note that \code{stri_printf} treats missing values in \code{...}
#' as \code{"NA"} strings by default.
#'
#' All format specifiers supported \code{\link[base]{sprintf}} are
#' also available here. For the formatting of integers and floating-point
#' values, currently the system \code{std::snprintf()} is called, but
#' this may change in the future. Format specifiers are normalized
#' and necessary sanity checks are performed.
#'
#' Supported conversion specifiers: \code{dioxX} (integers)
#' \code{feEgGaA} (floats) and \code{s} (character strings).
#' Supported flags: \code{-} (left-align),
#' \code{+} (force output sign or blank when \code{NaN} or \code{NA}; numeric only),
#' \code{<space>} (output minus or space for a sign; numeric only)
#' \code{0} (pad with 0s; numeric only),
#' \code{#} (alternative output of some numerics).
#'
#'
#' @param format character vector of format strings
#' @param ... vectors (coercible to integer, real, or character)
#' @param na_string single string to represent missing values;
#'     if \code{NA}, missing values in \code{...}
#'     result in the corresponding outputs be missing too;
#'     use \code{"NA"} for compatibility with base R
#' @param inf_string single string to represent the (unsigned) infinity (\code{NA} allowed)
#' @param nan_string single string to represent the not-a-number (\code{NA} allowed)
#' @param use_length single logical value; should the number of code
#' points be used when applying modifiers such as \code{\%20s}
#' instead of the total code point width?
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
#' @references
#' \code{printf} in \code{glibc},
#' \url{https://man.archlinux.org/man/printf.3}
#'
#' \code{printf} format strings -- Wikipedia,
#' \url{https://en.wikipedia.org/wiki/Printf_format_string}
#'
#' @examples
#' stri_printf("%4s=%.3f", c("e", "e\u00b2", "\u03c0", "\u03c0\u00b2"),
#'     c(exp(1), exp(2), pi, pi^2))
#'
#' x <- c(
#'   "xxabcd",
#'   "xx\u0105\u0106\u0107\u0108",
#'   stri_paste(
#'     "\u200b\u200b\u200b\u200b",
#'     "\U0001F3F4\U000E0067\U000E0062\U000E0073\U000E0063\U000E0074\U000E007F",
#'     "abcd"
#'   ))
#' stri_printf("[%10s]", x)  # minimum width = 10
#' stri_printf("[%-10.3s]", x)  # output of max width = 3, but pad to width of 10
#' stri_printf("[%10s]", x, use_length=TRUE)  # minimum number of Unicode code points = 10
#'
#' # vectorization wrt all arguments:
#' p <- runif(10)
#' stri_sprintf(ifelse(p > 0.5, "P(Y=1)=%1$.2f", "P(Y=0)=%2$.2f"), p, 1-p)
#'
#' # using a "preformatted" logical vector:
#' x <- c(TRUE, FALSE, FALSE, NA, TRUE, FALSE)
#' stri_sprintf("%s) %s", letters[seq_along(x)], c("\u2718", "\u2713")[x+1])
#'
#' # custom NA/Inf/NaN strings:
#' stri_printf("%+10.3f", c(-Inf, -0, 0, Inf, NaN, NA_real_),
#'     na_string="<NA>", nan_string="\U0001F4A9", inf_string="\u221E")
#'
#' stri_sprintf("UNIX time %1$f is %1$s.", Sys.time())
#'
#' # the following do not work in sprintf()
#' stri_sprintf("%1$#- *2$.*3$f", 1.23456, 10, 3)  # two asterisks
#' stri_sprintf(c("%s", "%f"), pi)  # re-coercion needed
#' stri_sprintf("%1$s is %1$f UNIX time.", Sys.time())  # re-coercion needed
#' stri_sprintf(c("%d", "%s"), factor(11:12))  # re-coercion needed
#' stri_sprintf(c("%s", "%d"), factor(11:12))  # re-coercion needed
#'
#' @rdname stri_sprintf
#' @family length
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


#' @rdname stri_sprintf
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


#' @title
#' C-Style Formatting with \code{\link{stri_sprintf}} as a Binary Operator
#'
#' @description
#' Provides access to \code{\link{stri_sprintf}} in form of a binary
#' operator in a way similar to Python's \code{\%} overloaded for strings.
#'
#' Missing values and empty vectors are propagated as usual.
#'
#' @details
#' Vectorized over \code{e1} and \code{e2}.
#'
#' \code{e1 \%s$\% atomic_vector} is equivalent to
#' \code{e1 \%s$\% list(atomic_vector)}.
#'
#'
#' @param e1 format strings, see \code{\link{stri_sprintf}} for syntax
#' @param e2 a list of atomic vectors to be passed to \code{\link{stri_sprintf}}
#' or a single atomic vector
#'
#' @return
#' Returns a character vector.
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
#' x <- c("abcd", "\u00DF\u00B5\U0001F970", "abcdef")
#' cat("[%6s]" %s$% x, sep="\n")  # width used, not the number of bytes
#'
#' @rdname operator_dollar
#' @aliases operator_dollar oper_dollar
#' @family length
#'
#' @usage
#' e1 \%s$\% e2
#'
#' @export
`%s$%` <- function(e1, e2)
{
    if (!is.list(e2))
        e2 <- list(e2)

    na_string <- NA_character_
    .Call(C_stri_sprintf, e1, e2, na_string, "Inf", "NaN", FALSE)

#  old version: based on base::sprintf
#     # this is stringi, assure UTF-8 output and proper NA handling!
#     e1 <- stri_enc_toutf8(as.character(e1))
#     if (length(e1) == 0) return(character(0))
#
#     for (i in seq_along(e2)) {
#         stopifnot(is.atomic(e2[[i]]))  # factor is atomic
#         if (length(e2[[i]]) == 0) return(character(0))
#         if (is.character(e2[[i]]) || is.factor(e2[[i]])) {
#             e2[[i]] <- stri_enc_toutf8(e2[[i]])
#         }
#     }
#
#     ret <- stri_enc_toutf8(do.call(sprintf, as.list(c(list(e1), e2))))
#     # for the time being, let stri_paste determine NAs
#     # (it might be too greedy if there are unused strings)
#     which_na <- do.call(stri_paste, e2)
#     ret[is.na(which_na)] <- NA_character_
#
#     ret[is.na(e1)] <- NA_character_
#
#     ret
}


#' @usage
#' e1 \%stri$\% e2
#' @rdname operator_dollar
#' @export
`%stri$%` <- `%s$%`
