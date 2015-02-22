require(testthat)
context("test-time-format")

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
   
   expect_true(stri_datetime_fstr("%Z") == "z")
   expect_true(stri_datetime_fstr("%z") == "Z")
   expect_true(stri_datetime_fstr("%Y") == "yyyy")
   expect_true(stri_datetime_fstr("%y") == "yy")
   expect_true(stri_datetime_fstr("%t") == "\t")
   expect_true(stri_datetime_fstr("%n") == "\n")
   expect_true(stri_datetime_fstr("%m") == "MM")
   expect_true(stri_datetime_fstr("%M") == "mm")
   expect_true(stri_datetime_fstr("%S") == "ss")
   expect_true(stri_datetime_fstr("%H") == "HH")
   expect_true(stri_datetime_fstr("%d") == "dd")
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



test_that("stri_datetime_format", {
   
   
})


test_that("format.POSIXct", {
   
})


test_that("stri_datetime_parse", {
   
   
})

