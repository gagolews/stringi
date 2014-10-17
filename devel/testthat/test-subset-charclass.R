require("testthat")

test_that("stri_subset_charclass", {
   expect_identical(stri_subset_charclass("a", NA), NA_character_)
   expect_identical(stri_subset_charclass(NA, "\\p{Z}"), NA_character_)
   expect_identical(stri_subset_charclass(NA, NA), NA_character_)
   expect_error(stri_subset_charclass("a", "WTF????"))
   expect_identical(stri_subset_charclass(c("","ala"),"\\p{L}"), "ala")
   expect_identical(stri_subset_charclass(c("ala","", "", "111"),c("\\p{L}", "\\p{N}")), c("ala",111))
   expect_identical(stri_subset_regex(c("a","b", NA, "aaa", ""),"[a]"), c("a", NA, "aaa"))

   expect_identical(stri_subset_charclass(c("a", "ab", "abc", "1234"), "\\p{L}"), c("a", "ab", "abc"))
   expect_identical(stri_subset_charclass("a\u0105bc", c("\\p{L}", "\\p{Ll}", "\\p{Lu}")), rep("a\u0105bc",2))
   expect_identical(stri_subset_charclass("a\u0105bc", c("\\p{l}", "\\p{ll}", "\\p{lu}")), rep("a\u0105bc",2))
   expect_identical(stri_subset_charclass("a\u0105bc", c("\\P{l}", "\\P{ll}", "\\P{lu}")), "a\u0105bc")
   expect_identical(stri_subset_charclass("a\u0105bc", c("\\p{AlPh_a  bEtic}")), "a\u0105bc")
   expect_identical(stri_subset_charclass("","\\p{L}"), character(0))
})
