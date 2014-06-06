# require(testthat)
# 
# test_that("stri_in_fixed", {
#    expect_identical(stri_in_fixed(c(NA, NA, NA), "test"), rep(NA_integer_, 3))
#    
#    expect_identical(stri_in_fixed("a", c("a", "b", "c")), c(1L))
#    expect_identical(stri_in_fixed(c("a", "b", "c", "d"), c("a", "b", "c")), c(1L, 2L, 3L, NA))
# })
