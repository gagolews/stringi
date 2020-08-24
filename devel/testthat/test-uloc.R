require(testthat)
context("test-uloc.R")

test_that("stri_locale", {
    
    expect_true(length(stri_locale_list()) > 0)
    
    expect_warning(stri_locale_set("XX_YY"))
    suppressMessages(expect_true(substr(stri_locale_set("pl_PL"), 1, 5) == "xx_YY"))
    suppressMessages(expect_true(substr(stri_locale_set("pl_PL"), 1, 5) == "pl_PL"))
    
})
