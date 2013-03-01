require("testthat")

test_that("stri_detect_regex", {
   expect_identical(stri_detect_regex(NA, NA), NA)
   expect_identical(stri_detect_regex(character(0), character(0)), logical(0))
   
   s <- c("Lorem", "123", " ", " ", "kota", "4\tą")
   p <- c("[:alpha:]+", "[:blank:]+")
   expect_identical(stri_detect_regex(s, p), c(T, F, F, T, T, T))
   expect_identical(stri_detect_regex("Lo123\trem", c("[:alpha:]", "[4-9]+")), c(T, F))
   
   expect_warning(stri_detect_regex(rep("asd", 5), rep("[A-z]", 2)))
   expect_error(stri_detect_regex("Ala", "{}"))
   
})