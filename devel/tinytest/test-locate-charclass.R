library("tinytest")
library("stringi")



expect_equal(mode(stri_locate_all_charclass(character(0), "\\p{Z}")), "list")
expect_error(stri_locate_all_charclass(c("", ""), 1))

expect_equivalent(stri_locate_all_charclass(character(0), "\\p{Z}"), list())
expect_equivalent(stri_locate_all_charclass(LETTERS, character(0)), list())

expect_equivalent(as.integer(stri_locate_all_charclass("", "\\P{WHITE_SPACE}")[[1]]),
    c(NA_integer_, NA_integer_))

expect_equivalent(as.integer(stri_locate_all_charclass("", NA)[[1]]), c(NA_integer_,
    NA_integer_))

expect_equivalent(as.integer(stri_locate_all_charclass(NA, "[a-z]")[[1]]), c(NA_integer_,
    NA_integer_))
expect_equivalent(as.integer(stri_locate_all_charclass("?", "[a-z]")[[1]]), c(NA_integer_,
    NA_integer_))
expect_equivalent(as.integer(stri_locate_all_charclass("?", "[a-z]", omit_no_match = TRUE)[[1]]),
    integer(0))

expect_error(stri_locate_all_charclass("", "\\P{WHITE_SPACE}", NA))

expect_equivalent(as.integer(stri_locate_all_charclass(NA, "\\P{WHITE_SPACE}")[[1]]),
    c(NA_integer_, NA_integer_))

expect_equivalent(lapply(stri_locate_all_charclass(c("abc", "a\u0105b", "a1B2c3",
    "1\u01052b3C", "123"), "\\p{L}", merge = TRUE), as.integer), list(c(1L, 3L),
    c(1L, 3L), c(1L, 3L, 5L, 1L, 3L, 5L), c(2L, 4L, 6L, 2L, 4L, 6L), c(NA_integer_,
        NA_integer_)))

expect_equivalent(lapply(stri_locate_all_charclass(c("abc", "a\u0105b", "a1B2c3",
    "1\u01052b3C", "123"), "\\p{L}", merge = FALSE), function(x) as.integer(x[, 1])),
    list(c(1L, 2L, 3L), c(1L, 2L, 3L), c(1L, 3L, 5L), c(2L, 4L, 6L), c(NA_integer_)))

expect_equivalent(lapply(stri_locate_all_charclass(c("abc", "a\u0105b", "a1B2c3",
    "1\u01052b3C", "123"), ("\\P{L}"), merge = TRUE), as.integer), list(c(NA_integer_,
    NA_integer_), c(NA_integer_, NA_integer_), c(2L, 4L, 6L, 2L, 4L, 6L), c(1L,
    3L, 5L, 1L, 3L, 5L), c(1L, 3L)))

expect_equivalent(as.integer(stri_locate_all_charclass("    xxx\n\t \v   \n",
    ("\\p{WHITE_SPACE}"), merge = TRUE)[[1]]), c(1L, 8L, 4L, 15L))

expect_equivalent(as.integer(stri_locate_all_charclass("    xxx\n\t \v   \n",
    ("\\P{WHITE_SPACE}"), merge = TRUE)[[1]]), c(5, 7))



expect_equivalent(as.integer(stri_locate_first_charclass("", ("\\P{WHITE_SPACE}"))),
    c(NA_integer_, NA_integer_))
expect_equivalent(as.integer(stri_locate_first_charclass(NA, ("\\P{WHITE_SPACE}"))),
    c(NA_integer_, NA_integer_))

expect_equivalent(stri_locate_first_charclass(c("abc", "5\u0105bc", "a1B2c3", "1\u01052b3C",
    "123"), ("\\p{L}"))[, 1], c(1L, 2L, 1L, 2L, NA_integer_))

expect_equivalent(stri_locate_first_charclass("abc", c("\\p{L}", "\\p{Z}", "\\p{P}"))[,
    1], c(1L, NA_integer_, NA_integer_))

expect_equivalent(stri_locate_first_charclass("    xxx\n\t \v   \n", c(("\\p{WHITE_SPACE}"),
    ("\\P{WHITE_SPACE}")))[, 2], c(1L, 5L))



expect_equivalent(stri_locate_last_charclass("", ("\\P{WHITE_SPACE}"))[, 2],
    NA_integer_)
expect_equivalent(stri_locate_last_charclass(NA, ("\\P{WHITE_SPACE}"))[, 2],
    NA_integer_)

expect_equivalent(stri_locate_last_charclass("abc", c("\\p{L}", "\\p{Z}", "\\p{P}"))[,
    1], c(3L, NA_integer_, NA_integer_))

expect_equivalent(stri_locate_last_charclass(c("abc", "5\u0105bc", "a1B2c3", "1\u01052b3C",
    "123"), ("\\p{L}"))[, 2], c(3L, 4L, 5L, 6L, NA_integer_))

expect_equivalent(stri_locate_last_charclass("    xxx\n\t \v   \n", c(("\\p{WHITE_SPACE}"),
    ("\\P{WHITE_SPACE}")))[, 2], c(15L, 7L))


###############################################################################
#### get_length


expect_equal(
    stri_locate_first_charclass(c("baba", "", "z", NA), "[a]", get_length=TRUE),
    cbind(start=c(2L, -1L, -1L, NA), length=c(1L, -1L, -1L, NA))
)

expect_equal(
    stri_locate_last_charclass(c("baba", "", "z", NA), "[a]", get_length=TRUE),
    cbind(start=c(4L, -1L, -1L, NA), length=c(1L, -1L, -1L, NA))
)

expect_equal(
    stri_locate_all_charclass(c("baba", "", "z", NA), "[a]", get_length=TRUE, omit_no_match=FALSE),
    list(
        cbind(start=c(2L, 4L), length=c(1L, 1L)),
        cbind(start=c(-1L), length=c(-1L)),
        cbind(start=c(-1L), length=c(-1L)),
        cbind(start=c(NA_integer_), length=c(NA_integer_))
    )
)

expect_equal(
    stri_locate_all_charclass(c("baba", "", "z", NA), "[a]", get_length=TRUE, omit_no_match=TRUE),
    list(
        cbind(start=c(2L, 4L), length=c(1L, 1L)),
        cbind(start=integer(0), length=integer(0)),
        cbind(start=integer(0), length=integer(0)),
        cbind(start=c(NA_integer_), length=c(NA_integer_))
    )
)

