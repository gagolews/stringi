require(testthat)
context("test-utils.R")

test_that("stri_remove_empty", {

   expect_equivalent(stri_remove_empty(stri_na2empty(c("a", NA, "", "b"))), c("a", "b"))
   expect_equivalent(stri_remove_empty(c("a", NA, "", "b")), c("a", NA, "b"))
   expect_equivalent(stri_remove_empty(c("a", NA, "", "b"), TRUE), c("a", "b"))

   expect_equivalent(stri_omit_empty_na(c("a", NA, "", "b")), c("a", "b"))
})

test_that("stri_na2empty", {

   expect_equivalent(stri_na2empty(c("a", NA, "", "b")), c("a", "", "", "b"))
})

