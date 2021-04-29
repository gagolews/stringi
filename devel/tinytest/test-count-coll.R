library("tinytest")
library("stringi")


expect_identical(stri_count_coll(character(0), " "), integer(0))
expect_identical(stri_count_coll(NA, "a"), NA_integer_)
expect_identical(stri_count_coll("NA", NA), NA_integer_)
expect_identical(stri_count_coll("   ", " "), 3L)
expect_identical(stri_count_coll("###", c("#", "##", "###")), c(3L, 1L, 1L))
expect_identical(stri_count_coll("a a", "a"), 2L)
expect_identical(stri_count_coll("aba", "abcdef"), 0L)
suppressWarnings(expect_identical(stri_count_coll("", ""), NA_integer_))
suppressWarnings(expect_identical(stri_count_coll("a", ""), NA_integer_))
expect_identical(stri_count_coll("", "a"), 0L)

expect_identical(stri_count_coll("aaaaa", "aa"), 2L)
expect_identical(stri_count_coll("aaAAa-a", "aa"), 1L)
expect_identical(stri_count_coll("aaAAa-a", "aa", opts_collator = list(strength = 1, locale="en")),
    2L)
expect_identical(stri_count_coll("aaAAa-a", "aa", opts_collator = stri_opts_collator(strength = 1,
    alternate_shifted = TRUE, locale="en")), 3L)

expect_equivalent(stri_count_coll("aaaab", "ab"), 1L)
expect_equivalent(stri_count_coll("bababababaab", "aab"), 1L)


# stri_opts_collator tests:
expect_equivalent(stri_count_coll("bababababaab", "aab", opts_collator = stri_opts_collator(locale = "UNKNOWN")),
    1L)
expect_equivalent(stri_count_coll("bababababaab", "aab", opts_collator = stri_opts_collator(strength = -100)),
    1L)
expect_error(stri_count_coll("bababababaab", "aab", opts_collator = stri_opts_collator(strength = 100)))
