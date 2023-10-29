library("tinytest")
library("stringi")


expect_identical(stri_split_charclass(character(0), "\\p{Z}"), list())
expect_identical(stri_split_charclass(NA, NA), list(NA_character_))
expect_identical(stri_split_charclass(NA, "\\p{Z}"), list(NA_character_))
expect_identical(stri_split_charclass("???", NA), list(NA_character_))
expect_identical(stri_split_charclass("???", "\\p{Z}", NA), list(NA_character_))
expect_identical(stri_split_charclass("", "\\p{Z}"), list(""))
expect_identical(stri_split_charclass("", "\\p{Z}", omit_empty = TRUE), list(character(0)))
expect_identical(stri_split_charclass("gas", "\\p{Z}", n = 0), list(character(0)))
expect_identical(stri_split_charclass("  ", "\\p{Z}"), list(c("", "", "")))
expect_identical(stri_split_charclass("  ", "\\p{Z}", omit_empty = TRUE), list(character(0)))
expect_identical(stri_split_charclass(" a  ", "\\p{Z}", omit_empty = TRUE), list("a"))
expect_identical(stri_split_charclass("ala ma kota", "\\p{Z}"), list(c("ala",
    "ma", "kota")))
expect_identical(stri_split_charclass("ala ma kota", "\\p{Z}", 0), list(character(0)))
expect_identical(stri_split_charclass("ala ma kota", "\\p{Z}", 1), list(c("ala ma kota")))
expect_identical(stri_split_charclass("ala ma kota", "\\p{Z}", 2), list(c("ala",
    "ma kota")))
expect_identical(stri_split_charclass("a  b", "\\p{Z}"), list(c("a", "", "b")))
expect_identical(stri_split_charclass("a  b", "\\p{Z}", omit_empty = TRUE), list(c("a",
    "b")))
expect_identical(stri_split_charclass(c("a1a", "aXa"), c("\\p{N}", "\\p{Lu}")),
    list(c("a", "a"), c("a", "a")))

# tokens_only
expect_identical(stri_split_charclass("a_b_c_d", "[_]"), list(c("a", "b", "c",
    "d")))
expect_identical(stri_split_charclass("a_b_c__d", "[_]"), list(c("a", "b", "c",
    "", "d")))
expect_identical(stri_split_charclass("a_b_c__d", "[_]", omit_empty = TRUE),
    list(c("a", "b", "c", "d")))
expect_identical(stri_split_charclass("a_b_c__d", "[_]", n = 2, tokens_only = FALSE),
    list(c("a", "b_c__d")))
expect_identical(stri_split_charclass("a_b_c__d", "[_]", n = 2, tokens_only = TRUE),
    list(c("a", "b")))
expect_identical(stri_split_charclass("a_b_c__d", "[_]", n = 4, omit_empty = TRUE,
    tokens_only = TRUE), list(c("a", "b", "c", "d")))
expect_identical(stri_split_charclass("a_b_c__d", "[_]", n = 4, omit_empty = FALSE,
    tokens_only = TRUE), list(c("a", "b", "c", "")))
expect_identical(stri_split_charclass(c("ab_c", "d_ef_g", "h", ""), "[_]", n = 1,
    tokens_only = TRUE, omit_empty = TRUE), list("ab", "d", "h", character(0)))
expect_identical(stri_split_charclass(c("ab_c", "d_ef_g", "h", ""), "[_]", n = 2,
    tokens_only = TRUE, omit_empty = TRUE), list(c("ab", "c"), c("d", "ef"),
    "h", character(0)))
expect_identical(stri_split_charclass(c("ab_c", "d_ef_g", "h", ""), "[_]", n = 3,
    tokens_only = TRUE, omit_empty = TRUE), list(c("ab", "c"), c("d", "ef", "g"),
    "h", character(0)))

expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = TRUE,
    simplify = NA), matrix(c("ab", "d", "h", NA, "c", "ef", NA, NA, NA, "g",
    NA, NA), nrow = 4))
expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = FALSE,
    simplify = NA), matrix(c("ab", "d", "", "", "c", "ef", "h", NA, NA, "g",
    NA, NA), nrow = 4))
expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = NA,
    simplify = NA), matrix(c("ab", "d", NA, NA, "c", "ef", "h", NA, NA, "g",
    NA, NA), nrow = 4))

expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = TRUE,
    simplify = TRUE), matrix(c("ab", "d", "h", "", "c", "ef", "", "", "", "g",
    "", ""), nrow = 4))
expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = FALSE,
    simplify = TRUE), matrix(c("ab", "d", "", "", "c", "ef", "h", "", "", "g",
    "", ""), nrow = 4))
expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = NA,
    simplify = TRUE), matrix(c("ab", "d", NA, NA, "c", "ef", "h", "", "", "g",
    "", ""), nrow = 4))

expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = FALSE,
    simplify = TRUE, n = 4), matrix(c("ab", "d", "", "", "c", "ef", "h", "",
    "", "g", "", "", "", "", "", ""), nrow = 4))

expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = TRUE),
    list(c("ab", "c"), c("d", "ef", "g"), "h", character()))
expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = FALSE),
    list(c("ab", "c"), c("d", "ef", "g"), c("", "h"), ""))
expect_identical(stri_split_charclass(c("ab,c", "d,ef,g", ",h", ""), "[,]", omit_empty = NA),
    list(c("ab", "c"), c("d", "ef", "g"), c(NA, "h"), NA_character_))
