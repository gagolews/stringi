## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-209, Marek Gagolewski and other contributors.
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


# @title
# Installation-Related Utilities [DEPRECATED]
#
# @description
# These functions are responsible for checking and guaranteeing
# that the ICU data library (icudt) is available and that \pkg{stringi}
# is ready to use.
#
# These functions are deprecated and will no longer be available
# in future \pkg{stringi} releases.
#
# @details
# ICU makes use of a wide variety of data tables to provide many
# of its services. Examples include converter mapping tables,
# collation rules, transliteration rules, break iterator rules
# and dictionaries, and other locale data.
#
# Without the ICU data library (icudt) many \pkg{stringi} features
# will not be available. icudt size is approx. 10-30 MB.
#
# \code{stri_install_check()} tests whether some ICU services
# are available. If this is not the case, it is most likely due to
# unavailable ICU data library.
#
# \code{stri_install_icudt()} downloads and installs the ICU data library
# specific to your platform (little/big-endian). The downloaded
# file will be decompressed into the directory where the package has been
# installed, see \code{\link{find.package}}, so make sure
# you have sufficient write permissions.
#
# @param silent suppress diagnostic messages
# @param check enable \code{stri_install_check()} tests
# @param outpath path to install icudt to. If \code{NULL}, then
# \code{file.path(path.package("stringi"), "libs")} will be used.
# @param inpath path to search icudt archive in.
# If \code{NULL}, then only stringi mirror servers will be used.
# Mainly of interest to system admins and software developers.
#
# @return These functions return a logical value, invisibly.
# \code{TRUE} denotes that the requested operation has been completed
# successfully.
#
# @references
# \emph{ICU Data} -- ICU User Guide,
# \url{http://userguide.icu-project.org/icudata}
#
# @examples
# stri_install_check()
#
# @rdname stri_install
stri_install_check <- function(silent=FALSE) {
   # As of v1.1.3, this function is no longer exported.
   # It was deprecated in 0.5-5.

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
         message("It seems that the ICU data library has not been installed properly.")
         message("Call stri_install_icudt() to fix this problem.")
      }
   }

   invisible(allok)
}




icudt_fname <- c("little55"="icudt55l.zip",
                 "big55"   ="icudt55b.zip",
                 "little61"="icudt61l.zip",
                 "big61"   ="icudt61b.zip"
                 )

icudt_md5ex <- c("little55"="ff345529f230cc39bb8d450af0607708",
                 "big55"   ="1194f0dd879d3c1c1f189cde5fd90efe",
                 "little61"="6d14e059b26606f08bad3b41eb3b5c93",
                 "big61"   ="45719f3208b2d67132efa620cecccb56"
                 )

icudt_mirrors <- c(
                   "http://www.ibspan.waw.pl/~gagolews/stringi/",
                   "https://raw.githubusercontent.com/gagolews/stringi/master/src/icu61/data/",
                   "https://raw.githubusercontent.com/gagolews/stringi/master/src/icu55/data/",
                   "http://raw.githubusercontent.com/gagolews/stringi/master/src/icu61/data/",
                   "http://raw.githubusercontent.com/gagolews/stringi/master/src/icu55/data/",
                   "http://www.gagolewski.com/software/stringi/"
                   )



# @rdname stri_install
stri_download_icudt <- function(inpath, icu_bundle_version) {

   fname <- icudt_fname[paste0(.Platform$endian, icu_bundle_version)]

   md5ex <- icudt_md5ex[paste0(.Platform$endian, icu_bundle_version)]

   mirrors <- icudt_mirrors

   icudtzipfname <- file.path(inpath, fname) #tempfile(fileext=".zip")

   if (file.exists(icudtzipfname)) {
      md5ob <- tools::md5sum(icudtzipfname)
      if (is.na(md5ob)) {
         message("error checking md5sum for icudt")
         return(invisible(FALSE))
      }
      if (md5ob != md5ex) {
         message("md5sum mismatch for icudt")
         return(invisible(FALSE))
      }
      message("icudt already downloaded")
      return(icudtzipfname)
   }

   # if (!is.null(inpath)) {
   #    stopifnot(is.character(inpath), length(inpath) > 0, !is.na(inpath))
   #    mirrors <- c(inpath, mirrors)
   # }

   download_from_mirror <- function(href, fname, icudtzipfname) {
      tryCatch({
         suppressWarnings(file.remove(icudtzipfname))
         # download icudt
         if (download.file(paste(href, fname, sep=""), icudtzipfname, mode="wb") != 0) {
            return("download error")
         }
         if (!file.exists(icudtzipfname)) return("download error")
         md5ob <- tools::md5sum(icudtzipfname)
         if (is.na(md5ob)) {
            return("error checking md5sum")
         }
         if (md5ob != md5ex) {
            return("md5sum mismatch")
         }
         TRUE
      }, error = function(e) as.character(e))
   }

   message("downloading the ICU data library (icudt)")
   message("output path: ", icudtzipfname)
   if (!exists("dir.exists") || !dir.exists(inpath)) # dir.exists is R >= 3.2.0
      suppressWarnings(dir.create(inpath))

   allok <- FALSE
   for (m in mirrors) {
      if (identical(status <- download_from_mirror(m, fname, icudtzipfname), TRUE)) {
         allok <- TRUE
         break
      }
      else message(status)
   }

   if (!allok || !file.exists(icudtzipfname)) {
      suppressWarnings(file.remove(icudtzipfname))
      message("icudt download failed")
      return(invisible(FALSE))
   }

   message("icudt fetch successful")
   return(icudtzipfname)
}


# @rdname stri_install
stri_install_icudt <- function(check=TRUE, outpath=NULL, inpath=NULL, icu_bundle_version=NULL) {
   # As of v1.1.3, this function is no longer exported.
   # It was deprecated in 0.5-5.

   stopifnot(is.logical(check), length(check) == 1, !is.na(check))
   if (check && stri_install_check(TRUE)) {
      message("icudt is already installed.")
      return(invisible(TRUE))
   }

   # remember about importFrom tools md5sum -> stringi-package.R
   # use this very code in install.libs.R directly

   icudtzipfname <- stri_download_icudt(inpath, icu_bundle_version)
   if (identical(icudtzipfname, FALSE) || !file.exists(icudtzipfname)) {
      return(invisible(FALSE))
   }

   if (is.null(outpath))
      outpath <- file.path(path.package("stringi"), "libs")

   stopifnot(is.character(outpath), length(outpath) == 1, file.exists(outpath))

   message("decompressing icudt archive ", icudtzipfname, " to: ", outpath)
   res <- unzip(icudtzipfname, exdir=outpath, overwrite=TRUE)
   if (!is.character(res) || length(res) <= 0) {
      message("error decompressing icudt archive")
      return(invisible(FALSE))
   }

   message("icudt has been installed successfully")
   invisible(TRUE)
}
