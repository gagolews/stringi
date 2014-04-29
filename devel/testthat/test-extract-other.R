require(testthat)

test_that("stri_extract_words", {

   expect_identical(stri_extract_words("   ala ma   kota... above-mentioned    123.45...  ")[[1]],
      c("ala"   ,    "ma"    ,    "kota"   ,   "above"   ,  "mentioned", "123.45"))

   expect_identical(stri_extract_words(c("   ", "", NA)),
      list(NA_character_, NA_character_, NA_character_))

#    expect_identical(stri_extract_words(c("", "stringi", NA)),
#       list(character(0), "stringi", NA_character_))
})
