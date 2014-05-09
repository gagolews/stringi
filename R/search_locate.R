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
#' @param pattern character vector specifying character classes to match,
#' see \link{stringi-search-charclass}
#' @param merge logical [\code{stri_locate_all_charclass} only];
#' indicates whether consecutive sequences of indices in the resulting
#' matrix shall be merged
#'
#' @return
#' For \code{stri_locate_all_charclass},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned.
#' The first column gives the start positions
#' of matches, and the second column gives the end positions.
#' Moreover, you may get two \code{NA}s in one row
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
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}')
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), '\\p{Ll}', merge=FALSE)
#' stri_locate_first_charclass('AaBbCc', '\\p{Ll}')
#' stri_locate_last_charclass('AaBbCc', '\\p{Ll}')
#' stri_locate_all_charclass(c('REXAMINE'), '\\p{Lu}', merge=c(TRUE, FALSE))
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
#' Locate Occurrences of a Canonically Equivalent Pattern
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
#' See \link{stringi-search-coll} for more details on
#' locale-sensitive text searching in \pkg{stringi}.
#'
#'
#' Note the difference between  \code{stri_locate_last_coll}
#' and \code{\link{stri_locate_last_regex}} for overlapping pattern matches.
#' In \code{stri_locate_last_coll}, search is done from-the-end.
#'
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named list with \pkg{ICU} Collator's options
#' as generated with \code{\link{stri_opts_collator}}; \code{NULL}
#' for default options
#'
#' @return
#' For \code{stri_locate_all_coll},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned.
#' The first column gives the start positions
#' of matches, and the second column gives the end positions.
#' Moreover, you may gen two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' For \code{stri_locate_first_coll} and \code{stri_locate_last_coll},
#' you get an integer matrix with \code{max(length(str), length(pattern))} rows,
#' and two columns, giving the start and end positions of the first
#' or the last matches, respectively, and \code{NA}s iff not found.
#'
#' @examples
#' \dontrun{
#' stri_locate_all_coll(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_locate_first_coll(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' stri_locate_last_coll(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#'
#' #first row is 1-2 like in locate_first
#' stri_locate_all_coll('bbbbb', 'bb')
#' stri_locate_first_coll('bbbbb', 'bb')
#' # but last row is 3-4, unlike in locate_last,
#' # keep this in mind [overlapping pattern match OK]!
#' stri_locate_last_coll('bbbbb', 'bb')
#'
#' locate <- stri_locate_first_coll('stringi - REXAMINE', letters)
#' rownames(locate) <- letters
#' locate
#' }
#'
#' @export
#' @rdname stri_locate_coll
#' @aliases stri_locate_all_coll stri_locate_first_coll stri_locate_last_coll
#' @family search_coll
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
stri_locate_all_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_all_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_coll
stri_locate_first_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_first_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_coll
stri_locate_last_coll <- function(str, pattern, opts_collator=NULL) {
   .Call("stri_locate_last_coll", str, pattern, opts_collator, PACKAGE="stringi")
}


#' @title
#' Locate Occurrences of a Fixed Pattern
#'
#' @description
#' These functions find the indices, at which
#' a given pattern matches a substring of the input string.
#'
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#'
#' These are locale-independent operations.
#' For natural language processing this function may be not give
#' you desired results. Refer to \link{stringi-search-fixed} for more details.
#'
#'
#' Note the difference between  \code{stri_locate_last_fixed}
#' and \code{\link{stri_locate_last_regex}} for overlapping pattern matches.
#' In \code{stri_locate_last_fixed}, search is done from-the-end.
#'
#' @param str character vector
#' @param pattern character vector
#'
#' @return
#' For \code{stri_locate_all_fixed},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned.
#' The first column gives the start positions
#' of matches, and the second column gives the end positions.
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
#' @aliases stri_locate_all_fixed stri_locate_first_fixed stri_locate_last_fixed
#' @family search_fixed
#' @family search_locate
#' @family indexing
stri_locate_all_fixed <- function(str, pattern) {
   .Call("stri_locate_all_fixed", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_fixed
stri_locate_first_fixed <- function(str, pattern) {
   .Call("stri_locate_first_fixed", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_fixed
stri_locate_last_fixed <- function(str, pattern) {
   .Call("stri_locate_last_fixed", str, pattern, PACKAGE="stringi")
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
#' @param opts_regex a named list with \pkg{ICU} Regex options
#' as generated with \code{\link{stri_opts_regex}}; \code{NULL}
#' for default options
#'
#' @return
#' For \code{stri_locate_all_charclass},
#' a list of \code{max(length(str), length(pattern))} integer matrices
#' is returned .
#' The first column gives the start positions
#' of matches, and the second column gives the end positions.
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
stri_locate_all_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_locate_all_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_regex
stri_locate_first_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_locate_first_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_regex
stri_locate_last_regex <- function(str, pattern, opts_regex=NULL) {
   .Call("stri_locate_last_regex", str, pattern, opts_regex, PACKAGE="stringi")
}


#' @title
#' Locate All Occurrences of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_all_regex}},
#' \code{\link{stri_locate_all_fixed}}, \code{\link{stri_locate_all_coll}},
#' or \code{\link{stri_locate_all_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' Please note that the parameters are considered in the following order:
#' \code{regex}, \code{fixed}, \code{coll},
#' and \code{class}. Thus, if you specify \code{regex} and \code{class},
#' only the first one will be used.
#'
#' @return Returns a list of integer matrices. The first column gives the
#' start positions
#' of the matches, and the second one gives the end positions.
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
stri_locate_all <- function(str, ..., regex, fixed, coll, charclass) {
   if (!missing(regex))
      stri_locate_all_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_locate_all_fixed(str, fixed, ...)
   else if (!missing(coll))
      stri_locate_all_coll(str, coll, ...)
   else if (!missing(charclass))
      stri_locate_all_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")
}


#' @title
#' Locate First Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_first_regex}},
#' \code{\link{stri_locate_first_fixed}},
#' \code{\link{stri_locate_first_coll}},
#' or \code{\link{stri_locate_first_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' Please note that the parameters are considered in the following order:
#' \code{regex}, \code{fixed}, \code{coll}, and \code{class}.
#' Thus, if you specify \code{regex} and \code{class},
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
stri_locate_first <- function(str, ..., regex, fixed, coll, charclass) {
   if (!missing(regex))
      stri_locate_first_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_locate_first_fixed(str, fixed, ...)
   else if (!missing(coll))
      stri_locate_first_coll(str, coll, ...)
   else if (!missing(charclass))
      stri_locate_first_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")
}


#' @title
#' Locate Last Occurrence of a Pattern
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_last_regex}},
#' \code{\link{stri_locate_last_fixed}},
#' \code{\link{stri_locate_last_coll}},
#' or \code{\link{stri_locate_last_charclass}},
#' depending on the argument used.
#'
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#'
#' @details
#' Unless you are very lazy, please call the underlying functions
#' directly for better performance.
#'
#' Please note that the parameters are considered in the following order:
#' \code{regex}, \code{fixed}, \code{coll}, and \code{class}.
#' Thus, if you specify \code{regex} and \code{class},
#' only the first one will be used.
#'
#' @return Returns an integer matrix with two columns, with
#' double \code{NA}s in a row if a pattern has not been found.
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
stri_locate_last <- function(str, ..., regex, fixed, coll, charclass) {
   if (!missing(regex))
      stri_locate_last_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_locate_last_fixed(str, fixed, ...)
   else if (!missing(coll))
      stri_locate_last_coll(str, coll, ...)
   else if (!missing(charclass))
      stri_locate_last_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, `coll`, or `charclass`")
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
#' @param coll character vector; canonically equivalent patterns
#' @param charclass character vector; identifiers of character classes
#' @param mode single string; whether to look for all, or only the first/last
#'             occurrence of the pattern
#'
#' @return The return value is the same as that of the underlying
#' functions called, i.e. a two-column matrix or a list of matrices.
#'
#'
#' @export
#' @family search_locate
#' @family indexing
stri_locate <- function(str, ..., regex, fixed, coll, charclass,
                        mode=c("first", "all", "last")) {
   # `first` is default for compatibility with stringr
   mode <- match.arg(mode) # this is slow

   switch(mode,
      first=stri_locate_first(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass),
      last =stri_locate_last(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass),
      all  =stri_locate_all(str, ..., regex=regex, fixed=fixed, coll=coll, charclass=charclass)
   )
}


#' @title
#' Locate Specific Text Boundaries
#'
#' @description
#' This function locates specific text boundaries
#' (like character, word, line, or sentence boundaries)
#' and splits strings at the indicated positions.
#'
#' @details
#' Vectorized over \code{str} and \code{boundary}.
#'
#' For more information on the text boundary analysis
#' performed by \pkg{ICU}'s \code{BreakIterator}, see
#' \code{\link{stri_locate_boundaries}}.
#'
#' For locating words in a text using \pkg{ICU}'s word iterator,
#' see \code{\link{stri_locate_words}}.
#'
#'
#' @param str character vector or an object coercible to
#' @param boundary character vector, each string is one of \code{character},
#' \code{line-break}, \code{sentence}, or \code{word}
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}.
#'
#' @return
#' A list of \code{max(length(str), length(boundary))} integer matrices
#' is returned. The first column gives the start positions
#' of substrings between located boundaries, and the second column gives
#' the end positions. The indices are code point-based, thus
#' they may be passed e.g. to the \code{\link{stri_sub}} function.
#'
#' Moreover, you may get two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' @examples
#' \dontrun{
#' stri_locate_boundaries("The\u00a0above-mentioned packages are...", boundary='line')
#' }
#'
#' @export
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
#' @family text_boundaries
stri_locate_boundaries <- function(str, boundary='word', locale=NULL) {
   .Call("stri_locate_boundaries", str, boundary, locale, PACKAGE="stringi")
}


#' @title
#' Locate Words in a Text
#'
#' @description
#' This function locates all words in each string.
#'
#' @details
#' Vectorized over \code{str}.
#'
#' Just like in \code{\link{stri_extract_words}},
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
#' A list of integer matrices
#' is returned. The first column gives the start positions
#' of the words, and the second column gives
#' the end positions. The indices are code point-based, thus
#' they may be passed e.g. to the \code{\link{stri_sub}} function.
#'
#' Moreover, you may get two \code{NA}s in one row
#' for no match or \code{NA} arguments.
#'
#' @examples
#' \dontrun{
#' stri_locate_words("  stringi: THE string processing package 123.48...  ")
#' }
#'
#' @references
#' \emph{Boundary Analysis} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/boundaryanalysis}
#'
#' @export
#' @family search_locate
#' @family indexing
#' @family locale_sensitive
#' @family text_boundaries
stri_locate_words <- function(str, locale=NULL) {
   .Call("stri_locate_words", str, locale, PACKAGE="stringi")
}
