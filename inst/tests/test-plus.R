require(testthat)



test_that("%+%", {
   expect_that("A" %+% NA, is_equivalent_to(NA_character_))
   expect_that(NA %+% "B", is_equivalent_to(NA_character_))
   expect_that("A" %+% "B", is_equivalent_to("AB"))
   expect_that("A" %+% character(0), is_equivalent_to("A"))
   expect_that("A" %+% c("A", "B", "C"), is_equivalent_to(c("AA", "AB", "AC")))
})

