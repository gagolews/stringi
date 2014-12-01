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
#' Pad (Center/Left/Right Align) a String
#'
#' @description
#' Adds multiple \code{pad} characters at the given \code{side}(s) of each string
#' so that each output string consists of at least \code{min_length} code points.
#' This function may be used to center or left/right-align each string.
#'
#' @details
#' Vectorized over \code{str}, \code{min_length}, and \code{pad}.
#' Each string in \code{pad} should consist of exactly one code point.
#'
#' \code{stri_pad} is a convenience function, which dispatches
#' control to \code{stri_pad_*}. Unless you are very lazy, do not use it:
#' it is a little bit slower.
#'
#' Note that Unicode code points may have various widths when
#' printed on screen. This function acts like each code point
#' is of width 1. This function should rather be used with
#' text in Latin script.
#'
#' See \code{\link{stri_trim_left}} (among others) for reverse operation.
#' Also check out \code{\link{stri_wrap}} for line wrapping.
#'
#' @param str character vector
#' @param min_length integer vector giving minimal output string lengths
#' @param side [\code{stri_pad} only] single character string;
#'    sides on which padding character is added
#'    (\code{left}, \code{right}, or \code{both})
#' @param pad character vector giving padding code points
#'
#' @return Returns a character vector.
#'
#' @rdname stri_pad
#' @examples
#' stri_pad_left("stringi", 10, pad="#")
#' stri_pad_both("stringi", 8:12, pad="*")
#' # center on screen:
#' cat(stri_pad_both(c("the", "string", "processing", "package"),
#'    getOption("width")*0.9), sep='\n')
#' @export
stri_pad_both <- function(str, min_length=floor(0.9*getOption("width")), pad=" ") {
   .Call(C_stri_pad, str, min_length, 2L, pad)
}


#' @rdname stri_pad
#' @export
stri_pad_left <- function(str, min_length=floor(0.9*getOption("width")), pad=" ") {
   .Call(C_stri_pad, str, min_length, 0L, pad)
}


#' @rdname stri_pad
#' @export
stri_pad_right <- function(str, min_length=floor(0.9*getOption("width")), pad=" ") {
   .Call(C_stri_pad, str, min_length, 1L, pad)
}


#' @rdname stri_pad
#' @export
stri_pad <- function(str, min_length=floor(0.9*getOption("width")),
   side=c("left", "right", "both"), pad=" ")
{
   # `left` is the default for compatibility with stringr
   side <- match.arg(side) # this is slow

   switch(side,
          both  =stri_pad_both(str, min_length, pad),
          left  =stri_pad_left(str, min_length, pad),
          right =stri_pad_right(str, min_length, pad)
   )
}
