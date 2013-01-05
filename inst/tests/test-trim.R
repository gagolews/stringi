require(testthat)


test_that("stri_trim", {
  
   expect_that(stri_trim("      "), is_equivalent_to(""))
   expect_that(stri_trim("   A  "), is_equivalent_to("A"))
   expect_that(stri_trim("A     "), is_equivalent_to("A"))
   expect_that(stri_trim("     A"), is_equivalent_to("A"))
   
   expect_that(stri_trim(LETTERS), is_equivalent_to(LETTERS))
   
   expect_that(stri_trim(stri_dup(" ", 1:100)), is_equivalent_to(rep("", 100)))
})
