require(testthat)
context("test-plus.R")

test_that("%s+%", {

   # basic tests (ASCII, border-line):
   expect_equivalent("" %s+% "", "")
   expect_equivalent("A" %s+% NA, NA_character_)
   expect_equivalent(NA %s+% "B", NA_character_)
   expect_equivalent(NA %s+% NA, NA_character_)
   expect_equivalent("A" %s+% "B", "AB")
   expect_equivalent("A" %s+% character(0), character(0))
   expect_equivalent("A" %s+% c("A", "B", "C"), c("AA", "AB", "AC"))
   expect_equivalent("A" %s+% 1:2, c("A1","A2"))
   expect_equivalent(c("A", "B", "C") %s+% "A", c("AA", "BA", "CA"))
   expect_equivalent(c("ABC", "A", "B") %s+% c(NA, "B", "C"), c(NA, "AB", "BC"))
   expect_equivalent(c("ABC", "A", "B") %s+% c(NA, NA, "C"), c(NA, NA, "BC"))

   expect_error("a"%s+%list("a"))
   expect_warning(letters[1:13]%s+%letters[1:75])
   expect_warning(expect_equivalent(letters[1:3]%s+%letters[1:5],c("aa","bb","cc","ad","be")))
})
