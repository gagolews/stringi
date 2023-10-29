library("tinytest")
library("stringi")


expect_identical(stri_split_fixed(character(0), " "), list())
expect_identical(stri_split_fixed("", "Z"), list(""))
expect_identical(stri_split_fixed("", "Z", omit_empty = TRUE), list(character(0)))
expect_identical(stri_split_fixed("gas", "Z", n = 0), list(character(0)))
expect_identical(stri_split_fixed(NA, NA), list(NA_character_))
expect_identical(stri_split_fixed(NA, "a"), list(NA_character_))
expect_identical(stri_split_fixed("NA", NA), list(NA_character_))
expect_identical(stri_split_fixed("NA", "a", NA), list(NA_character_))
expect_identical(stri_split_fixed(" ", " "), list(rep("", 2)))
expect_identical(stri_split_fixed("aa", "a"), list(rep("", 3)))
expect_identical(stri_split_fixed("aa", "a", -1L, TRUE), list(character(0)))

# n
expect_identical(stri_split_fixed(";123", ";", n = 2), list(c("", "123")))
expect_identical(stri_split_fixed(";123", ";", n = 2, omit_empty = TRUE), list("123"))
expect_identical(stri_split_fixed("123abc456", "abc", n = 2), list(c("123", "456")))
expect_identical(stri_split_fixed("123abc456abc789", "abc", n = 2), list(c("123",
    "456abc789")))

# tokens_only
expect_identical(stri_split_fixed("a_b_c_d", "_"), list(c("a", "b", "c", "d")))
expect_identical(stri_split_fixed("a_b_c__d", "_"), list(c("a", "b", "c", "",
    "d")))
expect_identical(stri_split_fixed("a_b_c__d", "_", omit_empty = TRUE), list(c("a",
    "b", "c", "d")))
expect_identical(stri_split_fixed("a_b_c__d", "_", n = 2, tokens_only = FALSE),
    list(c("a", "b_c__d")))
expect_identical(stri_split_fixed("a_b_c__d", "_", n = 2, tokens_only = TRUE),
    list(c("a", "b")))
expect_identical(stri_split_fixed("a_b_c__d", "_", n = 4, omit_empty = TRUE,
    tokens_only = TRUE), list(c("a", "b", "c", "d")))
expect_identical(stri_split_fixed("a_b_c__d", "_", n = 4, omit_empty = FALSE,
    tokens_only = TRUE), list(c("a", "b", "c", "")))
expect_identical(stri_split_fixed(c("ab_c", "d_ef_g", "h", ""), "_", n = 1, tokens_only = TRUE,
    omit_empty = TRUE), list("ab", "d", "h", character(0)))
expect_identical(stri_split_fixed(c("ab_c", "d_ef_g", "h", ""), "_", n = 2, tokens_only = TRUE,
    omit_empty = TRUE), list(c("ab", "c"), c("d", "ef"), "h", character(0)))
expect_identical(stri_split_fixed(c("ab_c", "d_ef_g", "h", ""), "_", n = 3, tokens_only = TRUE,
    omit_empty = TRUE), list(c("ab", "c"), c("d", "ef", "g"), "h", character(0)))

expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = TRUE,
    simplify = NA), matrix(c("ab", "d", "h", NA, "c", "ef", NA, NA, NA, "g",
    NA, NA), nrow = 4))
expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = FALSE,
    simplify = NA), matrix(c("ab", "d", "", "", "c", "ef", "h", NA, NA, "g",
    NA, NA), nrow = 4))
expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = NA,
    simplify = NA), matrix(c("ab", "d", NA, NA, "c", "ef", "h", NA, NA, "g",
    NA, NA), nrow = 4))

expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = TRUE,
    simplify = TRUE), matrix(c("ab", "d", "h", "", "c", "ef", "", "", "", "g",
    "", ""), nrow = 4))
expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = FALSE,
    simplify = TRUE), matrix(c("ab", "d", "", "", "c", "ef", "h", "", "", "g",
    "", ""), nrow = 4))
expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = NA,
    simplify = TRUE), matrix(c("ab", "d", NA, NA, "c", "ef", "h", "", "", "g",
    "", ""), nrow = 4))

expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = FALSE,
    simplify = TRUE, n = 4), matrix(c("ab", "d", "", "", "c", "ef", "h", "",
    "", "g", "", "", "", "", "", ""), nrow = 4))

expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = TRUE),
    list(c("ab", "c"), c("d", "ef", "g"), "h", character()))
expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = FALSE),
    list(c("ab", "c"), c("d", "ef", "g"), c("", "h"), ""))
expect_identical(stri_split_fixed(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty = NA),
    list(c("ab", "c"), c("d", "ef", "g"), c(NA, "h"), NA_character_))

