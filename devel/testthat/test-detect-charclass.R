require("testthat")

test_that("stri_detect_charclass", {
   expect_identical(stri_detect_charclass("a", NA), NA)
   expect_identical(stri_detect_charclass(NA, "\\p{Z}"), NA)
   expect_identical(stri_detect_charclass(NA, NA), NA)
   expect_error(stri_detect_charclass("a", "WTF????"))
   expect_identical(stri_detect_charclass(c("","ala"),"\\p{L}"), c(FALSE, TRUE))
   expect_identical(stri_detect_charclass(c("ala","", "", "111"),c("\\p{L}", "\\p{N}")), c(TRUE, FALSE, FALSE, TRUE))

   expect_identical(stri_detect_charclass(c("a", "ab", "abc", "1234"), "\\p{L}"), c(T,T,T,F))
   expect_identical(stri_detect_charclass("a\u0105bc", c("\\p{L}", "\\p{Ll}", "\\p{Lu}")), c(T,T,F))
   expect_identical(stri_detect_charclass("a\u0105bc", c("\\p{l}", "\\p{ll}", "\\p{lu}")), c(T,T,F))
   expect_identical(stri_detect_charclass("a\u0105bc", c("\\P{l}", "\\P{ll}", "\\P{lu}")), c(F,F,T))
   expect_identical(stri_detect_charclass("a\u0105bc", c("\\p{AlPh_a  bEtic}")), c(T))
   expect_identical(stri_detect_charclass("","\\p{L}"), FALSE)
})
