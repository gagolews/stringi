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
#' Word Wrap Text to Format Paragraphs
#'
#' @description
#' This function breaks text paragraphs into lines,
#' of total width (if it is possible) at most given \code{width}.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' If \code{whitespace_only} is \code{FALSE},
#' then \pkg{ICU}'s line-\code{BreakIterator} is used to determine
#' text boundaries where a line break is possible.
#' This is a locale-dependent operation.
#' Otherwise, the breaks are only at white-spaces.
#'
#' Note that Unicode code points may have various widths when
#' printed on the console and that this function, by default, takes that
#' into account. By changing the state of the \code{use_length}
#' argument, this function starts to act as if each code point
#' was of width 1.
#'
#' If \code{normalize} is \code{FALSE},
#' then multiple white spaces between the word boundaries are
#' preserved within each wrapped line.
#' In such a case, none of the strings can contain \code{\\r}, \code{\\n},
#' or other new line characters, otherwise you will get an error.
#' You should split the input text into lines
#' or, for example, substitute line breaks with spaces
#' before applying this function.
#'
#' If \code{normalize} is \code{TRUE}, then
#' all consecutive white space (ASCII space, horizontal TAB, CR, LF)
#' sequences are replaced with single ASCII spaces
#' before actual string wrapping. Moreover, \code{\link{stri_split_lines}}
#' and \code{\link{stri_trans_nfc}} is called on the input character vector.
#' This is for compatibility with \code{\link{strwrap}}.
#'
#' The greedy algorithm (for \code{cost_exponent} being non-positive)
#' provides a very simple way for word wrapping.
#' It always puts as many words in each line as possible.
#' This method -- contrary to the dynamic algorithm -- does not minimize
#' the number of space left at the end of every line.
#' The dynamic algorithm (a.k.a. Knuth's word wrapping algorithm)
#' is more complex, but it returns text wrapped
#' in a more aesthetic way. This method minimizes the squared
#' (by default, see \code{cost_exponent}) number of spaces  (raggedness)
#' at the end of each line, so the text is mode arranged evenly.
#' Note that the cost of printing the last line is always zero.
#'
#' @param str character vector of strings to reformat
#' @param width single integer giving the suggested
#'        maximal total width/number of code points per line
#' @param cost_exponent single numeric value, values not greater than zero
#'        will select a greedy word-wrapping algorithm; otherwise
#'        this value denotes the exponent in the cost function
#'        of a (more aesthetic) dynamic programming-based algorithm
#'        (values in [2, 3] are recommended)
#' @param simplify single logical value, see Value
#' @param normalize single logical value, see Details
#' @param normalise alias of \code{normalize}
#' @param indent single non-negative integer; gives the indentation of the
#'  first line in each paragraph
#' @param exdent single non-negative integer; specifies the indentation
#' of subsequent lines in paragraphs
#' @param prefix,initial single strings; \code{prefix} is used as prefix for each
#' line except the first, for which \code{initial} is utilized
#' @param whitespace_only single logical value; allow breaks only at white-spaces?
#' if \code{FALSE}, \pkg{ICU}'s line break iterator is used to split text
#' into words, which is suitable for natural language processing
#' @param locale \code{NULL} or \code{''} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}
#' @param use_length single logical value; should the number of code
#' points be used instead of the total code point width (see \code{\link{stri_width}})?
#'
#' @return
#' If \code{simplify} is \code{TRUE}, then a character vector is returned.
#' Otherwise, you will get a list of \code{length(str)} character vectors.
#'
#' @rdname stri_wrap
#' @family locale_sensitive
#' @family text_boundaries
#' @examples
#' s <- stri_paste(
#'    'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin ',
#'    'nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel ',
#'    'lorem. Etiam pellentesque aliquet tellus.')
#' cat(stri_wrap(s, 20, 0.0), sep='\n') # greedy
#' cat(stri_wrap(s, 20, 2.0), sep='\n') # dynamic
#' cat(stri_pad(stri_wrap(s), side='both'), sep='\n')
#'
#' @references
#' D.E. Knuth, M.F. Plass,
#' Breaking paragraphs into lines, \emph{Software: Practice and Experience} 11(11),
#' 1981, pp. 1119--1184.
#'
#' @export
stri_wrap <- function(str, width = floor(0.9 * getOption("width")),
    cost_exponent = 2,
    simplify = TRUE, normalize = TRUE, normalise = normalize,
    indent = 0, exdent = 0, prefix = "", initial = prefix,
    whitespace_only = FALSE, use_length = FALSE, locale = NULL)
{
    simplify <- as.logical(simplify)

    if (!missing(normalise))
        normalize <- normalise
    normalize <- as.logical(normalize)
    if (normalize) {
        # this will give an informative warning or error if sth is wrong
        str <- sapply(stri_split_lines(str), function(s) stri_flatten(s, collapse = " "))
        str <- stri_trim(stri_replace_all_charclass(str, "[\\u0020\\r\\n\\t]", " ",
            merge = TRUE))
        str <- stri_trans_nfc(str)
    }

    ret <- .Call(C_stri_wrap, str, width, cost_exponent, indent, exdent, prefix,
        initial, whitespace_only, use_length, locale)

    if (simplify) {
        # this will give an informative warning or error if sth is wrong
        as.character(unlist(ret))
    } else ret
}
