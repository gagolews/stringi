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
#' Pad a String
#'
#' @description
#' Adds \code{pad} characters at the given \code{side} of each string
#' so that each output string consists of at least \code{min_length} code points.
#' 
#' @details
#' Vectorized over \code{str}, \code{min_length}, \code{side}, and \code{pad}.
#' Each string in \code{pad} should consist of exactly one code point.
#' 
#' Note that Unicode code points may have different widths when
#' printed on screen. This function acts like each code point
#' is of width 1.
#'
#' @param str character vector
#' @param min_length integer vector giving minimal output string lengths
#' @param side character vector; sides on which padding character is added
#'    (\code{left}, \code{right}, or \code{both})
#' @param pad character vector giving padding code points
#' 
#' @return Returns a character vector.
#'
#' @family whitespaces
#' @examples
#' stri_pad("stringi", 10, pad="#")
#' stri_pad("stringi", 5:9, "right", pad="$")
#' stri_pad(1, 3, pad=LETTERS)
#' @export
stri_pad <- function(str, min_length=max(stri_length(str)), side="left", pad=" ") {
   .Call("stri_pad", str, min_length, side, pad, PACKAGE="stringi")
}
