require("testthat")
context("test-detect-coll.R")

test_that("stri_detect_coll", {
   expect_identical(stri_detect_coll("a", NA), NA)
   expect_identical(stri_detect_coll(NA, "a"), NA)
   expect_identical(stri_detect_coll(NA, NA), NA)
   expect_identical(stri_detect_coll(c("","ala"),"ala"), c(FALSE, TRUE))
   expect_identical(stri_detect_coll("kot lorem1", character(0)), logical(0))
   expect_identical(stri_detect_coll(character(0), "ipsum 1234"), logical(0))
   expect_identical(stri_detect_coll(character(0), character(0)), logical(0))
   expect_identical(stri_detect_coll(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab"), c(T, T, T, T))
   expect_identical(stri_detect_coll(c("ala","", "", "bbb"),c("ala", "bbb")), c(TRUE, FALSE, FALSE, TRUE))

   expect_identical(stri_detect_coll(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ", "\t\u0105")), c(F, F, F, T))
   expect_warning(stri_detect_coll(rep("asd", 5), rep("a", 2)))
   expect_identical(stri_detect_coll("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), TRUE)
   expect_equivalent(stri_detect_coll("aaaab", "ab"), TRUE)
   expect_equivalent(stri_detect_coll("bababababaab", "aab"), TRUE)

   suppressWarnings(expect_identical(stri_detect_coll("",""), NA))
   suppressWarnings(expect_identical(stri_detect_coll("a",""), NA))
   suppressWarnings(expect_identical(stri_detect_coll("","a"), FALSE))
})
