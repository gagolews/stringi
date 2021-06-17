library("tinytest")
library("stringi")


expect_identical(stri_subset_fixed("a", NA), NA_character_)
expect_identical(stri_subset_fixed(NA, "a"), NA_character_)
expect_identical(stri_subset_fixed(NA, NA), NA_character_)

expect_identical(stri_subset_fixed(c(NA, "", "ala", "bkb"), "ala"), c(NA, "ala"))
expect_identical(stri_subset_fixed(c(NA, "", "ala", "bkb"), "ala", negate = TRUE),
    c(NA, "", "bkb"))
expect_identical(stri_subset_fixed(c(NA, "", "ala", "bkb"), "ala", omit_na = TRUE),
    c("ala"))
expect_identical(stri_subset_fixed(c(NA, "", "ala", "bkb"), "ala", omit_na = TRUE,
    negate = TRUE), c("", "bkb"))

expect_identical(stri_subset_fixed(c("ala", "", "", "bbb"), c("ala", "bbb")),
    c("ala", "bbb"))
expect_identical(stri_subset_fixed("kot lorem1", character(0)), character(0))
expect_identical(stri_subset_fixed(character(0), "ipsum 1234"), character(0))
expect_identical(stri_subset_fixed(character(0), character(0)), character(0))
expect_identical(stri_subset_fixed(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab"),
    c("ab", "cab", "ccccab", "aaaabaaaa"))
expect_identical(stri_subset_fixed(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ",
    "\t\u0105")), "4\t\u0105")
expect_warning(stri_subset_fixed(rep("asd", 5), rep("a", 2)))
expect_identical(stri_subset_fixed("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), character(0))
expect_equivalent(stri_subset_fixed("aaaab", "ab"), "aaaab")
expect_equivalent(stri_subset_fixed("bababababaab", "aab"), "bababababaab")
expect_equivalent(stri_subset_fixed(c("a", "b", "aa", "bb"), c("a", "b")), c("a",
    "b", "aa", "bb"))
expect_identical(stri_subset_fixed(c("a", "b", NA, "aaa", ""), c("a")), c("a",
    NA, "aaa"))

expect_warning(expect_identical(stri_subset_fixed("", ""), NA_character_))
expect_warning(expect_identical(stri_subset_fixed("a", ""), NA_character_))
expect_identical(stri_subset_fixed("", "a"), character(0))

expect_identical(stri_subset_fixed(NA, NA, omit_na = TRUE), character(0))
suppressWarnings(expect_identical(stri_subset_fixed("", "", omit_na = TRUE),
    character(0)))
suppressWarnings(expect_identical(stri_subset_fixed("a", "", omit_na = TRUE),
    character(0)))
suppressWarnings(expect_identical(stri_subset_fixed("", "a", omit_na = TRUE),
    character(0)))
expect_identical(stri_subset_fixed(c("a", "b", NA, "aaa", ""), c("a"), omit_na = TRUE),
    c("a", "aaa"))
expect_identical(stri_subset_fixed(c("a", "x", "y"), c("a", "b", "c"), omit_na = TRUE), "a")


expect_warning(`stri_subset_fixed<-`(1:3, 1:3, value=1:2))
expect_identical(suppressWarnings(`stri_subset_fixed<-`(1:3, 1:3, value=1:2)), c("1", "2", "1"))

x <- c("", NA, "1")
stri_subset_fixed(x, "2") <- "e"
expect_identical(x, c("", NA, "1"))

x <- c("2", NA, "2")
stri_subset_fixed(x, "2", negate = TRUE) <- "e"
expect_identical(x, c("2", NA, "2"))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_fixed(x, "1") <- c(NA, "8")
expect_identical(x, c("stringi R", NA, "ID456", "", NA))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_fixed(x, "1") <- c(NA)
expect_identical(x, c("stringi R", NA, "ID456", "", NA))

x <- c(NA, "stringi R", "123", "", "ID456", NA)
stri_subset_fixed(x, "1", negate = TRUE) <- c("A", "B", "C", "D")
expect_identical(x, c(NA, "A", "123", "B", "C", NA))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_fixed(x, "7") <- c("a", "b")
expect_identical(x, c("stringi R", "123", "ID456", "", NA))

x <- c("stringi R", "123", NA, "ID456", "")
stri_subset_fixed(x, "7") <- c("a", "b")
expect_identical(x, c("stringi R", "123", NA, "ID456", ""))

x <- c("stringi R", NA, "173", "ID457", "7")
stri_subset_fixed(x, "7") <- c("a", "b")
expect_identical(x, c("stringi R", NA, "a", "b", "a"))

x <- c("stringi R", "173", "ID457", "7")
expect_error(stri_subset_fixed(x, "7") <- character(0))
expect_error(stri_subset_fixed(x, character(0)) <- NA)

x <- c("stringi R", "123", "ID456", "")
stri_subset(x, fixed = "S", case_insensitive = TRUE) <- NA
expect_identical(x, c(NA, "123", "ID456", ""))

expect_identical(`stri_subset_fixed<-`(c(NA, "2", "3", "4"), c("1", NA, "3", "3"), value="ZZZ"), c(NA, "2", "ZZZ", "4"))
expect_warning(`stri_subset_fixed<-`("1", "", value="1"))
