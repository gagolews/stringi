## This file is part of the 'stringi' package for R.
##
## Copyright (C) 2013-2014 Marek Gagolewski, Bartek Tartanus
##
##
## Permission is hereby granted, free of charge, to any person obtaining
## a copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom
## the Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included
## in all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
## EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
## IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
## DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
## TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
## THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#' @title
#' Extract Character Class Matches
#'
#' @description
#' These functions extract substrings of \code{str} that
#' match a given \code{pattern}.
#'
#' Generally, this is the way to extract single characters, only.
#' Longer substrings, however, may be extracted,
#' with the \code{stri_extract_all_charclass} function
#' and \code{merge=TRUE}.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{merge}.
#'
#' @param str character vector to search in
#' @param pattern character vector; identifiers of character classes,
#' see \link{stringi-search-charclass}
#' @param merge logical [\code{stri_extract_all_charclass} only];
#' should consecutive matches be merged into one string?
#'
#' @return
#' For \code{stri_extract_all_charclass},
#' a list of \code{max(length(str), length(pattern), length(merge))}
#' character vectors is returned.
#' Otherwise, you get a character vector.
#' \code{NA} if not found.
#'
#'
#' @examples
#' stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll')
#' stri_extract_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll', merge=FALSE)
#' stri_extract_first_charclass('AaBbCc', 'Ll')
#' stri_extract_last_charclass('AaBbCc', 'Ll')
#'
#' @export
#' @rdname stri_extract_charclass
#' @aliases stri_extract_all_charclass stri_extract_first_charclass stri_extract_last_charclass
#' @family search_charclass
#' @family search_extract
stri_extract_all_charclass <- function(str, pattern, merge=TRUE) {
   .Call("stri_extract_all_charclass", str, pattern, merge, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_charclass
stri_extract_first_charclass <- function(str, pattern) {
   .Call("stri_extract_first_charclass", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_charclass
stri_extract_last_charclass <- function(str, pattern) {
   .Call("stri_extract_last_charclass", str, pattern, PACKAGE="stringi")
}


#' @title
#' Extract Fixed Pattern Matches
#'
#' @description
#' These functions extract substrings of \code{str} that
#' match a given \code{pattern}.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' If \code{collator_opts} is not \code{NA} (default,
#' i.e. locale-aware search), then the operation
#' is not as dummy as it seems (for non-ASCII text).
#'
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named list as generated with \code{\link{stri_opts_collator}}
#' with Collator options, or \code{NA} for fast but locale-unaware byte comparison
#'
#' @return
#' For \code{stri_extract_all_fixed},
#' a list of \code{max(length(str), length(pattern))} character vectors is returned.
#' Otherwise, you get a character vector.
#' \code{NA} if not found.
#'
#' @examples
#' \dontrun{
#' stri_extract_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_extract_first_fixed(c('Yy\u00FD', 'AAA'), 'y', stri_opts_collator(strength=2, locale="sk_SK"))
#' stri_extract_last_fixed(c('Yy\u00FD', 'AAA'), 'y', stri_opts_collator(strength=1, locale="sk_SK"))
#' }
#'
#' @export
#' @rdname stri_extract_fixed
#' @aliases stri_extract_all_fixed, stri_extract_first_fixed, stri_extract_last_fixed
#' @family search_fixed
#' @family search_locate
#' @family search_extract
stri_extract_all_fixed <- function(str, pattern, opts_collator=list()) {
   .Call("stri_extract_all_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_fixed
stri_extract_first_fixed <- function(str, pattern, opts_collator=list()) {
   .Call("stri_extract_first_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_fixed
stri_extract_last_fixed <- function(str, pattern, opts_collator=list()) {
   .Call("stri_extract_last_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @title
#' Extract Regex Pattern Matches
#'
#' @description
#' These functions extract substrings of \code{str} that
#' match a given \code{pattern}.
#'
#' See also \code{\link{stri_match_all_regex}} for extracting
#' matches together with regex capture groups.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions
#' @param opts_regex a named list as generated with \code{\link{stri_opts_regex}}
#'
#' @return
#' For \code{stri_extract_all_regex},
#' list of \code{max(length(str), length(pattern))} character vectors is returned.
#' Otherwise, you get a character vector.
#' \code{NA} if not found.
#'
#' @examples
#' \dontrun{
#' stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_first_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_last_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' }
#'
#' @export
#' @rdname stri_extract_regex
#' @aliases stri_extract_all_regex stri_extract_first_regex stri_extract_last_regex
#' @family search_regex
#' @family search_extract
stri_extract_all_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_extract_all_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_regex
stri_extract_first_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_extract_first_regex", str, pattern, opts_regex, PACKAGE="stringi")
}



#' @export
#' @rdname stri_extract_regex
stri_extract_last_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_extract_last_regex", str, pattern, opts_regex, PACKAGE="stringi")
}



#' @title
#' Extract All Pattern Matches
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_all_regex}},
#' \code{\link{stri_extract_all_fixed}}, or \code{\link{stri_extract_all_charclass}},
#' depending on the argument used.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns a list of character vectors.
#'
#' @examples
#' \dontrun{
#' stri_extract_all('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_all('Bartolini', fixed='i')
#' stri_extract_all('stringi are so good!', charclass='Zs') # all whitespaces
#' }
#'
#' @export
#' @family search_extract
stri_extract_all <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_extract_all_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_extract_all_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_extract_all_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' @title
#' Extract First Pattern Match
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_first_regex}},
#' \code{\link{stri_extract_first_fixed}}, or \code{\link{stri_extract_first_charclass}},
#' depending on the argument used.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns a character vector.
#'
#' @examples
#' \dontrun{
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_extract_first('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_first('Bartolini', fixed=letters[1:3])
#' stri_extract_first(s, charclass='Zs')
#' }
#'
#' @export
#' @family search_extract
stri_extract_first <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_extract_first_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_extract_first_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_extract_first_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' @title
#' Extract Last Pattern Match
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_last_regex}},
#' \code{\link{stri_extract_last_fixed}}, or \code{\link{stri_extract_last_charclass}},
#' depending on the argument used.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @return Returns a character vector.
#'
#' @examples
#' \dontrun{
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_extract_last('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_last('Bartolini', fixed=letters[1:3])
#' stri_extract_last(s, charclass='Zs')
#' }
#'
#' @export
#' @family search_extract
stri_extract_last <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_extract_last_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_extract_last_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_extract_last_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
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
#' @param fixed character vector; fixed patterns
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
stri_extract <- function(str, ..., regex, fixed, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
          first=stri_extract_first(str, ..., regex=regex, fixed=fixed, charclass=charclass),
          last =stri_extract_last(str, ..., regex=regex, fixed=fixed, charclass=charclass),
          all  =stri_extract_all(str, ..., regex=regex, fixed=fixed, charclass=charclass)
   )
}
