require(testthat)
context("test-cppapi1")

test_that("cppapi", {
   if (require('Rcpp')) {
      Rcpp::sourceCpp("test-cppapi1.cpp")
      expect_identical(test_dup("1", 3), "111")
      rm(test_dup)
   }
})
