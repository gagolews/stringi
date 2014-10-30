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
#' Installation-Related Utilities
#'
#' @description
#' These functions are responsible for checking and guaranteeing
#' that the ICU data library (icudt) is available and that \pkg{stringi}
#' is ready to use.
#'
#' @details
#' ICU makes use of a wide variety of data tables to provide many
#' of its services. Examples include converter mapping tables,
#' collation rules, transliteration rules, break iterator rules
#' and dictionaries, and other locale data.
#'
#' Without the ICU data library (icudt) many \pkg{stringi} features
#' will not be available. icudt size is approx. 10-20 MB.
#'
#' \code{stri_install_check()} tests whether some ICU services
#' are available. If they are not, it is most likely due to
#' unavailable ICU data library.
#'
#' \code{stri_install_icudt()} downloads and installs the ICU data library
#' specific for your platform (little/big-endian). The downloaded
#' file will be decompressed into the directory where the package has been
#' installed, see \code{\link{find.package}}, so make sure
#' you have sufficient write permissions.
#'
#' @param silent suppress diagnostic messages
#' @param check enable \code{stri_install_check()} tests
#' @param path path to install icudt to. If \code{NULL}, then
#' \code{file.path(find.package('stringi'), 'libs')} will be used.
#' Custom, non-default paths should not be used normally by \pkg{stringi} users.
#'
#' @return The functions return a logical value, invisibly.
#' \code{TRUE} denotes that the requested operation has been completed
#' successfully.
#'
#' @references
#' \emph{ICU Data} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/icudata}
#'
#' @examples
#' \donttest{stri_install_check()}
#'
#' @rdname
#' stri_install
#' @export
stri_install_check <- function(silent=FALSE) {
   stopifnot(is.logical(silent), length(silent) == 1)

   allok <- tryCatch({
      if (!silent)
         message(stri_info(TRUE)) # this may also throw an error

      if (length(stri_enc_list()) <= 0) stop("encodings unsupported")
      if (length(stri_locale_list()) <= 0) stop("locales unsupported")
      if (length(stri_trans_list()) <= 0) stop("transliterators unsupported")
      if (stri_cmp("a", "b", opts_collator=stri_opts_collator(locale="en_US")) != -1)
         stop("no collator rules installed")
      if (stri_detect_regex("123abc!@#", "\\p{L}") != TRUE)
         stop("regex engine failure")
      TRUE
   }, error=function(e) { FALSE })

   if (!silent) {
      if (allok) message("All tests completed successfully.")
      else {
         message("It seems that ICU data library has not been installed properly.")
         message("Call stri_install_icudt() to fix this problem.")
      }
   }

   invisible(allok)
}


#' @rdname
#' stri_install
#' @export
stri_install_icudt <- function(check=TRUE, path=NULL) {
   stopifnot(is.logical(check), length(check) == 1)
   if (check && stri_install_check(TRUE)) {
      message("icudt has been already installed.")
      return(invisible(TRUE))
   }

   if (is.null(path))
      path <- file.path(find.package('stringi'), 'libs')
   stopifnot(is.character(path), length(path) == 1)

   mirror1 <- "http://static.rexamine.com/packages/"
   mirror2 <- "http://www.mini.pw.edu.pl/~gagolews/stringi/"
   mirror3 <- "http://www.ibspan.waw.pl/~gagolews/stringi/"


   if (.Platform$endian == 'little') {
      fname <- "icudt52l.zip"
   }
   else {
      fname <- "icudt52b.zip"
   }

   outfname <- tempfile(fileext=".zip")
   download_from_mirror <- function(mirror, outfname) {
      tryCatch({
         ret <- download.file(paste0(mirror, fname), outfname, mode="wb")
         if (ret != 0) stop("download error")
         if (!file.exists(outfname)) stop("download error")
         TRUE
      }, error = function(e) FALSE)
   }

   message("downloading ICU data library (icudt)")
   message("the files will be extracted to: ", path)
   allok <- download_from_mirror(mirror1, outfname)
   allok <- allok || download_from_mirror(mirror2, outfname)
   allok <- allok || download_from_mirror(mirror3, outfname)

   if (!allok) {
      message("download failed")
      return(invisible(FALSE))
   }
   message("download OK")

   message("decompressing downloaded archive")
   res <- unzip(outfname, exdir=path)
   if (!is.character(res) || length(res) <= 0) {
      message("error decompressing archive")
      return(invisible(FALSE))
   }

   message("icudt has been installed successfully")
   message("restart R to apply changes")
   invisible(TRUE)
}
