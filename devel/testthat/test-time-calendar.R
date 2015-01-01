require(testthat)
context("test-time-calendar.R")

test_that("stri_datetime_now", {
   expect_true(is(stri_datetime_now(), "POSIXst"))
   expect_true(is(stri_datetime_now(), "POSIXct"))
   expect_true(is(stri_datetime_now(), "POSIXt"))

   expect_equivalent(unclass(stri_datetime_now()), unclass(Sys.time()))
})


test_that("stri_datetime_add", {
   x <- stri_datetime_now()
   expect_true(is(stri_datetime_add(x, 1, "seconds"), "POSIXst"))
   expect_true(is(stri_datetime_add(x, 1, "seconds"), "POSIXct"))
   expect_true(is(stri_datetime_add(x, 1, "seconds"), "POSIXt"))
   attr(x, "tzone") <- "Europe/Warsaw"
   expect_equal(attr(stri_datetime_add(x, 1, "seconds"), "tzone"), "Europe/Warsaw")

   expect_equivalent(unclass(stri_datetime_add(x, numeric(0), "seconds")), numeric(0))
   expect_equivalent(unclass(stri_datetime_add(structure(numeric(0), class=c("POSIXct", "POSIXt")), 1, "seconds")), numeric(0))
   expect_equivalent(unclass(stri_datetime_add(x, NA, "seconds")), NA_real_)
   expect_equivalent(unclass(stri_datetime_add(structure(NA_real_, class=c("POSIXct", "POSIXt")), 1, "seconds")), NA_real_)

   # convert from date...

   # convert from POSIXlt...

   # to do....
})


test_that("stri_datetime_fields", {
   stri_datetime_fields(stri_datetime_now())
   
   
})
