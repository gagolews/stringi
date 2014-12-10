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
#' Split a String By Pattern Matches
#'
#' @description
#' These functions split each element of \code{str} into substrings.
#' \code{pattern} indicates delimiters that separate the input into tokens.
#' The input data between the matches become the fields themselves.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n}, and \code{omit_empty}.
#'
#' If \code{n} is negative, then all pieces are extracted.
#' Otherwise, if \code{tokens_only} is \code{FALSE} (this is the default,
#' for compatibility with the \pkg{stringr} package), then \code{n-1}
#' tokes are extracted (if possible) and the \code{n}-th string
#' gives the remainder (see Examples).
#' On the other hand, if \code{tokens_only} is \code{TRUE},
#' then only full tokens (up to \code{n} pieces) are extracted.
#'
#' \code{omit_empty} is applied during the split process: if it is set to
#' \code{TRUE}, then tokens of zero length are ignored. Thus, empty strings
#' will never appear in the resulting vector. On the other hand, if
#' \code{omit_empty} is \code{NA}, then empty tokes are substituted with
#' missing strings.
#'
#' Empty search patterns are not supported. If you would like to split a
#' string into individual characters, use e.g.
#' \code{\link{stri_split_boundaries}(str, type="character")} for THE Unicode way.
#'
#' \code{stri_split} is a convenience function. It calls either
#' \code{stri_split_regex}, \code{stri_split_fixed}, \code{stri_split_coll},
#' or \code{stri_split_charclass}, depending on the argument used.
#' Unless you are a very lazy person, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector with strings to search in
#' @param pattern,regex,fixed,coll,charclass character vector defining search patterns;
#' for more details refer to \link{stringi-search}
#' @param n integer vector, maximal number of strings to return,
#' and, at the same time, maximal number of text boundaries to look for
#' @param omit_empty logical vector; determines whether empty
#' tokens should be removed from the result (\code{TRUE} or \code{FALSE})
#' or replaced with \code{NA}s (\code{NA})
#' @param tokens_only single logical value;
#' may affect the result if \code{n} is positive, see Details
#' @param simplify single logical value;
#' if \code{TRUE} or \code{NA}, then a character matrix is returned;
#' otherwise (the default), a list of character vectors is given, see Value
#' @param opts_collator,opts_fixed,opts_regex a named list used to tune up
#' a search engine's settings; see
#' \code{\link{stri_opts_collator}}, \code{\link{stri_opts_fixed}},
#' and \code{\link{stri_opts_regex}}, respectively; \code{NULL}
#' for default settings;
#' @param ... supplementary arguments passed to the underlying functions,
#' including additional settings for \code{opts_collator}, \code{opts_regex},
#' \code{opts_fixed}, and so on
#'
#' @return If \code{simplify=FALSE} (the default),
#' then the functions return a list of character vectors.
#'
#' Otherwise, \code{\link{stri_list2matrix}} with \code{byrow=TRUE}
#' and \code{n_min=n} arguments is called on the resulting object.
#' In such a case, a character matrix with an appropriate number of rows
#' (according to the length of \code{str}, \code{pattern}, etc.)
#' is returned. Note that \code{\link{stri_list2matrix}}'s \code{fill} argument
#' is set to an empty string and \code{NA}, for \code{simplify} equal to
#' \code{TRUE} and \code{NA}, respectively.
#'
#' @examples
#' stri_split_fixed("a_b_c_d", "_")
#' stri_split_fixed("a_b_c__d", "_")
#' stri_split_fixed("a_b_c__d", "_", omit_empty=TRUE)
#' stri_split_fixed("a_b_c__d", "_", n=2, tokens_only=FALSE) # "a" & remainder
#' stri_split_fixed("a_b_c__d", "_", n=2, tokens_only=TRUE) # "a" & "b" only
#' stri_split_fixed("a_b_c__d", "_", n=4, omit_empty=TRUE, tokens_only=TRUE)
#' stri_split_fixed("a_b_c__d", "_", n=4, omit_empty=FALSE, tokens_only=TRUE)
#' stri_split_fixed("a_b_c__d", "_", omit_empty=NA)
#' stri_split_fixed(c("ab_c", "d_ef_g", "h", ""), "_", n=1, tokens_only=TRUE, omit_empty=TRUE)
#' stri_split_fixed(c("ab_c", "d_ef_g", "h", ""), "_", n=2, tokens_only=TRUE, omit_empty=TRUE)
#' stri_split_fixed(c("ab_c", "d_ef_g", "h", ""), "_", n=3, tokens_only=TRUE, omit_empty=TRUE)
#'
#' stri_list2matrix(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=TRUE))
#' stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=FALSE, simplify=TRUE)
#' stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=NA, simplify=TRUE)
#' stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=TRUE, simplify=TRUE)
#' stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=NA, simplify=NA)
#'
#' stri_split_regex(c("ab,c", "d,ef  ,  g", ",  h", ""),
#'    "\\p{WHITE_SPACE}*,\\p{WHITE_SPACE}*", omit_empty=NA, simplify=TRUE)
#'
#' stri_split_charclass("Lorem ipsum dolor sit amet", "\\p{WHITE_SPACE}")
#' stri_split_charclass(" Lorem  ipsum dolor", "\\p{WHITE_SPACE}", n=3,
#'    omit_empty=c(FALSE, TRUE))
#'
#' stri_split_regex("Lorem ipsum dolor sit amet",
#'    "\\p{Z}+") # see also stri_split_charclass
#'
#' @export
#' @rdname stri_split
#' @family search_split
#' @export
stri_split <- function(str, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_split_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_split_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_split_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_split_charclass(str, charclass, ...)
}


#' @export
#' @rdname stri_split
stri_split_fixed <- function(str, pattern, n=-1L,
      omit_empty=FALSE, tokens_only=FALSE, simplify=FALSE, ..., opts_fixed=NULL) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   # tokens_only defaults to FALSE for compatibility with the stringr package
   if (!missing(...))
       opts_fixed <- do.call(stri_opts_fixed, as.list(c(opts_fixed, ...)))
   .Call(C_stri_split_fixed, str, pattern,
      n, omit_empty, tokens_only, simplify, opts_fixed)
}


#' @export
#' @rdname stri_split
stri_split_regex <- function(str, pattern, n=-1L, omit_empty=FALSE,
      tokens_only=FALSE, simplify=FALSE, ..., opts_regex=NULL)  {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   # tokens_only defaults to FALSE for compatibility with the stringr package
   if (!missing(...))
       opts_regex <- do.call(stri_opts_regex, as.list(c(opts_regex, ...)))
   .Call(C_stri_split_regex, str, pattern,
      n, omit_empty, tokens_only, simplify, opts_regex)
}


#' @export
#' @rdname stri_split
stri_split_coll <- function(str, pattern, n=-1L, omit_empty=FALSE,
      tokens_only=FALSE, simplify=FALSE, ..., opts_collator=NULL) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   # tokens_only defaults to FALSE for compatibility with the stringr package
   if (!missing(...))
       opts_collator <- do.call(stri_opts_collator, as.list(c(opts_collator, ...)))
   .Call(C_stri_split_coll, str, pattern,
      n, omit_empty, tokens_only, simplify, opts_collator)
}


#' @export
#' @rdname stri_split
stri_split_charclass <- function(str, pattern, n=-1L,
                  omit_empty=FALSE, tokens_only=FALSE, simplify=FALSE) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   # tokens_only defaults to FALSE for compatibility with the stringr package
   .Call(C_stri_split_charclass, str, pattern,
      n, omit_empty, tokens_only, simplify)
}
