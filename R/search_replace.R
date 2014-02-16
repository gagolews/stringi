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
#' Replace Occurrences of a Character Class
#'
#' @description
#' Replaces with the given replacement string every/first/last
#' character class occurrence in the input string.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#'
#' These functions scan the input string for matches of a character class.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the same (fixed) replacement string.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector; identifiers of character classes,
#' see \link{stringi-search-charclass}
#' @param replacement character vector of strings to replace with
#' @return character vector
#'
#' @export
#' @rdname stri_replace_charclass
#' @aliases stri_replace_all_charclass stri_replace_first_charclass stri_replace_last_charclass
#' @family search_charclass
#' @family search_replace
#'
#' @examples
#' stri_replace_all_charclass("a\nb\tc d", "WHITE_SPACE", " ")
stri_replace_all_charclass <- function(str, pattern, replacement) {
   .Call("stri_replace_all_charclass", str, pattern, replacement, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_charclass
stri_replace_first_charclass <- function(str, pattern, replacement) {
   .Call("stri_replace_first_charclass", str, pattern, replacement, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_charclass
stri_replace_last_charclass <- function(str, pattern, replacement) {
   .Call("stri_replace_last_charclass", str, pattern, replacement, PACKAGE="stringi")
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
#' These functions scan the input string for matches of the pattern.
#' Input that is not part of any match is left unchanged;
#' each match is replaced in the result by the replacement string.
#'
#'
#' Pass \code{opts_collator} equal to \code{NA} for much faster, but
#' locale unaware, (exact) byte comparisons. For natural language text
#' this may be not what you really want.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of patterns to search for
#' @param replacement character vector of strings to replace with
#' @param opts_collator a named list as generated with
#' \code{\link{stri_opts_collator}} with Collator options,
#' or \code{NA} for fast but locale-unaware byte comparison
#' @return character vector
#'
#' @examples
#' \dontrun{
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all_fixed(s," ","#")
#' stri_replace_all_fixed(s,"o","0")
#' }
#'
#' @export
#' @rdname stri_replace_fixed
#' @aliases stri_replace_all_fixed stri_replace_first_fixed stri_replace_last_fixed
#' @family search_fixed
#' @family search_replace
#' @family locale_sensitive
stri_replace_all_fixed <- function(str, pattern, replacement, opts_collator=list()) {
   .Call("stri_replace_all_fixed", str, pattern, replacement, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_fixed
stri_replace_first_fixed <- function(str, pattern, replacement, opts_collator=list()) {
   .Call("stri_replace_first_fixed", str, pattern, replacement, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_fixed
stri_replace_last_fixed <- function(str, pattern, replacement, opts_collator=list()) {
   .Call("stri_replace_last_fixed", str, pattern, replacement, opts_collator, PACKAGE="stringi")
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
#' @param opts_regex a named list as generated with \code{\link{stri_opts_regex}}
#' @return character vector
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
stri_replace_all_regex <- function(str, pattern, replacement, opts_regex=list()) {
   .Call("stri_replace_all_regex", str, pattern, replacement, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_regex
stri_replace_first_regex <- function(str, pattern, replacement, opts_regex=list()) {
   .Call("stri_replace_first_regex", str, pattern, replacement, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_regex
stri_replace_last_regex <- function(str, pattern, replacement, opts_regex=list()) {
   .Call("stri_replace_last_regex", str, pattern, replacement, opts_regex, PACKAGE="stringi")
}



#' @title
#' Replace All Occurrences of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_replace_all_regex}},
#' \code{\link{stri_replace_all_fixed}}, or \code{\link{stri_replace_all_charclass}},
#' depending on the argument used.
#'
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#' @param replacement character vector of strings to replace with
#'
#' @return character vector
#'
#'
#' @export
#' @family search_replace
stri_replace_all <- function(str, replacement, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_replace_all_regex(str, regex, replacement, ...)
   else if (!missing(fixed))
      stri_replace_all_fixed(str, fixed, replacement, ...)
   else if (!missing(charclass))
      stri_replace_all_charclass(str, charclass, replacement, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}


#' @title
#' Replace First Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_replace_first_regex}},
#' \code{\link{stri_replace_first_fixed}}, or \code{\link{stri_replace_first_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#' @param replacement character vector of strings to replace with
#'
#' @return character vector
#'
#'
#' @export
#' @family search_replace
stri_replace_first <- function(str, replacement, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_replace_first_regex(str, regex, replacement, ...)
   else if (!missing(fixed))
      stri_replace_first_fixed(str, fixed, replacement, ...)
   else if (!missing(charclass))
      stri_replace_first_charclass(str, charclass, replacement, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' @title
#' Replace Last Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_replace_last_regex}},
#' \code{\link{stri_replace_last_fixed}}, or \code{\link{stri_replace_last_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#' @param replacement character vector of strings to replace with
#'
#' @return character vector
#'
#'
#' @export
#' @family search_replace
stri_replace_last <- function(str, replacement, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_replace_last_regex(str, regex, replacement, ...)
   else if (!missing(fixed))
      stri_replace_last_fixed(str, fixed, replacement, ...)
   else if (!missing(charclass))
      stri_replace_last_charclass(str, charclass, replacement, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
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
#' @param charclass character vector; identifiers of character classes
#' @param mode string; whether to look for all, or only the first/last
#'             occurrence of the pattern
#' @param replacement character vector of strings to replace with
#'
#' @return character vector
#'
#'
#' @export
#' @family search_replace
stri_replace <- function(str, replacement, ..., regex, fixed, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
          first=stri_replace_first(str, replacement, ..., regex=regex, fixed=fixed, charclass=charclass),
          last =stri_replace_last(str, replacement, ..., regex=regex, fixed=fixed, charclass=charclass),
          all  =stri_replace_all(str, replacement, ..., regex=regex, fixed=fixed, charclass=charclass)
   )
}
