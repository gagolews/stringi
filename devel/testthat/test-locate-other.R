require(testthat)

test_that("stri_locate_boundaries", {
   expect_error(stri_locate_boundaries("aaa", "???"))
   expect_equivalent(stri_locate_boundaries(c(NA, NA), "word"),
      list(matrix(NA_integer_, ncol=2, nrow=1), matrix(NA_integer_, ncol=2, nrow=1)))
   expect_equivalent(stri_locate_boundaries("aa", c(NA, NA)),
      list(matrix(NA_integer_, ncol=2, nrow=1), matrix(NA_integer_, ncol=2, nrow=1)))
   expect_equivalent(stri_locate_boundaries(stri_trans_nfkd("a\u0105"), 'chara')[[1]],
      matrix(c(1,1,2,3), nrow=2, byrow=TRUE))
})



test_that("stri_locate_words", {

   expect_equivalent(stri_locate_words(c("", "stringi", NA)),
      list(matrix(c(NA, NA), ncol=2),
           matrix(c(1, 7), ncol=2),
           matrix(c(NA, NA), ncol=2)))
})

