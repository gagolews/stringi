require("testthat")



test_that("stri_detect_charclass", {
   expect_identical(stri_detect_charclass("a", NA), NA)
   expect_identical(stri_detect_charclass(NA, "Z"), NA)
   expect_identical(stri_detect_charclass(NA, NA), NA)
   expect_identical(suppressWarnings(stri_detect_charclass("a", "WTF????")), NA)
   expect_warning(stri_detect_charclass("a", "WTF????"))

   expect_identical(stri_detect_charclass(c("a", "ab", "abc", "1234"), "L"), c(T,T,T,F))
   expect_identical(stri_detect_charclass("a\u0105bc", c("L", "Ll", "Lu")), c(T,T,F))
   expect_identical(stri_detect_charclass("a\u0105bc", c("l", "ll", "lu")), c(T,T,F))
   expect_identical(stri_detect_charclass("a\u0105bc", c("^l", "^ll", "^lu")), c(F,F,T))
   expect_identical(stri_detect_charclass("a\u0105bc", c("AlPh_a  bEtic")), c(T))
   expect_identical(stri_detect_charclass("","L"), FALSE)
})


test_that("stri_detect_fixed [byte]", {
   expect_identical(stri_detect_fixed("a", NA, opts_collator=NA), NA)
   expect_identical(stri_detect_fixed(NA, "a", opts_collator=NA), NA)
   expect_identical(stri_detect_fixed(NA, NA, opts_collator=NA), NA)
   expect_identical(stri_detect_fixed("kot lorem1", character(0), opts_collator=NA), logical(0))
   expect_identical(stri_detect_fixed(character(0), "ipsum 1234", opts_collator=NA), logical(0))
   expect_identical(stri_detect_fixed(character(0), character(0), opts_collator=NA), logical(0))
   expect_identical(stri_detect_fixed(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab", opts_collator=NA), c(T, T, T, T))
   expect_identical(stri_detect_fixed(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ", "\t\u0105"), opts_collator=NA), c(F, F, F, T))
   expect_warning(stri_detect_fixed(rep("asd", 5), rep("a", 2), opts_collator=NA))
   expect_identical(stri_detect_fixed("\u0104\u0105", stri_enc_nfkd("\u0104\u0105"), opts_collator=NA), FALSE)
   expect_equivalent(stri_detect_fixed("aaaab", "ab", NA), TRUE)
   expect_equivalent(stri_detect_fixed("bababababaab", "aab", NA), TRUE)


   suppressWarnings(expect_identical(stri_detect_fixed("","", opts_collator=NA), NA))
   suppressWarnings(expect_identical(stri_detect_fixed("a","", opts_collator=NA), NA))
   suppressWarnings(expect_identical(stri_detect_fixed("","a", opts_collator=NA), FALSE))
})



test_that("stri_detect_fixed [collator]", {
   expect_identical(stri_detect_fixed("a", NA), NA)
   expect_identical(stri_detect_fixed(NA, "a"), NA)
   expect_identical(stri_detect_fixed(NA, NA), NA)
   expect_identical(stri_detect_fixed("kot lorem1", character(0)), logical(0))
   expect_identical(stri_detect_fixed(character(0), "ipsum 1234"), logical(0))
   expect_identical(stri_detect_fixed(character(0), character(0)), logical(0))
   expect_identical(stri_detect_fixed(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab"), c(T, T, T, T))
   expect_identical(stri_detect_fixed(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ", "\t\u0105")), c(F, F, F, T))
   expect_warning(stri_detect_fixed(rep("asd", 5), rep("a", 2)))
   expect_identical(stri_detect_fixed("\u0104\u0105", stri_enc_nfkd("\u0104\u0105")), TRUE)
   expect_equivalent(stri_detect_fixed("aaaab", "ab"), TRUE)
   expect_equivalent(stri_detect_fixed("bababababaab", "aab"), TRUE)

   suppressWarnings(expect_identical(stri_detect_fixed("",""), NA))
   suppressWarnings(expect_identical(stri_detect_fixed("a",""), NA))
   suppressWarnings(expect_identical(stri_detect_fixed("","a"), FALSE))
})


test_that("stri_detect_regex", {
   expect_identical(stri_detect_regex(NA, NA), NA)
   expect_identical(stri_detect_regex(character(0), character(0)), logical(0))

   suppressWarnings(expect_identical(stri_detect_regex("",""), NA))
   suppressWarnings(expect_identical(stri_detect_regex("a",""), NA))
   suppressWarnings(expect_identical(stri_detect_regex("","a"), FALSE))

   expect_identical(stri_detect_regex('a', c('a', 'b', 'c')), c(T,F,F))
   expect_identical(stri_detect_regex(c('a', 'b', 'c'), 'a'), c(T,F,F))
   suppressWarnings(expect_identical(stri_detect_regex(LETTERS[1:2], LETTERS[1:3]), c(T,T,F)))
   suppressWarnings(expect_identical(stri_detect_regex(LETTERS[1:3], LETTERS[1:5]), c(T,T,T,F,F)))
   suppressWarnings(expect_identical(stri_detect_regex(LETTERS[1:2], LETTERS[1:5]), c(T,T,F,F,F)))
   suppressWarnings(expect_identical(stri_detect_regex(LETTERS[1:4], LETTERS[1:5]), c(T,T,T,T,F)))

   s <- c("Lorem", "123", " ", " ", "kota", "4\t\u0105")
   p <- c("[[:alpha:]]+", "[[:blank:]]+")
   expect_identical(stri_detect_regex(s, p), c(T, F, F, T, T, T))
   expect_identical(stri_detect_regex("Lo123\trem", c("[[:alpha:]]", "[4-9]+")), c(T, F))

   expect_warning(stri_detect_regex(rep("asd", 5), rep("[A-z]", 2)))
   expect_error(stri_detect_regex("Ala", "{}"))

   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaaa"), TRUE)
   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaa",  "aaaaaaaaaaaaaaa"), TRUE)
   expect_identical(stri_detect_regex("aaaaaaaaaaaaaaaa", "aaaaaaaaaaaaaaa"), TRUE)

   expect_equivalent(stri_detect_regex("\u0105\u0105\u0105\u0105\u0105\u0105\u0105b","\u0105+b$"),TRUE)

   expect_equivalent(stri_detect_regex("aaaab", "ab"), TRUE)
   expect_equivalent(stri_detect_regex("bababababaab", "aab"), TRUE)

})
