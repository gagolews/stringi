library("tinytest")
library("stringi")


expect_identical(stri_match_all_regex(NA, "test"), list(matrix(NA_character_,
    1, 1)))
expect_identical(stri_match_all_regex("", "(test)(rest)"), list(matrix(NA_character_,
    1, 3)))
expect_identical(stri_match_all_regex("", "(test)(rest)", omit_no_match = TRUE),
    list(matrix(NA_character_, 0, 3)))

expect_identical(stri_match_all_regex("abcd", "^(:)?([^:]*)(:)?$", omit_no_match = TRUE,
    cg_missing = "")[[1]], matrix(c("abcd", "", "abcd", ""), 1, 4))

expect_identical(stri_match_all_regex("abcd", "^(:)?([^:]*)(:)?$")[[1]], matrix(c("abcd",
    NA, "abcd", NA), 1, 4))

expect_identical(stri_match_all_regex(":abcd", "^(:)?([^:]*)(:)?$", omit_no_match = TRUE,
    cg_missing = "")[[1]], matrix(c(":abcd", ":", "abcd", ""), 1, 4))

expect_identical(stri_match_all_regex(":abcd", "^(:)?([^:]*)(:)?$")[[1]], matrix(c(":abcd",
    ":", "abcd", NA), 1, 4))

expect_equivalent(stri_match_all_regex(c("", " "), "^.*$"), list(matrix(c("")),
    matrix(c(" "))))
expect_equivalent(stri_match_all_regex(c("", " "), "^(.*)$"), list(matrix(c("",
    ""), ncol = 2), matrix(c(" ", " "), ncol = 2)))

expect_identical(stri_match_all_regex(NA, "(test)(rest)"), list(matrix(NA_character_,
    1, 3)))
expect_identical(stri_match_all_regex("", "(test)(rest)", omit_no_match = TRUE),
    list(matrix(NA_character_, 0, 3)))
expect_identical(stri_match_all_regex("test", NA), list(matrix(NA_character_,
    1, 1)))
suppressWarnings(expect_identical(stri_match_all_regex("test", ""), list(matrix(NA_character_,
    1, 1))))
expect_equivalent(sapply(stri_match_all_regex(c("bacab", "bacaba\u0105a", "aa"),
    "a.a"), as.character), list("aca", c("aca", "a\u0105a"), NA_character_))
expect_equivalent(sapply(stri_match_all_regex(c("a=b;c=d", "", "e=f"), "([a-z])=([a-z])"),
    as.character), list(c("a=b", "c=d", "a", "c", "b", "d"), rep(NA_character_,
    3), c("e=f", "e", "f")))

expect_equivalent(stri_match_all_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "\u0106*"), list(matrix(ncol = 1,
    c("", "\u0106", "", "")), matrix(ncol = 1, c("", "", ""))))  # match of zero length
expect_equivalent(stri_match_all_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "(?<=\u0106)"), list(matrix(ncol = 1,
    ""), matrix(ncol = 1, NA_character_)))  # match of zero length

expect_identical(stringi::stri_match_all_regex(character(0), "(.)"), list())
expect_identical(stringi::stri_match_all_regex(character(0), "(.)(.)"), list())
expect_identical(sapply(stringi::stri_match_all_regex(c(NA), "(.)"), ncol), 2L)
expect_identical(sapply(stringi::stri_match_all_regex(c("a", "ab", NA), "(.)"),
    ncol), rep(2L, 3))
expect_identical(sapply(stringi::stri_match_all_regex(c(NA), "(.)(.)"), ncol),
    3L)
expect_identical(sapply(stringi::stri_match_all_regex(c("a", "ab", NA), "(.)(.)"),
    ncol), rep(3L, 3))



expect_identical(stri_match_first_regex(NA, "test"), matrix(NA_character_, 1,
    1))
expect_identical(stri_match_first_regex("", "(test)(rest)"), matrix(NA_character_,
    1, 3))

expect_identical(stri_match_first_regex("abcd", "^(:)?([^:]*)(:)?$", cg_missing = ""),
    matrix(c("abcd", "", "abcd", ""), 1, 4))

expect_identical(stri_match_first_regex("abcd", "^(:)?([^:]*)(:)?$"), matrix(c("abcd",
    NA, "abcd", NA), 1, 4))

expect_identical(stri_match_first_regex(":abcd", "^(:)?([^:]*)(:)?$", cg_missing = ""),
    matrix(c(":abcd", ":", "abcd", ""), 1, 4))

expect_equivalent(stri_match_first_regex(c("", " "), "^.*$"), matrix(c("", " "),
    nrow = 2))
expect_equivalent(stri_match_first_regex(c("", " "), "^(.*)$"), matrix(c("",
    " "), nrow = 2, ncol = 2))

expect_identical(stri_match_first_regex(":abcd", "^(:)?([^:]*)(:)?$"), matrix(c(":abcd",
    ":", "abcd", NA), 1, 4))

expect_identical(stri_match_first_regex("test", NA), matrix(NA_character_, 1,
    1))
suppressWarnings(expect_identical(stri_match_first_regex("test", ""), matrix(NA_character_,
    1, 1)))
expect_equivalent(stri_match_first_regex(c("bacab", "ba\u0105aacaba\u0105a", "aa"), "a.a"),
    matrix(c("aca", "a\u0105a", NA_character_), 3, 1))
expect_equivalent(stri_match_first_regex(c("a=b;c=d", "", "e=f"), "([a-z])=([a-z])"),
    matrix(c("a=b", NA, "e=f", "a", NA, "e", "b", NA, "f"), 3, 3))


expect_identical(stri_match_first_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "\u0106*"), matrix(ncol = 1,
    c("", "")))  # match of zero length
expect_identical(stri_match_first_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "(?<=\u0106)"), matrix(ncol = 1,
    c("", NA_character_)))  # match of zero length

# Issue 288
expect_identical(dim(stringi::stri_match_first_regex(character(0), "(.)")), c(0L,
    2L))
expect_identical(dim(stringi::stri_match_first_regex(character(0), "(.)(.)")),
    c(0L, 3L))
expect_identical(dim(stringi::stri_match_first_regex(c(NA), "(.)")), c(1L, 2L))
expect_identical(dim(stringi::stri_match_first_regex(c(NA), "(.)(.)")), c(1L,
    3L))
expect_identical(dim(stringi::stri_match_first_regex(c("a", "ab", NA), "(.)")),
    c(3L, 2L))
expect_identical(dim(stringi::stri_match_first_regex(c("a", "ab", NA), "(.)(.)")),
    c(3L, 3L))



expect_identical(stri_match_last_regex(NA, "test"), matrix(NA_character_, 1,
    1))
expect_identical(stri_match_last_regex("", "(test)(rest)"), matrix(NA_character_,
    1, 3))

expect_equivalent(stri_match_last_regex(c("", " "), "^.*$"), matrix(c("", " "),
    nrow = 2))
expect_equivalent(stri_match_last_regex(c("", " "), "^(.*)$"), matrix(c("", " "),
    nrow = 2, ncol = 2))

expect_identical(stri_match_last_regex("abcd", "^(:)?([^:]*)(:)?$", cg_missing = ""),
    matrix(c("abcd", "", "abcd", ""), 1, 4))

expect_identical(stri_match_last_regex("abcd", "^(:)?([^:]*)(:)?$"), matrix(c("abcd",
    NA, "abcd", NA), 1, 4))

expect_identical(stri_match_last_regex(":abcd", "^(:)?([^:]*)(:)?$", cg_missing = ""),
    matrix(c(":abcd", ":", "abcd", ""), 1, 4))

expect_identical(stri_match_last_regex(":abcd", "^(:)?([^:]*)(:)?$"), matrix(c(":abcd",
    ":", "abcd", NA), 1, 4))

expect_identical(stri_match_last_regex("test", NA), matrix(NA_character_, 1,
    1))
suppressWarnings(expect_identical(stri_match_last_regex("test", ""), matrix(NA_character_,
    1, 1)))
expect_equivalent(stri_match_last_regex(c("bacab", "ba\u0105aacaba\u0104a", "aa"), "a.a"),
    matrix(c("aca", "a\u0104a", NA_character_), 3, 1))
expect_equivalent(stri_match_last_regex(c("a=b;c=d", "", "e=f"), "([a-z])=([a-z])"),
    matrix(c("c=d", NA, "e=f", "c", NA, "e", "d", NA, "f"), 3, 3))


expect_identical(stri_match_last_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "\u0106*"), matrix(ncol = 1,
    c("", "")))  # match of zero length
expect_identical(stri_match_last_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "(?<=\u0106)"), matrix(ncol = 1,
    c("", NA_character_)))  # match of zero length

expect_identical(dim(stringi::stri_match_last_regex(character(0), "(.)")), c(0L,
    2L))
expect_identical(dim(stringi::stri_match_last_regex(character(0), "(.)(.)")),
    c(0L, 3L))
expect_identical(dim(stringi::stri_match_last_regex(c(NA), "(.)")), c(1L, 2L))
expect_identical(dim(stringi::stri_match_last_regex(c(NA), "(.)(.)")), c(1L,
    3L))
expect_identical(dim(stringi::stri_match_last_regex(c("a", "ab", NA), "(.)")),
    c(3L, 2L))
expect_identical(dim(stringi::stri_match_last_regex(c("a", "ab", NA), "(.)(.)")),
    c(3L, 3L))

expect_equivalent(stri_locate_last_fixed("agaga", "aga"), matrix(nrow=1, c(3, 5)))
expect_equivalent(stri_locate_last_coll("agaga", "aga"), matrix(nrow=1, c(3, 5)))
expect_equivalent(stri_locate_last_regex("agaga", "aga"), matrix(nrow=1, c(1, 3)))
