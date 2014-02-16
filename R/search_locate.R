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
#' Locate Occurrences of a Character Class
#'
#' @description
#' These functions may be used e.g. to find the indices, at which
#' letters, digits, or white spaces occur in a given string.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{merge}.
#'
#' @param str character vector to search in
#' @param pattern character vector; identifiers of character classes,
#' see \link{stringi-search-charclass}
#' @param merge logical [\code{stri_locate_all_charclass} only];
#' indicates whether consecutive sequences of indices in the resulting
#' matrix shall be merged
#'
#' @return
#' For \code{stri_locate_all_charclass},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned .
#' The first column gives the start positions
#' of matches, and the second column gives the end position.
#' Moreover, you may gen two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' For \code{stri_locate_first_charclass} and \code{stri_locate_last_charclass},
#' you get an integer matrix with \code{max(length(str), length(pattern))} rows,
#' and two columns, giving the start and end positions of the first
#' or the last matches, respectively, and two \code{NA}s iff not found.
#' Note that the first column is always equal to the second column, as
#' we look for single code points in these two cases.
#'
#' @examples
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll')
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll', merge=FALSE)
#' stri_locate_first_charclass('AaBbCc', 'Ll')
#' stri_locate_last_charclass('AaBbCc', 'Ll')
#' stri_locate_all_charclass(c('REXAMINE'), 'Lu', merge=c(TRUE, FALSE))
#'
#' @export
#' @rdname stri_locate_charclass
#' @aliases stri_locate_all_charclass stri_locate_first_charclass stri_locate_last_charclass
#' @family search_charclass
#' @family search_locate
#' @family indexing
stri_locate_all_charclass <- function(str, pattern, merge=TRUE) {
   .Call("stri_locate_all_charclass", str, pattern, merge, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_charclass
stri_locate_first_charclass <- function(str, pattern) {
   .Call("stri_locate_first_charclass", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_charclass
stri_locate_last_charclass <- function(str, pattern) {
   .Call("stri_locate_last_charclass", str, pattern, PACKAGE="stringi")
}


#' @title
#' Locate Occurrences of a Fixed Pattern
#'
#' @description
#' These functions find the indices, at which
#' a given pattern matches a substring of the input string.
#'
#'
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' See \link{stringi-search-fixed} for more details on
#' Locale-Sensitive Text Searching in \pkg{stringi}.
#'
#'
#' Note the difference between  \code{stri_locate_last_fixed}
#' and \code{\link{stri_locate_last_regex}} for overlapping pattern matches.
#' In \code{stri_locate_last_fixed}, search is done from-the-end.
#'
#' Pass \code{opts_collator} equal to \code{NA} for much faster, but
#' locale unaware, (exact) bitwise comparisons. For a natural language text
#' this may be not what you really want.
#'
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named list as generated with
#' \code{\link{stri_opts_collator}} with Collator options,
#' or \code{NA} for fast but locale-unaware byte comparison
#'
#' @return
#' For \code{stri_locate_all_charclass},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned .
#' The first column gives the start positions
#' of matches, and the second column gives the end position.
#' Moreover, you may gen two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' For \code{stri_locate_first_fixed} and \code{stri_locate_last_fixed},
#' you get an integer matrix with \code{max(length(str), length(pattern))} rows,
#' and two columns, giving the start and end positions of the first
#' or the last matches, respectively, and \code{NA}s iff not found.
#'
#' @examples
#' \dontrun{
#' stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_locate_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' stri_locate_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#'
#' #first row is 1-2 like in locate_first
#' stri_locate_all_fixed('bbbbb', 'bb')
#' stri_locate_first_fixed('bbbbb', 'bb')
#' # but last row is 3-4, unlike in locate_last,
#' # keep this in mind [overlapping pattern match OK]!
#' stri_locate_last_fixed('bbbbb', 'bb')
#'
#' locate <- stri_locate_first_fixed('stringi - REXAMINE', letters)
#' rownames(locate) <- letters
#' locate
#' }
#'
#' @export
#' @rdname stri_locate_fixed
#' @aliases stri_locate_all_fixed, stri_locate_first_fixed, stri_locate_last_fixed
#' @family search_fixed
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
stri_locate_all_fixed <- function(str, pattern, opts_collator=list()) {
   .Call("stri_locate_all_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_fixed
stri_locate_first_fixed <- function(str, pattern, opts_collator=list()) {
   .Call("stri_locate_first_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_fixed
stri_locate_last_fixed <- function(str, pattern, opts_collator=list()) {
   .Call("stri_locate_last_fixed", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @title
#' Locate Occurrences of a Regex Pattern
#'
#' @description
#' These functions find the indices, at which
#' a regex pattern matches a substring of the input string.
#'
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' @param str character vector of strings to search in
#' @param pattern character vector of regular expressions
#' @param opts_regex a named list as generated with \code{\link{stri_opts_regex}}
#'
#' @return
#' For \code{stri_locate_all_charclass},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned .
#' The first column gives the start positions
#' of matches, and the second column gives the end position.
#' Moreover, you may gen two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' For \code{stri_locate_first_fixed} and \code{stri_locate_last_fixed},
#' you get an integer matrix with \code{max(length(str), length(pattern))} rows,
#' and two columns, giving the start and end positions of the first
#' or the last matches, respectively, and \code{NA}s iff not found.
#'
#' @examples
#' \dontrun{
#' stri_locate_all_regex('XaaaaX',
#'    c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_first_regex('XaaaaX',
#'    c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_last_regex('XaaaaX',
#'    c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' }
#'
#' @export
#' @rdname stri_locate_regex
#' @aliases stri_locate_all_regex stri_locate_first_regex stri_locate_last_regex
#' @family search_regex
#' @family search_locate
#' @family indexing
stri_locate_all_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_locate_all_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_regex
stri_locate_first_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_locate_first_regex", str, pattern, opts_regex, PACKAGE="stringi")
}



#' @export
#' @rdname stri_locate_regex
stri_locate_last_regex <- function(str, pattern, opts_regex=list()) {
   .Call("stri_locate_last_regex", str, pattern, opts_regex, PACKAGE="stringi")
}



#' @title
#' Locate All Occurrences of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_all_regex}},
#' \code{\link{stri_locate_all_fixed}},
#' or \code{\link{stri_locate_all_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' Please note that the parameters are considered in the following order:
#' \code{regex}, \code{fixed}
#' and \code{class}. Thus, if you specify \code{regex} and \code{class},
#' only the first one will be used.
#'
#' @return Returns a list of integer matrices. The first column gives the
#' start positions
#' of the matches, and the second one gives the end position.
#' Double \code{NA}s iff not found or \code{NA} argument is given.
#'
#' @examples
#' \dontrun{
#' stri_locate_all('XaaaaX',
#'    regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_all('Bartolini', fixed='i')
#' stri_locate_all('a b c', charclass='Zs') # all white spaces
#' }
#'
#' @export
#' @family search_locate
#' @family indexing
stri_locate_all <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_locate_all_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_locate_all_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_locate_all_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' @title
#' Locate First Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_first_regex}},
#' \code{\link{stri_locate_first_fixed}},
#' or \code{\link{stri_locate_first_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' Please note that the parameters are considered in the following order:
#' \code{regex}, \code{fixed}
#' and \code{class}. Thus, if you specify \code{regex} and \code{class},
#' only the first one will be used.
#'
#' @return Returns an integer matrix with two columns, with
#' double \code{NA}s in a row if a pattern not found.
#'
#' @examples
#' \dontrun{
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_first('XaaaaX',
#'    regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_first('Bartolini', fixed=letters[1:3])
#' stri_locate_first('a b c', charclass='Zs')
#' }
#'
#' @export
#' @family search_locate
#' @family indexing
stri_locate_first <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_locate_first_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_locate_first_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_locate_first_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' @title
#' Locate Last Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_last_regex}},
#' \code{\link{stri_locate_last_fixed}},
#' or \code{\link{stri_locate_last_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' Please note that the parameters are considered in the following order:
#' \code{regex}, \code{fixed}
#' and \code{class}. Thus, if you specify \code{regex} and \code{class},
#' only the first one will be used.
#'
#' @return Returns an integer matrix with two columns, with
#' double \code{NA}s in a row if a pattern  not found.
#'
#' @examples
#' \dontrun{
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_last('XaaaaX',
#'    regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_last('Bartolini', fixed=letters[1:3])
#' stri_locate_last('a b c', charclass='Zs')
#' }
#'
#' @export
#' @family search_locate
#' @family indexing
stri_locate_last <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_locate_last_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_locate_last_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_locate_last_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' @title
#' Locate Occurrences of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_all}},
#' \code{\link{stri_locate_first}}, or \code{\link{stri_locate_last}},
#' depending on the argument used.
#' Note that this is slower than the direct call.
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#' @param mode single string; whether to look for all, or only the first/last
#'             occurrence of the pattern
#'
#' @return The return value is the same as that of the underlying
#' functions called, i.e.
#' a two-column matrix or a list of matrices.
#'
#'
#' @export
#' @family search_locate
#' @family indexing
stri_locate <- function(str, ..., regex, fixed, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
      first=stri_locate_first(str, ..., regex=regex, fixed=fixed, charclass=charclass),
      last =stri_locate_last(str, ..., regex=regex, fixed=fixed, charclass=charclass),
      all  =stri_locate_all(str, ..., regex=regex, fixed=fixed, charclass=charclass)
   )
}
