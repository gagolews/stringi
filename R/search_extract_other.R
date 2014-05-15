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
#' Extract All Pattern Matches
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_all_regex}},
#' \code{\link{stri_extract_all_coll}},
#' or \code{\link{stri_extract_all_charclass}},
#' depending on the argument used.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns a list of character vectors.
#'
#' @examples
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_all('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_all('Bartolini', coll='i')
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_all('stringi is so good!', charclass='\\p{Zs}') # all whitespaces
#'
#' @export
#' @family search_extract
stri_extract_all <- function(str, ..., regex, coll, charclass) {
   providedarg <- c("regex"=!missing(regex),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, or `charclass`")

   if (providedarg["regex"])
      stri_extract_all_regex(str, regex, ...)
   else if (providedarg["coll"])
      stri_extract_all_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_extract_all_charclass(str, charclass, ...)
}


#' @title
#' Extract First Pattern Match
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_first_regex}},
#' \code{\link{stri_extract_first_coll}},
#' or \code{\link{stri_extract_first_charclass}},
#' depending on the argument used.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns a character vector.
#'
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_first('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_first('Bartolini', coll=letters[1:3])
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_first(s, charclass='\\p{Zs}')
#'
#' @export
#' @family search_extract
stri_extract_first <- function(str, ..., regex, coll, charclass) {
   providedarg <- c("regex"=!missing(regex),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, or `charclass`")

   if (providedarg["regex"])
      stri_extract_first_regex(str, regex, ...)
   else if (providedarg["coll"])
      stri_extract_first_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_extract_first_charclass(str, charclass, ...)
}


#' @title
#' Extract Last Pattern Match
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_last_regex}},
#' \code{\link{stri_extract_last_coll}},
#' or \code{\link{stri_extract_last_charclass}},
#' depending on the argument used.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns a character vector.
#'
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_last('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_last('Bartolini', coll=letters[1:3])
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_last(s, charclass='\\p{Zs}')
#'
#' @export
#' @family search_extract
stri_extract_last <- function(str, ..., regex, coll, charclass) {
   providedarg <- c("regex"=!missing(regex),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, or `charclass`")

   if (providedarg["regex"])
      stri_extract_last_regex(str, regex, ...)
   else if (providedarg["coll"])
      stri_extract_last_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_extract_last_charclass(str, charclass, ...)
}


#' @title
#' Extract Pattern Matches
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_all}},
#' \code{\link{stri_extract_first}}, or \code{\link{stri_extract_last}},
#' depending on the argument used.
#' Note that this is slower than the direct call.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#' @param mode single string; whether to look for all, or only the first/last
#'             occurrence of the pattern
#'
#' @return The return value is the same as the underlying functions called, i.e.
#' a character vector or a list of character vectors.
#'
#'
#' @export
#' @family search_extract
stri_extract <- function(str, ..., regex, coll, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
          first=stri_extract_first(str, ..., regex=regex, coll=coll, charclass=charclass),
          last =stri_extract_last(str, ..., regex=regex, coll=coll, charclass=charclass),
          all  =stri_extract_all(str, ..., regex=regex, coll=coll, charclass=charclass)
   )
}


#' @title
#' Extract Words from a Text
#'
#' @description
#' This function extracts all words from
#' each string.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' Just like in \code{\link{stri_locate_words}},
#' \pkg{ICU}'s word \code{BreakIterator} iterator is used
#' to locate word boundaries, and all non-word characters
#' (\code{UBRK_WORD_NONE} rule status) are ignored.
#'
#'
#' @param str character vector or an object coercible to
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}.
#'
#' @return
#' A list of character vectors is returned. Each string consists of
#' a separate word.
#' If there are no words or if a string is missing, a single \code{NA}
#' is provided on output.
#'
#' @examples
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_extract_words("stringi: THE string processing package 123.48...")
#'
#' @references
#' \emph{Boundary Analysis} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/boundaryanalysis}
#'
#' @export
#' @family search_extract
#' @family locale_sensitive
#' @family text_boundaries
stri_extract_words <- function(str, locale=NULL) {
   .Call("stri_extract_words", str, locale, PACKAGE="stringi")
}
