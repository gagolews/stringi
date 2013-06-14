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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with 'stringi'. If not, see <http://www.gnu.org/licenses/>.



#' @title
#' Split up Each String By Elements of Given Character Class
#' 
#' @description
#' Splits each element of \code{str} into substrings.
#' \code{pattern} indicates delimiters that separate 
#' the input into fields. The input data between the matches becomes 
#' the fields themselves.
#' 
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{n}.
#' 
#' If \code{n} is negative (default), then all pieces are extracted.
#' 
#' \code{omit_empty} is applied after splitting.
#' 
#' @param str character vector with strings to search in
#' @param pattern character vector with character class identifiers 
#' to search for, see \link{stringi-search-charclass}
#' @param n integer vector, maximal number of pieces to return
#' @param omit_empty single logical value; should empty strings be removed from result?
#' @return a list of character vectors
#' 
#' 
#' @examples
#' stri_split_charclass("Lorem ipsum dolor sit amet", "WHITE_SPACE")
#' stri_split_charclass("Lorem  ipsum dolor", "WHITE_SPACE", n=3, omit_empty=TRUE) # note
#' 
#' @export
#' @rdname stri_split_charclass
#' @aliases stri_split_charclass
#' @family search_charclass
#' @family search_split
stri_split_charclass <- function(str, pattern, n=-1L, omit_empty=FALSE) {
   ret <- .Call("stri_split_charclass", str, pattern, n, PACKAGE="stringi")
   if (!identical(omit_empty, FALSE))
      lapply(ret, function(x) x[!stri_isempty(x)])
   else
      ret
}


#' @title
#' Split up Each String By Given Regex Pattern Matches
#' 
#' @description
#' Splits each element of \code{str} into substring.
#' \code{pattern} indicates delimiters that separate 
#' the input into fields. The input data between the matches becomes 
#' the fields themselves.
#' 
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{n}.
#' 
#' If \code{n} is negative (default), then all pieces are extracted.
#' 
#' @param str character vector with strings to search in
#' @param pattern character vector with regex patterns
#' @param n integer vector, maximal number of pieces to return
#' @return a list of character vectors
#' 
#' 
#' @examples
#' stri_split_charclass("Lorem ipsum dolor sit amet", "WHITE_SPACE")
#' 
#' @export
#' @rdname stri_split_regex
#' @aliases stri_split_regex
#' @family search_regex
#' @family search_split
stri_split_regex <- function(str, pattern, n=-1L) {
   .Call("stri_split_regex", str, pattern, n, PACKAGE="stringi")
}


#' @title
#' Split up Each String By Elements of Given Character Class
#' 
#' @description
#' Splits each element of \code{str} into substring.
#' \code{pattern} indicates delimiters that separate 
#' the input into fields. The input data between the matches becomes 
#' the fields themselves.
#' 
#' @details
#' Vectorized over \code{str}, \code{pattern}, and \code{n}.
#' 
#' If \code{n} is negative (default), then all pieces are extracted.
#' 
#' 
#' @param str character vector with strings to search in
#' @param pattern character vector with patterns
#' @param n integer vector, maximal number of pieces to return
#' @param collator_opts a named R list as generated with \code{\link{stri_collator_genopts}}
#' with Collator's options, or \code{NA} for dummy byte comparison
#' @return a list of character vectors
#' 
#' 
#' @examples
#' stri_split_charclass("Lorem ipsum dolor sit amet", "WHITE_SPACE")
#' 
#' @export
#' @rdname stri_split_fixed
#' @aliases stri_split_fixed
#' @family search_fixed
#' @family search_split
#' @family locale_sensitive
stri_split_fixed <- function(str, pattern, n=-1L, collator_opts=list()) {
	.Call("stri_split_fixed", str, split, n, collator_opts, PACKAGE="stringi")
}



# @TODO: ADD stri_split_chars - split into chars
# @TODO: ADD stri_split_pos




#' @title
#' Split a String Into Fields
#' 
#' @description
#' A convenience function.
#' Calls either \code{\link{stri_split_regex}},
#' \code{\link{stri_split_fixed}}, or \code{\link{stri_split_charclass}},
#' depending on the argument used.
#' 
#' 
#' @param str character vector of strings to be splitted
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector of regex patterns to search for
#' @param fixed character vector of fixed patterns to search for
#' @param charclass character class identifiers
#' @return logical vector
#' 
#' 
#' @export
#' @family search_split
stri_split <- function(str, ..., regex, fixed, charclass) {
   if (!missing(regex))
      stri_split_regex(str, regex, ...)
   else if (!missing(fixed))
      stri_split_fixed(str, fixed, ...)
   else if (!missing(charclass))
      stri_split_charclass(str, charclass, ...)
   else
      stop("you have to specify either `regex`, `fixed`, or `charclass`")
}




# #' Split the elements of a character vector by position
# #' 
# #' 
# #' @param str character vector to split
# #' @param split character element
# #' @param from integer vector
# #' @param to integer vector
# #' @return A list of the same length as the longest of vectors: str, split and omitempty. Shorter vectors are recycled. The i-th element of list contains splitted str[i] character vectors
# #' 
# #' @examples
# #' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
# #' stri_split_pos(s,c(1,4),c(3,6))
# #' 
# #' @export
# stri_split_pos <- function(str, from, to) {
# #    if(is.matrix(from) && ncol(from) == 2){
# #       if(!missing(to))
# #          warning("'from' is matrix, so 'to' is ignored")
# #       to   <- from[ , 2]
# #       from <- from[ , 1]
# #    }
# #    .Call("stri_split_pos", str, from, to, PACKAGE="stringi")
# }

