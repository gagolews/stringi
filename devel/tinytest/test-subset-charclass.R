library("tinytest")
library("stringi")


expect_identical(stri_subset_charclass("a", NA), NA_character_)
expect_identical(stri_subset_charclass(NA, "\\p{Z}"), NA_character_)
expect_identical(stri_subset_charclass(NA, NA), NA_character_)
expect_error(stri_subset_charclass("a", "WTF????"))
expect_identical(stri_subset_charclass(c("", "ala"), "\\p{L}"), "ala")
expect_identical(stri_subset_charclass(c("ala", "", "", "111"), c("\\p{L}", "\\p{N}")),
    c("ala", 111))
expect_identical(stri_subset_charclass(c("a", "b", NA, "aaa", ""), "[a]"), c("a",
    NA, "aaa"))

expect_identical(stri_subset_charclass(c(NA, "", "ala", "bkb"), "[a]"), c(NA,
    "ala"))
expect_identical(stri_subset_charclass(c(NA, "", "ala", "bkb"), "[a]", negate = TRUE),
    c(NA, "", "bkb"))
expect_identical(stri_subset_charclass(c(NA, "", "ala", "bkb"), "[a]", omit_na = TRUE),
    c("ala"))
expect_identical(stri_subset_charclass(c(NA, "", "ala", "bkb"), "[a]", omit_na = TRUE,
    negate = TRUE), c("", "bkb"))

expect_identical(stri_subset_charclass(c("a", "ab", "abc", "1234"), "\\p{L}"),
    c("a", "ab", "abc"))
expect_error(stri_subset_charclass("a\u0105bc", c("\\p{L}", "\\p{Ll}", "\\p{Lu}")))
expect_identical(stri_subset_charclass("a\u0105bc", c("\\p{AlPh_a  bEtic}")), "a\u0105bc")
expect_identical(stri_subset_charclass("", "\\p{L}"), character(0))

expect_identical(stri_subset_charclass(NA, NA, omit_na = TRUE), character(0))
expect_error(stri_subset_charclass("", "", omit_na = TRUE))
expect_error(stri_subset_charclass("a", "", omit_na = TRUE))
expect_error(stri_subset_charclass("", "a", omit_na = TRUE))
expect_identical(stri_subset_charclass(c("a", "b", NA, "aaa", ""), c("[a]"),
    omit_na = TRUE), c("a", "aaa"))
expect_identical(stri_subset_charclass(c("a", "a", "a"), c("[a]", "[b]", "[c]"), omit_na = TRUE),
    "a")

x <- c("", NA, "1")
stri_subset_charclass(x, "[2]") <- "e"
expect_identical(x, c("", NA, "1"))

x <- c("2", NA, "2")
stri_subset_charclass(x, "[2]", negate = TRUE) <- "e"
expect_identical(x, c("2", NA, "2"))

x <- c("stringi R", "123", "ID456", "", NA)
suppressWarnings(stri_subset_charclass(x, "[1]") <- c(NA, "8"))
expect_identical(x, c("stringi R", NA, "ID456", "", NA))

x <- c(NA, "stringi R", "123", "", "ID456")
suppressWarnings(stri_subset_charclass(x, "[1]", negate = TRUE) <- c("a", "b", "c", "d"))
expect_identical(x, c(NA, "a", "123", "b", "c"))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_charclass(x, "[1]") <- c(NA)
expect_identical(x, c("stringi R", NA, "ID456", "", NA))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_charclass(x, "[7]") <- c("a", "b")
expect_identical(x, c("stringi R", "123", "ID456", "", NA))

x <- c("stringi R", "123", NA, "ID456", "")
stri_subset_charclass(x, "[7]") <- c("a", "b")
expect_identical(x, c("stringi R", "123", NA, "ID456", ""))

x <- c("stringi R", NA, "173", "ID457", "7")
suppressWarnings(stri_subset_charclass(x, "[7]") <- c("a", "b"))
expect_identical(x, c("stringi R", NA, "a", "b", "a"))

x <- c("stringi R", "173", "ID457", "7")
expect_error(stri_subset_charclass(x, "[7]") <- character(0))
expect_error(stri_subset_charclass(x, character(0)) <- NA)

x <- c("stringi R", "123", "ID456", "")
stri_subset(x, charclass = "[sS]") <- NA
expect_identical(x, c(NA, "123", "ID456", ""))


expect_warning(`stri_subset_charclass<-`(1:3, rep("\\p{N}", 3), value=1:2))
expect_identical(suppressWarnings(`stri_subset_charclass<-`(1:3, rep("\\p{N}", 3), value=1:2)), c("1", "2", "1"))
expect_warning(`stri_subset_charclass<-`(1:3, "\\p{N}", value=1:2))
expect_identical(suppressWarnings(`stri_subset_charclass<-`(1:3, "\\p{N}", value=1:2)), c("1", "2", "1"))
expect_warning(`stri_subset_charclass<-`(1:3, c("\\p{N}", "\\p{L}"), value=11:12))
expect_identical(suppressWarnings(`stri_subset_charclass<-`(1:3, c("\\p{N}", "\\p{L}"), value=11:12)), c("11", "2", "12"))

expect_identical(`stri_subset_charclass<-`(c(NA, "2", "3", "4"), c("[1]", NA, "[3]", "[3]"), value="ZZZ"), c(NA, "2", "ZZZ", "4"))
