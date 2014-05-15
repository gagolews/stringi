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
#' Replace All Occurrences of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_replace_all_regex}},
#' \code{\link{stri_replace_all_fixed}}, \code{\link{stri_replace_all_coll}},
#' or \code{\link{stri_replace_all_charclass}},
#' depending on the argument used.
#'
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#' @param replacement character vector of strings to replace with
#'
#' @return Returns a character vector.
#'
#'
#' @export
#' @family search_replace
stri_replace_all <- function(str, replacement, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_replace_all_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_replace_all_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_replace_all_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_replace_all_charclass(str, charclass, ...)
}


#' @title
#' Replace First Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_replace_first_regex}},
#' \code{\link{stri_replace_first_fixed}}, \code{\link{stri_replace_first_coll}},
#' or \code{\link{stri_replace_first_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#' @param replacement character vector of strings to replace with
#'
#' @return Returns a character vector.
#'
#'
#' @export
#' @family search_replace
stri_replace_first <- function(str, replacement, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_replace_first_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_replace_first_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_replace_first_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_replace_first_charclass(str, charclass, ...)
}


#' @title
#' Replace Last Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_replace_last_regex}},
#' \code{\link{stri_replace_last_fixed}}, \code{\link{stri_replace_last_coll}},
#' or \code{\link{stri_replace_last_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#' @param replacement character vector of strings to replace with
#'
#' @return Returns a character vector.
#'
#'
#' @export
#' @family search_replace
stri_replace_last <- function(str, replacement, ..., regex, fixed, coll, charclass) {
   providedarg <- c("regex"=!missing(regex), "fixed"    =!missing(fixed),
                    "coll" =!missing(coll),  "charclass"=!missing(charclass))

   if (sum(providedarg) != 1)
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")

   if (providedarg["regex"])
      stri_replace_last_regex(str, regex, ...)
   else if (providedarg["fixed"])
      stri_replace_last_fixed(str, fixed, ...)
   else if (providedarg["coll"])
      stri_replace_last_coll(str, coll, ...)
   else if (providedarg["charclass"])
      stri_replace_last_charclass(str, charclass, ...)
}


#' @title
#' Replace Occurrences of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_replace_all}},
#' \code{\link{stri_replace_first}}, or \code{\link{stri_replace_last}},
#' depending on the argument used.
#'
#' @details
#' Note that this is slower than the direct call.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#' @param mode string; whether to look for all, or only the first/last
#'             occurrence of the pattern
#' @param replacement character vector of strings to replace with
#'
#' @return Returns a character vector.
#'
#'
#' @export
#' @family search_replace
stri_replace <- function(str, replacement, ..., regex, fixed, coll, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
          first=stri_replace_first(str, replacement, ..., regex=regex,
               fixed=fixed, coll=coll, charclass=charclass),
          last =stri_replace_last(str, replacement, ..., regex=regex,
               fixed=fixed, coll=coll, charclass=charclass),
          all  =stri_replace_all(str, replacement, ..., regex=regex,
               fixed=fixed, coll=coll, charclass=charclass)
   )
}


#' @title
#' Replace Missing Values in a Character Vector
#'
#' @description
#' This function offers a convenient way to replace each \code{NA}
#' in a character vector with a given string.
#'
#' @details
#' This function is roughly equivalent to
#' \code{str2 <- stri_enc_toutf8(str);
#' str2[is.na(str2)] <- stri_enc_toutf8(replacement);
#' str2}.
#' It may be used e.g. wherever ``plain \R'' \code{NA} handling is
#' desired, see Examples.
#'
#' @param str character vector or an object coercible to
#' @param replacement single string
#'
#' @return Returns a character vector.
#'
#' @examples
#' x <- c('test', NA)
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_paste(x, 1:2)                           # "test1" NA
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' paste(x, 1:2)                                # "test 1" "NA 2"
#'
#' \dontshow{if (stri_install_check(silent=TRUE))}
#' stri_paste(stri_replace_na(x), 1:2, sep=' ') # "test 1" "NA 2"
#'
#' @export
#' @family search_replace
stri_replace_na <- function(str, replacement="NA"){
   .Call("stri_replace_na", str, replacement, PACKAGE="stringi")
}
