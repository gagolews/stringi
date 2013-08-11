## This file is part of the 'stringi' library.
##
## Copyright 2013 Marek Gagolewski, Bartek Tartanus
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


#' @title
#' [DRAFT API] Read Whole Text File as Raw
#' 
#' @description
#' T.B.D.
#' 
#' After reading a text file into memory (vast majority of them
#' will fit into RAM without any problems), you may do
#' encoding detection (cf. \code{\link{stri_enc_detect}}),
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
   stopifnot(is.character(fname), file.exists(fname))
   fsize <- file.info(fname)$size
   readBin(fname, what='raw', size=1, n=fsize)
}



#' @title
#' [DRAFT API] Read Text Lines from a Text File
#' 
#' @description
#' T.B.D.
#' 
#' It is a substitute for the system's \code{\link{readLines}} function,
#' with the ability to auto-detect input encodings (or specify
#' one manually), re-encode input without any strange function calls,
#' and split the text into lines with \code{\link{stri_split_lines1}}
#' (which conforms to Unicode guidelines for newline markers).
#' 
#' @param fname file name
#' @param encoding input encoding, \code{"auto"} for automatic
#' detection with \code{\link{stri_enc_detect}},
#' and \code{NULL} or \code{""} for the default encoding.
#' 
#' @return
#' Returns a character vector, with each line of text
#' being a single string. The output is always in UTF-8.
#' 
#' @family files
#' @export
stri_read_lines <- function(fname, encoding='auto') {
   stopifnot(is.character(encoding), length(encoding) == 1)
   txt <- stri_read_raw(fname)
   if (identical(encoding, 'auto')) {
      encoding <- stri_enc_detect(txt)[[1]]$Encoding[1]
      if (is.na(encoding))
         error('could not auto-detect encoding')
   }
   txt <- stri_encode(txt, encoding, "UTF-8")
   stri_split_lines1(txt)
}


#' @title
#' [DRAFT API] Write Text Lines to a Text File
#' 
#' @description
#' T.B.D.
#' 
#' It is a substitute for the system's \code{\link{writeLines}} function,
#' with the ability to re-encode output without any strange function calls.
#' 
#' Note that we suggest using the UTF-8 encoding for all text files:
#' thus, it's the default one for the output.
#' 
#' @param str character vector
#' @param fname file name
#' @param output encoding, \code{NULL} or \code{""} for 
#' the default one
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
