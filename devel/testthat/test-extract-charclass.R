require(testthat)
require(stringr)
context("test-extract-charclass.R")

test_that("stri_extract_all_charclass", {

   expect_is(stri_extract_all_charclass(character(0), "\\p{Z}"), "list")
   expect_error(stri_extract_all_charclass(c("", "\\p{Z}"), 1))

   expect_equivalent(stri_extract_all_charclass(character(0), "\\p{Z}"), list())
   expect_equivalent(stri_extract_all_charclass(LETTERS, integer(0)), list())

   expect_identical(stri_extract_all_charclass("", "[a]"), list(NA_character_))
   expect_identical(stri_extract_all_charclass("", "[a]", omit_no_match = TRUE), list(character(0)))
   expect_identical(stri_extract_all_charclass("test", "[a]"), list(NA_character_))
   expect_identical(stri_extract_all_charclass("test", "[a]", omit_no_match = TRUE), list(character(0)))

   expect_equivalent(stri_extract_all_charclass("", "\\P{WHITE_SPACE}")[[1]], NA_character_)

   expect_equivalent(stri_extract_all_charclass("", NA)[[1]], NA_character_)

   expect_error(stri_extract_all_charclass("", "\\P{WHITE_SPACE}", NA)[[1]])

   expect_equivalent(stri_extract_all_charclass(NA, "\\P{WHITE_SPACE}")[[1]], NA_character_)

   expect_equivalent(stri_extract_all_charclass(c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         "\\p{L}", merge=TRUE), list("abc", "a\u0105b", c("a", "B", "c"), c("\u0105", "b", "C"), NA_character_))

   expect_equivalent(stri_extract_all_charclass(c("abc", "a\u0105b", "a1B2c3", "1\u01052b3C", "123"),
         "\\p{L}", merge=FALSE), list(c("a", "b", "c"), c("a", "\u0105", "b"),
                                 c("a", "B", "c"), c("\u0105", "b", "C"), NA_character_))

#    expect_identical(stri_extract_all_charclass(c("a1b2c3", NA, "12", "ba"), "\\p{N}", merge=FALSE),
#       str_extract_all(c("a1b2c3", NA, "12", "ba"), "[0-9]"))

   expect_identical(stri_extract(c("ab_c", "d_ef_g", "h", ""), mode='all', charclass="\\p{L}", merge=TRUE, simplify=NA),
      matrix(c("ab", "d", "h", NA, "c", "ef", NA, NA, NA, "g", NA, NA), nrow=4))
   expect_identical(stri_extract(c("ab_c", "d_ef_g", "h", ""), mode='all', charclass="\\p{L}", merge=TRUE, omit_no_match=TRUE, simplify=TRUE),
      matrix(c("ab", "d", "h", "", "c", "ef", "", "", "", "g", "", ""), nrow=4))
})



test_that("stri_extract_first_charclass", {

   expect_is(stri_extract_first_charclass(character(0), ("\\P{WHITE_SPACE}")), "character")

   expect_equivalent(stri_extract_first_charclass("", ("\\P{WHITE_SPACE}")), NA_character_)
   expect_equivalent(stri_extract_first_charclass(NA, ("\\P{WHITE_SPACE}")), NA_character_)

   expect_equivalent(stri_extract_first_charclass("abc", c("\\p{L}", "\\p{Z}", "\\p{P}")), c("a", NA_character_, NA_character_))

   expect_equivalent(stri_extract_first_charclass(c("abc", "\u01055\u0104", "a1B2c3", "123"), "\\p{L}"), c("a", "\u0105", "a", NA_character_))

   expect_equivalent(stri_extract_first_charclass("    zxx\n\t \v   \n", c("\\p{WHITE_SPACE}", "\\P{WHITE_SPACE}")), c(" ", "z"))

   expect_identical(stri_extract_first_charclass(c("a1b2c3", NA, "12", "ba"), "\\p{N}"),
      str_extract(c("a1b2c3", NA, "12", "ba"), "[0-9]"))

})


test_that("stri_extract_last_charclass", {

   expect_is(stri_extract_last_charclass(character(0), ("\\P{WHITE_SPACE}")), "character")

   expect_equivalent(stri_extract_last_charclass("", ("\\P{WHITE_SPACE}")), NA_character_)
   expect_equivalent(stri_extract_last_charclass(NA, ("\\P{WHITE_SPACE}")), NA_character_)

   expect_equivalent(stri_extract_last_charclass("abc", c("\\p{L}", "\\p{Z}", "\\p{P}")), c("c", NA_character_, NA_character_))

   expect_equivalent(stri_extract_last_charclass(c("abc", "5\u0105", "a1B2c3", "123"), "\\p{L}"), c("c", "\u0105", "c", NA_character_))

   expect_equivalent(stri_extract_last_charclass("    yzx\n\t \v   \n", c("\\p{WHITE_SPACE}", "\\P{WHITE_SPACE}")), c("\n", "x"))

})
