require(testthat)
context("test-time-zone.R")

test_that("stri_timezone_list", {

   expect_true(is.character(stri_timezone_list()))
   expect_true(length(stri_timezone_list()) > 0)
   expect_error(stri_timezone_list(,mean))
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
   expect_true("America/Atka" %in% stri_timezone_list(region="US", offset=-10))
   
   for (i in (-12):14)
      expect_true(length(stri_timezone_list(offset=i))>0)
})


test_that("stri_timezone_get/set", {
   expect_true(stri_length(ctz <- stri_timezone_get()) > 0)

   expect_true(ctz == stri_timezone_set("Europe/Tallinn"))
   expect_true(stri_timezone_get() == "Europe/Tallinn")
   expect_true(stri_timezone_set(ctz) == "Europe/Tallinn")
   expect_true(ctz == stri_timezone_get())
})


test_that("stri_timezone_info", {
   expect_equivalent(stri_timezone_info(tz="Europe/Warsaw", locale="en_GB"),
      list("Europe/Warsaw", "Central European Standard Time", "Central European Summer Time",
         "Central European Standard Time", 1, TRUE))

   expect_equivalent(stri_timezone_info(tz="Asia/Kathmandu", locale="pl_PL"),
      list("Asia/Kathmandu", "Nepal", NULL, "Nepal Standard Time", 5.75, FALSE))
})
