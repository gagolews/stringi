require("testthat")
context("test-detect-fixed.R")

test_that("stri_detect_fixed", {
   expect_identical(stri_detect_fixed("a", NA), NA)
   expect_identical(stri_detect_fixed(NA, "a"), NA)
   expect_identical(stri_detect_fixed(NA, "a",negate=TRUE), NA)
   expect_identical(stri_detect_fixed(NA, NA), NA)
   expect_identical(stri_detect_fixed(c("","ala","ola"),"ala"), c(FALSE, TRUE, FALSE))
   expect_identical(stri_detect(c("","ala","ola"),fixed="ala",negate=TRUE), !c(FALSE, TRUE, FALSE))
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

   expect_identical(stri_detect_fixed(c("abc", "def", "123", "ghi", "456", "789", "jkl"),
                                      c("abc", "def", "123", "ghi", "456", "789", "jkl"),
     max_count=1),                    c(TRUE,  NA,    NA,   NA,   NA,     NA,    NA))
   expect_identical(stri_detect_fixed(c("abc", "def", "123", "ghi", "456", "789", "jkl"),
                                      c("abc", "def", "XXX", "ghi", "456", "789", "jkl"),
     max_count=3),                    c(TRUE,  TRUE,  FALSE,  TRUE,   NA,     NA,    NA))
   expect_identical(stri_detect_fixed(c("",    "def", "123", "ghi", "456", "789", "jkl"),
                                      c("abc", "def", "XXX", "ghi", "456", "789", "jkl"),
     negate=TRUE, max_count=2),       c(TRUE,  FALSE, TRUE,  NA,   NA,   NA,    NA))

   expect_identical(stri_detect_regex(c("aaa", "bbb", "ccc"), "bbb", max_count=1),
                    c(FALSE,  TRUE,    NA))
   expect_identical(stri_detect_regex(c("aaa", "bbb", "ccc"), "ddd", max_count=1),
                    c(FALSE, FALSE, FALSE))
})
