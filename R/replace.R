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


#' Replace All Occurences of a Pattern
#' 
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
stri_replace_all_fixed <- function(str, pattern, replacement) {
	# prepare_arg done internally
	.Call("stri_replace_all_fixed", str, pattern, replacement, PACKAGE="stringi")
}


#' Replace First Occurence of a Pattern
#' 
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of patterns to search for
#' @param replacement character vector of strings to replace with
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_first_fixed(s," ","123")
#' stri_replace_first_fixed(s,"o","!!!")
#' 
#' @export
stri_replace_first_fixed <- function(str, pattern, replacement) {
   # prepare_arg done internally
   .Call("stri_replace_first_fixed", str, pattern, replacement, PACKAGE="stringi")
}


#' Replace Last Occurence of a Pattern
#' 
#' 
#' @param str character vector of strings to search in
#' @param pattern character vector of patterns to search for
#' @param replacement character vector of strings to replace with
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_last_fixed(s," ","123")
#' stri_replace_last_fixed(s,"o","!!!")
#' 
#' @export
stri_replace_last_fixed <- function(str, pattern, replacement) {
   # prepare_arg done internally
   warning("TO DO: no stri_reverse call here.....")
   stri_reverse(.Call("stri_replace_first_fixed", stri_reverse(str), pattern, replacement, PACKAGE="stringi"))
}


#' Replace All Occurences of a Regex Pattern
#' 
#' 
#' Replaces every substring of the input that matches the pattern 
#' with the given replacement string. 
#' 
#' The function scans the input string for matches of the pattern. 
#' Input that is not part of any match is left unchanged; 
#' each match is replaced in the result by the replacement string. 
#' The replacement string may contain references to capture groups.
#' References are of the form \code{$n}, where n is the number of the capture group.
#' 
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
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
#' 
#' @export
#' @family regex
stri_replace_all_regex <- function(str, pattern, replacement) {
   # prepare_arg done internally
   .Call("stri_replace_all_regex", str, pattern, replacement, PACKAGE="stringi")
}


#' Replace All Occurences of a Pattern
#' 
#' 
#' Replaces every substring of the input that matches the pattern 
#' with the given replacement string. 
#' 
#' The function scans the input string for matches of the pattern. 
#' Input that is not part of any match is left unchanged; 
#' each match is replaced in the result by the replacement string. 
#' The replacement string may contain references to capture groups.
#' References are of the form \code{$n}, where n is the number of the capture group.
#' 
#' Vectorized over \code{str}, \code{pattern}, and \code{replacement}.
#' 
#' @param str character vector of strings to search in
#' @param regex character vector of regex patterns to search for
#' @param replacement character vector of strings to replace with
#' @param fixed character vector of patterns to search for
#' @param charclass character class identifiers specified by
#' \code{\link{stri_char_getpropertyid}} or \code{\link{stri_char_getcategoryid}}
#' @return character vector
#' 
#' @examples
#' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
#' stri_replace_all(s, " .*? ", "#")
#' stri_replace_all(s, "(el|s)it", "1234")
#' stri_replace_all('abaca', 'a', c('!', '*'))
#' stri_replace_all('123|456|789', '(\\p{N}).(\\p{N})', '$2-$1')
#' stri_replace_all('aaabbaabab', fixed='ab', replacement='***')
#' #delete all lowercase letters
#' stri_replace_all(s, charclass=stri_char_getcategoryid("Ll"), replacement='')
#' 
#' @export
#' @family regex, search
stri_replace_all <- function(str, regex, replacement, fixed, charclass) {
   #TODO: determine which order of arguments is more natural == easier to use
   if(!missing(regex))
      .Call("stri_replace_all_regex", str, regex, replacement, PACKAGE="stringi")
   else if(!missing(fixed))
      .Call("stri_replace_all_fixed", str, fixed, replacement, PACKAGE="stringi")
   else if(!missing(charclass))
      .Call("stri_replace_all_class", str, charclass, replacement, PACKAGE="stringi")
   else
      #TODO: maybe create a macro which contains text of this error? 
      #It would be use in at least three or four functions
      error("You have specify at least one of regex, fixed and charclass")
}
