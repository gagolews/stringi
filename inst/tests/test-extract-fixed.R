require(testthat)

test_that("stri_extract_all_fixed", {
   
   expect_identical(stri_extract_all_fixed(NA, "test"), list(NA_character_))
   expect_identical(stri_extract_all_fixed("test", NA), list(NA_character_))
   suppressWarnings(expect_identical(stri_extract_all_fixed("test", ""), list(NA_character_)))
   suppressWarnings(expect_identical(stri_extract_all_fixed("test", " "), list(NA_character_)))
   expect_identical(stri_extract_all_fixed("alaALA", "ala", stri_opts_collator(strength=1)), list(c("ala", "ALA")))
   
   expect_identical(stri_extract_all_fixed(NA, "test", NA), list(NA_character_))
   expect_identical(stri_extract_all_fixed("test", NA, NA), list(NA_character_))
   suppressWarnings(expect_identical(stri_extract_all_fixed("test", "", NA), list(NA_character_)))
   suppressWarnings(expect_identical(stri_extract_all_fixed("test", " ", NA), list(NA_character_)))
   expect_identical(stri_extract_all_fixed(c("alaALA", "ala ala al"), "ala", NA), list(c("ala"), c("ala", "ala")))
   
})



test_that("stri_extract_first_fixed", {
   
   expect_identical(stri_extract_first_fixed(NA, "test"), NA_character_)
   expect_identical(stri_extract_first_fixed("test", NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_first_fixed("test", ""), NA_character_))
   suppressWarnings(expect_identical(stri_extract_first_fixed("test", " "), NA_character_))
   expect_identical(stri_extract_first_fixed("alaALA", "ala", stri_opts_collator(strength=1)), c("ala"))
   
   expect_identical(stri_extract_first_fixed(NA, "test", NA), NA_character_)
   expect_identical(stri_extract_first_fixed("test", NA, NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_first_fixed("test", "", NA), NA_character_))
   suppressWarnings(expect_identical(stri_extract_first_fixed("test", " ", NA), NA_character_))
   expect_identical(stri_extract_first_fixed("alaALA", "ala", NA), c("ala"))
   
})


test_that("stri_extract_last_fixed", {
   
   expect_identical(stri_extract_last_fixed(NA, "test"), NA_character_)
   expect_identical(stri_extract_last_fixed("test", NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_last_fixed("test", ""), NA_character_))
   suppressWarnings(expect_identical(stri_extract_last_fixed("test", " "), NA_character_))
   expect_identical(stri_extract_last_fixed("alaALA", "ala", stri_opts_collator(strength=1)), c("ALA"))
   
   expect_identical(stri_extract_last_fixed(NA, "test", NA), NA_character_)
   expect_identical(stri_extract_last_fixed("test", NA, NA), NA_character_)
   suppressWarnings(expect_identical(stri_extract_last_fixed("test", "", NA), NA_character_))
   suppressWarnings(expect_identical(stri_extract_last_fixed("test", " ", NA), NA_character_))
   expect_identical(stri_extract_last_fixed("alaALA", "ala", NA), c("ala"))
   
})

