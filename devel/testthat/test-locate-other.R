require(testthat)

test_that("stri_locate_boundaries", {
   expect_identical(colnames(stri_locate_boundaries("stringi")[[1]]), c("start", "end"))
   expect_error(stri_locate_boundaries("aaa", stri_opts_brkiter(type="???")))
   expect_equivalent(stri_locate_boundaries(c(NA, NA), stri_opts_brkiter(type="word")),
      list(matrix(NA_integer_, ncol=2, nrow=1), matrix(NA_integer_, ncol=2, nrow=1)))
   expect_equivalent(stri_locate_boundaries(stri_trans_nfkd("a\u0105"), stri_opts_brkiter(type='chara'))[[1]],
      matrix(c(1,1,2,3), nrow=2, byrow=TRUE))
})



test_that("stri_locate_words", {

   expect_identical(colnames(stri_locate_words("stringi")[[1]]), c("start", "end"))

   expect_equivalent(stri_locate_words(c("", "stringi", NA)),
      list(matrix(c(NA, NA), ncol=2),
           matrix(c(1, 7), ncol=2),
           matrix(c(NA, NA), ncol=2)))
})
