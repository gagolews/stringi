require(testthat)

test_that("stri_locate_all_charclass", {

   expect_is(stri_locate_all_charclass(character(0), stri_char_getcategoryid("Z")), "list")
   expect_error(stri_locate_all_charclass(c("", ""), 1))
   expect_error(length(stri_locate_all_charclass(LETTERS, NA_integer_)))
   
   expect_equivalent(stri_locate_all_charclass(character(0), 1), list())
   expect_equivalent(stri_locate_all_charclass(LETTERS, integer(0)), list())
   
   expect_equivalent(as.integer(stri_locate_all_charclass("", stri_char_getpropertyid("^WHITE_SPACE"))[[1]]),
         c(NA_integer_, NA_integer_))
   
   expect_equivalent(as.integer(stri_locate_all_charclass(NA, stri_char_getpropertyid("^WHITE_SPACE"))[[1]]),
                     c(NA_integer_, NA_integer_))
   
   expect_equivalent(lapply(stri_locate_all_charclass(
      c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         stri_char_getcategoryid("L"), merge=TRUE), as.integer),
      list(c(1L, 3L), c(1L, 3L), c(1L, 3L, 5L, 1L, 3L, 5L),
           c(2L, 4L, 6L, 2L, 4L, 6L), c(NA_integer_, NA_integer_)))
   
   expect_equivalent(lapply(stri_locate_all_charclass(
      c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         stri_char_getcategoryid("^L"), merge=TRUE), as.integer),
      list(c(NA_integer_, NA_integer_), c(NA_integer_, NA_integer_),
         c(2L, 4L, 6L, 2L, 4L, 6L), c(1L, 3L, 5L, 1L, 3L, 5L), c(1L, 3L)))
   
   expect_equivalent(as.integer(
      stri_locate_all_charclass("    xxx\n\t \v   \n",
         stri_char_getpropertyid("WHITE_SPACE"), merge=TRUE)[[1]]),
      c(1L, 8L, 4L, 15L))

   expect_equivalent(as.integer(
      stri_locate_all_charclass("    xxx\n\t \v   \n",
         stri_char_getpropertyid("^WHITE_SPACE"), merge=TRUE)[[1]]),
      c(5, 7))
})



test_that("stri_locate_first_charclass", {
   
   expect_is(stri_locate_first_charclass(character(0), "^WHITE_SPACE"), "matrix")
   
   expect_equivalent(as.integer(stri_locate_first_charclass("", ("^WHITE_SPACE"))), c(NA_integer_,NA_integer_))
   expect_equivalent(as.integer(stri_locate_first_charclass(NA, ("^WHITE_SPACE"))), c(NA_integer_,NA_integer_))
   
   expect_equivalent(stri_locate_first_charclass(
      c("abc", "5\u0105bc", "a1B2c3", "1\u01052b3C", "123"),
      ("L"))[,1],
      c(1L, 2L, 1L, 2L, NA_integer_))
   
   expect_equivalent(stri_locate_first_charclass("abc", c("L", "Z", "P"))[,1],
                     c(1L, NA_integer_, NA_integer_))

   expect_equivalent(
      stri_locate_first_charclass("    xxx\n\t \v   \n",
         c(("WHITE_SPACE"),
           ("^WHITE_SPACE")))[,2],
      c(1L, 5L))
})


test_that("stri_locate_last_charclass", {
   
   expect_is(stri_locate_last_charclass(character(0), ("^WHITE_SPACE")), "matrix")
   
   expect_equivalent(stri_locate_last_charclass("", ("^WHITE_SPACE"))[,2], NA_integer_)
   expect_equivalent(stri_locate_last_charclass(NA, ("^WHITE_SPACE"))[,2], NA_integer_)
   
   expect_equivalent(stri_locate_last_charclass("abc", c("L", "Z", "P"))[,1],
                     c(3L, NA_integer_, NA_integer_))
   
   expect_equivalent(stri_locate_last_charclass(
      c("abc", "5\u0105bc", "a1B2c3", "1\u01052b3C", "123"),
      ("L"))[,2],
                     c(3L, 4L, 5L, 6L, NA_integer_))
   
   expect_equivalent(
      stri_locate_last_charclass("    xxx\n\t \v   \n",
            c(("WHITE_SPACE"),
              ("^WHITE_SPACE")))[,2],
      c(15L, 7L))
})



test_that("stri_locate_all_fixed", {
   
   expect_is(stri_locate_all_fixed(character(0), "a"), "list")
   
   expect_equivalent(stri_locate_all_fixed(NA, character(0)), list())
   expect_equivalent(stri_locate_all_fixed(character(0), NA), list())
   expect_equivalent(stri_locate_all_fixed(LETTERS, character(0)), list())
   expect_equivalent(stri_locate_all_fixed(NA, ""), list(matrix(c(NA,NA_integer_))))
   
   expect_equivalent(stri_locate_all_fixed("1a\u0105a", "\u0105"), list(matrix(c(3,3))))
   expect_equivalent(stri_locate_all_fixed("aaa", "aa"), list(matrix(c(1,2))))
   
})

test_that("stri_locate_first_fixed", {
   
   expect_is(stri_locate_first_fixed(character(0), "a"), "matrix")
   
   expect_equivalent(nrow(stri_locate_first_fixed(NA, character(0))), 0)
   expect_equivalent(nrow(stri_locate_first_fixed(character(0), NA)), 0)
   expect_equivalent(nrow(stri_locate_first_fixed(LETTERS, character(0))), 0)
   expect_equivalent(stri_locate_first_fixed(NA, ""), matrix(c(NA_integer_,NA_integer_)))
   
   expect_equivalent(stri_locate_first_fixed("1a\u0105a", "\u0105"), matrix(c(3,3)))
   expect_equivalent(stri_locate_first_fixed("aaa", "aa"), matrix(c(1,2)))
   expect_equivalent(stri_locate_first_fixed("aa1a12aa123", "123"), matrix(c(9,11)))
   expect_equivalent(stri_locate_first_fixed("1-1-2-33--2", "-32"), matrix(c(NA_integer_,NA_integer_)))
   
})


test_that("stri_locate_last_fixed", {
   
   expect_is(stri_locate_last_fixed(character(0), "a"), "matrix")
   
   expect_equivalent(nrow(stri_locate_last_fixed(NA, character(0))), 0)
   expect_equivalent(nrow(stri_locate_last_fixed(character(0), NA)), 0)
   expect_equivalent(nrow(stri_locate_last_fixed(LETTERS, character(0))), 0)
   expect_equivalent(stri_locate_last_fixed(NA, ""), matrix(c(NA,NA_integer_)))
   
   expect_equivalent(stri_locate_last_fixed("1a\u0105a", "\u0105"), matrix(c(3,3)))
   expect_equivalent(stri_locate_last_fixed("aaa", "aa"), matrix(c(2,3)))
   
})

test_that("stri_locate_all_regex", {
   
   expect_is(stri_locate_all_regex(character(0), "a"), "list")
   
   expect_equivalent(stri_locate_all_regex(NA, character(0)), list())
   expect_equivalent(stri_locate_all_regex(character(0), NA), list())
   expect_equivalent(stri_locate_all_regex(LETTERS, character(0)), list())
   expect_equivalent(stri_locate_all_regex(NA, ""), list(matrix(c(NA,NA_integer_))))
   
   expect_equivalent(stri_locate_all_regex("1a\u0105a", "\u0105"), list(matrix(c(3,3))))
   expect_equivalent(stri_locate_all_regex("X\U00024B62\U00024B63\U00024B64X",
                                    c("\U00024B62", "\U00024B63", "\U00024B64")),
            list(matrix(c(2L,2L)), matrix(c(3L,3L)), matrix(c(4L,4L))))
   expect_equivalent(stri_locate_all_regex("aaa", "aa"), list(matrix(c(1,2))))
   
   expect_equivalent(stri_locate_all_regex("1a\u0105a", "a.a"), list(matrix(c(2,4))))
   expect_equivalent(stri_locate_all_regex("ala ola ela ula", ".la"), list(matrix(c(1,5,9,13,3,7,11,15),ncol=2)))
   expect_equivalent(stri_locate_all_regex("ala ola ela ula", "(a|u|z)la"), list(matrix(c(1,13,3,15),ncol=2)))
   
})

test_that("stri_locate_first_regex", {
   
   expect_is(stri_locate_first_regex(character(0), "a"), "matrix")
   
   expect_equivalent(nrow(stri_locate_first_regex(NA, character(0))), 0)
   expect_equivalent(nrow(stri_locate_first_regex(character(0), NA)), 0)
   expect_equivalent(nrow(stri_locate_first_regex(LETTERS, character(0))), 0)
   expect_equivalent(stri_locate_first_regex(NA, ""), matrix(c(NA_integer_,NA_integer_)))
   
   expect_equivalent(stri_locate_first_regex("X\u0104\u0105\u106X", "\u0105"), matrix(c(3L,3L)))
   expect_equivalent(stri_locate_first_regex("X\u9999\u9998\u9997X", "\u9998"), matrix(c(3L,3L)))
   expect_equivalent(stri_locate_first_regex("X\U00024B62\U00024B63\U00024B64X", "\U00024B63"), matrix(c(3L,3L)))
   expect_equivalent(stri_locate_first_regex("aaa", "aa"), matrix(c(1L,2L)))
   
   expect_equivalent(stri_locate_first_regex("1a\u0105a", "a.a"), matrix(c(2,4)))
   expect_equivalent(stri_locate_first_regex("ala ola ela ula", ".la"), matrix(c(1,3)))
   expect_equivalent(stri_locate_first_regex("ala ola ela ula", "(e|u|z)la"), matrix(c(9,11)))
   
})
