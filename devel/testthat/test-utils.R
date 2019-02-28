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
   expect_equivalent(stri_na2empty(c("a", NA, "", "b")), stri_replace_na(c("a", NA, "", "b"), ""))
})


test_that("stri_replace_na", {
   s <- c("ala",NA,"kota")
   expect_identical(stri_replace_na(s,"brak"),c("ala","brak","kota"))
   expect_identical(stri_replace_na(s,""),c("ala","","kota"))
   expect_identical(stri_replace_na(s,NA),c("ala",NA,"kota"))
   expect_warning(stri_replace_na(s,character(3)))
   expect_error(stri_replace_na(s,character(0)))

   x <- stri_enc_tonative(stri_dup("\u0105", 1:100))
   x[sample(seq_along(x), 20)] <- NA_character_
   expect_equivalent(stri_replace_na(x, "???"), {
      x2 <- stri_enc_toutf8(x); x2[is.na(x2)] <- "???"; x2
   })
})



test_that("stri_remove_na", {
   expect_equivalent(stri_remove_na(c("1", "", "2", NA, NA, "", "3")), c("1", "", "2", "", "3"))
   expect_equivalent(stri_omit_na(c("1", "", "2", NA, NA, "", "3")), c("1", "", "2", "", "3"))
   expect_equivalent(stri_remove_empty_na(c("1", "", "2", NA, NA, "", "3")), c("1", "2", "3"))
   expect_equivalent(stri_omit_empty_na(c("1", "", "2", NA, NA, "", "3")), c("1", "2", "3"))
   expect_equivalent(stri_remove_empty(c("1", "", "2", NA, NA, "", "3")), c("1", "2", NA, NA, "3"))
   expect_equivalent(stri_omit_empty(c("1", "", "2", NA, NA, "", "3")), c("1", "2", NA, NA, "3"))
})

