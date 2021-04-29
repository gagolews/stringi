library("tinytest")
library("stringi")

icudt_download_test <- as.logical(Sys.getenv("STRINGI_icudt_download_test", FALSE))
if (identical(icudt_download_test, TRUE)) {
    source("R/install.R")

    for (href in icudt_mirrors) {
        for (i in 1:2) {
            f <- tempfile()
            expect_true(download.file(paste(href, icudt_fname[i], sep = ""),
                f, quiet = FALSE, mode = "wb") == 0)
            expect_true(tools::md5sum(f) == icudt_md5ex[i])
        }
    }
} else message("skipping icudt_download tests")
