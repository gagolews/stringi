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
#' @param outpath path to install icudt to. If \code{NULL}, then
#' \code{file.path(path.package("stringi"), "libs")} will be used.
#' @param inpath path to search icudt archive in (must end with a slash).
#' If \code{NULL}, then only stringi mirror servers will be used as possible sources
#' Custom, non-default paths should not be used normally by \pkg{stringi} users.
#'
#' @return These functions return a logical value, invisibly.
#' \code{TRUE} denotes that the requested operation has been completed
#' successfully.
#'
#' @references
#' \emph{ICU Data} -- ICU User Guide,
#' \url{http://userguide.icu-project.org/icudata}
#'
#' @examples
#' stri_install_check()
#'
#' @rdname stri_install
#' @export
stri_install_check <- function(silent=FALSE) {
   stopifnot(is.logical(silent), length(silent) == 1)

   allok <- tryCatch({
      if (!silent) message(stri_info(TRUE)) # this may also throw an error

      if (length(stri_enc_list()) <= 0)    stop("encodings unsupported")
      if (length(stri_locale_list()) <= 0) stop("locales unsupported")
      if (length(stri_trans_list()) <= 0)  stop("transliterators unsupported")
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


#' @rdname stri_install
#' @export
#' @importFrom tools md5sum
stri_install_icudt <- function(check=TRUE, outpath=NULL, inpath=NULL) {
   stopifnot(is.logical(check), length(check) == 1, !is.na(check))
   if (check && stri_install_check(TRUE)) {
      message("icudt has been already installed.")
      return(invisible(TRUE))
   }

   if (is.null(outpath))
      outpath <- file.path(path.package("stringi"), "libs")
   stopifnot(is.character(outpath), length(outpath) == 1, file.exists(outpath))

   fname <- if (.Platform$endian == 'little') "icudt52l.zip"
                                         else "icudt52b.zip"

   md5ex <- if (.Platform$endian == 'little') "d86d3191818ae58d5703f1ac78b0050c"
                                         else "91cd9aacaa4e776bd14f20c8839cd9c2"

   mirrors <- c("http://static.rexamine.com/packages/",
                "http://www.mini.pw.edu.pl/~gagolews/stringi/",
                "http://www.ibspan.waw.pl/~gagolews/stringi/")

   if (!is.null(inpath)) {
      stopifnot(is.character(inpath), length(inpath) > 0, !is.na(inpath))
      mirrors <- c(inpath, mirrors)
   }

   outfname <- tempfile(fileext=".zip")
   download_from_mirror <- function(href, outfname) {
      tryCatch({
         suppressWarnings(file.remove(outfname))
         if (!grepl("^https?://", href)) {
            # try to copy icudt from a local repo
            if (!file.exists(href)) return("no icudt in a local repo")
            message("icudt has been found in a local repo")
            file.copy(href, outfname)
         }
         else {
            # download icudt
            if (download.file(href, outfname, mode="wb") != 0)
               return("download error")
         }
         if (!file.exists(outfname)) return("download error")
         md5ob <- tools::md5sum(outfname)
         if (is.na(md5ob)) return("error checking md5sum")
         if (md5ob != md5ex) return("md5sum mismatch")
         TRUE
      }, error = function(e) as.character(e))
   }

   message("downloading ICU data library (icudt)")
   message("the files will be extracted to: ", outpath)
   allok <- FALSE
   for (m in mirrors) {
      if (identical(status <- download_from_mirror(paste0(m, fname), outfname), TRUE)) {
         allok <- TRUE
         break
      }
      else message(status)
   }

   if (!allok) {
      message("icudt download failed")
      return(invisible(FALSE))
   }
   message("icudt fetch OK")

   message("decompressing downloaded archive")
   res <- unzip(outfname, exdir=outpath, overwrite=TRUE)
   if (!is.character(res) || length(res) <= 0) {
      message("error decompressing archive")
      return(invisible(FALSE))
   }

   suppressWarnings(file.remove(outfname))
   message("icudt has been installed successfully")
   message("restart R to apply changes")
   invisible(TRUE)
}
