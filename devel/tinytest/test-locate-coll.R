library("tinytest")
library("stringi")


expect_equal(mode(stri_locate_all_coll(character(0), "a")), "list")

suppressWarnings(expect_equivalent(stri_locate_all_coll(NA, character(0)), list()))
expect_equivalent(stri_locate_all_coll(character(0), NA), list())
suppressWarnings(expect_equivalent(stri_locate_all_coll(LETTERS, character(0)),
    list()))
suppressWarnings(expect_equivalent(stri_locate_all_coll(NA, ""), list(matrix(c(NA,
    NA_integer_)))))
expect_equivalent(stri_locate_all_coll("", NA), list(matrix(c(NA, NA_integer_))))
expect_equivalent(stri_locate_all_coll(NA, NA), list(matrix(c(NA, NA_integer_))))

expect_equivalent(as.integer(stri_locate_all_coll(NA, "[a-z]")[[1]]), c(NA_integer_,
    NA_integer_))
expect_equivalent(as.integer(stri_locate_all_coll("?", "[a-z]")[[1]]), c(NA_integer_,
    NA_integer_))
expect_equivalent(as.integer(stri_locate_all_coll("?", "[a-z]", omit_no_match = TRUE)[[1]]),
    integer(0))

expect_equivalent(stri_locate_all_coll("1a\u0105a", "\u0105"), list(matrix(c(3, 3))))
expect_equivalent(stri_locate_all_coll("aaa", "aa"), list(matrix(c(1, 2))))

expect_equivalent(stri_locate_all_coll("\u0105a", "\u0105a"), list(matrix(c(1, 2))))
expect_equivalent(stri_locate_all_coll(stri_trans_nfkd("\u0105a"), "\u0105a"), list(matrix(c(1,
    3))))
expect_equivalent(stri_locate_all_coll("\U0001F0A0a", "a"), list(matrix(c(2, 2))))

suppressWarnings(expect_equivalent(stri_locate_all_coll("", ""), list(matrix(c(NA,
    NA_integer_)))))
suppressWarnings(expect_equivalent(stri_locate_all_coll("a", ""), list(matrix(c(NA,
    NA_integer_)))))
expect_equivalent(stri_locate_all_coll("", "a"), list(matrix(c(NA, NA_integer_))))
expect_equivalent(stri_locate_all_coll(c("a", ""), "a"), list(matrix(c(1, 1)),
    matrix(c(NA, NA_integer_))))
expect_equivalent(stri_locate_all_coll("aaaab", "ab"), list(matrix(4:5)))
expect_equivalent(stri_locate_all_coll("bababababaab", "aab"), list(matrix(5:6 *
    2)))



expect_equivalent(nrow(stri_locate_first_coll(NA, character(0))), 0)
expect_equivalent(nrow(stri_locate_first_coll(character(0), NA)), 0)
expect_equivalent(nrow(stri_locate_first_coll(LETTERS, character(0))), 0)
expect_warning(expect_equivalent(stri_locate_first_coll(NA, ""), matrix(c(NA_integer_,
    NA_integer_))))
expect_equivalent(stri_locate_first_coll("", NA), matrix(c(NA_integer_, NA_integer_)))
expect_equivalent(stri_locate_first_coll(NA, NA), matrix(c(NA_integer_, NA_integer_)))

expect_equivalent(stri_locate_first_coll("1a\u0105a", "\u0105"), matrix(c(3, 3)))
expect_equivalent(stri_locate_first_coll("aaa", "aa"), matrix(c(1, 2)))
expect_equivalent(stri_locate_first_coll("aa1a12aa123", "123"), matrix(c(9, 11)))
expect_equivalent(stri_locate_first_coll("1-1-2-33--2", "-32"), matrix(c(NA_integer_,
    NA_integer_)))

expect_equivalent(stri_locate_first_coll("\u0105a", "\u0105a"), matrix(c(1, 2)))
expect_equivalent(stri_locate_first_coll(stri_trans_nfkd("\u0105a"), "\u0105a"), matrix(c(1,
    3)))
expect_equivalent(stri_locate_first_coll("\U0001F0A0a", "a"), matrix(c(2, 2)))

expect_warning(expect_equivalent(stri_locate_first_coll("", ""), matrix(c(NA,
    NA_integer_))))
expect_warning(expect_equivalent(stri_locate_first_coll("a", ""), matrix(c(NA,
    NA_integer_))))
expect_equivalent(stri_locate_first_coll("", "a"), matrix(c(NA, NA_integer_)))
expect_equivalent(stri_locate_first_coll(c("a", ""), "a"), matrix(c(1, NA, 1,
    NA_integer_)))
expect_equivalent(stri_locate_first_coll("aaaab", "ab"), matrix(4:5))
expect_equivalent(stri_locate_first_coll("bababababaab", "aab"), matrix(5:6 *
    2))




expect_equivalent(nrow(stri_locate_last_coll(NA, character(0))), 0)
expect_equivalent(nrow(stri_locate_last_coll(character(0), NA)), 0)
expect_equivalent(nrow(stri_locate_last_coll(LETTERS, character(0))), 0)
expect_warning(expect_equivalent(stri_locate_last_coll(NA, ""), matrix(c(NA,
    NA_integer_))))
expect_equivalent(stri_locate_last_coll("", NA), matrix(c(NA, NA_integer_)))
expect_equivalent(stri_locate_last_coll(NA, NA), matrix(c(NA, NA_integer_)))

expect_equivalent(stri_locate_last_coll("1a\u0105a", "\u0105"), matrix(c(3, 3)))
#overlapping pattern
expect_equivalent(stri_locate_last_coll("aaa", "aa"), matrix(c(2, 3)))
expect_equivalent(stri_locate_last_coll("aa1a12aa123", "123"), matrix(c(9, 11)))
expect_equivalent(stri_locate_last_coll("1-1-2-33--2", "-32"), matrix(c(NA_integer_,
    NA_integer_)))

expect_equivalent(stri_locate_last_coll("\u0105a", "\u0105a"), matrix(c(1, 2)))
expect_equivalent(stri_locate_last_coll(stri_trans_nfkd("\u0105a"), "\u0105a"), matrix(c(1,
    3)))
expect_equivalent(stri_locate_last_coll("\U0001F0A0a", "a"), matrix(c(2, 2)))
#additional test for overlapping patterns
expect_equivalent(stri_locate_last_coll(stri_trans_nfkd("\u0105a\u0105a\u0105a"), "\u0105a\u0105a"),
    matrix(c(4, 9)))

expect_warning(expect_equivalent(stri_locate_last_coll("", ""), matrix(c(NA,
    NA_integer_))))
expect_warning(expect_equivalent(stri_locate_last_coll("a", ""), matrix(c(NA,
    NA_integer_))))
expect_equivalent(stri_locate_last_coll("", "a"), matrix(c(NA, NA_integer_)))
expect_equivalent(stri_locate_last_coll(c("a", ""), "a"), matrix(c(1, NA, 1,
    NA_integer_)))
expect_equivalent(stri_locate_last_coll("aaaab", "ab"), matrix(4:5))
expect_equivalent(stri_locate_last_coll("bababababaab", "aab"), matrix(5:6 *
    2))
