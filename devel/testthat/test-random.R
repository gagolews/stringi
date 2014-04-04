require(testthat)

test_that("stri_rand_shuffle", {
   expect_identical({set.seed(123); stri_rand_shuffle(c("abcdefghi", NA, "", "a"))},
      c("fhdbgciea", NA, "", "a"))
   expect_identical(stri_length(stri_rand_shuffle(rep(stri_paste(letters, collapse=''), 10))), rep(26L, 10))
   expect_identical({set.seed(12346); stri_rand_shuffle("\u0105\u0104")},
      "\u0104\u0105")
})
