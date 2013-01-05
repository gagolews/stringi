require(testthat)

test_that("stri_tolower", {
   
   expect_that(stri_tolower(LETTERS), is_equivalent_to(letters)) 
   expect_that(stri_tolower(letters), is_equivalent_to(letters))
   
   expect_that(stri_toupper(LETTERS), is_equivalent_to(LETTERS)) 
   expect_that(stri_toupper(letters), is_equivalent_to(LETTERS))
   
})