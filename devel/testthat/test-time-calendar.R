require(testthat)
context("test-time-calendar.R")

test_that("stri_datetime_now", {
   expect_true(is(stri_datetime_now(), "POSIXst"))
   expect_true(is(stri_datetime_now(), "POSIXct"))
   expect_true(is(stri_datetime_now(), "POSIXt"))

   expect_true(abs(unclass(stri_datetime_now())-unclass(Sys.time()))<1)
})



test_that("stri_datetime_create", {
   
   x <- stri_datetime_create(2010:2015, 01, 01)
   expect_equivalent(length(x), 6)
   expect_equivalent(attr(x, 'tzone'), NULL)
   
   expect_equivalent(format(x), c(
     "2010-01-01 12:00:00", "2011-01-01 12:00:00", "2012-01-01 12:00:00",
     "2013-01-01 12:00:00", "2014-01-01 12:00:00", "2015-01-01 12:00:00" 
   ))
   
   x <- stri_datetime_create(2010:2015, 1:6, 1, 12, 59, 50:55, tz='Europe/Moscow')
   expect_equivalent(length(x), 6)
   expect_equivalent(attr(x, 'tzone'), 'Europe/Moscow')

   expect_equivalent(format(x), c(
      "2010-01-01 12:59:50", "2011-02-01 12:59:51", "2012-03-01 12:59:52",
      "2013-04-01 12:59:53", "2014-05-01 12:59:54", "2015-06-01 12:59:55"
   ))
   
   
   expect_equivalent(stri_datetime_format(stri_datetime_create(0, 1, 1), "Y"), "0")
   expect_equivalent(stri_datetime_format(stri_datetime_create(-1, 1, 1), "Y"), "-1")
   
   expect_equivalent(format(stri_datetime_create(5775, 8, 1, locale="@@calendar=hebrew")),
      "5775-08-01 12:00:00")
   expect_true(is.na(stri_datetime_create(2015, 02, 29)))
   expect_equivalent(format(stri_datetime_create(2015, 02, 29, lenient=TRUE)),
      "2015-03-01 12:00:00")
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
