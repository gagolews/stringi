require(testthat)
context("test-time-symbols.R")

test_that("stri_datetime_symbols", {
    
    expect_true(length(stri_datetime_symbols()$Month) == 12)
    expect_true(length(stri_datetime_symbols()$Weekday) == 7)
    expect_true(length(stri_datetime_symbols()$Quarter) == 4)
    
    expect_true(length(stri_datetime_symbols(locale = "en_US", width = "abbreviated")$Month) == 
        12)
    expect_true(length(stri_datetime_symbols(locale = "en_US", width = "abbreviated")$Weekday) == 
        7)
    expect_true(length(stri_datetime_symbols(locale = "en_US", width = "abbreviated")$Quarter) == 
        4)
    
    expect_true(stri_datetime_symbols("en_US@calendar=hebrew")$Month[1] == "Tishri")
    expect_true(stri_datetime_symbols("en_US@calendar=islamic")$Month[1] == "Muharram")
})
