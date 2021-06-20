library("tinytest")
library("stringi")

expect_equivalent(stri_locate_all_regex(NA, character(0)), list())
expect_equivalent(stri_locate_all_regex(character(0), NA), list())
expect_equivalent(stri_locate_all_regex(LETTERS, character(0)), list())
suppressWarnings(expect_equivalent(stri_locate_all_regex("abc", ""), list(matrix(c(NA_integer_,
    NA_integer_)))))
suppressWarnings(expect_equivalent(stri_locate_all_regex("", "abc"), list(matrix(c(NA_integer_,
    NA_integer_)))))
suppressWarnings(expect_equivalent(stri_locate_all_regex("", ""), list(matrix(c(NA_integer_,
    NA_integer_)))))

expect_equivalent(as.integer(stri_locate_all_regex(NA, "[a-z]")[[1]]), c(NA_integer_,
    NA_integer_))
expect_equivalent(as.integer(stri_locate_all_regex("?", "[a-z]")[[1]]), c(NA_integer_,
    NA_integer_))
expect_equivalent(as.integer(stri_locate_all_regex("?", "[a-z]", omit_no_match = TRUE)[[1]]),
    integer(0))

expect_equivalent(stri_locate_all_regex("1a\u0105a", "\u0105"), list(matrix(c(3, 3))))
expect_equivalent(stri_locate_all_regex("X\U00024B62\U00024B63\U00024B64X", c("\U00024B62", "\U00024B63", "\U00024B64")),
    list(matrix(c(2L, 2L)), matrix(c(3L, 3L)), matrix(c(4L, 4L))))
expect_equivalent(stri_locate_all_regex("aaa", "aa"), list(matrix(c(1, 2))))
expect_equivalent(stri_locate_all_regex(c("", " "), "^.*$"), list(matrix(c(1,
    0)), matrix(c(1, 1))))

expect_equivalent(stri_locate_all_regex("1a\u0105a", "a.a"), list(matrix(c(2, 4))))
expect_equivalent(stri_locate_all_regex("ala ola ela ula", ".la"), list(matrix(c(1,
    5, 9, 13, 3, 7, 11, 15), ncol = 2)))
expect_equivalent(stri_locate_all_regex("ala ola ela ula", "(a|u|z)la"), list(matrix(c(1,
    13, 3, 15), ncol = 2)))

expect_equivalent(stri_locate_all_regex("aabaaaba", "(a+b)+"), list(matrix(c(1,
    7))))
expect_equivalent(stri_locate_all_regex("aabaacba", "(a+b)+"), list(matrix(c(1,
    3))))
expect_equivalent(stri_locate_all_regex("ababacba", "(a+b)+"), list(matrix(c(1,
    4))))

expect_equivalent(stri_locate_all_regex("aabdaaaba", "(a+b)+"), list(matrix(c(1,
    5, 3, 8), ncol = 2)))
expect_equivalent(stri_locate_all_regex("aabdaacba", "(a+b)+"), list(matrix(c(1,
    3))))
expect_equivalent(stri_locate_all_regex("ababdacba", "(a+b)+"), list(matrix(c(1,
    4))))


expect_equivalent(stri_locate_all_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "\u0106*"), list(matrix(ncol = 2,
    c(1, 2, 3, 4, 0, 2, 2, 3)), matrix(ncol = 2, c(1, 2, 3, 0, 1, 2))))  # match of zero length
expect_equivalent(stri_locate_all_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "(?<=\u0106)"), list(matrix(ncol = 2,
    c(3L, 2L)), matrix(ncol = 2, c(NA, NA))))  # match of zero length:


expect_equivalent(nrow(stri_locate_first_regex(NA, character(0))), 0)
expect_equivalent(nrow(stri_locate_first_regex(character(0), NA)), 0)
expect_equivalent(nrow(stri_locate_first_regex(LETTERS, character(0))), 0)
suppressWarnings(expect_equivalent(stri_locate_first_regex("abc", ""), matrix(c(NA_integer_,
    NA_integer_))))
suppressWarnings(expect_equivalent(stri_locate_first_regex("", "abc"), matrix(c(NA_integer_,
    NA_integer_))))
suppressWarnings(expect_equivalent(stri_locate_first_regex("", ""), matrix(c(NA_integer_,
    NA_integer_))))
expect_equivalent(stri_locate_first_regex(c("", " "), "^.*$"), matrix(c(1, 0,
    1, 1), byrow = TRUE, ncol = 2))

expect_equivalent(stri_locate_first_regex("X\u0104\u0105\u0106X", "\u0105"), matrix(c(3L, 3L)))
expect_equivalent(stri_locate_first_regex("X\u9999\u9998\u9997X", "\u9998"), matrix(c(3L,
    3L)))
expect_equivalent(stri_locate_first_regex("X\U00024B62\U00024B63\U00024B64X", "\U00024B63"), matrix(c(3L,
    3L)))
expect_equivalent(stri_locate_first_regex("aaa", "aa"), matrix(c(1L, 2L)))

expect_equivalent(stri_locate_first_regex("1a\u0105a", "a.a"), matrix(c(2, 4)))
expect_equivalent(stri_locate_first_regex("ala ola ela ula", ".la"), matrix(c(1,
    3)))
expect_equivalent(stri_locate_first_regex("ala ola ela ula", "(e|u|z)la"), matrix(c(9,
    11)))

expect_equivalent(stri_locate_first_regex("aabaaaba", "(a+b)+"), matrix(c(1,
    7)))
expect_equivalent(stri_locate_first_regex("aabaacba", "(a+b)+"), matrix(c(1,
    3)))
expect_equivalent(stri_locate_first_regex("ababacba", "(a+b)+"), matrix(c(1,
    4)))

expect_equivalent(stri_locate_first_regex("aabdaaaba", "(a+b)+"), matrix(c(1,
    3)))
expect_equivalent(stri_locate_first_regex("aabdaacba", "(a+b)+"), matrix(c(1,
    3)))
expect_equivalent(stri_locate_first_regex("ababdacba", "(a+b)+"), matrix(c(1,
    4)))


expect_equivalent(stri_locate_first_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "\u0106*"), matrix(ncol = 2,
    c(1, 1, 0, 0)))  # match of zero length
expect_equivalent(stri_locate_first_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "(?<=\u0106)"), matrix(ncol = 2,
    c(3, NA, 2, NA)))  # match of zero length:


expect_equivalent(nrow(stri_locate_last_regex(NA, character(0))), 0)
expect_equivalent(nrow(stri_locate_last_regex(character(0), NA)), 0)
expect_equivalent(nrow(stri_locate_last_regex(LETTERS, character(0))), 0)
suppressWarnings(expect_equivalent(stri_locate_last_regex("abc", ""), matrix(c(NA_integer_,
    NA_integer_))))
suppressWarnings(expect_equivalent(stri_locate_last_regex("", "abc"), matrix(c(NA_integer_,
    NA_integer_))))
suppressWarnings(expect_equivalent(stri_locate_last_regex("", ""), matrix(c(NA_integer_,
    NA_integer_))))

expect_equivalent(stri_locate_last_regex("X\u0104\u0105\u0106X", "\u0104", case_insensitive = TRUE),
    matrix(c(3L, 3L)))
expect_equivalent(stri_locate_last_regex("X\u0104\u0105\u0106X", "\u0105"), matrix(c(3L, 3L)))
expect_equivalent(stri_locate_last_regex("X\u9999\u9998\u9997X", "\u9998"), matrix(c(3L,
    3L)))
expect_equivalent(stri_locate_last_regex("X\U00024B62\U00024B63\U00024B64X", "\U00024B63"), matrix(c(3L,
    3L)))

# ICU 4.8.1 - problems with UREGEX_LITERAL on clang:
expect_equivalent(stri_locate_last_regex("X\U00024B62\U00024B63\U00024B64X", "\U00024B63", literal = TRUE),
    matrix(c(3L, 3L)))

expect_equivalent(stri_locate_last_regex("aaa", "aa"), matrix(c(1L, 2L)))

expect_equivalent(stri_locate_last_regex("1a\u0105a", "a.a"), matrix(c(2, 4)))
expect_equivalent(stri_locate_last_regex("ala ola ela ula", ".la"), matrix(c(13,
    15)))
expect_equivalent(stri_locate_last_regex("ala ola ela ula", "(e|u|z)la"), matrix(c(13,
    15)))

expect_equivalent(stri_locate_last_regex("aabaaaba", "(a+b)+"), matrix(c(1, 7)))
expect_equivalent(stri_locate_last_regex("aabaacba", "(a+b)+"), matrix(c(1, 3)))
expect_equivalent(stri_locate_last_regex("ababacba", "(a+b)+"), matrix(c(1, 4)))

expect_equivalent(stri_locate_last_regex("aabdaaaba", "(a+b)+"), matrix(c(5,
    8)))
expect_equivalent(stri_locate_last_regex("aabdaacba", "(a+b)+"), matrix(c(1,
    3)))
expect_equivalent(stri_locate_last_regex("ababdacba", "(a+b)+"), matrix(c(1,
    4)))

expect_equivalent(stri_locate_last_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "\u0106*"), matrix(ncol = 2,
    c(4, 3, 3, 2)))  # match of zero length
expect_equivalent(stri_locate_last_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "(?<=\u0106)"), matrix(ncol = 2,
    c(3, NA, 2, NA)))  # match of zero length:
expect_equivalent(stri_locate_last_regex(c("", " "), "^.*$"), matrix(c(1, 0,
    1, 1), byrow = TRUE, ncol = 2))


# .....
stri_locate_all_regex(
    c('breakfast=eggs;lunch=pizza',
   'breakfast=spam', 'no food here'),
   '(?<when>\\w+)=(?<what>\\w+)',
   capture_groups=TRUE
)

