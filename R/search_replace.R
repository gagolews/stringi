## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus
##
##
## 'stringi' is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## 'stringi' is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' Replace Occurences of a Character Class
#' 
#' Replaces with the given replacement string every/first/last
#' character class occurence in the input string.
#' 
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#' 
#' The function scans the input string for matches of the character class. 
#' Input that is not part of any match is left unchanged; 
#' each match is replaced in the result by the replacement string. 
#' 
#' @param str character vector of strings to search in
#' @param pattern character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' @param replacement character vector of strings to replace with
#' @return character vector
#' 
#' @export
#' @rdname stri_replace_charclass
#' @aliases stri_replace_all_charclass stri_replace_first_charclass stri_replace_last_charclass
#' @family search_charclass
#' @family search_replace
stri_replace_all_charclass <- function(str, pattern, replacement) {
   stop("TO DO")
}


#' @export
#' @rdname stri_replace_charclass
stri_replace_first_charclass <- function(str, pattern, replacement) {
   stop("TO DO")
}


#' @export
#' @rdname stri_replace_charclass
stri_replace_last_charclass <- function(str, pattern, replacement) {
   stop("TO DO")
}



#' Replace Occurences of a Fixed Pattern
#' 
#' Replaces with the given replacement string every/first/last
#' substring of the input that matches the pattern.
#' 
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#' 
#' The function scans the input string for matches of the pattern. 
#' Input that is not part of any match is left unchanged; 
#' each match is replaced in the result by the replacement string. 
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of patterns to search for
#' @param replacement character vector of strings to replace with
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all_fixed(s," ","#")
#' stri_replace_all_fixed(s,"o","0")
#' 
#' @export
#' @rdname stri_replace_fixed
#' @aliases stri_replace_all_fixed stri_replace_first_fixed stri_replace_last_fixed
#' @family search_fixed
#' @family search_replace
#' @family locale_sensitive
stri_replace_all_fixed <- function(str, pattern, replacement) {
	.Call("stri_replace_all_fixed", str, pattern, replacement, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_fixed
stri_replace_first_fixed <- function(str, pattern, replacement) {
   .Call("stri_replace_first_fixed", str, pattern, replacement, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_fixed
stri_replace_last_fixed <- function(str, pattern, replacement) {
   stop("TO DO: no stri_reverse call here.....")
   stri_reverse(.Call("stri_replace_first_fixed", stri_reverse(str), pattern, replacement, PACKAGE="stringi"))
}


#' Replace Occurences of a Regex Pattern
#' 
#' 
#' Replaces with the given replacement string every/first/last
#' substring of the input that matches the pattern.
#' 
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#' 
#' The function scans the input string for matches of the pattern. 
#' Input that is not part of any match is left unchanged; 
#' each match is replaced in the result by the replacement string. 
#' 
#' The replacement string may contain references to capture groups.
#' References are of the form \code{$n}, where \code{n} is the number
#' of the capture group (numbering starts from 1).
#' 
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of regex patterns to search for
#' @param replacement character vector of strings to replace with
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all_regex(s, " .*? ", "#")
#' stri_replace_all_regex(s, "(el|s)it", "1234")
#' stri_replace_all_regex('abaca', 'a', c('!', '*'))
#' stri_replace_all_regex('123|456|789', '(\\p{N}).(\\p{N})', '$2-$1')
#' stri_replace_all_regex(c("stringi w R","REXAMINE","123"), '( R|R.)', ' r ')
#'  
#' @export
#' @rdname stri_replace_regex
#' @aliases stri_replace_all_regex stri_replace_first_regex stri_replace_last_regex
#' @family search_regex
#' @family search_replace
stri_replace_all_regex <- function(str, pattern, replacement) {
   .Call("stri_replace_all_regex", str, pattern, replacement, PACKAGE="stringi")
}


#' @export
#' @rdname stri_replace_regex
stri_replace_first_regex <- function(str, pattern, replacement) {
   stop("TO DO")
}


#' @export
#' @rdname stri_replace_regex
stri_replace_last_regex <- function(str, pattern, replacement) {
   stop("TO DO")
}



#' Replace All Occurences of a Pattern
#' 
#' 
#' A convenience function.
#' Calls either \code{\link{stri_replace_all_regex}},
#' \code{\link{stri_replace_all_fixed}}, or \code{\link{stri_replace_all_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
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


#' Replace First Occurence of a Pattern
#' 
#' 
#' A convenience function.
#' Calls either \code{\link{stri_replace_first_regex}},
#' \code{\link{stri_replace_first_fixed}}, or \code{\link{stri_replace_first_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
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



#' Replace Last Occurence of a Pattern
#' 
#' 
#' A convenience function.
#' Calls either \code{\link{stri_replace_last_regex}},
#' \code{\link{stri_replace_last_fixed}}, or \code{\link{stri_replace_last_charclass}},
#' depending on the argument used.
#' 
#' @param str character vector of strings to search in
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
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



#' Replace Occurences of a Regex Pattern, Fixed Patter or Character Class
#'
#' A convenience function.
#' Calls either \code{\link{stri_replace_all}},
#' \code{\link{stri_replace_first}}, or \code{\link{stri_replace_last}},
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

