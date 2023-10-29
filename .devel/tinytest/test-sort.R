library("tinytest")
library("stringi")


expect_equivalent(stri_order(rep(NA, 5)), 1:5)
expect_equivalent(stri_order(rep(NA, 5), na_last = FALSE), 1:5)
expect_equivalent(stri_order(rep(NA, 5), na_last = NA), integer(0))
expect_equivalent(stri_order(c(NA, "b", NA, "a")), c(4L, 2L, 1L, 3L))
expect_equivalent(stri_order(c(NA, "b", NA, "a"), na_last = FALSE), c(1L, 3L,
    4L, 2L))
expect_equivalent(stri_order(c(NA, "b", NA, "a"), na_last = NA), c(4L, 2L))

expect_equivalent(stri_order(character(0)), integer(0))
expect_equivalent(stri_order(LETTERS), 1:length(LETTERS))
expect_equivalent(stri_order(c("c", "a", "b")), order(c("c", "a", "b")))
expect_equivalent(stri_order(rev(LETTERS)), length(LETTERS):1)
expect_equivalent(stri_order(rev(LETTERS)), rev(stri_order(LETTERS)))
expect_equivalent(stri_order(LETTERS, decreasing = TRUE), length(LETTERS):1)

expect_equivalent(stri_order(c("hladny", "chladny"), F, opts_collator = stri_opts_collator(locale = "pl_PL")),
    2:1)
expect_equivalent(stri_order(c("hladny", "chladny"), F, opts_collator = stri_opts_collator(locale = "sk_SK")),
    1:2)

expect_equivalent(stri_order(c("c", NA, "a", NA, "b", NA)), c(3, 5, 1, 2, 4,
    6))


expect_equivalent(stri_order(factor(c("z", "a", "z"), c("z", "a"), ordered = TRUE)),
    c(2, 1, 3))
expect_equivalent(stri_order(c(1, 100, 2, 101, 11, 10)), c(1, 6, 2, 4, 5, 3))
expect_equivalent(stri_order(c(1, 100, 2, 101, 11, 10), numeric = TRUE), c(1,
    3, 6, 5, 2, 4))



#
#    expect_equivalent(stri_order(character(0), opts_collator=NA), integer(0))
#    expect_equivalent(stri_order(LETTERS, opts_collator=NA), 1:length(LETTERS))
#    expect_equivalent(stri_order(rev(LETTERS), opts_collator=NA), length(LETTERS):1)
#    expect_equivalent(stri_order(c('c', 'a', 'b'), opts_collator=NA), order(c('c', 'a', 'b')))
#    expect_equivalent(stri_order(LETTERS, decreasing=TRUE, opts_collator=NA), length(LETTERS):1)
#
#
#    expect_equivalent(stri_order(c('c', NA, 'a', NA, 'b', NA), opts_collator=NA), c(3, 5, 1, 2, 4, 6))




expect_equivalent(stri_sort(character(0)), character(0))
#expect_equivalent(stri_sort(NA),character(0))
expect_equivalent(stri_sort(c("b", NA, "a", NA)), c("a", "b"))
expect_equivalent(stri_sort(LETTERS[sample(length(LETTERS))]), LETTERS)
expect_equivalent(stri_sort(rev(LETTERS)), LETTERS)
expect_equivalent(stri_sort(rev(letters)), letters)
expect_equivalent(stri_sort(c("abc", "aab", "baa", "ab", "aba")), c("aab", "ab",
    "aba", "abc", "baa"))
expect_equivalent(stri_sort(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107"), opts_collator = list(locale = "pl_PL")),
    c("aab", "a\u0105b", "abc", "ab\u0107", "\u0105bc"))
expect_equivalent(stri_sort(c("abc", "aab", NA, "ab", "aba"), na_last = TRUE),
    c("aab", "ab", "aba", "abc", NA))
expect_equivalent(stri_sort(c("abc", "aab", NA, "ab", "aba"), na_last = NA),
    c("aab", "ab", "aba", "abc"))
expect_equivalent(stri_sort(c("abc", "aab", NA, "ab", "aba"), na_last = FALSE),
    c(NA, "aab", "ab", "aba", "abc"))
expect_equivalent(stri_sort(c(NA, "abc", "aab", NA, "ab", "aba", NA), na_last = TRUE),
    c("aab", "ab", "aba", "abc", NA, NA, NA))
expect_equivalent(stri_sort(c(NA, "abc", "aab", NA, "ab", "aba", NA), na_last = NA),
    c("aab", "ab", "aba", "abc"))
expect_equivalent(stri_sort(c(NA, "abc", "aab", NA, "ab", "aba", NA), na_last = FALSE),
    c(NA, NA, NA, "aab", "ab", "aba", "abc"))

expect_equivalent(stri_sort(factor(c("z", "a", "z"), c("z", "a"), ordered = TRUE)),
    c("a", "z", "z"))
expect_equivalent(stri_sort(sample(LETTERS)), LETTERS)
expect_equivalent(stri_sort(c(1, 100, 2, 101, 11, 10)), c("1", "10", "100", "101",
    "11", "2"))
expect_equivalent(stri_sort(c(1, 100, 2, 101, 11, 10), numeric = TRUE), c("1",
    "2", "10", "11", "100", "101"))


expect_equivalent(stri_unique(character(0)), character(0))
expect_equivalent(stri_unique(NA), NA_character_)
expect_equivalent(stri_unique(c("b", NA, "a", NA)), c("b", NA, "a"))
expect_equivalent(stri_unique(rep(letters, 10)), letters)
expect_equivalent(stri_unique(rep(letters, each = 10)), letters)
expect_equivalent(stri_unique(rev(LETTERS)), rev(LETTERS))
expect_equivalent(stri_unique(c("\u0105", stri_trans_nfd("\u0105"))), "\u0105")
expect_equivalent(stri_unique(c("abc", "ab", "abc", "ab", "aba")), c("abc", "ab",
    "aba"))
expect_equivalent(stri_unique(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107", "a\u0105b"),
    opts_collator = list(locale = "pl_PL")), c("abc", "aab", "a\u0105b", "\u0105bc",
    "ab\u0107"))
expect_equivalent(stri_unique(c("abc", "ABC"), opts_collator = list(strength = 1, locale="en")),
    c("abc"))


expect_equivalent(stri_duplicated(character(0)), logical(0))
expect_equivalent(stri_duplicated(NA), FALSE)
expect_equivalent(stri_duplicated(c("b", NA, "a", NA)), c(rep(FALSE, 3), TRUE))
expect_equivalent(stri_duplicated(rep(letters, 10)), c(rep(FALSE, length(letters)),
    rep(TRUE, length(letters) * 9)))
expect_equivalent(stri_duplicated(rep(letters, each = 10)), rep(c(F, rep(T, 9)),
    length(letters)))
expect_equivalent(stri_duplicated(rev(LETTERS)), rep(FALSE, length(letters)))
expect_equivalent(stri_duplicated(c("\u0105", stri_trans_nfd("\u0105"))), c(F, T))
expect_equivalent(stri_duplicated(c("abc", "ab", "abc", "ab", "aba")), c(F, F,
    T, T, F))
expect_equivalent(stri_duplicated(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107", "a\u0105b"),
    opts_collator = list(locale = "pl_PL")), c(F, F, F, F, F, T))

expect_equivalent(stri_duplicated(character(0), TRUE), logical(0))
expect_equivalent(stri_duplicated(NA, TRUE), FALSE)
expect_equivalent(stri_duplicated(c("b", NA, "a", NA), TRUE), c(FALSE, TRUE,
    rep(FALSE, 2)))
expect_equivalent(stri_duplicated(rep(letters, 10), TRUE), c(rep(TRUE, length(letters) *
    9), rep(FALSE, length(letters))))
expect_equivalent(stri_duplicated(rep(letters, each = 10), TRUE), rep(c(rep(T,
    9), F), length(letters)))
expect_equivalent(stri_duplicated(rev(LETTERS), TRUE), rep(FALSE, length(letters)))
expect_equivalent(stri_duplicated(c("\u0105", stri_trans_nfd("\u0105")), TRUE), c(T,
    F))
expect_equivalent(stri_duplicated(c("abc", "ab", "abc", "ab", "aba"), TRUE),
    c(T, T, F, F, F))
expect_equivalent(stri_duplicated(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107", "a\u0105b"),
    TRUE, opts_collator = list(locale = "pl_PL")), c(F, F, T, F, F, F))
expect_equivalent(stri_duplicated(c("abc", "ABC"), FALSE, opts_collator = list(strength = 1, locale="en")),
    c(F, T))

expect_equivalent(stri_duplicated_any(character(0)), 0)
expect_equivalent(stri_duplicated_any(NA), 0)
expect_equivalent(stri_duplicated_any(c("b", NA, "a", NA)), 4)
expect_equivalent(stri_duplicated_any(rep(letters, 10)), length(letters) + 1)
expect_equivalent(stri_duplicated_any(rep(letters, each = 10)), 2)
expect_equivalent(stri_duplicated_any(rev(LETTERS)), 0)
expect_equivalent(stri_duplicated_any(c("\u0105", stri_trans_nfd("\u0105"))), 2)
expect_equivalent(stri_duplicated_any(c("abc", "ab", "abc", "ab", "aba")), 3)
expect_equivalent(stri_duplicated_any(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107",
    "a\u0105b"), opts_collator = list(locale = "pl_PL")), 6)

expect_equivalent(stri_duplicated_any(character(0), TRUE), 0)
expect_equivalent(stri_duplicated_any(NA, TRUE), 0)
expect_equivalent(stri_duplicated_any(c("b", NA, "a", NA), TRUE), 2)
expect_equivalent(stri_duplicated_any(rep(letters, 10), TRUE), length(letters) *
    9)
expect_equivalent(stri_duplicated_any(rep(letters, each = 10), TRUE), length(letters) *
    10 - 1)
expect_equivalent(stri_duplicated_any(rev(LETTERS), TRUE), 0)
expect_equivalent(stri_duplicated_any(c("\u0105", stri_trans_nfd("\u0105")), TRUE), 1)
expect_equivalent(stri_duplicated_any(c("abc", "ab", "abc", "ab", "aba"), TRUE),
    2)
expect_equivalent(stri_duplicated_any(c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107",
    "a\u0105b"), TRUE, opts_collator = list(locale = "pl_PL")), 3)

if (getRversion() > "3.3.0") {
    radix_order <- function(x) order(x, method = "radix")

    expect_equivalent(stri_sort_key(character()), character())
    expect_equivalent(stri_sort_key(NA), NA_character_)

    # C locale would order capital letters before lower case
    x <- c("a", "A")
    expect_equivalent(radix_order(stri_sort_key(x, locale = "en_US")), stri_order(x,
        locale = "en_US"))

    x <- c("abc", "aab", "a\u0105b", "\u0105bc", "ab\u0107")
    expect_equivalent(radix_order(stri_sort_key(x, locale = "pl_PL")), stri_order(x,
        locale = "pl_PL"))

    x <- c("1", "100", "2")
    expect_equivalent(radix_order(stri_sort_key(x, numeric = TRUE)), stri_order(x,
        numeric = TRUE))
}


x <- LETTERS
expect_equivalent(stri_rank(x), rank(x, ties.method="min"))

x <- rev(LETTERS)
expect_equivalent(stri_rank(x), rank(x, ties.method="min"))

x <- c("b", "a", "a", "b", "a", "b", "a", "b", "a")
expect_equivalent(stri_rank(x), rank(x, ties.method="min"))

x <- c("a", "a", "b", NA, "a", "b", "a", "b", "a", NA)
r <- rank(x, ties.method="min")
r[is.na(x)] <- NA
expect_equivalent(stri_rank(x), r)

expect_equivalent(stri_rank(character(0)), integer(0))

expect_equivalent(stri_rank(NA), NA_integer_)


expect_equivalent(stri_rank(c(NA, 1, 2)), c(NA, 1, 2))
expect_equivalent(stri_rank(c(2, NA, 1)), c(2, NA, 1))
expect_equivalent(stri_rank(c(NA, 1)), c(NA, 1))
expect_equivalent(stri_rank(c(1, NA)), c(1, NA))

expect_equivalent(stri_rank(c(rep(NA, 100), 1)), c(rep(NA, 100), 1))

expect_equivalent(stri_rank(c(rep(NA, 100))), c(rep(NA_integer_, 100)))

expect_equivalent(stri_rank(c('hladny', 'chladny'), locale='pl_PL'), c(2, 1))

expect_equivalent(stri_rank(c('hladny', 'chladny'), locale='sk_SK'), c(1, 2))


