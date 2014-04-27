require(testthat)
require(stringr)

test_that("stri_extract_all_regex", {
   expect_identical(stri_extract_all_regex(character(0), "test"), list())
   expect_identical(stri_extract_all_regex("test", character(0)), list())
   expect_identical(stri_extract_all_regex(character(0), character(0)), list())
   expect_identical(stri_extract_all_regex(NA, "test"), list(NA_character_))
   expect_identical(stri_extract_all_regex("test", NA), list(NA_character_))
   suppressWarnings(expect_identical(stri_extract_all_regex("test", ""), list(NA_character_)))
   expect_identical(stri_extract_all_regex(c("bacab", "bacaba\u0105a", "aa"), "a.a"), 
      list("aca", c("aca", "a\u0105a"), NA_character_))
   
#    expect_identical(stri_extract_all_regex(c("ababab", NA, "ab", "ba"), "ab"),
#       str_extract_all(c("ababab", NA, "ab", "ba"), "ab"))
})



test_that("stri_extract_first_regex", {
   expect_identical(stri_extract_first_regex(character(0), "test"), character(0))
   expect_identical(stri_extract_first_regex("test", character(0)), character(0))
   expect_identical(stri_extract_first_regex(character(0), character(0)), character(0))
   expect_identical(stri_extract_first_regex(NA, "test"), NA_character_)
   expect_identical(stri_extract_first_regex("test", NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_first_regex("test", ""), NA_character_))
   expect_identical(stri_extract_first_regex("\U00f0ffffb\u0105deb!d", "b.d"), "b\u0105d")
   expect_identical(stri_extract_first_regex("\U00f0ffffb\u0105deb!d", "B.D", stri_opts_regex(case_insensitive=TRUE)), "b\u0105d")

   expect_identical(stri_extract_first_regex(c("ababab", NA, "ab", "ba"), "ab"),
      str_extract(c("ababab", NA, "ab", "ba"), "ab"))
})


test_that("stri_extract_last_regex", {

   expect_identical(stri_extract_last_regex(character(0), "test"), character(0))
   expect_identical(stri_extract_last_regex("test", character(0)), character(0))
   expect_identical(stri_extract_last_regex(character(0), character(0)), character(0))
   expect_identical(stri_extract_last_regex(NA, "test"), NA_character_)
   expect_identical(stri_extract_last_regex("test", NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_last_regex("test", ""), NA_character_))
   expect_identical(stri_extract_last_regex("b!d\U00f0ffffb\u0105de", "b.d"), "b\u0105d")
   expect_identical(stri_extract_last_regex("b!d\U00f0ffffb\u0105de", "B.D", stri_opts_regex(case_insensitive=TRUE)), "b\u0105d")

})
