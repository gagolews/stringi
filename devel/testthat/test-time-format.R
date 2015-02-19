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
   
   
   
})


# t <- strptime('2014-12-29 13:01:02', "%Y-%m-%d %H:%M:%S", tz="CET")
# w <- c('%r', '%R', '%S', '%t', '%T', '%u', '%U', '%V', '%w', '%W', '%x', '%X', '%y', '%Y', '%z', '%Z')
# for (f in w)
#    cat(c(f,
#       stri_datetime_format(t, stri_datetime_fstr(f), locale = 'en_US'),
#       strftime(t, f)), "\n",
#       sep="\t"
#    )
