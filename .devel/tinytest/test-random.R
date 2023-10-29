library("tinytest")
library("stringi")


expect_identical({
    set.seed(123)
    stri_rand_shuffle(c("abcdefghi", NA, "", "a"))
}, c("cheidfbag", NA, "", "a"))
expect_identical(stri_rand_shuffle(character(0)), character(0))
expect_identical(stri_length(stri_rand_shuffle(rep(stri_paste(letters, collapse = ""),
    10))), rep(26L, 10))
expect_identical({
    set.seed(12346)
    stri_rand_shuffle("\u0105\u0104")
}, "\u0104\u0105")

suppressWarnings(expect_identical(stri_rand_strings(0, 10), character(0)))
suppressWarnings(expect_warning(stri_rand_strings(5, 1:6)))
expect_error(stri_rand_strings(10, 1:5, "dupa"))
expect_error(stri_rand_strings(10, 1:5, "[]"))
expect_error(stri_rand_strings(10, 5, "[{fi}]"))
expect_identical(stri_length(stri_rand_strings(10, 1:5)), rep(1:5, 2))
expect_identical(stri_rand_strings(10, 1:5, "[a]"), stri_dup("a", c(1:5, 1:5)))
expect_identical({
    set.seed(123)
    stri_rand_strings(3, 2, "[a-d]")
}, c("bd", "bd", "da"))
expect_identical(stri_rand_strings(10, 5, NA), rep(NA_character_, 10))
expect_identical(stri_rand_strings(10, NA, "[a-z]"), rep(NA_character_, 10))


expect_true(all(sapply(lapply(1:100, stri_rand_lipsum), length) == 1:100))


