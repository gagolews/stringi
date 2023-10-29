library("tinytest")
library("stringi")

expect_equivalent(stri_locate_all_regex(NA, character(0)), list())
expect_equivalent(stri_locate_all_regex(character(0), NA), list())
expect_equivalent(stri_locate_all_regex(LETTERS, character(0)), list())
suppressWarnings(expect_equivalent(stri_locate_all_regex("abc", ""), list(matrix(c(NA_integer_,
    NA_integer_)))))
suppressWarnings(expect_equivalent(stri_locate_all_regex("", "abc"), list(matrix(c(NA_integer_,
    NA_integer_)))))
suppressWarnings(expect_equivalent(stri_locate_all_regex("", "abc", get_length=TRUE), list(matrix(c(-1,
    -1)))))
suppressWarnings(expect_equivalent(stri_locate_all_regex("", ""), list(matrix(c(NA_integer_,
    NA_integer_)))))
suppressWarnings(expect_equivalent(stri_locate_all_regex("", "", get_length=TRUE), list(matrix(c(NA_integer_,
    NA_integer_)))))

expect_equivalent(as.integer(stri_locate_all_regex(NA, "[a-z]")[[1]]), c(NA_integer_,
    NA_integer_))
expect_equivalent(as.integer(stri_locate_all_regex("?", "[a-z]")[[1]]), c(NA_integer_,
    NA_integer_))
expect_equivalent(as.integer(stri_locate_all_regex("?", "[a-z]", omit_no_match = TRUE)[[1]]),
    integer(0))
expect_equivalent(as.integer(stri_locate_all_regex("?", "[a-z]", omit_no_match = TRUE, get_length=TRUE)[[1]]),
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



##############################################################################
###### capture groups

# expect_equal tests attributes too

expect_warning(stri_locate_all_regex("test", "", capture_groups=TRUE))
expect_equal(suppressWarnings(stri_locate_all_regex("test", "", capture_groups=TRUE)),
    list(structure(cbind(start=NA_integer_, end=NA_integer_), capture_groups=list())))


expect_warning(stri_locate_first_regex("test", "", capture_groups=TRUE))
expect_equal(suppressWarnings(stri_locate_first_regex("test", "", capture_groups=TRUE)),
    structure(cbind(start=NA_integer_, end=NA_integer_), capture_groups=list()))

expect_warning(stri_locate_last_regex("test", "", capture_groups=TRUE))
expect_equal(suppressWarnings(stri_locate_last_regex("test", "", capture_groups=TRUE)),
    structure(cbind(start=NA_integer_, end=NA_integer_), capture_groups=list()))


expect_equal(
    stri_locate_all_regex("a\U0001f600c", "(?<a>.)", capture_groups=TRUE),
    list(
        structure(cbind(start=1:3, end=1:3), capture_groups=list(a=cbind(start=1:3, end=1:3)))
    )
)
expect_equal(
    stri_locate_all_regex("\U0001f600b\U0001f601", "(?<a>.)(.)(?<c>.)", capture_groups=TRUE),
    list(
        structure(cbind(start=1, end=3), capture_groups=list(
            a=cbind(start=1, end=1),
            cbind(start=2, end=2),
            c=cbind(start=3, end=3)
        ))
    )
)
expect_equal(
    stri_locate_all_regex("\U0001f601\U0001f600\U0001f602", "(.)(.)(.)", capture_groups=TRUE),
    list(
        structure(cbind(start=1, end=3), capture_groups=list(
            cbind(start=1, end=1),
            cbind(start=2, end=2),
            cbind(start=3, end=3)
        ))
    )
)

expect_equal(
    stri_locate_all_regex("abc", c("(?<a>.)", "(?<a>.)(.)(?<c>.)", "(.)(.)"), capture_groups=TRUE),
    list(
        structure(cbind(start=1:3, end=1:3), capture_groups=list(a=cbind(start=1:3, end=1:3))),
        structure(cbind(start=1, end=3), capture_groups=list(
            a=cbind(start=1, end=1),
            cbind(start=2, end=2),
            c=cbind(start=3, end=3)
        )),
        structure(cbind(start=1, end=2), capture_groups=list(
            cbind(start=1, end=1),
            cbind(start=2, end=2)
        ))
    )
)

expect_equal(
    stri_locate_all_regex(c("", NA, "no"), "(?<a>.)(.)(?<c>.)", capture_groups=TRUE),
    list(
        structure(cbind(start=NA_integer_, end=NA_integer_), capture_groups=list(
            a=cbind(start=NA_integer_, end=NA_integer_),
            cbind(start=NA_integer_, end=NA_integer_),
            c=cbind(start=NA_integer_, end=NA_integer_)
        )),
        structure(cbind(start=NA_integer_, end=NA_integer_), capture_groups=list(
            a=cbind(start=NA_integer_, end=NA_integer_),
            cbind(start=NA_integer_, end=NA_integer_),
            c=cbind(start=NA_integer_, end=NA_integer_)
        )),
        structure(cbind(start=NA_integer_, end=NA_integer_), capture_groups=list(
            a=cbind(start=NA_integer_, end=NA_integer_),
            cbind(start=NA_integer_, end=NA_integer_),
            c=cbind(start=NA_integer_, end=NA_integer_)
        ))
    )
)

expect_equal(
    stri_locate_all_regex(c("", NA, "no"), "(?<a>.)(.)(?<c>.)", capture_groups=TRUE, omit_no_match=TRUE),
    list(
        structure(cbind(start=integer(0), end=integer(0)), capture_groups=list(
            a=cbind(start=integer(0), end=integer(0)),
            cbind(start=integer(0), end=integer(0)),
            c=cbind(start=integer(0), end=integer(0))
        )),
        structure(cbind(start=NA_integer_, end=NA_integer_), capture_groups=list(
            a=cbind(start=NA_integer_, end=NA_integer_),
            cbind(start=NA_integer_, end=NA_integer_),
            c=cbind(start=NA_integer_, end=NA_integer_)
        )),
        structure(cbind(start=integer(0), end=integer(0)), capture_groups=list(
            a=cbind(start=integer(0), end=integer(0)),
            cbind(start=integer(0), end=integer(0)),
            c=cbind(start=integer(0), end=integer(0))
        ))
    )
)



expect_equal(
    stri_locate_all_regex("abc", c("(?<a>.)", "(?<a>.)(.)(?<c>.)", "(.)(.)"), capture_groups=TRUE, get_length=TRUE),
    list(
        structure(cbind(start=1:3, length=c(1, 1, 1)), capture_groups=list(a=cbind(start=1:3, length=c(1, 1, 1)))),
        structure(cbind(start=1, length=3), capture_groups=list(
            a=cbind(start=1, length=1),
            cbind(start=2, length=1),
            c=cbind(start=3, length=1)
        )),
        structure(cbind(start=1, length=2), capture_groups=list(
            cbind(start=1, length=1),
            cbind(start=2, length=1)
        ))
    )
)

expect_equal(
    stri_locate_all_regex(c("", NA, "no"), "(?<a>.)(.)(?<c>.)", capture_groups=TRUE, get_length=TRUE),
    list(
        structure(cbind(start=-1, length=-1), capture_groups=list(
            a=cbind(start=-1, length=-1),
            cbind(start=-1, length=-1),
            c=cbind(start=-1, length=-1)
        )),
        structure(cbind(start=NA_integer_, length=NA_integer_), capture_groups=list(
            a=cbind(start=NA_integer_, length=NA_integer_),
            cbind(start=NA_integer_, length=NA_integer_),
            c=cbind(start=NA_integer_, length=NA_integer_)
        )),
        structure(cbind(start=-1, length=-1), capture_groups=list(
            a=cbind(start=-1, length=-1),
            cbind(start=-1, length=-1),
            c=cbind(start=-1, length=-1)
        ))
    )
)

expect_equal(
    stri_locate_all_regex(c("", NA, "no"), "(?<a>.)(.)(?<c>.)", capture_groups=TRUE, omit_no_match=TRUE, get_length=TRUE),
    list(
        structure(cbind(start=integer(0), length=integer(0)), capture_groups=list(
            a=cbind(start=integer(0), length=integer(0)),
            cbind(start=integer(0), length=integer(0)),
            c=cbind(start=integer(0), length=integer(0))
        )),
        structure(cbind(start=NA_integer_, length=NA_integer_), capture_groups=list(
            a=cbind(start=NA_integer_, length=NA_integer_),
            cbind(start=NA_integer_, length=NA_integer_),
            c=cbind(start=NA_integer_, length=NA_integer_)
        )),
        structure(cbind(start=integer(0), length=integer(0)), capture_groups=list(
            a=cbind(start=integer(0), length=integer(0)),
            cbind(start=integer(0), length=integer(0)),
            c=cbind(start=integer(0), length=integer(0))
        ))
    )
)



expect_equal(
    stri_locate_first_regex(c("\U0001f601\U0001f600\U0001f602def", "ghi", "jk", NA), "(?<a>.)(..)", capture_groups=TRUE),
    structure(
        cbind(start=c(1, 1, NA_integer_, NA_integer_), end=c(3, 3, NA_integer_, NA_integer_)),
        capture_groups=list(
            a=cbind(start=c(1, 1, NA_integer_, NA_integer_), end=c(1, 1, NA_integer_, NA_integer_)),
            cbind(start=c(2, 2, NA_integer_, NA_integer_), end=c(3, 3, NA_integer_, NA_integer_))
        )
    )
)

expect_equal(
    stri_locate_last_regex(c("\U0001f601\U0001f600\U0001f602def", "ghi", "jk", NA), "(?<a>.)(..)", capture_groups=TRUE),
    structure(
        cbind(start=c(4, 1, NA_integer_, NA_integer_), end=c(6, 3, NA_integer_, NA_integer_)),
        capture_groups=list(
            a=cbind(start=c(4, 1, NA_integer_, NA_integer_), end=c(4, 1, NA_integer_, NA_integer_)),
            cbind(start=c(5, 2, NA_integer_, NA_integer_), end=c(6, 3, NA_integer_, NA_integer_))
        )
    )
)

expect_equal(
    stri_locate_first_regex("\U0001f601\U0001f600\U0001f602abc", c("(?<a>.)", "(?<a>.)(.)(?<c>.)", "(.)(.)", "(.)asfsa(.)ffe(.)gege(.)"), capture_groups=TRUE),
    structure(
        cbind(start=c(1, 1, 1, NA_integer_), end=c(1, 3, 2, NA_integer_)),
        capture_groups=list(
            cbind(start=c(1, 1, 1, NA_integer_), end=c(1, 1, 1, NA_integer_)),
            cbind(start=c(NA_integer_, 2, 2, NA_integer_), end=c(NA_integer_, 2, 2, NA_integer_)),
            cbind(start=c(NA_integer_, 3, NA_integer_, NA_integer_), end=c(NA_integer_, 3, NA_integer_, NA_integer_)),
            cbind(start=c(NA_integer_, NA_integer_, NA_integer_, NA_integer_), end=c(NA_integer_, NA_integer_, NA_integer_, NA_integer_))
        )
    )
)

expect_equal(
    stri_locate_last_regex("\U0001f601\U0001f600\U0001f602abc", c("(?<a>.)", "(?<a>.)(.)(?<c>.)", "(.)(.)", "(.)asfsa(.)ffe(.)gege(.)"), capture_groups=TRUE),
    structure(
        cbind(start=c(6, 4, 5, NA_integer_), end=c(6, 6, 6, NA_integer_)),
        capture_groups=list(
            cbind(start=c(6, 4, 5, NA_integer_), end=c(6, 4, 5, NA_integer_)),
            cbind(start=c(NA_integer_, 5, 6, NA_integer_), end=c(NA_integer_, 5, 6, NA_integer_)),
            cbind(start=c(NA_integer_, 6, NA_integer_, NA_integer_), end=c(NA_integer_, 6, NA_integer_, NA_integer_)),
            cbind(start=c(NA_integer_, NA_integer_, NA_integer_, NA_integer_), end=c(NA_integer_, NA_integer_, NA_integer_, NA_integer_))
        )
    )
)



expect_equal(
    stri_locate_first_regex(c("\U0001f601\U0001f600\U0001f602def", "ghi", "jk", NA), "(?<a>.)(..)", capture_groups=TRUE, get_length=TRUE),
    structure(
        cbind(start=c(1, 1, -1, NA_integer_), length=c(3, 3, -1, NA_integer_)),
        capture_groups=list(
            a=cbind(start=c(1, 1, -1, NA_integer_), length=c(1, 1, -1, NA_integer_)),
            cbind(start=c(2, 2, -1, NA_integer_), length=c(2, 2, -1, NA_integer_))
        )
    )
)

expect_equal(
    stri_locate_last_regex(c("\U0001f601\U0001f600\U0001f602def", "ghi", "jk", NA), "(?<a>.)(..)", capture_groups=TRUE, get_length=TRUE),
    structure(
        cbind(start=c(4, 1, -1, NA_integer_), length=c(3, 3, -1, NA_integer_)),
        capture_groups=list(
            a=cbind(start=c(4, 1, -1, NA_integer_), length=c(1, 1, -1, NA_integer_)),
            cbind(start=c(5, 2, -1, NA_integer_), length=c(2, 2, -1, NA_integer_))
        )
    )
)

expect_equal(
    stri_locate_first_regex("\U0001f601\U0001f600\U0001f602abc", c("(?<a>.)", "(?<a>.)(.)(?<c>.)", "(.)(.)", "(.)asfsa(.)ffe(.)gege(.)"), capture_groups=TRUE, get_length=TRUE),
    structure(
        cbind(start=c(1, 1, 1, -1), length=c(1, 3, 2, -1)),
        capture_groups=list(
            cbind(start=c(1, 1, 1, -1), length=c(1, 1, 1, -1)),
            cbind(start=c(NA, 2, 2, -1), length=c(NA, 1, 1, -1)),
            cbind(start=c(NA, 3, NA, -1), length=c(NA, 1, NA, -1)),
            cbind(start=c(NA, NA, NA, -1), length=c(NA, NA, NA, -1))
        )
    )
)

expect_equal(
    stri_locate_last_regex("\U0001f601\U0001f600\U0001f602abc", c("(?<a>.)", "(?<a>.)(.)(?<c>.)", "(.)(.)", "(.)asfsa(.)ffe(.)gege(.)"), capture_groups=TRUE, get_length=TRUE),
    structure(
        cbind(start=c(6, 4, 5, -1), length=c(1, 3, 2, -1)),
        capture_groups=list(
            cbind(start=c(6, 4, 5, -1), length=c(1, 1, 1, -1)),
            cbind(start=c(NA, 5, 6, -1), length=c(NA, 1, 1, -1)),
            cbind(start=c(NA, 6, NA, -1), length=c(NA, 1, NA, -1)),
            cbind(start=c(NA, NA, NA, -1), length=c(NA, NA, NA, -1))
        )
    )
)


expect_equal(
    stri_locate_first_regex(NA, "(?<a>.)", capture_groups=TRUE),
    structure(cbind(start=NA_integer_, end=NA_integer_),
        capture_groups=list(
            a=cbind(start=NA_integer_, end=NA_integer_)
        )
    )
)


expect_equal(
    stri_locate_last_regex(NA, "(?<a>.)", capture_groups=TRUE),
    structure(cbind(start=NA_integer_, end=NA_integer_),
        capture_groups=list(
            a=cbind(start=NA_integer_, end=NA_integer_)
        )
    )
)


expect_equal(
    stri_locate_all_regex(NA, "(?<a>.)", capture_groups=TRUE),
    list(structure(cbind(start=NA_integer_, end=NA_integer_),
        capture_groups=list(
            a=cbind(start=NA_integer_, end=NA_integer_)
        )
    ))
)



expect_equal(
    stri_locate_first_regex(NA, "(?<a>.)", get_length=TRUE, capture_groups=TRUE),
    structure(cbind(start=NA_integer_, length=NA_integer_),
        capture_groups=list(
            a=cbind(start=NA_integer_, length=NA_integer_)
        )
    )
)


expect_equal(
    stri_locate_last_regex(NA, "(?<a>.)", get_length=TRUE, capture_groups=TRUE),
    structure(cbind(start=NA_integer_, length=NA_integer_),
        capture_groups=list(
            a=cbind(start=NA_integer_, length=NA_integer_)
        )
    )
)


expect_equal(
    stri_locate_all_regex(NA, "(?<a>.)", get_length=TRUE, capture_groups=TRUE),
    list(structure(cbind(start=NA_integer_, length=NA_integer_),
        capture_groups=list(
            a=cbind(start=NA_integer_, length=NA_integer_)
        )
    ))
)



################################################################################
### capture groups - conditional

expect_equal(
    stri_locate_all_regex(c("azabaz", "a", "az", "b", NA), "(?<a>a)(?<z>z)?", capture_groups=TRUE, get_length=FALSE),
    list(
        structure(
            cbind(start=c(1L, 3L, 5L), end=c(2L, 3L, 6L)),
            capture_groups=list(
                a=cbind(start=c(1L, 3L, 5L), end=c(1L, 3L, 5L)),
                z=cbind(start=c(2L, NA, 6L), end=c(2L, NA, 6L))
            )
        ),
        structure(
            cbind(start=c(1L), end=c(1L)),
            capture_groups=list(
                a=cbind(start=c(1L), end=c(1L)),
                z=cbind(start=c(NA_integer_), end=c(NA_integer_))
            )
        ),
        structure(
            cbind(start=c(1L), end=c(2L)),
            capture_groups=list(
                a=cbind(start=c(1L), end=c(1L)),
                z=cbind(start=c(2L), end=c(2L))
            )
        ),
        structure(
            cbind(start=c(NA_integer_), end=c(NA_integer_)),
            capture_groups=list(
                a=cbind(start=c(NA_integer_), end=c(NA_integer_)),
                z=cbind(start=c(NA_integer_), end=c(NA_integer_))
            )
        ),
        structure(
            cbind(start=c(NA_integer_), end=c(NA_integer_)),
            capture_groups=list(
                a=cbind(start=c(NA_integer_), end=c(NA_integer_)),
                z=cbind(start=c(NA_integer_), end=c(NA_integer_))
            )
        )
    )
)

expect_equal(
    stri_locate_all_regex(c("azabaz", "a", "az", "b", NA), "(?<a>a)(?<z>z)?", capture_groups=TRUE, get_length=FALSE, omit_no_match=TRUE),
    list(
        structure(
            cbind(start=c(1L, 3L, 5L), end=c(2L, 3L, 6L)),
            capture_groups=list(
                a=cbind(start=c(1L, 3L, 5L), end=c(1L, 3L, 5L)),
                z=cbind(start=c(2L, NA, 6L), end=c(2L, NA, 6L))
            )
        ),
        structure(
            cbind(start=c(1L), end=c(1L)),
            capture_groups=list(
                a=cbind(start=c(1L), end=c(1L)),
                z=cbind(start=c(NA_integer_), end=c(NA_integer_))
            )
        ),
        structure(
            cbind(start=c(1L), end=c(2L)),
            capture_groups=list(
                a=cbind(start=c(1L), end=c(1L)),
                z=cbind(start=c(2L), end=c(2L))
            )
        ),
        structure(
            cbind(start=integer(0), end=integer(0)),
            capture_groups=list(
                a=cbind(start=integer(0), end=integer(0)),
                z=cbind(start=integer(0), end=integer(0))
            )
        ),
        structure(
            cbind(start=c(NA_integer_), end=c(NA_integer_)),
            capture_groups=list(
                a=cbind(start=c(NA_integer_), end=c(NA_integer_)),
                z=cbind(start=c(NA_integer_), end=c(NA_integer_))
            )
        )
    )
)

expect_equal(
    stri_locate_first_regex(c("azabaz", "a", "az", "b", NA), "(?<a>a)(?<z>z)?", capture_groups=TRUE, get_length=FALSE),
    structure(
        cbind(start=c(1L, 1L, 1L, NA, NA), end=c(2L, 1L, 2L, NA, NA)),
        capture_groups=list(
            a=cbind(start=c(1L, 1L, 1L, NA, NA), end=c(1L, 1L, 1L, NA, NA)),
            z=cbind(start=c(2L, NA, 2L, NA, NA), end=c(2L, NA, 2L, NA, NA))
        )
    )
)

expect_equal(
    stri_locate_last_regex(c("azabaz", "a", "az", "b", NA), "(?<a>a)(?<z>z)?", capture_groups=TRUE, get_length=FALSE),
    structure(
        cbind(start=c(5L, 1L, 1L, NA, NA), end=c(6L, 1L, 2L, NA, NA)),
        capture_groups=list(
            a=cbind(start=c(5L, 1L, 1L, NA, NA), end=c(5L, 1L, 1L, NA, NA)),
            z=cbind(start=c(6L, NA, 2L, NA, NA), end=c(6L, NA, 2L, NA, NA))
        )
    )
)


expect_equal(
    stri_locate_all_regex(c("azabaz", "a", "az", "b", NA), "(?<a>a)(?<z>z)?", capture_groups=TRUE, get_length=TRUE),
    list(
        structure(
            cbind(start=c(1L, 3L, 5L), length=c(2L, 1L, 2L)),
            capture_groups=list(
                a=cbind(start=c(1L, 3L, 5L), length=c(1L, 1L, 1L)),
                z=cbind(start=c(2L, -1L, 6L), length=c(1L, -1L, 1L))
            )
        ),
        structure(
            cbind(start=c(1L), length=c(1L)),
            capture_groups=list(
                a=cbind(start=c(1L), length=c(1L)),
                z=cbind(start=c(-1L), length=c(-1L))
            )
        ),
        structure(
            cbind(start=c(1L), length=c(2L)),
            capture_groups=list(
                a=cbind(start=c(1L), length=c(1L)),
                z=cbind(start=c(2L), length=c(1L))
            )
        ),
        structure(
            cbind(start=c(-1L), length=c(-1L)),
            capture_groups=list(
                a=cbind(start=c(-1L), length=c(-1L)),
                z=cbind(start=c(-1L), length=c(-1L))
            )
        ),
        structure(
            cbind(start=c(NA_integer_), length=c(NA_integer_)),
            capture_groups=list(
                a=cbind(start=c(NA_integer_), length=c(NA_integer_)),
                z=cbind(start=c(NA_integer_), length=c(NA_integer_))
            )
        )
    )
)

expect_equal(
    stri_locate_all_regex(c("azabaz", "a", "az", "b", NA), "(?<a>a)(?<z>z)?", capture_groups=TRUE, get_length=TRUE, omit_no_match=TRUE),
    list(
        structure(
            cbind(start=c(1L, 3L, 5L), length=c(2L, 1L, 2L)),
            capture_groups=list(
                a=cbind(start=c(1L, 3L, 5L), length=c(1L, 1L, 1L)),
                z=cbind(start=c(2L, -1L, 6L), length=c(1L, -1L, 1L))
            )
        ),
        structure(
            cbind(start=c(1L), length=c(1L)),
            capture_groups=list(
                a=cbind(start=c(1L), length=c(1L)),
                z=cbind(start=c(-1L), length=c(-1L))
            )
        ),
        structure(
            cbind(start=c(1L), length=c(2L)),
            capture_groups=list(
                a=cbind(start=c(1L), length=c(1L)),
                z=cbind(start=c(2L), length=c(1L))
            )
        ),
        structure(
            cbind(start=integer(0), length=integer(0)),
            capture_groups=list(
                a=cbind(start=integer(0), length=integer(0)),
                z=cbind(start=integer(0), length=integer(0))
            )
        ),
        structure(
            cbind(start=c(NA_integer_), length=c(NA_integer_)),
            capture_groups=list(
                a=cbind(start=c(NA_integer_), length=c(NA_integer_)),
                z=cbind(start=c(NA_integer_), length=c(NA_integer_))
            )
        )
    )
)

expect_equal(
    stri_locate_first_regex(c("azabaz", "a", "az", "b", NA), "(?<a>a)(?<z>z)?", capture_groups=TRUE, get_length=TRUE),
    structure(
        cbind(start=c(1L, 1L, 1L, -1L, NA), length=c(2L, 1L, 2L, -1L, NA)),
        capture_groups=list(
            a=cbind(start=c(1L, 1L, 1L, -1L, NA), length=c(1L, 1L, 1L, -1L, NA)),
            z=cbind(start=c(2L, -1L, 2L, -1L, NA), length=c(1L, -1L, 1L, -1L, NA))
        )
    )
)

expect_equal(
    stri_locate_last_regex(c("azabaz", "a", "az", "b", NA), "(?<a>a)(?<z>z)?", capture_groups=TRUE, get_length=TRUE),
    structure(
        cbind(start=c(5L, 1L, 1L, -1L, NA), length=c(2L, 1L, 2L, -1L, NA)),
        capture_groups=list(
            a=cbind(start=c(5L, 1L, 1L, -1L, NA), length=c(1L, 1L, 1L, -1L, NA)),
            z=cbind(start=c(6L, -1L, 2L, -1L, NA), length=c(1L, -1L, 1L, -1L, NA))
        )
    )
)

