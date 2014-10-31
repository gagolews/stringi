require("testthat")

test_that("stri_startswith_fixed", {
   expect_identical(stri_startswith_fixed("a", NA), NA)
   expect_identical(stri_startswith_fixed(NA, "a"), NA)
   expect_identical(stri_startswith_fixed(NA, NA), NA)
   expect_identical(stri_startswith_fixed(c("","ala"),"ala"), c(FALSE, TRUE))
   expect_identical(stri_startswith_fixed(c("ala","", "", "bbb"),c("ala", "bbb")), c(TRUE, FALSE, FALSE, TRUE))
   expect_identical(stri_startswith_fixed("kot lorem1", character(0)), logical(0))
   expect_identical(stri_startswith_fixed(character(0), "ipsum 1234"), logical(0))
   expect_identical(stri_startswith_fixed(character(0), character(0)), logical(0))
   expect_identical(stri_startswith_fixed(c("ab", "cab", "ccccab", "abaabaaaa"), "ab"), c(T, F, F, T))
   expect_identical(stri_startswith_fixed(c("Lorem\n123", " ", "kota", "\t\u01054"), c(" ", "\t\u0105")), c(F, F, F, T))
   expect_warning(stri_startswith_fixed(rep("asd", 5), rep("a", 2)))
   expect_identical(stri_startswith_fixed("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), FALSE)
   expect_equivalent(stri_startswith_fixed("aaaab", "ab"), FALSE)
   expect_equivalent(stri_startswith_fixed("bababababaab", "bab"), TRUE)
   expect_equivalent(stri_startswith_fixed("bababababaab", "bab", from=c(1,2,3)), c(T,F,T))
   expect_equivalent(stri_startswith_fixed("\u0105\u0104\u0105\u0104\u0105", "\u0105\u0104\u0105",
      from=c(1,2,3,100,-3)), c(T,F,T,F,T))
   expect_equivalent(stri_startswith("\u0105\u0104\u0105\u0104\u0105", fixed="\u0105\u0104\u0105",
      from=c(1,2,3,100,-3)), c(T,F,T,F,T))
   expect_equivalent(stri_startswith_fixed("a", "agsdgsjgidjso", c(-1,1,-2,2,0)), c(F,F,F,F,F))
   
   expect_equivalent(stri_startswith_fixed("abc", "a", c(1,2,3)), c(TRUE, FALSE, FALSE))
   expect_equivalent(stri_startswith_fixed("abc", "b", c(1,2,3)), c(FALSE, TRUE, FALSE))
   expect_equivalent(stri_startswith_fixed("abc", "c", c(1,2,3)), c(FALSE, FALSE, TRUE))
   expect_equivalent(stri_startswith_fixed("abc", "a", c(-3,-2,-1)), c(TRUE, FALSE, FALSE))
   expect_equivalent(stri_startswith_fixed("abc", "b", c(-3,-2,-1)), c(FALSE, TRUE, FALSE))
   expect_equivalent(stri_startswith_fixed("abc", "c", c(-3,-2,-1)), c(FALSE, FALSE, TRUE))
   
   expect_equivalent(stri_startswith_fixed("abc", "a", c(-1000, 0, 4)), c(TRUE, TRUE, FALSE))
   expect_equivalent(stri_startswith_fixed("ab",  "b", c(-1000, 0, 3)), c(FALSE, FALSE, FALSE))
   expect_equivalent(stri_startswith_fixed("a",  "b", c(-1000, 0, 2)), c(FALSE, FALSE, FALSE))

   suppressWarnings(expect_identical(stri_startswith_fixed("",""), NA))
   suppressWarnings(expect_identical(stri_startswith_fixed("a",""), NA))
   suppressWarnings(expect_identical(stri_startswith_fixed("","a"), FALSE))
})


test_that("stri_endswith_fixed", {
   expect_identical(stri_endswith_fixed("a", NA), NA)
   expect_identical(stri_endswith_fixed(NA, "a"), NA)
   expect_identical(stri_endswith_fixed(NA, NA), NA)
   expect_identical(stri_endswith_fixed(c("","ala"),"ala"), c(FALSE, TRUE))
   expect_identical(stri_endswith_fixed(c("ala","", "", "bbb"),c("ala", "bbb")), c(TRUE, FALSE, FALSE, TRUE))
   expect_identical(stri_endswith_fixed("kot lorem1", character(0)), logical(0))
   expect_identical(stri_endswith_fixed(character(0), "ipsum 1234"), logical(0))
   expect_identical(stri_endswith_fixed(character(0), character(0)), logical(0))
   expect_identical(stri_endswith_fixed(c("ab", "cab", "ccccab", "abaabaaaa"), "ab"), c(T, T, T, F))
   expect_identical(stri_endswith_fixed(c("Lorem\n123", " ", "kota", "4\t\u0105"), c(" ", "\t\u0105")), c(F, F, F, T))
   expect_warning(stri_endswith_fixed(rep("asd", 5), rep("a", 2)))
   expect_identical(stri_endswith_fixed("\u0104\u0105", stri_trans_nfkd("\u0104\u0105")), FALSE)
   expect_equivalent(stri_endswith_fixed("aaaab", "ab"), TRUE)
   expect_equivalent(stri_endswith_fixed("bababababaab", "bab", to=c(-1,-2,-3,-4,4,3)), c(F,F,F,T,F,T))
   expect_equivalent(stri_endswith_fixed("\u0105\u0104\u0105\u0104\u0105\u0104\u0105\u0104\u0105\u0104\u0104\u0105",
      "\u0105\u0104\u0105", to=c(-1,-2,-3,-4,4,3)), c(F,F,F,T,F,T))
   expect_equivalent(stri_endswith("\u0105\u0104\u0105\u0104\u0105\u0104\u0105\u0104\u0105\u0104\u0104\u0105",
      fixed="\u0105\u0104\u0105", to=c(-1,-2,-3,-4,4,3)), c(F,F,F,T,F,T))

   expect_equivalent(stri_endswith_fixed("aba", "a", c(-1,-100000000, 0, 10000000)), c(T,F,F,T))
   expect_equivalent(stri_endswith_fixed("a", "agsdgsjgidjso", c(-1,1,-2,2,0)), c(F,F,F,F,F))
   suppressWarnings(expect_identical(stri_endswith_fixed("",""), NA))
   suppressWarnings(expect_identical(stri_endswith_fixed("a",""), NA))
   suppressWarnings(expect_identical(stri_endswith_fixed("","a"), FALSE))
   
   expect_equivalent(stri_endswith_fixed("abc", "a", c(1,2,3)), c(TRUE, FALSE, FALSE))
   expect_equivalent(stri_endswith_fixed("abc", "b", c(1,2,3)), c(FALSE, TRUE, FALSE))
   expect_equivalent(stri_endswith_fixed("abc", "c", c(1,2,3)), c(FALSE, FALSE, TRUE))
   expect_equivalent(stri_endswith_fixed("abc", "a", c(-3,-2,-1)), c(TRUE, FALSE, FALSE))
   expect_equivalent(stri_endswith_fixed("abc", "b", c(-3,-2,-1)), c(FALSE, TRUE, FALSE))
   expect_equivalent(stri_endswith_fixed("abc", "c", c(-3,-2,-1)), c(FALSE, FALSE, TRUE))
   
   expect_equivalent(stri_endswith_fixed("abc", "a", c(-1000, 0)), c(FALSE, FALSE))
   expect_equivalent(stri_endswith_fixed("ab",  "b", c(-1000, 0)), c(FALSE, FALSE))
   expect_equivalent(stri_endswith_fixed("a",  "b", c(-1000, 0)), c(FALSE, FALSE))
   
   expect_equivalent(stri_endswith_fixed("abc", "a", c(-1000, 0, 4)), c(FALSE, FALSE, FALSE))
   expect_equivalent(stri_endswith_fixed("ab",  "b", c(-1000, 0, 4)), c(FALSE, FALSE, TRUE))
   expect_equivalent(stri_endswith_fixed("a",  "b", c(-1000, 0, 4)), c(FALSE, FALSE, FALSE))
})
