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


#' Locate Occurences of a Character Class
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' @param merge logical [\code{stri_locate_all_charclass} only];
#' should consecutive sequences of indices in resulting
#' matrix be merged?
#'    
#' @return
#' For \code{stri_locate_all_charclass},
#' list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' \code{NA}s for no match.
#' 
#' For \code{stri_locate_first_charclass} and \code{stri_locate_last_charclass},
#' Integer matrix with n rows, where n is the length of \code{str},
#' and 2 columns, giving the start and end positions of first
#' or last matches, respectively, and \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), stri_char_getcategoryid('Ll'))
#' stri_locate_all_charclass(c('AbcdeFgHijK', 'abc', 'ABC'), stri_char_getcategoryid('Ll'), merge=TRUE)
#' stri_locate_first_charclass('AaBbCc', stri_char_getcategoryid('Ll'))
#' stri_locate_last_charclass('AaBbCc', stri_char_getcategoryid('Ll'))
#' 
#' @export
#' @rdname stri_locate_charclass 
#' @aliases stri_locate_all_charclass stri_locate_first_charclass stri_locate_last_charclass
#' @family search_charclass 
#' @family search_locate
#' @family indexing
stri_locate_all_charclass <- function(str, pattern, merge=FALSE) {
   ret <- .Call("stri_locate_all_class", str, pattern, PACKAGE="stringi")
   merge <- identical(merge, TRUE)
   
   if (merge) return(ret)
   else return(lapply(ret, function(m) {
      if (is.na(m[1,1])) return(m)
      idx <- unlist(apply(m, 1, function(k) k[1]:k[2]))
      matrix(idx, ncol=2, nrow=length(idx),
             dimnames=list(NULL,c('start', 'end')))
   }))
}


#' @export
#' @rdname stri_locate_charclass
stri_locate_first_charclass <- function(str, pattern) {
   ret <- .Call("stri_locate_first_or_last_class", str, pattern, TRUE, PACKAGE="stringi")
   matrix(ret, ncol=2, nrow=length(ret),
      dimnames=list(NULL,c('start', 'end')))
}


#' @export
#' @rdname stri_locate_charclass
stri_locate_last_charclass <- function(str, pattern) {
   ret <- .Call("stri_locate_first_or_last_class", str, pattern, FALSE, PACKAGE="stringi")
   matrix(ret, ncol=2, nrow=length(ret),
      dimnames=list(NULL,c('start', 'end')))
}


#' Locate Occurences of a Fixed Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector
#' @param pattern character vector
#' 
#' @return
#' For \code{stri_locate_all_fixed},
#' list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' \code{NA}s for no match.
#' 
#' For \code{stri_locate_first_fixed} and \code{stri_locate_last_fixed},
#' Integer matrix with n rows, where n is the length of \code{str},
#' and 2 columns, giving the start and end positions of first
#' or last matches, respectively, and \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
#' stri_locate_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' stri_locate_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' 
#' @export
#' @rdname stri_locate_fixed
#' @aliases stri_locate_all_fixed, stri_locate_first_fixed, stri_locate_last_fixed
#' @family search_fixed
#' @family search_locate
#' @family indexing
stri_locate_all_fixed <- function(str, pattern) {
   .Call("stri_locate_all_fixed", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_fixed
stri_locate_first_fixed <- function(str, pattern) {
   .Call("stri_locate_first_or_last_fixed", str, pattern, TRUE, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_fixed
stri_locate_last_fixed <- function(str, pattern) {
   .Call("stri_locate_first_or_last_fixed", str, pattern, FALSE, PACKAGE="stringi")
}


#' Locate Occurences of a Regex Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' 
#' @return
#' For \code{stri_locate_all_regex},
#' list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' \code{NA}s for no match.
#' 
#' For \code{stri_locate_first_regex} and \code{stri_locate_last_regex},
#' Integer matrix with n rows, where n is the length of \code{str},
#' and 2 columns, giving the start and end positions of first
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
stri_locate_all_regex <- function(str, pattern) {
   .Call("stri_locate_all_regex", str, pattern, PACKAGE="stringi")
}


#' @export
#' @rdname stri_locate_regex 
stri_locate_first_regex <- function(str, pattern) {
   .Call("stri_locate_first_regex", str, pattern, PACKAGE="stringi")
}



#' @export
#' @rdname stri_locate_regex 
stri_locate_last_regex <- function(str, pattern) {
   stop("TO DO")
#    .Call("stri_locate_last_regex", str, pattern, PACKAGE="stringi")
}



#' Locate All Occurences of a Regex Pattern, Fixed Patter or Character Class
#'
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
#' \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_all('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_all('Bartolini', fixed='i')
#' stri_locate_all(s, charclass=stri_char_getcategoryid('Zs')) # all whitespaces
#' 
#' @export
#' @family search_locate
#' @family indexing
stri_locate_all <- function(str, ..., regex, fixed, charclass) {
   if(!missing(regex))
      stri_locate_all_regex(str, regex, ...)
   else if(!missing(fixed))
      stri_locate_all_fixed(str, fixed, ...)
   else if(!missing(charclass))
      stri_locate_all_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' Locate First Occurence of a Regex Pattern, Fixed Patter or Character Class
#'
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
#' @return integer matrix with n rows, where n is the length of \code{str}.  
#' First column gives start postions of matches, and second column gives end position.
#' \code{NA}s iff not found.
#' 
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_first('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_first('Bartolini', fixed=letters[1:3])
#' stri_locate_first(s, charclass=stri_char_getcategoryid('Zs'))
#' 
#' @export
#' @family search_locate
#' @family indexing
stri_locate_first <- function(str, ..., regex, fixed, charclass) {
   if(!missing(regex))
      stri_locate_first_regex(str, regex, ...)
   else if(!missing(fixed))
      stri_locate_first_fixed(str, fixed, ...)
   else if(!missing(charclass))
      stri_locate_first_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' Locate Last Occurence of a Regex Pattern, Fixed Patter or Character Class
#'
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
#' @return integer matrix with n rows, where n is the length of \code{str}.  
#' First column gives start postions of matches, and second column gives end position.
#' \code{NA}s iff not found.
#' 
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_last('XaaaaX', regex=c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_last('Bartolini', fixed=letters[1:3])
#' stri_locate_last(s, charclass=stri_char_getcategoryid('Zs'))
#' 
#' @export
#' @family search_locate
#' @family indexing
stri_locate_last <- function(str, ..., regex, fixed, charclass) {
   if(!missing(regex))
      stri_locate_last_regex(str, regex, ...)
   else if(!missing(fixed))
      stri_locate_last_fixed(str, fixed, ...)
   else if(!missing(charclass))
      stri_locate_last_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}



#' Locate Occurences of a Regex Pattern, Fixed Patter or Character Class
#'
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
#' a 2-column matrix or list of matrices.
#' 
#' 
#' @export
#' @family search_locate
#' @family indexing
stri_locate <- function(str, ..., regex, fixed, charclass, 
                        mode=c("all", "first", "last")) {
   mode <- match.arg(mode) # this is slow
   
   switch(mode,
      first=stri_locate_first(str, ..., regex=regex, fixed=fixed, charclass=charclass),
      last =stri_locate_last(str, ..., regex=regex, fixed=fixed, charclass=charclass),
      all  =stri_locate_all(str, ..., regex=regex, fixed=fixed, charclass=charclass)
   )
}

