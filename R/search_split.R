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
#' Split up a String by a Character Class
#'
#' @description
#' Splits each element of \code{str} into substrings.
#' \code{pattern} indicates delimiters that separate
#' the input into fields. The input data between the matches become
#' the fields themselves.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max}, and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector; identifiers of character classes,
#' see \link{stringi-search-charclass}
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; should empty strings be removed from result?
#' 
#' @return Returns a list of character vectors.
#'
#'
#' @examples
#' stri_split_charclass("Lorem ipsum dolor sit amet", "WHITE_SPACE")
#' stri_split_charclass(" Lorem  ipsum dolor", "WHITE_SPACE", n=3, omit_empty=c(FALSE, TRUE))
#'
#' @export
#' @rdname stri_split_charclass
#' @aliases stri_split_charclass
#' @family search_charclass
#' @family search_split
stri_split_charclass <- function(str, pattern, n_max=-1L, omit_empty=FALSE) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   .Call("stri_split_charclass", str, pattern, n_max, omit_empty, PACKAGE="stringi")
}


#' @title
#' Split up a String By Regex Pattern Matches
#'
#' @description
#' Splits each element of \code{str} into substrings.
#' \code{pattern} indicates delimiters that separate
#' the input into fields. The input data between the matches become
#' the fields themselves.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max}, and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#' 
#'
#' @param str character vector with strings to search in
#' @param pattern pattern character; regular expressions
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; should empty strings be removed from result?
#' @param opts_regex a named list as generated with \code{\link{stri_opts_regex}}
#' 
#' @return Returns a list of character vectors.
#'
#'
#' @examples
#' stri_split_regex("Lorem ipsum dolor sit amet", "\\p{Z}+")
#'
#' @export
#' @rdname stri_split_regex
#' @aliases stri_split_regex
#' @family search_regex
#' @family search_split
stri_split_regex <- function(str, pattern, n_max=-1L, omit_empty=FALSE, opts_regex=list())  {
   # omit_empty defaults to FALSE for compatibility with the stringr package
   .Call("stri_split_regex", str, pattern, n_max, omit_empty, opts_regex, PACKAGE="stringi")
}


#' @title
#' Split up a String By Fixed Pattern Matches
#'
#' @description
#' Splits each element of \code{str} into substring.
#' \code{pattern} indicates delimiters that separate
#' the input into fields. The input data between the matches become
#' the fields themselves.
#'
#' @details
#' Vectorized over \code{str}, \code{pattern}, \code{n_max}, and \code{omit_empty}.
#'
#' If \code{n_max} is negative (default), then all pieces are extracted.
#'
#' \code{omit_empty} is applied during splitting: if set to \code{TRUE},
#' then empty strings will never appear in the resulting vector.
#'
#'
#' Pass \code{opts_collator} equal to \code{NA} for much faster, but
#' locale unaware, (exact) byte comparisons. For natural language text
#' this may be not what you really want.
#'
#' @param str character vector with strings to search in
#' @param pattern character vector with fixed patterns
#' @param n_max integer vector, maximal number of pieces to return
#' @param omit_empty logical vector; should empty strings be removed from result?
#' @param opts_collator a named list as generated with \code{\link{stri_opts_collator}}
#' with Collator options, or \code{NA} for fast but locale-unaware byte comparison
#' 
#' @return Returns a list of character vectors.
#'
#'
#' @examples
#' stri_split_fixed("Lorem ipsum dolor sit amet", " ")
#'
#' @export
#' @rdname stri_split_fixed
#' @aliases stri_split_fixed
#' @family search_fixed
#' @family search_split
#' @family locale_sensitive
stri_split_fixed <- function(str, pattern, n_max=-1L, omit_empty=FALSE, opts_collator=list()) {
   # omit_empty defaults to FALSE for compatibility with the stringr package
	.Call("stri_split_fixed", str, pattern, n_max, omit_empty, opts_collator, PACKAGE="stringi")
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
#' @param str character vector of strings to be split
#' @param ... additional arguments passed to the underlying functions
#' @param regex character vector; regular expressions
#' @param fixed character vector; fixed patterns
#' @param charclass character vector; identifiers of character classes
#' 
#' @return Returns a list of character vectors.
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
