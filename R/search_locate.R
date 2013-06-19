## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus, Marcin Bujarski
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.


#' @title
#' Locate Occurences of a Character Class
#'
#' @description
#' These functions may be used e.g. to find the indices, at which
#' we find letters, digits, or whitespaces in a given string.
#' 
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{merge}.
#' 
#' @param str character vector to search in
#' @param pattern character vector with character class identifiers, see \link{stringi-search-charclass}
#' @param merge logical [\code{stri_locate_all_charclass} only];
#' should consecutive sequences of indices in resulting
#' matrix be merged?
#'    
#' @return
#' For \code{stri_locate_all_charclass},
#' list of \code{max(length(str), length(pattern))} integer matrices.
#' The first column gives start postions
#' of matches, and the second column gives end position.
#' Two \code{NA}s for no match or \code{NA} arguments.
#' 
#' For \code{stri_locate_first_charclass} and \code{stri_locate_last_charclass},
#' integer matrix with \code{max(length(str), length(pattern))} rows, 
#' and two columns, giving the start and end positions of first
#' or last matches, respectively, and two \code{NA}s iff not found.
#' Note that the first column is always equal to the same column, as
#' we look for single code points in these two cases.
#' 
#' @examples
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll')
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), 'Ll', merge=FALSE)
#' stri_locate_first_charclass('AaBbCc', 'Ll')
#' stri_locate_last_charclass('AaBbCc', 'Ll')
#' stri_locate_all_charclass(c('REXAMINE'), 'Lu', merge=c(T,F))
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
#' Locate Occurences of a Fixed Pattern
#'
#' @description
#' ...
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
#' TO DO: ....Note the difference between  \code{stri_locate_last_fixed}
#' and \code{stri_locate_last_fixed} for overlapping pattern matches....
#' In \code{stri_locate_last_fixed}, search is done from-the-end.
#' 
#' @param str character vector
#' @param pattern character vector
#' @param opts_collator a named R list as generated with \code{\link{stri_opts_collator}}
#' with Collator's options, or \code{NA} for dummy byte comparison
#' 
#' @return
#' For \code{stri_locate_all_fixed},
#' list of \code{max(length(str), length(pattern))} integer matrices.
#' The first column gives start postions
#' of matches, and the second column gives end position.
#' Two \code{NA}s for no match.
#' 
#' For \code{stri_locate_first_fixed} and \code{stri_locate_last_fixed},
#' integer matrix with \code{max(length(str), length(pattern))} rows, 
#' and two columns, giving the start and end positions of first
#' or last matches, respectively, and \code{NA}s iff not found.
#' 
#' @examples
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
#' Locate Occurences of a Regex Pattern
#' 
#' @description
#' ...
#' 
#' 
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' @param opts_regex a named R list as generated with \code{\link{stri_opts_regex}}
#' 
#' @return
#' For \code{stri_locate_all_regex},
#' list of \code{max(length(str), length(pattern))} integer matrices.
#' The first column gives start postions
#' of matches, and the second column gives end position.
#' Two \code{NA}s for no match.
#' 
#' For \code{stri_locate_first_regex} and \code{stri_locate_last_regex},
#' integer matrix with \code{max(length(str), length(pattern))} rows, 
#' and two columns, giving the start and end positions of first
#' or last matches, respectively, and \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_first_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_last_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
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
#' Locate All Occurences of a Regex Pattern, Fixed Patter or Character Class
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_all_regex}},
#' \code{\link{stri_locate_all_fixed}}, or \code{\link{stri_locate_all_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' 
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Double \code{NA}s iff not found or \code{NA} argument is given.
#' 
#' @examples
#' stri_locate_all('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_all('Bartolini', fixed='i')
#' stri_locate_all(s, charclass='Zs') # all whitespaces
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
#' Locate First Occurence of a Regex Pattern, Fixed Patter or Character Class
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_first_regex}},
#' \code{\link{stri_locate_first_fixed}}, or \code{\link{stri_locate_first_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' 
#' @return integer matrix with two columns,
#' double \code{NA}s if not found.
#' 
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_first('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_first('Bartolini', fixed=letters[1:3])
#' stri_locate_first(s, charclass='Zs')
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
#' Locate Last Occurence of a Regex Pattern, Fixed Patter or Character Class
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_last_regex}},
#' \code{\link{stri_locate_last_fixed}}, or \code{\link{stri_locate_last_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' 
#' @return integer matrix with two columns,
#' double \code{NA}s if not found.
#' 
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_last('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_last('Bartolini', fixed=letters[1:3])
#' stri_locate_last(s, charclass='Zs')
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
#' Locate Occurences of a Regex Pattern, Fixed Patter or Character Class
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_locate_all}},
#' \code{\link{stri_locate_first}}, or \code{\link{stri_locate_last}},
#' depending on the argument used.
#' Note that this is slower than the direct call.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' @param mode string; whether to look for all, or only the first/last
#'             occurence of the pattern
#' 
#' @return same as the underlying functions called, i.e.
#' a 2-column matrix or a list of matrices.
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

