require("testthat")

test_that("stri_detect_fixed", {
   expect_identical(stri_detect_fixed("a", NA), NA)
   expect_identical(stri_detect_fixed(NA, "a"), NA)
   expect_identical(stri_detect_fixed(NA, NA), NA)
   expect_identical(stri_detect_fixed("kot lorem1", character(0)), logical(0))
   expect_identical(stri_detect_fixed(character(0), "ipsum 1234"), logical(0))
   expect_identical(stri_detect_fixed(character(0), character(0)), logical(0))
   
   s <- c("Lorem\n123", " ", "kota", "4\tą")
   p <- c(" ", "\tą")
   expect_identical(stri_detect_fixed(s, p), c(F, F, F, T))
   
   expect_warning(stri_detect_fixed(rep("asd", 5), rep("a", 2)))
   
})


test_that("stri_detect_regex", {
   expect_identical(stri_detect_regex(NA, NA), NA)
   expect_identical(stri_detect_regex(character(0), character(0)), logical(0))
   
   expect_identical(stri_detect_regex('a', c('a', 'b', 'c')), c(T,F,F))
   expect_identical(stri_detect_regex(c('a', 'b', 'c'), 'a'), c(T,F,F))
   
   s <- c("Lorem", "123", " ", " ", "kota", "4\tą")
   p <- c("[[:alpha:]]+", "[[:blank:]]+")
   expect_identical(stri_detect_regex(s, p), c(T, F, F, T, T, T))
   expect_identical(stri_detect_regex("Lo123\trem", c("[[:alpha:]]", "[4-9]+")), c(T, F))
   
   expect_warning(stri_detect_regex(rep("asd", 5), rep("[A-z]", 2)))
   expect_error(stri_detect_regex("Ala", "{}"))
   
   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaa"), TRUE)
   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaa",  "aaaaaaaaaaaaaaa"), TRUE)
   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaa"), TRUE)
   
})
