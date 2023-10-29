library("tinytest")
library("stringi")


expect_error(stri_count("aaa", "a"))
expect_error(stri_count("aaa", regex = "a", fixed = "a"))
expect_identical(stri_count("aaa", regex = "a"), 3L)
expect_identical(stri_count("aaa", fixed = "a"), 3L)
expect_identical(stri_count("aaa", coll = "a"), 3L)
expect_identical(stri_count("aaa", charclass = "[a]"), 3L)



expect_identical(stri_count_words(c("ala ma kota", "ala", NA, "")), c(3L, 1L,
    NA_integer_, 0L))

expect_identical(stri_count_boundaries("Check this out. This is great.", opts_brkiter = stri_opts_brkiter(type = "sentence")),
    2L)
expect_identical(stri_count_boundaries("Check this out. This is great.", opts_brkiter = stri_opts_brkiter(type = "line")),
    6L)
expect_identical(stri_count_boundaries("Check this out. This is great.", opts_brkiter = stri_opts_brkiter(type = "word")),
    13L)
expect_identical(stri_count_boundaries("Check this out. This is great.", opts_brkiter = stri_opts_brkiter(type = "character")),
    30L)
expect_error(stri_count_boundaries("Check this out. This is great.", opts_brkiter = stri_opts_brkiter(type = "WTF???")))
expect_error(stri_count_boundaries("Check this out. This is great.", opts_brkiter = stri_opts_brkiter(type = NA)))
