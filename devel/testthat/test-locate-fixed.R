require(testthat)


test_that("stri_locate_all_fixed", {

   expect_is(stri_locate_all_fixed(character(0), "a"), "list")

   suppressWarnings(expect_equivalent(stri_locate_all_fixed(NA, character(0)), list()))
   expect_equivalent(stri_locate_all_fixed(character(0), NA), list())
   suppressWarnings(expect_equivalent(stri_locate_all_fixed(LETTERS, character(0)), list()))
   suppressWarnings(expect_equivalent(stri_locate_all_fixed(NA, ""), list(matrix(c(NA,NA_integer_)))))
   expect_equivalent(stri_locate_all_fixed("", NA), list(matrix(c(NA,NA_integer_))))
   expect_equivalent(stri_locate_all_fixed(NA, NA), list(matrix(c(NA,NA_integer_))))

   expect_equivalent(stri_locate_all_fixed("1a\u0105a", "\u0105"), list(matrix(c(3,3))))
   expect_equivalent(stri_locate_all_fixed("aaa", "aa"), list(matrix(c(1,2))))
   expect_equivalent(stri_locate_all_fixed("aaa", "a"), list(matrix(rep(1:3,2),ncol=2)))
   expect_equivalent(stri_locate_all_fixed("abbabbab", "ab"), list(matrix(c(1,4,7,2,5,8),ncol=2)))

   expect_equivalent(stri_locate_all_fixed("\u0105a", "\u0105a"), list(matrix(c(1,2))))
   expect_equivalent(stri_locate_all_fixed(stri_trans_nfkd("\u0105a"), "\u0105a"), list(matrix(c(NA_integer_,NA_integer_))))
   expect_equivalent(stri_locate_all_fixed("\U0001F0A0a", "a"), list(matrix(c(2,2))))

   suppressWarnings(expect_equivalent(stri_locate_all_fixed("",  ""), list(matrix(c(NA,NA_integer_)))))
   suppressWarnings(expect_equivalent(stri_locate_all_fixed("a", ""), list(matrix(c(NA,NA_integer_)))))
   expect_equivalent(stri_locate_all_fixed("", "a"), list(matrix(c(NA,NA_integer_))))
   expect_equivalent(stri_locate_all_fixed(c("a",""), "a"), list(matrix(c(1,1)),matrix(c(NA,NA_integer_))))
   expect_equivalent(stri_locate_all_fixed("aaaab", "ab"), list(matrix(4:5)))
   expect_equivalent(stri_locate_all_fixed("bababababaab", "aab"), list(matrix(5:6*2)))
})

test_that("stri_locate_first_fixed", {

   expect_is(stri_locate_first_fixed(character(0), "a"), "matrix")

   expect_equivalent(nrow(stri_locate_first_fixed(NA, character(0))), 0)
   expect_equivalent(nrow(stri_locate_first_fixed(character(0), NA)), 0)
   expect_equivalent(nrow(stri_locate_first_fixed(LETTERS, character(0))), 0)
   expect_warning(expect_equivalent(stri_locate_first_fixed(NA, ""), matrix(c(NA_integer_,NA_integer_))))
   expect_equivalent(stri_locate_first_fixed("", NA), matrix(c(NA_integer_,NA_integer_)))
   expect_equivalent(stri_locate_first_fixed(NA, NA), matrix(c(NA_integer_,NA_integer_)))

   expect_equivalent(stri_locate_first_fixed("1a\u0105a", "\u0105"), matrix(c(3,3)))
   expect_equivalent(stri_locate_first_fixed("aaa", "aa"), matrix(c(1,2)))
   expect_equivalent(stri_locate_first_fixed("aa1a12aa123", "123"), matrix(c(9,11)))
   expect_equivalent(stri_locate_first_fixed("1-1-2-33--2", "-32"), matrix(c(NA_integer_,NA_integer_)))

   expect_equivalent(stri_locate_first_fixed("\u0105a", "\u0105a"), matrix(c(1,2)))
   expect_equivalent(stri_locate_first_fixed(stri_trans_nfkd("\u0105a"), "\u0105a"), matrix(c(NA_integer_,NA)))
   expect_equivalent(stri_locate_first_fixed("\U0001F0A0a", "a"), matrix(c(2,2)))

   expect_warning(expect_equivalent(stri_locate_first_fixed("",  ""), matrix(c(NA,NA_integer_))))
   expect_warning(expect_equivalent(stri_locate_first_fixed("a", ""), matrix(c(NA,NA_integer_))))
   expect_equivalent(stri_locate_first_fixed("", "a"), matrix(c(NA,NA_integer_)))
   expect_equivalent(stri_locate_first_fixed(c("a",""), "a"), matrix(c(1,NA,1,NA_integer_)))
   expect_equivalent(stri_locate_first_fixed("aaaab", "ab"), matrix(4:5))
   expect_equivalent(stri_locate_first_fixed("bababababaab", "aab"), matrix(5:6*2))

})


test_that("stri_locate_last_fixed", {


   expect_is(stri_locate_last_fixed(character(0), "a"), "matrix")

   expect_equivalent(nrow(stri_locate_last_fixed(NA, character(0))), 0)
   expect_equivalent(nrow(stri_locate_last_fixed(character(0), NA)), 0)
   expect_equivalent(nrow(stri_locate_last_fixed(LETTERS, character(0))), 0)
   expect_warning(expect_equivalent(stri_locate_last_fixed(NA, ""), matrix(c(NA_integer_,NA_integer_))))
   expect_equivalent(stri_locate_last_fixed("", NA), matrix(c(NA,NA_integer_)))
   expect_equivalent(stri_locate_last_fixed(NA, NA), matrix(c(NA,NA_integer_)))

   expect_equivalent(stri_locate_last_fixed("1a\u0105a", "\u0105"), matrix(c(3,3)))
   #overlapping pattern
   expect_equivalent(stri_locate_last_fixed("aaa", "aa"), matrix(c(2,3)))
   expect_equivalent(stri_locate_last_fixed("aa1a12aa123", "123"), matrix(c(9,11)))
   expect_equivalent(stri_locate_last_fixed("1-1-2-33--2", "-32"), matrix(c(NA_integer_,NA_integer_)))

   expect_equivalent(stri_locate_last_fixed("\u0105a", "\u0105a"), matrix(c(1,2)))
   expect_equivalent(stri_locate_last_fixed(stri_trans_nfkd("\u0105a"), "\u0105a"), matrix(c(NA_integer_,NA)))
   expect_equivalent(stri_locate_last_fixed("\U0001F0A0a", "a"), matrix(c(2,2)))

   expect_warning(expect_equivalent(stri_locate_last_fixed("",  ""), matrix(c(NA,NA_integer_))))
   expect_warning(expect_equivalent(stri_locate_last_fixed("a", ""), matrix(c(NA,NA_integer_))))
   expect_equivalent(stri_locate_last_fixed("", "a"), matrix(c(NA,NA_integer_)))
   expect_equivalent(stri_locate_last_fixed(c("a",""), "a"), matrix(c(1,NA,1,NA_integer_)))
   expect_equivalent(stri_locate_last_fixed("aaaab", "ab"), matrix(4:5))
   expect_equivalent(stri_locate_last_fixed("bababababaab", "aab"), matrix(5:6*2))
})
