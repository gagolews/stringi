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


invisible(NULL) # TO BE DONE, version >= 0.2
#
# #' Pad the start of a string
# #'
# #' Add whitespace at the begining or/and at the end of string.
# #' Works like str_pad but faster and it's vectorized not only over s, but
# #' also over width, side and pad. And works with NA value.
# #'
# #' @param str character vector
# #' @param width pad strings to this minimum width
# #' @param side side on which padding character is added (left, right or both)
# #' @param pad character vector of single padding character (default is space)
# #' @return character vector
# #' @details If string is longer than width, then string is returned unchanged. Look at the example.
# #' @examples
# #' stri_pad("stringi",10,"#")
# #' stri_pad("stringi",5:9,pad="$")
# #' stri_pad("1",3,pad=LETTERS)
# #' @export
# stri_pad <- function(str, length, pad = " ") {
#    # prepare_arg done internally
#    #side <- pmatch(side, c("left", "right", "both"),1,T)
#    .Call("stri_pad", str, length, pad, PACKAGE="stringi")
# }
