require(testthat)

test_that("stri_replace_fixed", {
   expect_identical(stri_replace_all_fixed(character(0),1,2),character(0))
   expect_identical(stri_replace_all_fixed("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_fixed(NA,"A",1),NA_character_)
   s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
   expect_warning(stri_replace_all_fixed(s,c(" ","o"),1:3))
})



test_that("stri_replace_regex", {
   expect_identical(stri_replace_all_regex(character(0),1,2),character(0))
   expect_identical(stri_replace_all_regex("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all_regex(NA,"A",1),NA_character_)
   s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
   expect_warning(stri_replace_all_regex(s,c(" ","o"),1:3))
})
