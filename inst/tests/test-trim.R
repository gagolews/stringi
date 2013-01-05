require(testthat)


test_that("stri_trim", {
  
   # basic tests (ASCII, border-line):
   expect_equivalent(stri_trim(character(0)), character(0))
   expect_equivalent(stri_trim(NA), NA_character_)
   
   expect_equivalent(stri_trim("      "), "")
   expect_equivalent(stri_trim("   A  "), "A")
   expect_equivalent(stri_trim("A     "), "A")
   expect_equivalent(stri_trim("     A"), "A")
   
   expect_equivalent(stri_trim(LETTERS), LETTERS)
   
   expect_equivalent(stri_trim(stri_dup(" ", 1:100)), rep("", 100))
})
