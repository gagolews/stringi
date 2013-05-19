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


#' Locate All Occurences of a Character Class
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param class character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' @param merge logical; should consecutive sequences of characters be merged?
#'    
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' Consecutive sequences of characters from a class are not merged by default.
#' \code{NA}s for no match.
#' 
#' @examples
#' stri_locate_all_class(c('AbcdeFgHijK', 'abc', 'ABC'), stri_char_getcategoryid('Ll'))
#' stri_locate_all_class(c('AbcdeFgHijK', 'abc', 'ABC'), stri_char_getcategoryid('Ll'), merge=TRUE)
#' 
#' @export
#' @family charclass
stri_locate_all_class <- function(str, class, merge=FALSE) {
   ret <- .Call("stri_locate_all_class", str, class, PACKAGE="stringi")
   merge <- identical(merge, TRUE)
   
   if (merge) return(ret)
   else return(lapply(ret, function(m) {
      if (is.na(m[1,1])) return(m)
      idx <- unlist(apply(m, 1, function(k) k[1]:k[2]))
      matrix(idx, ncol=2, nrow=length(idx),
             dimnames=list(NULL,c('start', 'end')))
   }))
}


#' Locate First Occurence of a Character Class
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param class character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#'    
#' @return Integer matrix with n rows, where n is the length of \code{str},
#' and 2 columns, giving the start and end positions of each match
#' and \code{NA}s iff not found.
#' Note that it always holds \code{start == end}.
#' 
#' @examples
#' stri_locate_first_class('AaBbCc', stri_char_getcategoryid('Ll'))
#' stri_locate_first_class('AbcdeF', stri_char_getcategoryid('Ll'))
#' 
#' @export
#' @family charclass
stri_locate_first_class <- function(str, class) {
   ret <- .Call("stri_locate_first_or_last_class", str, class, TRUE, PACKAGE="stringi")
   matrix(ret, ncol=2, nrow=length(ret),
      dimnames=list(NULL,c('start', 'end')))
}


#' Locate Last Occurence of a Character Class
#'
#' Vectorized over s and class
#' @param str character vector of strings to search in
#' @param class character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' 
#' @return Integer matrix with n rows, where n is the length of \code{str},
#' and 2 columns, giving the start and end positions of each match
#' and \code{NA}s iff not found.
#' Note that it always holds \code{start == end}.
#' 
#' @examples
#' stri_locate_last_class('AaBbCc', stri_char_getcategoryid('Ll'))
#' stri_locate_last_class('AbcdeF', stri_char_getcategoryid('Ll'))
#' 
#' @export
#' @family charclass
stri_locate_last_class <- function(str, class) {
   ret <- .Call("stri_locate_first_or_last_class", str, class, FALSE, PACKAGE="stringi")
   matrix(ret, ncol=2, nrow=length(ret),
      dimnames=list(NULL,c('start', 'end')))
}


#' Locate All Occurences of a Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector
#' @param pattern character vector
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' \code{NA}s for no match.
#' 
#' @examples
#' stri_locate_all_fixed(c('AaaaaaaA', 'AAAA'), 'a')
#' 
#' @seealso \code{\link{stri_locate_first_fixed}}, \code{\link{stri_locate_last_fixed}}
#' @export
stri_locate_all_fixed <- function(str, pattern) {
   .Call("stri_locate_all_fixed", str, pattern, PACKAGE="stringi")
}


#' Locate First Occurence of a Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector
#' @param pattern character vector
#' @return Integer matrix with n rows, where n is the length of \code{str},
#' and 2 columns, giving the start and end positions of each match
#' and \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_first_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' 
#' @seealso \code{\link{stri_locate_all_fixed}}, \code{\link{stri_locate_last_fixed}}
#' @export
stri_locate_first_fixed <- function(str, pattern) {
   .Call("stri_locate_first_or_last_fixed", str, pattern, TRUE, PACKAGE="stringi")
}


#' Locate Last Occurence of a Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector
#' @param pattern character vector
#' @return Integer matrix with n rows, where n is the length of \code{str},
#' and 2 columns, giving the start and end positions of each match
#' and \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_last_fixed(c('AaaaaaaA', 'aaa', 'AAA'), 'a')
#' 
#' @seealso \code{\link{stri_locate_all_fixed}}, \code{\link{stri_locate_first_fixed}}
#' @export
stri_locate_last_fixed <- function(str, pattern) {
   .Call("stri_locate_first_or_last_fixed", str, pattern, FALSE, PACKAGE="stringi")
}


#' Locate All Occurences of a Regex Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' 
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_all_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' 
#' @export
#' @family regex
stri_locate_all_regex <- function(str, pattern) {
   .Call("stri_locate_all_regex", str, pattern, PACKAGE="stringi")
}


#' Locate First Occurence of a Regex Pattern
#'
#' Vectorized over \code{str} and \code{pattern}.
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' 
#' @return Integer matrix with n rows, where n is the length of \code{str},
#' and 2 columns, giving the start and end positions of each match
#' and \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_first_regex('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' 
#' @export
#' @family regex
stri_locate_first_regex <- function(str, pattern) {
   .Call("stri_locate_first_regex", str, pattern, PACKAGE="stringi")
}


#' Locate All Occurences of a Regex Pattern, Fixed Patter or Character Class
#'
#' Vectorized over \code{str} and \code{regex}, \code{fixed}, \code{charclass}.
#' 
#' @param str character vector of strings to search in
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of patterns to search for
#' @param charclass character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' 
#' @return list of integer matrices.  First column gives start postions
#' of matches, and second column gives end position.
#' \code{NA}s iff not found.
#' 
#' @examples
#' stri_locate_all('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_all('Bartolini', fixed='i')
#' 
#' @export
#' @family regex, search
stri_locate_all <- function(str, regex, fixed, charclass) {
   if(!missing(regex))
      .Call("stri_locate_all_regex", str, regex, PACKAGE="stringi")
   else if(!missing(fixed))
      .Call("stri_locate_all_fixed", str, fixed, PACKAGE="stringi")
   else if(!missing(charclass))
      .Call("stri_locate_all_class", str, charclass, PACKAGE="stringi")
   else
      #TODO: maybe create a macro which contains text of this error? 
      #It would be use in at least three or four functions
      error("You have specify at least one of regex, fixed and charclass")
}



#' Locate First Occurences of a Regex Pattern, Fixed Patter or Character Class
#'
#' Vectorized over \code{str} and \code{regex}, \code{fixed}, \code{charclass}.
#' 
#' @param str character vector of strings to search in
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of patterns to search for
#' @param charclass character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' 
#' @return integer matrix with n rows, where n is the length of \code{str}.  
#' First column gives start postions of matches, and second column gives end position.
#' \code{NA}s iff not found.
#' 
#' @examples
#' s <- 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.'
#' stri_locate_all('XaaaaX', c('\\p{Ll}', '\\p{Ll}+', '\\p{Ll}{2,3}', '\\p{Ll}{2,3}?'))
#' stri_locate_all('Bartolini', fixed=letters[1:3])
#' #locate all white spacess
#' stri_locate_all(s, charclass=stri_char_getcategoryid('Zs'))
#' 
#' @export
#' @family regex, search
stri_locate_first <- function(str, regex, fixed, charclass) {
   if(!missing(regex))
      .Call("stri_locate_first_regex", str, regex, PACKAGE="stringi")
   else if(!missing(fixed))
      .Call("stri_locate_first_or_last_fixed", str, fixed, TRUE, PACKAGE="stringi")
   else if(!missing(charclass))
      .Call("stri_locate_first_class", str, charclass, PACKAGE="stringi")
   else
      #TODO: maybe create a macro which contains text of this error? 
      #It would be use in at least three or four functions
      error("You have specify at least one of regex, fixed and charclass")
}
