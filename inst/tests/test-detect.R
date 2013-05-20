require("testthat")

test_that("stri_detect_fixed [byte]", {
   collator_opts <- NA
   expect_identical(stri_detect_fixed("a", NA, collator_opts=collator_opts), NA)
   expect_identical(stri_detect_fixed(NA, "a", collator_opts=collator_opts), NA)
   expect_identical(stri_detect_fixed(NA, NA, collator_opts=collator_opts), NA)
   expect_identical(stri_detect_fixed("kot lorem1", character(0), collator_opts=collator_opts), logical(0))
   expect_identical(stri_detect_fixed(character(0), "ipsum 1234", collator_opts=collator_opts), logical(0))
   expect_identical(stri_detect_fixed(character(0), character(0), collator_opts=collator_opts), logical(0))
   expect_identical(stri_detect_fixed(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab", collator_opts=collator_opts), c(T, T, T, T))
   expect_identical(stri_detect_fixed(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ", "\t\u0105"), collator_opts=collator_opts), c(F, F, F, T))
   expect_warning(stri_detect_fixed(rep("asd", 5), rep("a", 2), collator_opts=collator_opts))
   expect_identical(stri_detect_fixed("\u0104\u0105", stri_enc_nfkd("\u0104\u0105"), collator_opts=collator_opts), FALSE)
})



test_that("stri_detect_fixed [collator]", {
   collator_opts <- list()
   expect_identical(stri_detect_fixed("a", NA, collator_opts=collator_opts), NA)
   expect_identical(stri_detect_fixed(NA, "a", collator_opts=collator_opts), NA)
   expect_identical(stri_detect_fixed(NA, NA, collator_opts=collator_opts), NA)
   expect_identical(stri_detect_fixed("kot lorem1", character(0), collator_opts=collator_opts), logical(0))
   expect_identical(stri_detect_fixed(character(0), "ipsum 1234", collator_opts=collator_opts), logical(0))
   expect_identical(stri_detect_fixed(character(0), character(0), collator_opts=collator_opts), logical(0))
   expect_identical(stri_detect_fixed(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab", collator_opts=collator_opts), c(T, T, T, T))
   expect_identical(stri_detect_fixed(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ", "\t\u0105"), collator_opts=collator_opts), c(F, F, F, T))
   expect_warning(stri_detect_fixed(rep("asd", 5), rep("a", 2), collator_opts=collator_opts))
   expect_identical(stri_detect_fixed("\u0104\u0105", stri_enc_nfkd("\u0104\u0105"), collator_opts=collator_opts), TRUE)
})


test_that("stri_detect_regex", {
   expect_identical(stri_detect_regex(NA, NA), NA)
   expect_identical(stri_detect_regex(character(0), character(0)), logical(0))
   
   expect_identical(stri_detect_regex('a', c('a', 'b', 'c')), c(T,F,F))
   expect_identical(stri_detect_regex(c('a', 'b', 'c'), 'a'), c(T,F,F))
   suppressWarnings(expect_identical(stri_detect_regex(LETTERS[1:2], LETTERS[1:3]), c(T,T,F)))
   suppressWarnings(expect_identical(stri_detect_regex(LETTERS[1:3], LETTERS[1:5]), c(T,T,T,F,F)))
   suppressWarnings(expect_identical(stri_detect_regex(LETTERS[1:2], LETTERS[1:5]), c(T,T,F,F,F)))
   suppressWarnings(expect_identical(stri_detect_regex(LETTERS[1:4], LETTERS[1:5]), c(T,T,T,T,F)))
   
   s <- c("Lorem", "123", " ", " ", "kota", "4\tą")
   p <- c("[[:alpha:]]+", "[[:blank:]]+")
   expect_identical(stri_detect_regex(s, p), c(T, F, F, T, T, T))
   expect_identical(stri_detect_regex("Lo123\trem", c("[[:alpha:]]", "[4-9]+")), c(T, F))
   
   expect_warning(stri_detect_regex(rep("asd", 5), rep("[A-z]", 2)))
   expect_error(stri_detect_regex("Ala", "{}"))
   
   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaa"), TRUE)
   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaa",  "aaaaaaaaaaaaaaa"), TRUE)
   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaa"), TRUE)
   
})
