require(testthat)
context("test-time-zone.R")

test_that("stri_timezone_list", {

   expect_true(is.character(stri_timezone_list()))
   expect_true(length(stri_timezone_list()) > 0)
   expect_true("UTC" %in% stri_timezone_list())
   expect_true("GMT" %in% stri_timezone_list())
   expect_true("CET" %in% stri_timezone_list())
   expect_true("CST" %in% stri_timezone_list())
   expect_true("Europe/Warsaw" %in% stri_timezone_list())
   expect_true("CET" %in% stri_timezone_list(offset=1))
   expect_true("Asia/Colombo" %in% stri_timezone_list(offset=5.5))
   expect_true("Asia/Katmandu" %in% stri_timezone_list(offset=5.75))
   expect_true("Europe/Tallinn" %in% stri_timezone_list(offset=2))
   expect_true("America/Los_Angeles" %in% stri_timezone_list(offset=-8))
   expect_true("UTC" %in% stri_timezone_list(offset=0))
   expect_true("Europe/Warsaw" %in% stri_timezone_list("pl"))
   
   for (i in (-12):14)
      expect_true(length(stri_timezone_list(offset=i))>0)
})
