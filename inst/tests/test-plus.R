require(testthat)

test_that("%+%", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent("A" %+% NA, NA_character_)
   expect_equivalent(NA %+% "B", NA_character_)
   expect_equivalent(NA %+% NA, NA_character_)
   expect_equivalent("A" %+% "B", "AB")
   expect_equivalent("A" %+% character(0), "A")
   expect_equivalent("A" %+% c("A", "B", "C"), c("AA", "AB", "AC"))
})
