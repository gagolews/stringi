require(testthat)

test_that("stri_numbytes", {
   expect_equivalent(stri_numbytes(c(NA, '', ' ', 'abc', '\u0104B\u0106')), c(NA, 0, 1, 3, 5))
})

test_that("stri_length", {
   expect_equivalent(stri_length(c(NA, '', ' ', 'abc', '\u0104B\u0106')), c(NA, 0, 1, 3, 3))
})
  

test_that("stri_length-cjk", {
   cjk_test <- intToUtf8(c(24120, 29992, 22283, 23383, 27161, 28310, 23383, 39636, 34920)) # '常用國字標準字體表'
   expect_equivalent(stri_numbytes(cjk_test), 27)
   expect_equivalent(stri_length(cjk_test), 9)
   
   cjk_test_Big5 <- stri_encode(cjk_test, 'UTF-8', 'Big5')
   expect_equivalent(stri_numbytes(cjk_test_Big5), 18)
   oldenc <- stri_encinfo()$Name.friendly
   stri_encset('Big5')
   expect_equivalent(stri_length(cjk_test_Big5), 9)
   stri_encset(oldenc)
})


test_that("stri_isempty", {
   expect_equivalent(stri_isempty(c(NA, '', ' ', 'abc', '\u0104B\u0106')), c(NA, T, F, F, F))
})


test_that("stri_width", {
#    expect_equivalent(stri_width(c(NA, '', ' ', 'abc', '\u0104B\u0106')), c(NA, 0, 1, 3, 3))
})
