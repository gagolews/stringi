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
#' Word Wrap Text to Format Paragraphs
#'
#' @description
#' ...
#'
#' @details
#' Vectorized over \code{str}.
#' 
#' Any of the strings must not contain \code{\\r} or \code{\\n} characters,
#' otherwise you will get at error.
#' 
#' Note that Unicode code points may have various widths when
#' printed on screen. This function acts like each code point
#' is of width 1.
#' 
#' \pkg{ICU}'s line-\code{BreakIterator} is used to determine
#' text boundaries at which a line break is possible.
#'
#' @param str character vector of strings to reformat
#' @param width single positive integer giving the desired 
#'        maximal number of code points per line
#' @param cost_exponent single numeric value, values not greater than zero
#'        will select a greedy word-wrapping algorithm; otherwise
#'        this value denotes the exponent in the cost function
#'        of a (more esthetic) dynamic programming-based algorithm
#' @param simplify single logical value, see Value
#' @param locale \code{NULL} or \code{""} for text boundary analysis following
#' the conventions of the default locale, or a single string with
#' locale identifier, see \link{stringi-locale}
#' @param simplify single logical value....
#'
#' @return
#' If \code{simplify} is \code{TRUE}, then a character vector is returned.
#' Otherwise, you will get a list of \code{length(str)} character vectors.
#'
#' @rdname stri_wrap
#' @family locale_sensitive
#' @family text_boundaries
#' @examples
#' invisible(NULL) # t.b.d.
#' @export
stri_wrap <- function(str, width=floor(0.9*getOption("width")),
   cost_exponent=2.0, simplify=TRUE, locale=NULL)
{
   simplify <- as.logical(simplify)
   
   ret <- .Call("stri_wrap", str, width, cost_exponent, locale, PACKAGE="stringi")
   
   if (simplify) # will give an informative warning or error if sth is wrong
      as.character(unlist(ret))
   else
      ret
}


# unlist(stri_split_lines("aaaa\nnnn"))
# stri_trim(stri_replace_all_charclass(c("   ", "     above-mentioned    "), "\\p{WHITE_SPACE}", " ", TRUE))
# stri_paste(str, collapse=' ')


# #' Wrap strings to paragraphs
# #'
# #' Function is vectorized over str, width, method and spacecost
# #'
# #' @description Wrap strings to paragraphs
# #' @usage stri_wrap(s, width = 76, method = "greedy", spaces = "(\\p{Z}|\\n)+", spacecost = 1)
# #' @param s character vector of strings to format into paragraphs
# #' @param width positive integer giving the target column for wrapping lines
# #' @param method indicates which method is used for wrapping ("greedy" or "dynamic"). You can specify just the initial letter of the value. See 'Details' for description of possible methods.
# #' @param spaces length one character vector or expression ?...
# #' @param spacecost positive integer which determines the cost of one space (gap between each word)
# #' @details Greedy algorithm is simple way of word wrapping and it always puts as many words on each line as possible. This method minimize the number of space left at the end of every line and always uses the minimum number of lines. Disadvantage of this method could be fact that the number of empty space at the end of lines may be various. Dynamic algorithm is more complex, but it returns text wrapped more aesthetic. This method minimize the squared number of space, so the text is arranged evenly.
# #'
# #' @return character vector of reformatted strings
# #'@family whitespaces
# #' @examples
# #' s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
# #'       nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel
# #'       lorem. Etiam pellentesque aliquet tellus."
# #' stri_wrap(s,20,"d")
# #' cat(stri_wrap(s,20,"d"))
# #' cat(stri_wrap(s,20,"g"))
# #'
# #' @export
#
# #  TODO the default parameter spaces should be different (class WHITESPACE)
# #  TODO add indent and exdent parameter (see strwrap)
#
# stri_wrap <- function(str,width=76,method="greedy",spaces="(\\p{Z}|\\n|\\t)+",spacecost=1)
# {
#    str <- stri_prepare_arg_string(str)
#    width <- stri_prepare_arg_integer(width)
#    stopifnot(is.finite(width)&&width>0)
#    spacecost <- stri_prepare_arg_integer(spacecost)
#    stopifnot(is.finite(spacecost)&&spacecost>0)
#    method <- pmatch(method,c("greedy","dynamic"),1,T)
#    # when stri_split will work with regexp use this line:
#    # wordslist <- stri_split_class(str, whitespaces)
#    # for now we can only split by " "
#    wordslist <- stri_split_fixed(enc2utf8(str), enc2utf8(" "), omitempty=TRUE)
#    .Call("stri_wrap",wordslist,method,width,spacecost,PACKAGE="stringi")
# }
