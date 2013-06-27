require(testthat)

test_that("%+%", {
   
   # basic tests (ASCII, border-line):
   expect_equivalent("" %+% "", "")
   expect_equivalent("A" %+% NA, NA_character_)
   expect_equivalent(NA %+% "B", NA_character_)
   expect_equivalent(NA %+% NA, NA_character_)
   expect_equivalent("A" %+% "B", "AB")
   expect_equivalent("A" %+% character(0), character(0))
   expect_equivalent("A" %+% c("A", "B", "C"), c("AA", "AB", "AC"))
   expect_equivalent("A" %+% 1:2, c("A1","A2"))
   expect_equivalent(c("A", "B", "C") %+% "A", c("AA", "BA", "CA"))
   expect_equivalent(c("ABC", "A", "B") %+% c(NA, "B", "C"), c(NA, "AB", "BC"))
   expect_equivalent(c("ABC", "A", "B") %+% c(NA, NA, "C"), c(NA, NA, "BC"))
   
   expect_error("a"%+%list("a"))
   expect_warning(letters[1:3]%+%letters[1:5])
})
