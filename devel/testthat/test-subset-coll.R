require("testthat")
context("test-subset-coll.R")

test_that("stri_subset_coll", {
   expect_identical(stri_subset_coll("a", NA), NA_character_)
   expect_identical(stri_subset_coll(NA, "a"), NA_character_)
   expect_identical(stri_subset_coll(NA, NA), NA_character_)
   expect_identical(stri_subset_coll(c("","ala"),"ala"), "ala")
   expect_identical(stri_subset_coll(c("","ala","AlA"),"ala", opts_collator=stri_opts_collator(strength=1)), c("ala", "AlA"))
   expect_identical(stri_subset_coll(c("","ala","AlA"),"ala", strength=1), c("ala", "AlA"))
   expect_identical(stri_subset_coll("kot lorem1", character(0)), character(0))
   expect_identical(stri_subset_coll(character(0), "ipsum 1234"), character(0))
   expect_identical(stri_subset_coll(character(0), character(0)), character(0))
   expect_identical(stri_subset_coll(c("ab", "cab", "ccccab", "aaaabaaaa"), "ab"), c("ab", "cab", "ccccab", "aaaabaaaa"))
   expect_identical(stri_subset_coll(c("ala","", "", "bbb"),c("ala", "bbb")), c("ala", "bbb"))
   expect_identical(stri_subset_coll(c("a","b", NA, "aaa", ""),c("a")), c("a", NA, "aaa"))

   expect_identical(stri_subset_coll(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ", "\t\u0105")), "4\t\u0105")
   expect_warning(stri_subset_coll(rep("asd", 5), rep("a", 2)))
   expect_identical(stri_subset_coll("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), "\u0104\u0105")
   expect_equivalent(stri_subset_coll("aaaab", "ab"), "aaaab")
   expect_equivalent(stri_subset_coll("bababababaab", "aab"), "bababababaab")

   suppressWarnings(expect_identical(stri_subset_coll("",""), NA_character_))
   suppressWarnings(expect_identical(stri_subset_coll("a",""), NA_character_))
   suppressWarnings(expect_identical(stri_subset_coll("","a"), character(0)))

   expect_identical(stri_subset_coll(NA, NA, omit_na=TRUE), character(0))
   suppressWarnings(expect_identical(stri_subset_coll("","", omit_na=TRUE), character(0)))
   suppressWarnings(expect_identical(stri_subset_coll("a","", omit_na=TRUE), character(0)))
   suppressWarnings(expect_identical(stri_subset_coll("","a", omit_na=TRUE), character(0)))
   expect_identical(stri_subset_coll(c("a","b", NA, "aaa", ""),c("a"), omit_na=TRUE), c("a", "aaa"))
   expect_identical(stri_subset_coll('a', c('a', 'b', 'c'), omit_na=TRUE), "a")



   x <- c("stringi R", "123", "ID456", "", NA)
   stri_subset_coll(x, "1") <- c(NA, "8")
   expect_identical(x, c("stringi R", NA, "ID456", "", NA))

   x <- c("stringi R", "123", "ID456", "", NA)
   stri_subset_coll(x, "1") <- c(NA)
   expect_identical(x, c("stringi R", NA, "ID456", "", NA))

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
   expect_warning(stri_subset_coll(x, c("7","8")) <- NA)
   expect_error(stri_subset_coll(x, character(0)) <- NA)

   x <- c("stringi R", "123", "ID456", "")
   stri_subset(x, coll="S", strength=1) <- NA
   expect_identical(x, c(NA, "123", "ID456", ""))
})
