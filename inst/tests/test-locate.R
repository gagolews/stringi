require(testthat)

test_that("stri_locate_all_class", {

   # basic tests (ASCII, border-line):
   
   expect_is(stri_locate_all_class(character(0), 1), "list")
   expect_is(stri_locate_all_class(c("", ""), 1), "list")
   
   expect_equivalent(stri_locate_all_class(character(0), 1), list())
   expect_equivalent(stri_locate_all_class(LETTERS, integer(0)), list())
   expect_equivalent(length(stri_locate_all_class(LETTERS, NA_integer_)), 
      length(LETTERS))
   
   expect_equivalent(lapply(stri_locate_all_class(
      c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         stri_char_getcategoryid("L")), as.integer),
      list(c(1L, 3L), c(1L, 3L), c(1L, 3L, 5L, 1L, 3L, 5L),
           c(2L, 4L, 6L, 2L, 4L, 6L), integer(0)))
   
   expect_equivalent(as.integer(
      stri_locate_all_class("    xxx\n\t \v   \n",
         stri_char_getpropertyid("WHITE_SPACE"))[[1]]),
      c(1L, 8L, 4L, 15L))
   
})
