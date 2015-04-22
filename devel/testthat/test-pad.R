require(testthat)
require(stringr)
context("test-pad.R")

test_that("stri_pad", {
   expect_warning(stri_pad(letters, 1:5))
   expect_identical(stri_pad(letters,20),stri_join(stri_dup(" ",19),letters))

   expect_identical(stri_pad("ala",9, "l"), "      ala")
   expect_identical(stri_pad("ala",9, "r"), "ala      ")
   expect_identical(stri_pad("ala",9, "b"), "   ala   ")

   expect_identical(stri_pad("ala",6:8), c("   ala","    ala","     ala"))
   expect_identical(stri_pad(c("abc",NA),5),c("  abc",NA))

   expect_identical(stri_pad("a",3,pad=LETTERS[1:3]), c("AAa","BBa","CCa"))

   test <- stri_c(stri_dup(letters, 1:2600), "A", stri_dup(" ", 1:2600), sep="")
   expect_identical(stri_pad(test,150), str_pad(test,150))
})
