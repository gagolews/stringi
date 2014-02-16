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
#' [DRAFT API] Read Whole Text File as Raw
#'
#' @description
#' Reads a text file as-is, with no conversion or text line spliting.
#'
#' \bold{[THIS IS AN EXPERIMENTAL FUNCTION]}
#'
#' @details
#' After reading a text file into memory (vast majority of them
#' will fit into RAM without any problems), you may perform e.g.
#' encoding detection (cf. \code{\link{stri_enc_detect2}}),
#' conversion (cf. \code{\link{stri_encode}}),
#' and e.g. split it into text lines with
#' \code{\link{stri_split_lines1}}.
#'
#' @param fname file name
#'
#' @return
#' Returns a raw vector.
#'
#' @family files
#' @export
stri_read_raw <- function(fname) {
   stopifnot(is.character(fname), length(fname) == 1, file.exists(fname))
   fsize <- file.info(fname)$size
   readBin(fname, what='raw', size=1, n=fsize)
}



#' @title
#' [DRAFT API] Read Text Lines from a Text File
#'
#' @description
#' Reads a text file, re-encodes it, and splits it into text lines.
#'
#' \bold{[THIS IS AN EXPERIMENTAL FUNCTION]}
#'
#' @details
#' It is a substitute for the system's \code{\link{readLines}} function,
#' with the ability to auto-detect input encodings (or specify
#' one manually), re-encode input without any strange function calls
#' or sys options change,
#' and split the text into lines with \code{\link{stri_split_lines1}}
#' (which conforms with the Unicode guidelines for newline markers).
#'
#' If \code{locale} is \code{NA} and auto-detect of UTF-32/16/8 fails,
#' then \code{fallback_encoding} is used.
#'
#' @param fname single string with file name
#' @param encoding single string; input encoding, \code{"auto"} for automatic
#' detection with \code{\link{stri_enc_detect2}},
#' and \code{NULL} or \code{""} for the current default encoding.
#' @param locale single string passed to \code{\link{stri_enc_detect2}};
#' \code{NULL} or \code{""} for default locale,
#' \code{NA} for checking just UTF-* family
#' @param fallback_encoding single string; encoding to be used if encoding detection fails;
#' defaults to the current default encoding, see \code{\link{stri_enc_get}}
#'
#' @return
#' Returns a character vector, with each line of text
#' being a single string. The output is always in UTF-8.
#'
#' @family files
#' @export
stri_read_lines <- function(fname, encoding='auto', locale=NA, fallback_encoding=stri_enc_get()) {
   stopifnot(is.character(encoding), length(encoding) == 1)
   txt <- stri_read_raw(fname)
   if (identical(encoding, 'auto')) {
      encoding <- stri_enc_detect2(txt, locale)[[1]]$Encoding[1]
      if (is.na(encoding)) {
         if (is.na(locale))
            encoding <- fallback_encoding
         else
            stop('could not auto-detect encoding')
      }
   }
   txt <- stri_encode(txt, encoding, "UTF-8")
   stri_split_lines1(txt)
}


#' @title
#' [DRAFT API] Write Text Lines to a Text File
#'
#' @description
#' Writes a text file such that each element of a given
#' character vector becomes a separate text line.
#'
#' \bold{[THIS IS AN EXPERIMENTAL FUNCTION]}
#'
#' @details
#' It is a substitute for the \R \code{\link{writeLines}} function,
#' with the ability to re-encode output without any strange function calls.
#'
#' Note that we suggest using the UTF-8 encoding for all text files:
#' thus, it is the default one for the output.
#'
#' @param str character vector
#' @param fname file name
#' @param encoding output encoding, \code{NULL} or \code{""} for
#' the current default one
#' @param sep newline separator
#'
#' @return
#' This function does not return anything interesting
#'
#' @family files
#' @export
stri_write_lines <- function(str, fname, encoding='UTF-8',
      sep=ifelse(.Platform$OS.type == "windows", '\x0d\x0a', '\x0a')) {
   str <- stri_join(str, sep, collapse='')
   str <- stri_encode(str, '', encoding, to_raw=TRUE)[[1]]
   writeBin(str, fname, useBytes=TRUE)
   invisible(NULL)
}
