# kate: default-dictionary en_US

## This file is part of the 'stringi' package for R.
## Copyright (c) 2013-2025, Marek Gagolewski <https://www.gagolewski.com/>
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
## 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
## BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
## FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
## HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
## SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
## PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
## OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
## WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
## OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
## EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# internal functions used whilst installing stringi

icudt_fname <- c(
    little74 = "icudt74l.dat",
    big74    = "icudt74b.dat"
)


# This function is not exported; it is called by install.libs.r(.in)
stri_install_icudt <- function(outpath, inpath, icu_bundle_version)
{
    # remember about importFrom tools md5sum -> stringi-package.R

    xzpath <- stri_download_icudt(inpath, icu_bundle_version)
    if (identical(xzpath, FALSE) || !file.exists(xzpath)) {
        return(invisible(FALSE))
    }

    basepath <- substr(xzpath, 1, nchar(xzpath)-3)  # ~~".xz"~~

    message("decompressing ", xzpath, " to: ", outpath)
    fin <- xzfile(xzpath, "rb")
    fout <- file(basepath, "wb")
    repeat {
        chunk <- readBin(fin, raw(), 8192L)
        if (length(chunk) <= 0) break
        writeBin(chunk, fout)
    }
    close(fout)
    close(fin)

    md5ex <- scan(sprintf("%s.md5sum", basepath), what=character(), n=1, quiet=TRUE)
    md5ob <- tools::md5sum(basepath)
    if (is.na(md5ob) || md5ob != md5ex) {
        message(sprintf("md5sum mismatch for %s (%s vs %s)",
            basepath, as.character(md5ob), as.character(md5ex)
        ))
        file.remove(basepath)
        return(invisible(FALSE))
    }

    file.copy(basepath, file.path(outpath, basename(basepath)), overwrite=TRUE)
    file.remove(basepath)

    message(sprintf("%s installed successfully", basepath))
    invisible(TRUE)
}


# This function is not exported;
# it is called by configure(.ac) and stri_install_icudt above
stri_download_icudt <- function(inpath, icu_bundle_version)
{
    fname <- icudt_fname[paste0(.Platform$endian, icu_bundle_version)]
    path <- file.path(inpath, fname)

    commit_id <- "bbe75eca8f9ef4dc72dc5c6e36c8f8306a324b7e"
    mirrors <- sprintf(
        "%s://raw.githubusercontent.com/gagolews/stringi/%s/src/icu%d/data/",
        c("https", "http"),
        commit_id,
        icu_bundle_version
    )

    xzpath <- sprintf("%s.xz", path)

    if (file.exists(xzpath)) {
        message(sprintf("%s exists", xzpath))
        return(xzpath)
    }

    download_from_mirror <- function(href, fname, xzpath) {
        tryCatch({
            suppressWarnings(file.remove(xzpath))
            # download icudt
            if (
                download.file(
                    paste(href, fname, sep = ""), xzpath, mode = "wb"
                ) != 0
            ) {
                return("download error")
            }
            if (!file.exists(xzpath)) {
                return("download error")
            }
            TRUE
        }, error = function(e) as.character(e))
    }

    message(sprintf("downloading the ICU data library (%s)...", xzpath))
    if (!dir.exists(inpath)) suppressWarnings(dir.create(inpath))

    allok <- FALSE
    for (m in mirrors) {
        status <- download_from_mirror(m, sprintf("%s.xz", fname), xzpath)
        if (identical(status, TRUE)) {
            allok <- TRUE
            break
        }
        else message(status)
    }

    if (!allok || !file.exists(xzpath)) {
        suppressWarnings(file.remove(xzpath))
        message(sprintf("Error: %s could not be downloaded", xzpath))
        return(invisible(FALSE))
    }

    message(sprintf("%s downloaded successfully", xzpath))
    return(xzpath)
}
