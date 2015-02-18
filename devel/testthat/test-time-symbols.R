require(testthat)
context("test-time-symbols.R")

test_that("stri_datetime_symbols", {

   expect_true(length(stri_datetime_symbols()$Months) == 12)
   expect_true(length(stri_datetime_symbols()$Weekdays) == 7)
   expect_true(length(stri_datetime_symbols()$Quarters) == 4)

   expect_true(length(stri_datetime_symbols(locale="en_US", width="abbreviated")$Months) == 12)
   expect_true(length(stri_datetime_symbols(locale="en_US", width="abbreviated")$Weekdays) == 7)
   expect_true(length(stri_datetime_symbols(locale="en_US", width="abbreviated")$Quarters) == 4)
   
   expect_true(stri_datetime_symbols("en_US@calendar=hebrew")$Months[1] == "Tishri")
   expect_true(stri_datetime_symbols("en_US@calendar=islamic")$Months[1] == "Muharram")
})
