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


invisible(NULL) # TO DO, version >= 0.3


# @TODO: ADD stri_split_chars - split into chars
# @TODO: ADD stri_split_pos


# #' Split the elements of a character vector by position
# #'
# #'
# #' @param str character vector to split
# #' @param split character element
# #' @param from integer vector
# #' @param to integer vector
# #' @return A list of the same length as the longest of vectors:
# #' str, split and omitempty. Shorter vectors are recycled. The i-th element
# #' of list contains splitted str[i] character vectors
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
# #    .Call(C_stri_split_pos, str, from, to)
# }
