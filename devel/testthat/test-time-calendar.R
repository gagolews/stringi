require(testthat)
context("test-time-calendar.R")

test_that("stri_datetime_now", {
    # expect_true(is(stri_datetime_now(), 'POSIXst'))
    expect_true(is(stri_datetime_now(), "POSIXct"))
    expect_true(is(stri_datetime_now(), "POSIXt"))
    
    expect_true(abs(unclass(stri_datetime_now()) - unclass(Sys.time())) < 1)
})



test_that("stri_datetime_create", {
    
    expect_equivalent(unclass(stri_datetime_create(NA, 1, 1)), NA_real_)
    expect_equivalent(unclass(stri_datetime_create(NA, 1:1000, integer(0))), double(0))
    
    x <- stri_datetime_create(2010:2015, 1, 1)
    expect_equivalent(length(x), 6)
    expect_equivalent(attr(x, "tzone"), NULL)
    
    expect_equivalent(format(x), c("2010-01-01 12:00:00", "2011-01-01 12:00:00", 
        "2012-01-01 12:00:00", "2013-01-01 12:00:00", "2014-01-01 12:00:00", "2015-01-01 12:00:00"))
    
    x <- stri_datetime_create(2010:2015, 1:6, 1, 12, 59, 50:55, tz = "Europe/Moscow")
    expect_equivalent(length(x), 6)
    expect_equivalent(attr(x, "tzone"), "Europe/Moscow")
    
    #    # Russia changed its existing time zones on October 26, 2014.
    #    expect_equivalent(format(x), c(
    #       '2010-01-01 12:59:50', '2011-02-01 12:59:51', '2012-03-01 12:59:52',
    #       '2013-04-01 12:59:53', '2014-05-01 12:59:54', '2015-06-01 12:59:55'
    #    ))
    
    stri_datetime_format(x)
    
    expect_equivalent(stri_datetime_format(stri_datetime_create(0, 1, 1), "Y"), "0")
    expect_equivalent(stri_datetime_format(stri_datetime_create(-1, 1, 1), "Y"), 
        "-1")
    
    expect_equivalent(strftime(stri_datetime_create(5775, 8, 1, locale = "@@calendar=hebrew"), 
        "%Y-%m-%d"), "5775-08-01")
    expect_true(is.na(stri_datetime_create(2015, 2, 29)))
    expect_equivalent(format(stri_datetime_create(2015, 2, 29, lenient = TRUE)), 
        "2015-03-01 12:00:00")
})

test_that("stri_datetime_add", {
    x <- stri_datetime_now()
    # expect_true(is(stri_datetime_add(x, 1, 'seconds'), 'POSIXst'))
    expect_true(is(stri_datetime_add(x, 1, "seconds"), "POSIXct"))
    expect_true(is(stri_datetime_add(x, 1, "seconds"), "POSIXt"))
    expect_equal(attr(stri_datetime_add(x, 1, "seconds", tz = "Europe/Warsaw"), "tzone"), 
        "Europe/Warsaw")
    
    xold <- x
    stri_datetime_add(x, "seconds") <- 1
    expect_equivalent(as.numeric(x), as.numeric(xold) + 1)
    
    stri_datetime_add(x, "seconds") <- (-5):5
    expect_equivalent(as.numeric(x), as.numeric(xold) + (-4:6))
    
    expect_equivalent(unclass(stri_datetime_add(stri_datetime_now(), numeric(0), 
        "seconds")), numeric(0))
    expect_equivalent(unclass(stri_datetime_add(structure(numeric(0), class = c("POSIXct", 
        "POSIXt")), 1, "seconds")), numeric(0))
    expect_equivalent(unclass(stri_datetime_add(stri_datetime_now(), NA, "seconds")), 
        NA_real_)
    expect_equivalent(unclass(stri_datetime_add(structure(NA_real_, class = c("POSIXct", 
        "POSIXt")), 1, "seconds")), NA_real_)
    
    expect_equivalent(stri_datetime_add(stri_datetime_create(2016, 1, 31), 1, units = "months", 
        locale = "en_US"), stri_datetime_create(2016, 2, 29))
    expect_equivalent(stri_datetime_add(stri_datetime_create(2014, 4, 20), 1, units = "years", 
        locale = "@calendar=hebrew"), stri_datetime_create(2015, 4, 9))
})


test_that("stri_datetime_fields", {
    
    expect_true(nrow(stri_datetime_fields(structure(double(0), class = c("POSIXTst", 
        "POSIXct", "POSIXt")))) == 0)
    expect_true(all(is.na(as.integer(stri_datetime_fields(structure(NA_real_, class = c("POSIXTst", 
        "POSIXct", "POSIXt")))))))
    
    x <- stri_datetime_fields(stri_datetime_create(2015, 1, 2, 13, 14, 15.5))
    expect_equivalent(x$Year, 2015)
    expect_equivalent(x$Month, 1)
    expect_equivalent(x$Day, 2)
    expect_equivalent(x$Hour, 13)
    expect_equivalent(x$Minute, 14)
    expect_equivalent(x$Second, 15)
    expect_equivalent(x$Millisecond, 500)
    
    x <- stri_datetime_fields(stri_datetime_create(2015, 1, 2, 19, 13, 14.5, tz = "America/New_York"))
    expect_equivalent(x$Hour, 19)
    
    suppressWarnings(x <- stri_datetime_fields(as.POSIXlt(stri_datetime_create(2015, 
        1, 2, 19, 13, 14.5, tz = "America/New_York"))))
    expect_equivalent(x$Hour, 19)
    
})


# test_that('c.POSIXst', {
#
#    x1 <- stri_datetime_create(2015, 1, 1)
#    x2 <- stri_datetime_now()
#    expect_true(length(c(x1, c(x2, x1), as.POSIXlt(x1), as.POSIXct(x2), as.POSIXct(NA))) == 6)
#    expect_true(is(c(x1, c(x2, x1), as.POSIXlt(x1), as.POSIXct(x2)), 'POSIXst'))
#
# })
