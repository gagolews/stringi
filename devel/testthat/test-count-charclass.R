require(testthat)
context("test-count-charclass.R")

test_that("stri_count_charclass", {
   expect_identical(stri_count_charclass("a", NA), NA_integer_)
   expect_identical(stri_count_charclass(NA, "\\p{Z}"), NA_integer_)
   expect_identical(stri_count_charclass(NA, NA), NA_integer_)
   expect_error(stri_count_charclass("a", "WTF????"))

   expect_identical(stri_count_charclass(c(""), "\\p{L}"), 0L)

   expect_identical(stri_count_charclass(c("a", "ab", "abc", "1234"), "\\p{L}"), c(1L,2L,3L,0L))
   expect_identical(stri_count_charclass("a\u0105bc", c("\\p{L}", "\\p{Ll}", "\\p{Lu}")), c(4L,4L,0L))
   expect_identical(stri_count_charclass("a\u0105bc", c("\\p{l}", "\\p{ll}", "\\p{lu}")), c(4L,4L,0L))
   expect_identical(stri_count_charclass("a\u0105bc", c("\\P{l}", "\\P{ll}", "\\P{lu}")), c(0L,0L,4L))
   expect_identical(stri_count_charclass("a\u0105bc", c("\\p{AlPh_a  bEtic}")), c(4L))
})
