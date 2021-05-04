library("tinytest")
library("stringi")


expect_identical(colnames(stri_locate_all_boundaries("stringi")[[1]]), c("start",
    "end"))
expect_error(stri_locate_all_boundaries("aaa", opts_brkiter = stri_opts_brkiter(type = "???")))
expect_equivalent(stri_locate_all_boundaries(c(NA, NA), type = "word"), list(matrix(NA_integer_,
    ncol = 2, nrow = 1), matrix(NA_integer_, ncol = 2, nrow = 1)))
expect_equivalent(stri_locate_all_boundaries(c(NA, "     "), omit_no_match = TRUE,
    opts_brkiter = stri_opts_brkiter(type = "word", skip_word_none = TRUE)),
    list(matrix(NA_integer_, ncol = 2, nrow = 1), matrix(integer(0), ncol = 2,
        nrow = 0)))
expect_equivalent(stri_locate_all_boundaries(stri_trans_nfkd("a\u0105"), type = "chara")[[1]],
    matrix(c(1, 1, 2, 3), nrow = 2, byrow = TRUE))


expect_equivalent(stri_locate_first_boundaries(c("\u0105l\u0105 m\u0105 kot\u0105", "    kot    ",
    "", NA), opts_brkiter = stri_opts_brkiter(type = "character")), matrix(c(1,
    1, 1, 1, NA, NA, NA, NA), ncol = 2, byrow = TRUE))
expect_equivalent(stri_locate_first_boundaries(character(0), opts_brkiter = stri_opts_brkiter(type = "character")),
    matrix(integer(0), ncol = 2, byrow = TRUE))
expect_equivalent(colnames(stri_locate_first_boundaries(character(0), type = "character")),
    c("start", "end"))


expect_equivalent(stri_locate_last_boundaries(c("\u0105l\u0105 m\u0105 kot\u0105", "    kot    ",
    "", NA), opts_brkiter = stri_opts_brkiter(type = "character")), matrix(c(11,
    11, 11, 11, NA, NA, NA, NA), ncol = 2, byrow = TRUE))
expect_equivalent(stri_locate_last_boundaries(character(0), type = "character"),
    matrix(integer(0), ncol = 2, byrow = TRUE))
expect_equivalent(colnames(stri_locate_last_boundaries(character(0), opts_brkiter = stri_opts_brkiter(type = "character"))),
    c("start", "end"))



expect_equivalent(stri_locate_first_words(c("\u0105l\u0105 m\u0105 kot\u0105", "    kot    ",
    "   ", NA)), matrix(c(1, 3, 5, 7, NA, NA, NA, NA), ncol = 2, byrow = TRUE))
expect_equivalent(stri_locate_first_words(character(0)), matrix(integer(0), ncol = 2,
    byrow = TRUE))
expect_equivalent(colnames(stri_locate_first_words(c("\u0105l\u0105 m\u0105 kot\u0105", "    kot",
    "   ", NA))), c("start", "end"))



expect_equivalent(stri_locate_last_words(c("\u0105l\u0105 m\u0105 kot\u0105", "    kot   ", "   ",
    NA)), matrix(c(8, 11, 5, 7, NA, NA, NA, NA), ncol = 2, byrow = TRUE))
expect_equivalent(stri_locate_last_words(c("ala ma kota", "    kot", "   ", "",
    NA, "a", "aa ", "aa")), matrix(c(8, 11, 5, 7, NA, NA, NA, NA, NA, NA, 1,
    1, 1, 2, 1, 2), ncol = 2, byrow = TRUE))
expect_equivalent(stri_locate_last_words(character(0)), matrix(integer(0), ncol = 2,
    byrow = TRUE))
expect_equivalent(colnames(stri_locate_last_words(c("\u0105l\u0105 m\u0105 kot\u0105", "    kot",
    "   ", NA))), c("start", "end"))


expect_identical(colnames(stri_locate_all_words("stringi")[[1]]), c("start",
    "end"))

expect_equivalent(stri_locate_all_words(c("    \t   ", "stri\u0105gi", NA)), list(matrix(c(NA,
    NA), ncol = 2), matrix(c(1, 7), ncol = 2), matrix(c(NA, NA), ncol = 2)))

expect_equivalent(stri_locate_all_words(c("    \t   ", "stri\u0105gi", NA), omit_no_match = TRUE),
    list(matrix(integer(0), ncol = 2), matrix(c(1, 7), ncol = 2), matrix(c(NA,
        NA), ncol = 2)))

