require("testthat")
context("test-subset-regex.R")

test_that("stri_subset_regex", {
   expect_identical(stri_subset_regex(NA, NA), NA_character_)
   expect_identical(stri_subset_regex(character(0), character(0)), character(0))

   suppressWarnings(expect_identical(stri_subset_regex("",""), NA_character_))
   suppressWarnings(expect_identical(stri_subset_regex("a",""), NA_character_))
   suppressWarnings(expect_identical(stri_subset_regex("","a"), character(0)))
   expect_identical(stri_subset_regex(c("","ala"),"ala"), "ala")
   expect_identical(stri_subset_regex(c("","ala","AlA"),"ala", opts=stri_opts_regex(case_insensitive=TRUE)), c("ala", "AlA"))
   expect_identical(stri_subset_regex(c("","ala", "ala", "bbb"),c("ala", "bbb")), c("ala", "bbb"))
   expect_identical(stri_subset_regex(c("ala","", "", "bbb"),c("ala", "bbb")), c("ala", "bbb"))
   expect_identical(stri_subset_regex(c("a","b", NA, "aaa", ""),c("a")), c("a", NA, "aaa"))

   expect_identical(stri_subset_regex('a', c('a', 'b', 'c')), "a")
   expect_identical(stri_subset_regex(c('a', 'b', 'c'), 'a'), "a")
   suppressWarnings(expect_identical(stri_subset_regex(LETTERS[1:2], LETTERS[1:3]), LETTERS[1:2]))
   suppressWarnings(expect_identical(stri_subset_regex(LETTERS[1:3], LETTERS[1:5]), LETTERS[1:3]))
   suppressWarnings(expect_identical(stri_subset_regex(LETTERS[1:2], LETTERS[1:5]), LETTERS[1:2]))
   suppressWarnings(expect_identical(stri_subset_regex(LETTERS[1:4], LETTERS[1:5]), LETTERS[1:4]))

   s <- c("Lorem", "123", " ", " ", "kota", "4\t\u0105")
   p <- c("[[:alpha:]]+", "[[:blank:]]+")
   expect_identical(stri_subset_regex(s, p, omit_na = TRUE), s[c(T, F, F, T, T, T)])
   expect_identical(stri_subset_regex(s, p, omit_na = FALSE), s[c(T, F, F, T, T, T)])
   expect_identical(stri_subset_regex("Lo123\trem", c("[[:alpha:]]", "[4-9]+")), "Lo123\trem")

   expect_warning(stri_subset_regex(rep("asd", 5), rep("[A-z]", 2)))
   expect_error(stri_subset_regex("Ala", "{}"))

   expect_identical(stri_subset_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaa"), "aaaaaaaaaaaaaaaa")
   expect_identical(stri_subset_regex("aaaaaaaaaaaaaaa",  "aaaaaaaaaaaaaaa"), "aaaaaaaaaaaaaaa")
   expect_identical(stri_subset_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaa"), "aaaaaaaaaaaaaaaa")

   expect_equivalent(stri_subset_regex("\u0105\u0105\u0105\u0105\u0105\u0105\u0105b","\u0105+b$"),"\u0105\u0105\u0105\u0105\u0105\u0105\u0105b")

   expect_equivalent(stri_subset_regex("aaaab", "ab"), "aaaab")
   expect_equivalent(stri_subset_regex("bababababaab", "aab"), "bababababaab")

   expect_equivalent(stri_subset_regex("caabaab", "(a+b)+"), "caabaab")
   expect_equivalent(stri_subset_regex("caacbaab", "(a+b)+"), "caacbaab")
   expect_equivalent(stri_subset_regex("caacbacab", "(a+b)+"), "caacbacab")
   expect_equivalent(stri_subset_regex("caacbacacb", "(a+b)+"), character(0))

   expect_equivalent(stri_subset_regex("abc", c("a", "b", "d")), c("abc", "abc")) # this is weird

   expect_identical(stri_subset_regex(NA, NA, omit_na=TRUE), character(0))
   suppressWarnings(expect_identical(stri_subset_regex("","", omit_na=TRUE), character(0)))
   suppressWarnings(expect_identical(stri_subset_regex("a","", omit_na=TRUE), character(0)))
   suppressWarnings(expect_identical(stri_subset_regex("","a", omit_na=TRUE), character(0)))
   expect_identical(stri_subset_regex(c("a","b", NA, "aaa", ""),c("a"), omit_na=TRUE), c("a", "aaa"))
   expect_identical(stri_subset_regex('a', c('a', 'b', 'c'), omit_na=TRUE), "a")
})
