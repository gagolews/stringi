library("tinytest")
library("stringi")


expect_identical(stri_subset_coll("a", NA), NA_character_)
expect_identical(stri_subset_coll(NA, "a"), NA_character_)
expect_identical(stri_subset_coll(NA, NA), NA_character_)

expect_identical(stri_subset_coll(c(NA, "", "ala", "bkb"), "ala"), c(NA, "ala"))
expect_identical(stri_subset_coll(c(NA, "", "ala", "bkb"), "ala", negate = TRUE),
    c(NA, "", "bkb"))
expect_identical(stri_subset_coll(c(NA, "", "ala", "bkb"), "ala", omit_na = TRUE),
    c("ala"))
expect_identical(stri_subset_coll(c(NA, "", "ala", "bkb"), "ala", omit_na = TRUE,
    negate = TRUE), c("", "bkb"))

expect_identical(stri_subset_coll(c("", "ala", "AlA"), "ala", opts_collator = stri_opts_collator(strength = 1, locale="en")),
    c("ala", "AlA"))
expect_identical(stri_subset_coll(c("", "ala", "AlA"), "ala", strength = 1, locale="en"),
    c("ala", "AlA"))

expect_identical(stri_subset_coll(character(0), "ipsum 1234"), character(0))
expect_identical(stri_subset_coll(character(0), character(0)), character(0))
expect_identical(stri_subset_coll(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab"),
    c("ab", "cab", "ccccab", "aaaabaaaa"))
expect_identical(stri_subset_coll(c("ala", "", "", "bbb"), c("ala", "bbb")),
    c("ala", "bbb"))
expect_identical(stri_subset_coll(c("a", "b", NA, "aaa", ""), c("a")), c("a",
    NA, "aaa"))

expect_identical(stri_subset_coll(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ",
    "\t\u0105")), "4\t\u0105")
expect_warning(stri_subset_coll(rep("asd", 5), rep("a", 2)))
expect_identical(stri_subset_coll("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), "\u0104\u0105")
expect_equivalent(stri_subset_coll("aaaab", "ab"), "aaaab")
expect_equivalent(stri_subset_coll("bababababaab", "aab"), "bababababaab")

suppressWarnings(expect_identical(stri_subset_coll("", ""), NA_character_))
suppressWarnings(expect_identical(stri_subset_coll("a", ""), NA_character_))
suppressWarnings(expect_identical(stri_subset_coll("", "a"), character(0)))

expect_identical(stri_subset_coll(NA, NA, omit_na = TRUE), character(0))
suppressWarnings(expect_identical(stri_subset_coll("", "", omit_na = TRUE), character(0)))
suppressWarnings(expect_identical(stri_subset_coll("a", "", omit_na = TRUE),
    character(0)))
suppressWarnings(expect_identical(stri_subset_coll("", "a", omit_na = TRUE),
    character(0)))
expect_identical(stri_subset_coll(c("a", "b", NA, "aaa", ""), c("a"), omit_na = TRUE),
    c("a", "aaa"))
expect_error(stri_subset_coll("a", c("a", "b", "c"), omit_na = TRUE))

expect_warning(`stri_subset_coll<-`(1:3, 1:3, value=1:2))
expect_identical(suppressWarnings(`stri_subset_coll<-`(1:3, 1:3, value=1:2)), c("1", "2", "1"))

x <- c("", NA, "1")
stri_subset_coll(x, "2") <- "e"
expect_identical(x, c("", NA, "1"))

x <- c("2", NA, "2")
stri_subset_coll(x, "2", negate = TRUE) <- "e"
expect_identical(x, c("2", NA, "2"))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_coll(x, "1") <- c(NA, "8")
expect_identical(x, c("stringi R", NA, "ID456", "", NA))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_coll(x, "1") <- c(NA)
expect_identical(x, c("stringi R", NA, "ID456", "", NA))

x <- c(NA, "stringi R", "123", "", "ID456")
stri_subset_coll(x, "1", negate = TRUE) <- c("A", "B", "C", "D")
expect_identical(x, c(NA, "A", "123", "B", "C"))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_coll(x, "7") <- c("a", "b")
expect_identical(x, c("stringi R", "123", "ID456", "", NA))

x <- c("stringi R", "123", NA, "ID456", "")
stri_subset_coll(x, "7") <- c("a", "b")
expect_identical(x, c("stringi R", "123", NA, "ID456", ""))

x <- c("stringi R", NA, "173", "ID457", "7")
stri_subset_coll(x, "7") <- c("a", "b")
expect_identical(x, c("stringi R", NA, "a", "b", "a"))

x <- c("stringi R", "173", "ID457", "7")
expect_error(stri_subset_coll(x, "7") <- character(0))
expect_error(stri_subset_coll(x, character(0)) <- NA)

x <- c("stringi R", "123", "ID456", "")
stri_subset(x, coll = "S", strength = 1, locale="en") <- NA
expect_identical(x, c(NA, "123", "ID456", ""))

expect_identical(`stri_subset_coll<-`(c(NA, "2", "3", "4"), c("1", NA, "3", "3"), value="ZZZ"), c(NA, "2", "ZZZ", "4"))
expect_warning(`stri_subset_coll<-`("1", "", value="2"))
