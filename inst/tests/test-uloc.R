require(testthat)


test_that("stri_locale", {
   
   expect_true(length(stri_localelist())>0)
   
   expect_warning(stri_localeset("XX_YY"))
   expect_true(substr(stri_localeset("pl_PL"), 1, 5) == "pl_PL")
   
})
