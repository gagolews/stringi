require("testthat")

test_that("stri_detect_fixed", {
   expect_identical(stri_detect_fixed("a", NA), NA)
   expect_identical(stri_detect_fixed(NA, "a"), NA)
   expect_identical(stri_detect_fixed(NA, NA), NA)
   expect_identical(stri_detect_fixed(c("","ala"),"ala"), c(FALSE, TRUE))
   expect_identical(stri_detect_fixed(c("ala","", "", "bbb"),c("ala", "bbb")), c(TRUE, FALSE, FALSE, TRUE))
   expect_identical(stri_detect_fixed("kot lorem1", character(0)), logical(0))
   expect_identical(stri_detect_fixed(character(0), "ipsum 1234"), logical(0))
   expect_identical(stri_detect_fixed(character(0), character(0)), logical(0))
   expect_identical(stri_detect_fixed(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab"), c(T, T, T, T))
   expect_identical(stri_detect_fixed(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ", "\t\u0105")), c(F, F, F, T))
   expect_warning(stri_detect_fixed(rep("asd", 5), rep("a", 2)))
   expect_identical(stri_detect_fixed("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), FALSE)
   expect_equivalent(stri_detect_fixed("aaaab", "ab"), TRUE)
   expect_equivalent(stri_detect_fixed("bababababaab", "aab"), TRUE)


   suppressWarnings(expect_identical(stri_detect_fixed("",""), NA))
   suppressWarnings(expect_identical(stri_detect_fixed("a",""), NA))
   suppressWarnings(expect_identical(stri_detect_fixed("","a"), FALSE))
})
