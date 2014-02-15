## This file is part of the 'stringi' library.
##
## Copyright 2013-2014 Marek Gagolewski, Bartek Tartanus
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
