require(testthat)

# TO DO...

test_that("stri_dup", {

   # basic tests (ASCII, border-line):
   expect_that(stri_dup(c("A", "B"), c(2,3,4)), is_identical_to(c("AA", "BBB", "AAAA")))
   
   expect_that(length(stri_dup(character(0), integer(0)))==0, is_true())
   expect_that(length(stri_dup("char", integer(0)))==0, is_true())
   expect_that(length(stri_dup(character(0), 1))==0, is_true())
   
   expect_that(all(is.na(stri_dup("A", c(-1, NA)))), is_true())
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
