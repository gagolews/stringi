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


invisible(NULL) # TO BE DONE, version >= 0.2


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
# #'
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
