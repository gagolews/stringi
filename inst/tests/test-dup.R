require(testthat)

# TO DO...

test_that("stri_dup", {

   # basic tests (ASCII, border-line):
   suppressWarnings(expect_identical(stri_dup(c("A", "B"), c(2,3,4)), c("AA", "BBB", "AAAA")))
   expect_warning(stri_dup(c("A", "B"), c(2,3,4)))
   
   expect_identical(stri_dup(character(0), integer(0)), character(0))
   expect_identical(stri_dup("char", integer(0)), character(0))
   expect_identical(stri_dup(character(0), 10), character(0))
   expect_identical(stri_dup("ABC", 0), "")
   expect_identical(stri_dup("A", c(1.5, 1.99, 0.1)), c("A", "A", ""))
   expect_warning(stri_dup("A", ":-("))
   expect_identical(stri_dup(c("ABC", "", "A"), c(0, 100, 0)), c("", "", ""))
   expect_identical(stri_dup("A", c(-1, 0, 1, NA)), c(NA, "", "A", NA))
})


# expect_that(stri_dup("A", 3), is_identical_to(str_dup("A", 3)))
# expect_that(stri_dup(c("A", "B"), 3), is_identical_to(str_dup(c("A", "B"), 3)))
# expect_that(stri_dup(c("A", "B"), c(2,3)), is_identical_to(str_dup(c("A", "B"), c(2,3))))

# str_dup("A", -1)  # throws error
# stri_dup("A", -1) # returns NA

# str_dup("A", 0)  # empty
# stri_dup("A", 0) # empty

#  str_dup(c(NA, "A", "AA"), 3) # incorrect behavior
#  stri_dup(c(NA, "A", "AA"), 3)

# str_dup("A", c(NA, 1, 2))  # error
# stri_dup("A", c(NA, 1, 2)) # NA, A, AA
