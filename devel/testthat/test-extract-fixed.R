require(testthat)
require(stringr)
context("test-extract-fixed.R")

test_that("stri_extract_all_fixed", {
   expect_identical(stri_extract_all_fixed(character(0), "test"), list())
   expect_identical(stri_extract_all_fixed("test", character(0)), list())
   expect_identical(stri_extract_all_fixed(character(0), character(0)), list())
   expect_identical(stri_extract_all_fixed(NA, "test"), list(NA_character_))
   expect_identical(stri_extract_all_fixed("test", NA), list(NA_character_))
   suppressWarnings(expect_identical(stri_extract_all_fixed("test", ""), list(NA_character_)))

   expect_identical(stri_extract_all_fixed("", " "), list(NA_character_))
   expect_identical(stri_extract_all_fixed("", " ", omit_no_match = TRUE), list(character(0)))
   expect_identical(stri_extract_all_fixed("test", " "), list(NA_character_))
   expect_identical(stri_extract_all_fixed("test", " ", omit_no_match = TRUE), list(character(0)))

   expect_identical(stri_extract(c("a_a", "a_a_a", "a", ""), mode='all', fixed="a", simplify=NA),
      matrix(c("a", "a", "a", NA, "a", "a", NA, NA, NA, "a", NA, NA), nrow=4))

   expect_identical(stri_extract(c("a_a", "a_a_a", "a", ""), mode='all', fixed="a", simplify=TRUE, omit_no_match=TRUE),
      matrix(c("a", "a", "a", "", "a", "a", "", "", "", "a", "", ""), nrow=4))

   expect_identical(stri_extract_all_fixed("abaBAba", "Aba", case_insensitive=TRUE, overlap=TRUE), list(c("aba", "aBA", "Aba")))

#    expect_identical(stri_extract_all_fixed(c("ababab", NA, "ab", "ba"), "ab"),
#       str_extract_all(c("ababab", NA, "ab", "ba"), "ab"))
})



test_that("stri_extract_first_fixed", {
   expect_identical(stri_extract_first_fixed(character(0), "test"), character(0))
   expect_identical(stri_extract_first_fixed("test", character(0)), character(0))
   expect_identical(stri_extract_first_fixed(character(0), character(0)), character(0))
   expect_identical(stri_extract_first_fixed(NA, "test"), NA_character_)
   expect_identical(stri_extract_first_fixed("test", NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_first_fixed("test", ""), NA_character_))
   expect_identical(stri_extract_first_fixed("\U00f0ffffb\u0105deb!d", "b\u0105d"), "b\u0105d")
   expect_identical(stri_extract_first_fixed("\U00f0ffffb\u0105deb!d", "B\u0105D", case_insensitive=TRUE), "b\u0105d")

   expect_identical(stri_extract_first_fixed(c("ababab", NA, "ab", "ba"), "ab"),
      str_extract(c("ababab", NA, "ab", "ba"), "ab"))
})


test_that("stri_extract_last_fixed", {

   expect_identical(stri_extract_last_fixed(character(0), "test"), character(0))
   expect_identical(stri_extract_last_fixed("test", character(0)), character(0))
   expect_identical(stri_extract_last_fixed(character(0), character(0)), character(0))
   expect_identical(stri_extract_last_fixed(NA, "test"), NA_character_)
   expect_identical(stri_extract_last_fixed("test", NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_last_fixed("test", ""), NA_character_))
   expect_identical(stri_extract_last_fixed("b!d\U00f0ffffb\u0105de", "b\u0105d"), "b\u0105d")
   expect_identical(stri_extract_last_fixed("b!d\U00f0ffffb\u0105de", "B\u0105D", case_insensitive=TRUE), "b\u0105d")

})
