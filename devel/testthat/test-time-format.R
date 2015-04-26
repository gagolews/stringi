require(testthat)
context("test-time-format.R")

test_that("stri_datetime_fstr", {
   expect_true(stri_datetime_fstr(" test123") == "' test123'")
   expect_true(stri_datetime_fstr("%%") == "'%'")
   expect_true(stri_datetime_fstr("%%y%%m%%") == "'%y%m%'")
   expect_true(stri_datetime_fstr("''") == "'\\'\\''")
   expect_true(stri_datetime_fstr("%y") == "yy")
   expect_true(stri_datetime_fstr("%Y") == "yyyy")
   expect_warning(stri_datetime_fstr("%Q"))
   expect_true(suppressWarnings(stri_datetime_fstr("%Q")) == "%?") # unsupported formatter
   expect_true(stri_datetime_fstr("!%y!") == "'!'yy'!'")
   expect_true(stri_datetime_fstr("%%%y%%") == "'%'yy'%'")

   expect_equivalent(stri_datetime_fstr(c("%Z", "%z")), c("z", "Z"))
   expect_true(stri_datetime_fstr("%Y") == "yyyy")
   expect_true(stri_datetime_fstr("%y") == "yy")
   expect_true(stri_datetime_fstr("%t") == "\t")
   expect_true(stri_datetime_fstr("%n") == "\n")
   expect_true(stri_datetime_fstr("%m") == "MM")
   expect_true(stri_datetime_fstr("%M") == "mm")
   expect_true(stri_datetime_fstr("%S") == "ss")
   expect_true(stri_datetime_fstr("%H") == "HH")
   expect_true(stri_datetime_fstr("%d") == "dd")
   expect_equivalent(stri_datetime_fstr(character(0)), character(0))
#    expect_equivalent(stri_datetime_fstr(NA), NA_character_)
})


# t <- strptime('2014-12-04 13:01:02', "%Y-%m-%d %H:%M:%S", tz="CET")
# w <- c('%a', '%A', '%b', '%B', '%c', '%C', '%d', '%D', '%e', '%F', '%h',
#    '%H', '%I', '%j', '%m', '%M', '%n', '%p', '%r', '%R', '%S', '%t',
#    '%T', '%u', '%U', '%V', '%w', '%W', '%x', '%X', '%y', '%Y', '%z', '%Z', '%g', '%G')
# for (f in w)
#    cat(c(f,
#       stri_datetime_format(t, stri_datetime_fstr(f), locale = 'pl_PL'),
#       strftime(t, f)), "\n",
#       sep="\t"
#    )



test_that("stri_datetime_parse, stri_datetime_format, format.POSIXct", {
   t <- stri_datetime_parse("2015-02-25 23:53:01")
   expect_equivalent(attr(t, 'tzone'), NULL)
   expect_equivalent(format(t), "2015-02-25 23:53:01")

   expect_equivalent(unclass(stri_datetime_parse(NA)), NA_real_)
   expect_equivalent(unclass(stri_datetime_parse(character(0))), double(0))

   expect_equivalent(unclass(stri_datetime_format(as.POSIXct(NA))), NA_character_)
   expect_equivalent(unclass(stri_datetime_format(structure(double(0), class=c("POSIXct", "POSIXt")))), character(0))

   t <- stri_datetime_parse("2015-02-25 23:53:01", tz='Europe/Tallinn')
   expect_equivalent(attr(t, 'tzone'), 'Europe/Tallinn')
   expect_equivalent(format(t, tz='Europe/Warsaw'), "2015-02-25 22:53:01")
   expect_equivalent(format(structure(t, tzone='Europe/Tallinn')), "2015-02-25 23:53:01")

   # daylight savings time=FALSE
   x1 <- as.POSIXct(strptime("2015-03-01 12:00:00", "%Y-%m-%d %H:%M:%S", tz="Europe/Warsaw"))
   x2 <- stri_datetime_parse("2015-03-01 12:00:00", tz="Europe/Warsaw")
   expect_equivalent(format(x1), format(x2))
   expect_equivalent(format(x1, usetz=TRUE), format(x2, usetz=TRUE))

   x1 <- as.POSIXlt(x1)
   expect_equivalent(format(x1), format(x2))
   expect_equivalent(format(x1, usetz=TRUE), format(x2, usetz=TRUE))

   # daylight savings time=TRUE
   x1 <- as.POSIXct(strptime(c("2015-04-01 12:00:00", "2015-03-31 23:59:59"), "%Y-%m-%d %H:%M:%S", tz="Europe/Warsaw"))
   x2 <- stri_datetime_parse(c("2015-04-01 12:00:00", "2015-03-31 23:59:59"), tz="Europe/Warsaw")
   expect_equivalent(format(x1), format(x2))
   expect_equivalent(format(x1, usetz=TRUE), format(x2, usetz=TRUE))

   x1 <- as.POSIXlt(x1)
   expect_equivalent(format(x1), format(x2))
   expect_equivalent(format(x1, usetz=TRUE), format(x2, usetz=TRUE))

   x1 <- as.POSIXct(strptime("2015-03-01 12:00:00", "%Y-%m-%d %H:%M:%S", tz="GMT"))
   x2 <- stri_datetime_parse("2015-03-01 12:00:00", tz="GMT")
   expect_equivalent(format(x1), format(x2))
   expect_equivalent(format(x1, usetz=TRUE), format(x2, usetz=TRUE))

   x1 <- as.POSIXlt(x1)
   expect_equivalent(format(x1), format(x2))
   expect_equivalent(format(x1, usetz=TRUE), format(x2, usetz=TRUE))


   x1 <- stri_paste("2015-01-01 ", sprintf("%02g", 0: 23), ":59:59")
   x1 <- stri_datetime_parse(x1, tz='CET')

   x2 <- stri_paste("2015-01-01 ", sprintf("%02g", 0: 23), ":59:59")
   x2 <- strptime(x2, "%Y-%m-%d %H:%M:%S", tz='CET')
   expect_equivalent(format(data.frame(x=x1)), format(data.frame(x=x2)))
})
