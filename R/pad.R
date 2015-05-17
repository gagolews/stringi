## This file is part of the 'stringi' package for R.
## Copyright (C) 2013-2015, Marek Gagolewski and Bartek Tartanus
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
#' so that each output string is of total width of at least \code{width}.
#' This function may be used to center or left/right-align each string.
#'
#' @details
#' Vectorized over \code{str}, \code{width}, and \code{pad}.
#' Each string in \code{pad} should consist of a code points of total width
#' equal to 1 or, if \code{use_length} is \code{TRUE}, exactly one code point.
#'
#' \code{stri_pad} is a convenience function, which dispatches
#' control to \code{stri_pad_*}. Relying on one of the underlying
#' functions will make your code run slightly faster.
#'
#' Note that Unicode code points may have various widths when
#' printed on the console and that the function takes that by default
#' into account. By changing the state of the \code{use_length}
#' argument, this function starts to act like each code point
#' was of width 1. This feature should rather be used with
#' text in Latin script.
#'
#' See \code{\link{stri_trim_left}} (among others) for reverse operation.
#' Also check out \code{\link{stri_wrap}} for line wrapping.
#'
#' @param str character vector
#' @param width integer vector giving minimal output string lengths
#' @param side [\code{stri_pad} only] single character string;
#'    sides on which padding character is added
#'    (\code{left}, \code{right}, or \code{both})
#' @param pad character vector giving padding code points
#' @param use_length single logical value; should the number of code
#' points be used instead of the total code point width (see \code{\link{stri_width}})?
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
#' cat(stri_pad_both(c("\ud6c8\ubbfc\uc815\uc74c", # takes width into account
#'    stri_trans_nfkd("\ud6c8\ubbfc\uc815\uc74c"), "abcd"),
#'    width=10), sep="\n")
#' @export
stri_pad_both <- function(str, width=floor(0.9*getOption("width")), pad=" ", use_length=FALSE) {
   .Call(C_stri_pad, str, width, 2L, pad, use_length)
}


#' @rdname stri_pad
#' @export
stri_pad_left <- function(str, width=floor(0.9*getOption("width")), pad=" ", use_length=FALSE) {
   .Call(C_stri_pad, str, width, 0L, pad, use_length)
}


#' @rdname stri_pad
#' @export
stri_pad_right <- function(str, width=floor(0.9*getOption("width")), pad=" ", use_length=FALSE) {
   .Call(C_stri_pad, str, width, 1L, pad, use_length)
}


#' @rdname stri_pad
#' @export
stri_pad <- function(str, width=floor(0.9*getOption("width")),
   side=c("left", "right", "both"), pad=" ", use_length=FALSE)
{
   # `left` is the default for compatibility with stringr
   side <- match.arg(side) # this is slow

   switch(side,
          both  =stri_pad_both(str, width, pad, use_length),
          left  =stri_pad_left(str, width, pad, use_length),
          right =stri_pad_right(str, width, pad, use_length)
   )
}
