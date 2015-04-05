require(testthat)
context("test-trans-other")

test_that("stri_trans_char", {

   expect_equivalent(stri_trans_char(c("aaa", "bbb"), NA, "a"), rep(NA_character_,2))
   expect_equivalent(stri_trans_char(c("aaa", "bbb"), "a", NA), rep(NA_character_,2))
   expect_equivalent(stri_trans_char(character(0), "a", "b"), character(0))
   expect_equivalent(stri_trans_char(rep(NA_character_, 10), "a", "b"), rep(NA_character_, 10))

   # expect_warning(stri_trans_char("aaaa", "a", "ab"))
   # expect_warning(stri_trans_char("aaaa", "ba", "a"))
})
