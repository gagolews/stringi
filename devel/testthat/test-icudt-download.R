require(testthat)
context("test-icudt-download.R")

icudt_donwload_test <- as.logical(Sys.getenv("STRINGI_icudt_donwload_test", FALSE))
if (identical(icudt_donwload_test, TRUE))
{
   test_that("icudt_download", {

      source("R/install.R")

      for (href in icudt_mirrors) {
         for (i in 1:2) {
            f <- tempfile()
            expect_true(download.file(paste(href, icudt_fname[i], sep=""), f, quiet=FALSE, mode="wb") == 0)
            expect_true(tools::md5sum(f) == icudt_md5ex[i])
         }
      }
   })
} else
   message("skipping icudt_download tests")
