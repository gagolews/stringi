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
#' Replace Occurrences of a Character Class
#'
#' @description
#' Replaces with the given replacement string every/first/last
#' the characters that fall into a class specified by \code{pattern}.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' These functions scan the input string for matches of a character class.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the same (fixed) replacement string.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector specifying character classes to match,
#' see \link{stringi-search-charclass}
#' @param replacement character vector of strings to replace with
#' @param merge logical [\code{stri_replace_all_charclass} only];
#' should consecutive matches be merged into a single one?
#'
#' @return Each function returns a character vector.
#'
#' @export
#' @rdname stri_replace_charclass
#' @aliases stri_replace_all_charclass stri_replace_first_charclass stri_replace_last_charclass
#' @family search_charclass
#' @family search_replace
#'
#' @examples
#' stri_replace_all_charclass("a\nb\tc   d", "\\p{WHITE_SPACE}", " ")
#' stri_replace_all_charclass("a\nb\tc   d", "\\p{WHITE_SPACE}", " ", TRUE)
stri_replace_all_charclass <- function(str, pattern, replacement, merge=FALSE) {
   .Call("stri_replace_all_charclass", str, pattern, replacement, merge,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_charclass
stri_replace_first_charclass <- function(str, pattern, replacement) {
   .Call("stri_replace_first_charclass", str, pattern, replacement,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_charclass
stri_replace_last_charclass <- function(str, pattern, replacement) {
   .Call("stri_replace_last_charclass", str, pattern, replacement,
         PACKAGE="stringi")
}


#' @title
#' Replace Occurrences of a Canonically Equivalent Pattern
#'
#' @description
#' Replaces with the given replacement string every/first/last
#' substring of the input that matches the pattern.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' These are locale-sensitive operations.
#' See \link{stringi-search-coll} for more details on
#' locale-sensitive text searching in \pkg{stringi}.
#'
#' These functions scan the input string for matches of the pattern.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the replacement string.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of patterns to search for
#' @param replacement character vector of strings to replace with
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}; \code{NULL}
#' for default options
#'
#' @return Each function discussed returns a character vector.
#'
#' @examples
#' \dontrun{
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all_coll(s, " ", "#")
#' stri_replace_all_coll(s, "o", "0")
#' }
#'
#' @export
#' @rdname stri_replace_coll
#' @aliases stri_replace_all_coll stri_replace_first_coll stri_replace_last_coll
#' @family search_coll
#' @family search_replace
#' @family locale_sensitive
stri_replace_all_coll <- function(str, pattern, replacement, opts_collator=NULL) {
   .Call("stri_replace_all_coll", str, pattern, replacement, opts_collator,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_coll
stri_replace_first_coll <- function(str, pattern, replacement, opts_collator=NULL) {
   .Call("stri_replace_first_coll", str, pattern, replacement, opts_collator,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_coll
stri_replace_last_coll <- function(str, pattern, replacement, opts_collator=NULL) {
   .Call("stri_replace_last_coll", str, pattern, replacement, opts_collator,
         PACKAGE="stringi")
}


#' @title
#' Replace Occurrences of a Fixed Pattern
#'
#' @description
#' Replaces with the given replacement string every/first/last
#' substring of the input that matches the pattern.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' For natural language processing this function may be not give
#' you desired results. Refer to \link{stringi-search-fixed} for more details.
#'
#' These functions scan the input string for matches of the pattern.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the replacement string.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of patterns to search for
#' @param replacement character vector of strings to replace with
#'
#' @return Each function returns a character vector.
#'
#' @examples
#' \dontrun{
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all_fixed(s, " ", "#")
#' stri_replace_all_fixed(s, "o", "0")
#' }
#'
#' @export
#' @rdname stri_replace_fixed
#' @aliases stri_replace_all_fixed stri_replace_first_fixed stri_replace_last_fixed
#' @family search_fixed
#' @family search_replace
stri_replace_all_fixed <- function(str, pattern, replacement) {
   .Call("stri_replace_all_fixed", str, pattern, replacement,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_fixed
stri_replace_first_fixed <- function(str, pattern, replacement) {
   .Call("stri_replace_first_fixed", str, pattern, replacement,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_fixed
stri_replace_last_fixed <- function(str, pattern, replacement) {
   .Call("stri_replace_last_fixed", str, pattern, replacement,
         PACKAGE="stringi")
}


#' @title
#' Replace Occurrences of a Regex Pattern
#'
#' @description
#' Replaces with the given replacement string every/first/last
#' substring of the input that matches a regular expression
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' These functions scan the input string for matches of the pattern.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the replacement string.
#'
#' The replacement string may contain references to capture groups
#' (in round parentheses).
#' References are of the form \code{$n}, where \code{n} is the number
#' of the capture group (their numbering starts from 1).
#'
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions
#' @param replacement character vector of strings to replace with,
#' possibly including references to capture groups
#' @param opts_regex a named list with \pkg{ICU} Regex options
#' as generated with \code{\link{stri_opts_regex}}; \code{NULL}
#' for default options
#'
#' @return Each function returns a character vector.
#'
#' @examples
#' \dontrun{
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all_regex(s, " .*? ", "#")
#' stri_replace_all_regex(s, "(el|s)it", "1234")
#' stri_replace_all_regex('abaca', 'a', c('!', '*'))
#' stri_replace_all_regex('123|456|789', '(\\p{N}).(\\p{N})', '$2-$1')
#' stri_replace_all_regex(c("stringi w R","REXAMINE","123"), '( R|R.)', ' r ')
#' }
#'
#' @export
#' @rdname stri_replace_regex
#' @aliases stri_replace_all_regex stri_replace_first_regex stri_replace_last_regex
#' @family search_regex
#' @family search_replace
stri_replace_all_regex <- function(str, pattern, replacement, opts_regex=NULL) {
   .Call("stri_replace_all_regex", str, pattern, replacement, opts_regex,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_regex
stri_replace_first_regex <- function(str, pattern, replacement, opts_regex=NULL) {
   .Call("stri_replace_first_regex", str, pattern, replacement, opts_regex,
         PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_regex
stri_replace_last_regex <- function(str, pattern, replacement, opts_regex=NULL) {
   .Call("stri_replace_last_regex", str, pattern, replacement, opts_regex,
         PACKAGE="stringi")
}


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
   if (!missing(regex))
      stri_replace_all_regex(str, regex, replacement, ...)
   else if (!missing(fixed))
      stri_replace_all_fixed(str, fixed, replacement, ...)
   else if (!missing(coll))
      stri_replace_all_coll(str, coll, replacement, ...)
   else if (!missing(charclass))
      stri_replace_all_charclass(str, charclass, replacement, ...)
   else
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")
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
   if (!missing(regex))
      stri_replace_first_regex(str, regex, replacement, ...)
   else if (!missing(fixed))
      stri_replace_first_fixed(str, fixed, replacement, ...)
   else if (!missing(coll))
      stri_replace_first_coll(str, coll, replacement, ...)
   else if (!missing(charclass))
      stri_replace_first_charclass(str, charclass, replacement, ...)
   else
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")
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
   if (!missing(regex))
      stri_replace_last_regex(str, regex, replacement, ...)
   else if (!missing(fixed))
      stri_replace_last_fixed(str, fixed, replacement, ...)
   else if (!missing(coll))
      stri_replace_last_coll(str, coll, replacement, ...)
   else if (!missing(charclass))
      stri_replace_last_charclass(str, charclass, replacement, ...)
   else
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")
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
#' stri_paste(x, 1:2)                           # "test1" NA
#' paste(x, 1:2)                                # "test 1" "NA 2"
#' stri_paste(stri_replace_na(x), 1:2, sep=' ') # "test 1" "NA 2"
#'
#' @export
#' @family search_replace
stri_replace_na <- function(str, replacement="NA"){
   .Call("stri_replace_na", str, replacement, PACKAGE="stringi")
}
