require(testthat)

test_that("stri_flatten", {
   
   
   expect_that(stri_flatten(c("A", "", "B", "", "C")), is_identical_to("ABC"))

})
