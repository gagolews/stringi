require(testthat)
context("test-extract-other.R")

test_that("stri_extract_all_words", {

   expect_identical(stri_extract_all_words("   ala ma   kota... above-mentioned    123.45...  ")[[1]],
      c("ala"   ,    "ma"    ,    "kota"   ,   "above"   ,  "mentioned", "123.45"))

   expect_identical(stri_extract_all_words(c("   ", "", NA)),
      list(NA_character_, NA_character_, NA_character_))

   expect_identical(stri_extract_all_words(c("   ", "", NA), omit_no_match = TRUE),
      list(character(0), character(0), NA_character_))

   expect_identical(stri_extract_all_words(c("", "ala", "ma kota"), simplify=TRUE),
      matrix(c(NA, "", "ala", "", "ma", "kota"), nrow=3, byrow=TRUE))
   
   expect_identical(stri_extract_all_words(c("", "ala", "ma kota"), simplify=NA),
      matrix(c(NA, NA, "ala", NA, "ma", "kota"), nrow=3, byrow=TRUE))

   expect_identical(stri_extract_all_words(c("", "ala", "ma kota"), simplify=NA, omit_no_match=TRUE),
      matrix(c(NA, NA, "ala", NA, "ma", "kota"), nrow=3, byrow=TRUE))
   
   
   

#    expect_identical(stri_extract_all_words(c("", "stringi", NA)),
#       list(character(0), "stringi", NA_character_))
})


test_that("stri_extract_first_words", {

   expect_identical(stri_extract_first_words("   ala ma   kota... above-mentioned    123.45...  "),
      c("ala"))

   expect_identical(stri_extract_first_words(c("   ", "", NA)),
      c(NA_character_, NA_character_, NA_character_))

   expect_identical(stri_extract_first_words(character(0)),
      character(0))

   expect_identical(stri_extract_first_words(c("", "ala", "ma kota")),
      c(NA, "ala", "ma"))

})


test_that("stri_extract_last_words", {

   expect_identical(stri_extract_last_words("   ala ma   kota... above-mentioned    123.45...  "),
      c("123.45"))

   expect_identical(stri_extract_last_words(c("   ", "", NA)),
      c(NA_character_, NA_character_, NA_character_))

   expect_identical(stri_extract_last_words(character(0)),
      character(0))

   expect_identical(stri_extract_last_words(c("", "ala", "ma kota")),
      c(NA, "ala", "kota"))

})
