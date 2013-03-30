require(testthat)

test_that("stri_locate_all_class", {

   expect_is(stri_locate_all_class(character(0), stri_char_getcategoryid("Z")), "list")
   expect_error(stri_locate_all_class(c("", ""), 1))
   expect_error(length(stri_locate_all_class(LETTERS, NA_integer_)))
   
   expect_equivalent(stri_locate_all_class(character(0), 1), list())
   expect_equivalent(stri_locate_all_class(LETTERS, integer(0)), list())
   
   expect_equivalent(as.integer(stri_locate_all_class("", stri_char_getpropertyid("^WHITE_SPACE"))[[1]]),
         c(NA_integer_, NA_integer_))
   
   expect_equivalent(as.integer(stri_locate_all_class(NA, stri_char_getpropertyid("^WHITE_SPACE"))[[1]]),
                     c(NA_integer_, NA_integer_))
   
   expect_equivalent(lapply(stri_locate_all_class(
      c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         stri_char_getcategoryid("L")), as.integer),
      list(c(1L, 3L), c(1L, 3L), c(1L, 3L, 5L, 1L, 3L, 5L),
           c(2L, 4L, 6L, 2L, 4L, 6L), c(NA_integer_, NA_integer_)))
   
   expect_equivalent(lapply(stri_locate_all_class(
      c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         stri_char_getcategoryid("^L")), as.integer),
      list(c(NA_integer_, NA_integer_), c(NA_integer_, NA_integer_),
         c(2L, 4L, 6L, 2L, 4L, 6L), c(1L, 3L, 5L, 1L, 3L, 5L), c(1L, 3L)))
   
   expect_equivalent(as.integer(
      stri_locate_all_class("    xxx\n\t \v   \n",
         stri_char_getpropertyid("WHITE_SPACE"))[[1]]),
      c(1L, 8L, 4L, 15L))

   expect_equivalent(as.integer(
      stri_locate_all_class("    xxx\n\t \v   \n",
         stri_char_getpropertyid("^WHITE_SPACE"))[[1]]),
      c(5, 7))
})



test_that("stri_locate_first_class", {
   
   expect_equivalent(stri_locate_first_class("", stri_char_getpropertyid("^WHITE_SPACE")), NA_integer_)
   expect_equivalent(stri_locate_first_class(NA, stri_char_getpropertyid("^WHITE_SPACE")), NA_integer_)
                           
   expect_equivalent(stri_locate_first_class(
      c("abc", "5\u0105bc", "a1B2c3", "1\u01052b3C", "123"),
      stri_char_getcategoryid("L")),
      c(1L, 2L, 1L, 2L, NA_integer_))

   expect_equivalent(
      stri_locate_first_class("    xxx\n\t \v   \n",
         c(stri_char_getpropertyid("WHITE_SPACE"),
           stri_char_getpropertyid("^WHITE_SPACE"))),
      c(1L, 5L))
})


test_that("stri_locate_last_class", {
   
   expect_equivalent(stri_locate_last_class("", stri_char_getpropertyid("^WHITE_SPACE")), NA_integer_)
   expect_equivalent(stri_locate_last_class(NA, stri_char_getpropertyid("^WHITE_SPACE")), NA_integer_)
   
   expect_equivalent(stri_locate_last_class(
      c("abc", "5\u0105bc", "a1B2c3", "1\u01052b3C", "123"),
      stri_char_getcategoryid("L")),
                     c(3L, 4L, 5L, 6L, NA_integer_))
   
   expect_equivalent(
      stri_locate_last_class("    xxx\n\t \v   \n",
            c(stri_char_getpropertyid("WHITE_SPACE"),
              stri_char_getpropertyid("^WHITE_SPACE"))),
      c(15L, 7L))
})



test_that("stri_locate_all_fixed", {
   
   expect_is(stri_locate_all_fixed(character(0), "a"), "list")
   
   expect_equivalent(stri_locate_all_fixed(NA, character(0)), list())
   expect_equivalent(stri_locate_all_fixed(character(0), NA), list())
   expect_equivalent(stri_locate_all_fixed(LETTERS, character(0)), list())
   expect_equivalent(stri_locate_all_fixed(NA, ""), list(matrix(c(NA,NA_integer_))))
   
   expect_equivalent(stri_locate_all_fixed("1aąa", "ą"), list(matrix(c(3,3))))
   expect_equivalent(stri_locate_all_fixed("aaa", "aa"), list(matrix(c(1,2))))
   
})

test_that("stri_locate_first_fixed", {
   
   expect_is(stri_locate_first_fixed(character(0), "a"), "list")
   
   expect_equivalent(stri_locate_first_fixed(NA, character(0)), list())
   expect_equivalent(stri_locate_first_fixed(character(0), NA), list())
   expect_equivalent(stri_locate_first_fixed(LETTERS, character(0)), list())
   expect_equivalent(stri_locate_first_fixed(NA, ""), list(matrix(c(NA,NA_integer_))))
   
   expect_equivalent(stri_locate_first_fixed("1aąa", "ą"), list(matrix(c(3,3))))
   expect_equivalent(stri_locate_first_fixed("aaa", "aa"), list(matrix(c(1,2))))
   expect_equivalent(stri_locate_first_fixed("aa1a12aa123", "123"), list(matrix(c(9,11))))
   expect_equivalent(stri_locate_first_fixed("1-1-2-33--2", "-32"), list(matrix(c(NA_integer_,NA))))
   
})


test_that("stri_locate_last_fixed", {
   
   expect_is(stri_locate_last_fixed(character(0), "a"), "list")
   
   expect_equivalent(stri_locate_last_fixed(NA, character(0)), list())
   expect_equivalent(stri_locate_last_fixed(character(0), NA), list())
   expect_equivalent(stri_locate_last_fixed(LETTERS, character(0)), list())
   expect_equivalent(stri_locate_last_fixed(NA, ""), list(matrix(c(NA,NA_integer_))))
   
   expect_equivalent(stri_locate_last_fixed("1aąa", "ą"), list(matrix(c(3,3))))
   expect_equivalent(stri_locate_last_fixed("aaa", "aa"), list(matrix(c(2,3))))
   
})

test_that("stri_locate_all_regex", {
   
   expect_is(stri_locate_all_regex(character(0), "a"), "list")
   
   expect_equivalent(stri_locate_all_regex(NA, character(0)), list())
   expect_equivalent(stri_locate_all_regex(character(0), NA), list())
   expect_equivalent(stri_locate_all_regex(LETTERS, character(0)), list())
   expect_equivalent(stri_locate_all_regex(NA, ""), list(matrix(c(NA,NA_integer_))))
   
   expect_equivalent(stri_locate_all_regex("1aąa", "ą"), list(matrix(c(3,3))))
   expect_equivalent(stri_locate_all_regex("aaa", "aa"), list(matrix(c(1,2))))
   
   expect_equivalent(stri_locate_all_regex("1aąa", "a.a"), list(matrix(c(2,4))))
   expect_equivalent(stri_locate_all_regex("ala ola ela ula", ".la"), list(matrix(c(1,5,9,13,3,7,11,15),ncol=2)))
   expect_equivalent(stri_locate_all_regex("ala ola ela ula", "(a|u|z)la"), list(matrix(c(1,13,3,15),ncol=2)))
   
})

test_that("stri_locate_first_regex", {
   
   expect_is(stri_locate_first_regex(character(0), "a"), "list")
   
   expect_equivalent(stri_locate_first_regex(NA, character(0)), list())
   expect_equivalent(stri_locate_first_regex(character(0), NA), list())
   expect_equivalent(stri_locate_first_regex(LETTERS, character(0)), list())
   expect_equivalent(stri_locate_first_regex(NA, ""), list(matrix(c(NA,NA_integer_))))
   
   expect_equivalent(stri_locate_first_regex("1aąa", "ą"), list(matrix(c(3,3))))
   expect_equivalent(stri_locate_first_regex("aaa", "aa"), list(matrix(c(1,2))))
   
   expect_equivalent(stri_locate_first_regex("1aąa", "a.a"), list(matrix(c(2,4))))
   expect_equivalent(stri_locate_first_regex("ala ola ela ula", ".la"), list(matrix(c(1,3))))
   expect_equivalent(stri_locate_first_regex("ala ola ela ula", "(e|u|z)la"), list(matrix(c(9,11))))
   
})
