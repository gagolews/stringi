require(testthat)

test_that("stri_extract_all_charclass", {

   expect_is(stri_extract_all_charclass(character(0), "Z"), "list")
   expect_warning(stri_extract_all_charclass(c("", "Z"), 1))

   expect_equivalent(stri_extract_all_charclass(character(0), "Z"), list())
   expect_equivalent(stri_extract_all_charclass(LETTERS, integer(0)), list())

   expect_equivalent(stri_extract_all_charclass("", "^WHITE_SPACE")[[1]], NA_character_)

   expect_equivalent(stri_extract_all_charclass("", NA)[[1]], NA_character_)

   expect_equivalent(stri_extract_all_charclass("", "^WHITE_SPACE", NA)[[1]], NA_character_)

   expect_equivalent(stri_extract_all_charclass(NA, "^WHITE_SPACE")[[1]], NA_character_)

   expect_equivalent(stri_extract_all_charclass(c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         "L", merge=TRUE), list("abc", "a\u0105b", c("a", "B", "c"), c("\u0105", "b", "C"), NA_character_))

   expect_equivalent(stri_extract_all_charclass(c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         "L", merge=FALSE), list(c("a", "b", "c"), c("a", "\u0105", "b"),
                                 c("a", "B", "c"), c("\u0105", "b", "C"), NA_character_))
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

