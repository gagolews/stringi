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
#' Extract Character Class Matches
#'
#' @description
#' These functions extract substrings of \code{str} that
#' match a given \code{pattern}.
#' 
#' This is the way to extract single characters, only.
#' The only case when longer substrings may be extracted,
#' is the \code{stri_extract_all_charclass} function
#' with \code{merge=TRUE}.
#' 
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{merge}.
#' 
#' @param str character vector to search in
#' @param pattern character vector with character class identifiers, see \link{stringi-search-charclass}
#' @param merge logical [\code{stri_extract_all_charclass} only];
#' should consecutive matches be merged into one string?
#'    
#' @return
#' For \code{stri_extract_all_charclass},
#' list of \code{max(length(str), length(pattern), length(merge))} character vectors.
#' Otherwise, a character vector.
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
#' @param str character vector
#' @param pattern character vector
#' @param collator_opts a named R list as generated with \code{\link{stri_collator_genopts}}
#' with Collator's options, or \code{NA} for dummy byte comparison
#' 
#' @return
#' For \code{stri_extract_all_fixed},
#' list of \code{max(length(str), length(pattern))} character vectors.
#' Otherwise, a character vector.
#' \code{NA} if not found.
#' 
#' @examples
#' stri_extract_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_extract_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' stri_extract_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' 
#' @export
#' @rdname stri_extract_fixed
#' @aliases stri_extract_all_fixed, stri_extract_first_fixed, stri_extract_last_fixed
#' @family search_fixed
#' @family search_locate
#' @family search_extract
stri_extract_all_fixed <- function(str, pattern, collator_opts=list()) {
   stop("TO DO")
#    .Call("stri_extract_all_fixed", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_fixed
stri_extract_first_fixed <- function(str, pattern, collator_opts=list()) {
   stop("TO DO")
#    .Call("stri_extract_first_fixed", str, pattern, TRUE, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_fixed
stri_extract_last_fixed <- function(str, pattern, collator_opts=list()) {
   stop("TO DO")
#    .Call("stri_extract_last_fixed", str, pattern, FALSE, PACKAGE="stringi")
}


#' @title
#' Extract Regex Pattern Matches
#'
#' @description
#' These functions extract substrings of \code{str} that
#' match a given \code{pattern}.
#' 
#' @details
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' 
#' @return
#' For \code{stri_extract_all_regex},
#' list of \code{max(length(str), length(pattern))} character vectors.
#' Otherwise, a character vector.
#' \code{NA} if not found.
#' 
#' @examples
#' stri_extract_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_first_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_last_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' 
#' @export
#' @rdname stri_extract_regex 
#' @aliases stri_extract_all_regex stri_extract_first_regex stri_extract_last_regex
#' @family search_regex
#' @family search_extract
stri_extract_all_regex <- function(str, pattern) {
   stop("TO DO")
#    .Call("stri_extract_all_regex", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_extract_regex 
stri_extract_first_regex <- function(str, pattern) {
   stop("TO DO")
#    .Call("stri_extract_first_regex", str, pattern, PACKAGE="stringi")
}



#' @export
#' @rdname stri_extract_regex 
stri_extract_last_regex <- function(str, pattern) {
   stop("TO DO")
   #    .Call("stri_extract_last_regex", str, pattern, PACKAGE="stringi")
}



#' @title
#' Extract All Regex Pattern, Fixed Pattern, or Character Class Matches
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_all_regex}},
#' \code{\link{stri_extract_all_fixed}}, or \code{\link{stri_extract_all_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' 
#' @return list of character vectors
#' 
#' @examples
#' stri_extract_all('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_all('Bartolini', fixed='i')
#' stri_extract_all(s, charclass='Zs') # all whitespaces
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
#' Extract First Regex Pattern, Fixed Pattern, or Character Class Match
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_first_regex}},
#' \code{\link{stri_extract_first_fixed}}, or \code{\link{stri_extract_first_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' 
#' @return character vector
#' 
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_extract_first('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_first('Bartolini', fixed=letters[1:3])
#' stri_extract_first(s, charclass='Zs')
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
#' Extract Last Regex Pattern, Fixed Pattern, or Character Class Match
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_last_regex}},
#' \code{\link{stri_extract_last_fixed}}, or \code{\link{stri_extract_last_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' 
#' @return character vector
#' 
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_extract_last('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_extract_last('Bartolini', fixed=letters[1:3])
#' stri_extract_last(s, charclass='Zs')
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
#' Extract Regex Pattern, Fixed Patter or Character Class Matches
#'
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_extract_all}},
#' \code{\link{stri_extract_first}}, or \code{\link{stri_extract_last}},
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
#' a character vector or a list of character vectors.
#' 
#' 
#' @export
#' @family search_locate
#' @family indexing
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
