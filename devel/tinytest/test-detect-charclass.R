library("tinytest")
library("stringi")
library("stringr")


expect_identical(stri_detect_charclass("a", NA), NA)
expect_identical(stri_detect_charclass("a", NA, negate = TRUE), NA)
expect_identical(stri_detect_charclass(NA, "\\p{Z}"), NA)
expect_identical(stri_detect_charclass(NA, NA), NA)
expect_error(stri_detect_charclass("a", "WTF????"))
expect_identical(stri_detect_charclass(c("", "ala"), "\\p{L}"), c(FALSE, TRUE))
expect_identical(stri_detect_charclass(c("", "ala", "123"), negate = TRUE, "\\p{L}"),
    c(TRUE, FALSE, TRUE))
expect_identical(stri_detect(c("", "ala", "123"), negate = TRUE, charclass = "\\p{L}"),
    c(TRUE, FALSE, TRUE))
expect_identical(stri_detect_charclass(c("ala", "", "", "111"), c("\\p{L}", "\\p{N}")),
    c(TRUE, FALSE, FALSE, TRUE))

expect_identical(stri_detect_charclass(c("a", "ab", "abc", "1234"), "\\p{L}"),
    c(T, T, T, F))
expect_identical(stri_detect_charclass("aąbc", c("\\p{L}", "\\p{Ll}", "\\p{Lu}")),
    c(T, T, F))
expect_identical(stri_detect_charclass("aąbc", c("\\p{l}", "\\p{ll}", "\\p{lu}")),
    c(T, T, F))
expect_identical(stri_detect_charclass("aąbc", c("\\P{l}", "\\P{ll}", "\\P{lu}")),
    c(F, F, T))
expect_identical(stri_detect_charclass("aąbc", c("\\p{AlPh_a  bEtic}")), c(T))
expect_identical(stri_detect_charclass("", "\\p{L}"), FALSE)

expect_identical(stri_detect_charclass(c("abc", "def", "123", "ghi", "456", "789",
    "jkl"), "[0-9]", max_count = 1), c(FALSE, FALSE, TRUE, NA, NA, NA, NA))
expect_identical(stri_detect_charclass(c("abc", "def", "123", "ghi", "456", "789",
    "jkl"), "[0-9]", max_count = 2), c(FALSE, FALSE, TRUE, FALSE, TRUE, NA, NA))
expect_identical(stri_detect_charclass(c("abc", "def", "123", "ghi", "456", "789",
    "jkl"), "[0-9]", negate = TRUE, max_count = 3), c(TRUE, TRUE, FALSE, TRUE,
    NA, NA, NA))
expect_identical(stri_detect_charclass(c("abc", "def", "123", "ghi", "456", "789",
    "jkl"), c("[a]", "[d]", "[1]", "[g]", "[4]", "[7]", "[j]"), max_count = 1),
    c(TRUE, NA, NA, NA, NA, NA, NA))
expect_identical(stri_detect_charclass(c("abc", "def", "123", "ghi", "456", "789",
    "jkl"), c("[a]", "[d]", "[x]", "[g]", "[4]", "[7]", "[j]"), max_count = 3),
    c(TRUE, TRUE, FALSE, TRUE, NA, NA, NA))
expect_identical(stri_detect_charclass(c("", "def", "123", "ghi", "456", "789",
    "jkl"), c("[a]", "[d]", "[x]", "[g]", "[4]", "[7]", "[j]"), negate = TRUE,
    max_count = 2), c(TRUE, FALSE, TRUE, NA, NA, NA, NA))
