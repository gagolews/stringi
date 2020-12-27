library("tinytest")
library("stringi")
library("stringr")

expect_identical(stri_detect_coll("a", NA), NA)
expect_identical(stri_detect_coll(NA, "a"), NA)
expect_identical(stri_detect_coll(NA, "a", negate = TRUE), NA)
expect_identical(stri_detect_coll(NA, NA), NA)
expect_identical(stri_detect_coll(c("", "ala"), "ala"), c(FALSE, TRUE))
expect_identical(stri_detect(c("", "ala", "ola"), coll = "ala", negate = TRUE),
    c(TRUE, FALSE, TRUE))
expect_identical(stri_detect_coll("kot lorem1", character(0)), logical(0))
expect_identical(stri_detect_coll(character(0), "ipsum 1234"), logical(0))
expect_identical(stri_detect_coll(character(0), character(0)), logical(0))
expect_identical(stri_detect_coll(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab"),
    c(T, T, T, T))
expect_identical(stri_detect_coll(c("ala", "", "", "bbb"), c("ala", "bbb")),
    c(TRUE, FALSE, FALSE, TRUE))

expect_identical(stri_detect_coll(c("Lorem\n123", " ", "kota", "4\tą"), c(" ",
    "\tą")), c(F, F, F, T))
expect_warning(stri_detect_coll(rep("asd", 5), rep("a", 2)))
expect_identical(stri_detect_coll("Ąą", stri_trans_nfkd("Ąą")), TRUE)
expect_equivalent(stri_detect_coll("aaaab", "ab"), TRUE)
expect_equivalent(stri_detect_coll("bababababaab", "aab"), TRUE)

suppressWarnings(expect_identical(stri_detect_coll("", ""), NA))
suppressWarnings(expect_identical(stri_detect_coll("a", ""), NA))
suppressWarnings(expect_identical(stri_detect_coll("", "a"), FALSE))

expect_identical(stri_detect_coll(c("abc", "def", "123", "ghi", "456", "789",
    "jkl"), c("abc", "def", "123", "ghi", "456", "789", "jkl"), max_count = 1),
    c(TRUE, NA, NA, NA, NA, NA, NA))
expect_identical(stri_detect_coll(c("abc", "def", "123", "ghi", "456", "789",
    "jkl"), c("abc", "def", "XXX", "ghi", "456", "789", "jkl"), max_count = 3),
    c(TRUE, TRUE, FALSE, TRUE, NA, NA, NA))
expect_identical(stri_detect_coll(c("", "def", "123", "ghi", "456", "789", "jkl"),
    c("abc", "def", "XXX", "ghi", "456", "789", "jkl"), negate = TRUE, max_count = 2),
    c(TRUE, FALSE, TRUE, NA, NA, NA, NA))
