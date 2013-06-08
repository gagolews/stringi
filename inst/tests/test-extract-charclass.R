require(testthat)

test_that("stri_extract_all_charclass", {

   expect_is(stri_extract_all_charclass(character(0), "Z"), "list")
   expect_warning(stri_extract_all_charclass(c("", ""), 1))
   
   expect_equivalent(stri_extract_all_charclass(character(0), 1), list())
   expect_equivalent(stri_extract_all_charclass(LETTERS, integer(0)), list())
   
   expect_equivalent(as.integer(stri_extract_all_charclass("", "^WHITE_SPACE")[[1]]),
         c(NA_integer_, NA_integer_))
   
   expect_equivalent(as.integer(stri_extract_all_charclass("", NA)[[1]]),
                     c(NA_integer_, NA_integer_))
   
   expect_equivalent(as.integer(stri_extract_all_charclass("", "^WHITE_SPACE", NA)[[1]]),
                     c(NA_integer_, NA_integer_))
   
   expect_equivalent(as.integer(stri_extract_all_charclass(NA, "^WHITE_SPACE")[[1]]),
                     c(NA_integer_, NA_integer_))
   
   expect_equivalent(lapply(stri_extract_all_charclass(
      c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         "L", merge=TRUE), as.integer),
      list(c(1L, 3L), c(1L, 3L), c(1L, 3L, 5L, 1L, 3L, 5L),
           c(2L, 4L, 6L, 2L, 4L, 6L), c(NA_integer_, NA_integer_)))
   
   expect_equivalent(lapply(stri_extract_all_charclass(
      c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
      "L", merge=FALSE), function(x) as.integer(x[,1])),
                     list(c(1L, 2L, 3L), c(1L, 2L, 3L), c(1L, 3L, 5L),
                          c(2L, 4L, 6L), c(NA_integer_)))
   
   expect_equivalent(lapply(stri_extract_all_charclass(
      c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         ("^L"), merge=TRUE), as.integer),
      list(c(NA_integer_, NA_integer_), c(NA_integer_, NA_integer_),
         c(2L, 4L, 6L, 2L, 4L, 6L), c(1L, 3L, 5L, 1L, 3L, 5L), c(1L, 3L)))
   
   expect_equivalent(as.integer(
      stri_extract_all_charclass("    xxx\n\t \v   \n",
         ("WHITE_SPACE"), merge=TRUE)[[1]]),
      c(1L, 8L, 4L, 15L))

   expect_equivalent(as.integer(
      stri_extract_all_charclass("    xxx\n\t \v   \n",
         ("^WHITE_SPACE"), merge=TRUE)[[1]]),
      c(5, 7))
})



test_that("stri_extract_first_charclass", {
   
   expect_is(stri_extract_first_charclass(character(0), ("^WHITE_SPACE")), "character")
   
   expect_equivalent(stri_extract_first_charclass("", ("^WHITE_SPACE")), NA_character_)
   expect_equivalent(stri_extract_first_charclass(NA, ("^WHITE_SPACE")), NA_character_)
   
   expect_equivalent(stri_extract_first_charclass("abc", c("L", "Z", "P")), c("a", NA_character_, NA_character_))
   
   expect_equivalent(stri_extract_first_charclass(c("abc", "\u01055\u0104", "a1B2c3", "123"), "L"), c("a", "\u0105", "a", NA_character_))
   
   expect_equivalent(stri_extract_first_charclass("    zxx\n\t \v   \n", c("WHITE_SPACE", "^WHITE_SPACE")), c(" ", "z"))
   
})


test_that("stri_extract_last_charclass", {
   
   expect_is(stri_extract_last_charclass(character(0), ("^WHITE_SPACE")), "character")
   
   expect_equivalent(stri_extract_last_charclass("", ("^WHITE_SPACE")), NA_character_)
   expect_equivalent(stri_extract_last_charclass(NA, ("^WHITE_SPACE")), NA_character_)
   
   expect_equivalent(stri_extract_last_charclass("abc", c("L", "Z", "P")), c("c", NA_character_, NA_character_))
   
   expect_equivalent(stri_extract_last_charclass(c("abc", "5\u0105", "a1B2c3", "123"), "L"), c("c", "\u0105", "c", NA_character_))
   
   expect_equivalent(stri_extract_last_charclass("    yzx\n\t \v   \n", c("WHITE_SPACE", "^WHITE_SPACE")), c("\n", "x"))
   
})

