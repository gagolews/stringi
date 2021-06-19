library("tinytest")
library("stringi")


expect_identical(stri_subset_regex(NA, NA), NA_character_)
expect_identical(stri_subset_regex(character(0), character(0)), character(0))

suppressWarnings(expect_identical(stri_subset_regex("", ""), NA_character_))
suppressWarnings(expect_identical(stri_subset_regex("a", ""), NA_character_))
suppressWarnings(expect_identical(stri_subset_regex("", "a"), character(0)))

expect_identical(stri_subset_regex(c(NA, "", "ala", "bkb"), "ala"), c(NA, "ala"))
expect_identical(stri_subset_regex(c(NA, "", "ala", "bkb"), "ala", negate = TRUE),
    c(NA, "", "bkb"))
expect_identical(stri_subset_regex(c(NA, "", "ala", "bkb"), "ala", omit_na = TRUE),
    c("ala"))
expect_identical(stri_subset_regex(c(NA, "", "ala", "bkb"), "ala", omit_na = TRUE,
    negate = TRUE), c("", "bkb"))

expect_identical(stri_subset_regex(c("", "ala", "AlA"), "ala", opts_regex = stri_opts_regex(case_insensitive = TRUE)),
    c("ala", "AlA"))
expect_identical(stri_subset_regex(c("", "ala", "AlA"), "ala", case_insensitive = TRUE),
    c("ala", "AlA"))
expect_identical(stri_subset_regex(c("", "ala", "ala", "bbb"), c("ala", "bbb")),
    c("ala", "bbb"))
expect_identical(stri_subset_regex(c("ala", "", "", "bbb"), c("ala", "bbb")),
    c("ala", "bbb"))
expect_identical(stri_subset_regex(c("a", "b", NA, "aaa", ""), c("a")), c("a",
    NA, "aaa"))

expect_identical(stri_subset_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "\u0106*"), c("\u0105\u0106\u0107", "\u0105\u0107"))  # match of zero length
expect_identical(stri_subset_regex(c("\u0105\u0106\u0107", "\u0105\u0107"), "(?<=\u0106)"), "\u0105\u0106\u0107")  # match of zero length:
expect_identical(stri_subset_regex(c("", " ", "  "), "^.*$"), c("", " ", "  "))
expect_identical(stri_subset_regex(c("", " ", "  "), "^.+$"), c(" ", "  "))
expect_error(stri_subset_regex("a", c("a", "b", "c")))
expect_identical(stri_subset_regex(c("a", "b", "c"), "a"), "a")
expect_warning(stri_subset_regex(LETTERS[1:3], LETTERS[1:2]))
suppressWarnings(expect_identical(stri_subset_regex(LETTERS[1:3], LETTERS[1:2]),
    LETTERS[1:2]))
suppressWarnings(expect_identical(stri_subset_regex(LETTERS[1:5], LETTERS[1:3]),
    LETTERS[1:3]))
suppressWarnings(expect_identical(stri_subset_regex(LETTERS[1:7], LETTERS[1:2]),
    LETTERS[1:2]))
suppressWarnings(expect_identical(stri_subset_regex(LETTERS[1:8], LETTERS[1:4]),
    LETTERS[1:4]))

s <- c("Lorem", "123", " ", " ", "kota", "4\t\u0105")
p <- c("[[:alpha:]]+", "[[:blank:]]+")
expect_identical(stri_subset_regex(s, p, omit_na = TRUE), s[c(T, F, F, T, T,
    T)])
expect_identical(stri_subset_regex(s, p, omit_na = FALSE), s[c(T, F, F, T, T,
    T)])
expect_identical(stri_subset_regex(rep("Lo123\trem", 2), c("[[:alpha:]]", "[4-9]+")),
    "Lo123\trem")

expect_warning(stri_subset_regex(rep("asd", 5), rep("[A-z]", 2)))
expect_error(stri_subset_regex("Ala", "{}"))

expect_identical(stri_subset_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaa"), "aaaaaaaaaaaaaaaa")
expect_identical(stri_subset_regex("aaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaa"), "aaaaaaaaaaaaaaa")
expect_identical(stri_subset_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaa"), "aaaaaaaaaaaaaaaa")

expect_equivalent(stri_subset_regex("\u0105\u0105\u0105\u0105\u0105\u0105\u0105b", "\u0105+b$"), "\u0105\u0105\u0105\u0105\u0105\u0105\u0105b")

expect_equivalent(stri_subset_regex("aaaab", "ab"), "aaaab")
expect_equivalent(stri_subset_regex("bababababaab", "aab"), "bababababaab")

expect_equivalent(stri_subset_regex("caabaab", "(a+b)+"), "caabaab")
expect_equivalent(stri_subset_regex("caacbaab", "(a+b)+"), "caacbaab")
expect_equivalent(stri_subset_regex("caacbacab", "(a+b)+"), "caacbacab")
expect_equivalent(stri_subset_regex("caacbacacb", "(a+b)+"), character(0))

expect_warning(`stri_subset_regex<-`(1:3, 1:3, value=1:2))
expect_identical(suppressWarnings(`stri_subset_regex<-`(1:3, 1:3, value=1:2)), c("1", "2", "1"))
expect_warning(`stri_subset_regex<-`(1:3, "\\p{N}", value=1:2))
expect_identical(suppressWarnings(`stri_subset_regex<-`(1:3, "\\p{N}", value=1:2)), c("1", "2", "1"))
expect_warning(`stri_subset_regex<-`(1:3, c("\\p{N}", "\\p{L}"), value=11:12))
expect_identical(suppressWarnings(`stri_subset_regex<-`(1:3, c("\\p{N}", "\\p{L}"), value=11:12)), c("11", "2", "12"))

expect_identical(stri_subset_regex(NA, NA, omit_na = TRUE), character(0))
suppressWarnings(expect_identical(stri_subset_regex("", "", omit_na = TRUE),
    character(0)))
suppressWarnings(expect_identical(stri_subset_regex("a", "", omit_na = TRUE),
    character(0)))
suppressWarnings(expect_identical(stri_subset_regex("", "a", omit_na = TRUE),
    character(0)))
expect_identical(stri_subset_regex(c("a", "b", NA, "aaa", ""), c("a"), omit_na = TRUE),
    c("a", "aaa"))
expect_identical(stri_subset_regex(rep("a", 3), c("a", "b", "c"), omit_na = TRUE), "a")


x <- c("", NA, "1")
stri_subset_regex(x, "2") <- "e"
expect_identical(x, c("", NA, "1"))

x <- c("2", NA, "2")
stri_subset_regex(x, "2", negate = TRUE) <- "e"
expect_identical(x, c("2", NA, "2"))

x <- c("stringi R", "123", "ID456", "", NA)
suppressWarnings(stri_subset_regex(x, "1") <- c(NA, "8"))
expect_identical(x, c("stringi R", NA, "ID456", "", NA))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_regex(x, "1") <- c(NA)
expect_identical(x, c("stringi R", NA, "ID456", "", NA))

x <- c(NA, "stringi R", "123", "", "ID456")
suppressWarnings(stri_subset_regex(x, "1", negate = TRUE) <- c("A", "B", "C", "D"))
expect_identical(x, c(NA, "A", "123", "B", "C"))

x <- c("stringi R", "123", "ID456", "", NA)
stri_subset_regex(x, "7") <- c("a", "b")
expect_identical(x, c("stringi R", "123", "ID456", "", NA))

x <- c("stringi R", "123", NA, "ID456", "")
stri_subset_regex(x, "7") <- c("a", "b")
expect_identical(x, c("stringi R", "123", NA, "ID456", ""))

x <- c("stringi R", NA, "173", "ID457", "7")
suppressWarnings(stri_subset_regex(x, "7") <- c("a", "b"))
expect_identical(x, c("stringi R", NA, "a", "b", "a"))

x <- c("stringi R", "173", "ID457", "7")
expect_error(stri_subset_regex(x, "7") <- character(0))
expect_error(stri_subset_regex(x, character(0)) <- NA)

x <- c("stringi R", "123", "ID456", "")
stri_subset(x, regex = "S", case_insensitive = TRUE) <- NA
expect_identical(x, c(NA, "123", "ID456", ""))

x <- c("stringi R", "123", "ID456", "")
stri_subset_regex(x, "[^0-9]+|^$") <- NA
expect_identical(x, c(NA, "123", NA, NA))

expect_identical(`stri_subset_regex<-`(c(NA, "2", "3", "4"), c("1", NA, "3", "3"), value="ZZZ"), c(NA, "2", "ZZZ", "4"))
expect_warning(`stri_subset_regex<-`("1", "", value="1"))
