require(testthat)

test_that("stri_numbytes", {
   expect_equivalent(stri_numbytes(c(NA, '', ' ', 'abc', 'ąbć')), c(NA, 0, 1, 3, 5))
})
  

test_that("stri_length", {
   expect_equivalent(stri_length(c(NA, '', ' ', 'abc', 'ąbć')), c(NA, 0, 1, 3, 3))
})


test_that("stri_isempty", {
   expect_equivalent(stri_isempty(c(NA, '', ' ', 'abc', 'ąbć')), c(NA, T, F, F, F))
})


test_that("stri_width", {
   expect_equivalent(stri_width(c(NA, '', ' ', 'abc', 'ąbć')), c(NA, 0, 1, 3, 3))
})
