require(testthat)

test_that("stri_replace_all", {
   expect_identical(stri_replace_all(character(0),1,2),character(0))
   expect_identical(stri_replace_all("abab123 a","a",1),"1b1b123 1")
   expect_identical(stri_replace_all(NA,"A",1),NA_character_)
   s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
   expect_warning(stri_replace_all(s,c(" ","o"),1:3))
})
