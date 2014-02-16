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
#' Count the Number of Bytes
#'
#' @description
#' Counts the number of bytes needed to store
#' all the characters of each string in computer's memory.
#'
#' @details
#' This is often not the function you would normally use
#' in your string processing activities. See rather \code{\link{stri_length}}.
#'
#' For 8-bit encoded strings, this is the same as \code{\link{stri_length}}.
#' For UTF-8 strings, the returned values may be greater
#' than the number of code points, as UTF-8 is not a fixed-byte encoding:
#' one code point may be represented with 1-4 bytes
#' (according to the current Unicode standard).
#'
#' Missing values are handled properly,
#' as opposed to the built-in \code{\link{nchar}(str, "bytes")} function call.
#'
#' The strings do not need to be re-encoded to perform this operation.
#'
#' The returned values does not of course include the trailing NUL bytes,
#' which are used internally to mark the end of string data (in C).
#'
#' @param str character vector
#'
#' @return Returns an integer vector of the same length as \code{str}.
#'
#' @examples
#' stri_numbytes(letters)
#' stri_numbytes(c('abc','123','\u0105\u0104'))
#' \dontrun{
#' # this may fail on Windows, as there is no native support for 4-bytes
#' # Unicode characters; see, however, stri_escape_unicode():
#' stri_numbytes('\U7fffffff') # compare stri_length('\U7fffffff')
#' }
#'
#' @export
#' @family length
stri_numbytes <- function(str) {
   .Call("stri_numbytes", str, PACKAGE="stringi")
}


#' @title
#' Count the Number of Characters
#'
#' @description
#' This function returns the number of code points
#' in each string.
#'
#' @details
#' Note that the number of code points is
#' not the same as the `width` of the string when
#' printed on the screen.
#'
#' If a given string is in UTF-8 and  has not been properly Unicode normalized
#' (e.g. by \code{\link{stri_enc_nfc}}), this number may sometimes be
#' misleading.
#'
#' Missing values are handled properly,
#' as opposed to the built-in \code{\link{nchar}} function.
#' For `byte` encodings we get, as usual, an error.
#'
#' @param str character vector
#' @return Returns an integer vector of the same length as \code{str}.
#'
#' @examples
#' stri_length(LETTERS)
#' stri_length(c('abc','123','\u0105\u0104'))
#' stri_length('\u0105') # length is equal to one, but...
#' stri_numbytes('\u0105') # just like here
#' \dontrun{
#' stri_length(stri_enc_nfkd('\u0105')) # ...two code points (!)
#' }
#'
#' @export
#' @family length
stri_length <- function(str) {
   .Call("stri_length", str, PACKAGE="stringi")
}


#' @title
#' Determine if a String is Empty
#'
#' @description
#' This is the fastest way to find out
#' whether the elements of a character vector are empty strings or not.
#'
#' @details
#' Missing values are handled properly,
#' as opposed to the built-in \code{\link{nzchar}} function.
#'
#' @param str character vector
#' @return Returns a logical vector of the same length as \code{str}.
#'
#' @examples
#' stri_isempty(letters[1:3])
#' stri_isempty(c(',','','abc','123','\u0105\u0104'))
#' stri_isempty(character(1))
#'
#' @export
#' @family length
stri_isempty <- function(str) {
   .Call("stri_isempty", str, PACKAGE="stringi")
}




invisible(NULL) # TO BE DONE, version >= 0.2
# #' Count the Width of Characters [version >0.1]
# #'
# #' Missing values are handled properly.
# #' This is equivalent to the number of columns the cat() function will use
# #' to print the string in a monospaced font.
# #'
# #' @param str character vector, or a vector to be coerced to a character vector
# #' @return an integer vector giving the sizes of each element
# #' @examples
# #' stri_width(LETTERS[1:5])
# #' stri_width(c('abc','123','\u0105\u0104'))
# #' @export
# #' @family length
# stri_width <- function(str) {
#    .Call("stri_width", str, PACKAGE="stringi")
# }
