require(testthat)
require(stringr)


test_that("stri_extract_all_coll", {

   expect_identical(stri_extract_all_coll(NA, "test"), list(NA_character_))
   expect_identical(stri_extract_all_coll("test", NA), list(NA_character_))
   suppressWarnings(expect_identical(stri_extract_all_coll("test", ""), list(NA_character_)))
   suppressWarnings(expect_identical(stri_extract_all_coll("test", " "), list(NA_character_)))
   expect_identical(stri_extract_all_coll("alaALA", "ala", opts_collator=stri_opts_collator(strength=1)), list(c("ala", "ALA")))
})



test_that("stri_extract_first_coll", {

   expect_identical(stri_extract_first_coll(NA, "test"), NA_character_)
   expect_identical(stri_extract_first_coll("test", NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_first_coll("test", ""), NA_character_))
   suppressWarnings(expect_identical(stri_extract_first_coll("test", " "), NA_character_))
   expect_identical(stri_extract_first_coll("alaALA", "ala", stri_opts_collator(strength=1)), c("ala"))

   expect_identical(stri_extract_first_coll(c("ababab", NA, "ab", "ba"), "ab"),
      str_extract(c("ababab", NA, "ab", "ba"), "ab"))
})


test_that("stri_extract_last_coll", {

   expect_identical(stri_extract_last_coll(NA, "test"), NA_character_)
   expect_identical(stri_extract_last_coll("test", NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_last_coll("test", ""), NA_character_))
   suppressWarnings(expect_identical(stri_extract_last_coll("test", " "), NA_character_))
   expect_identical(stri_extract_last_coll("alaALA", "ala", stri_opts_collator(strength=1)), c("ALA"))

})
