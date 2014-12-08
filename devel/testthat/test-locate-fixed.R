require(testthat)
context("test-locate-fixed.R")

test_that("stri_locate_all_fixed", {

   expect_is(stri_locate_all_fixed(character(0), "a"), "list")

   suppressWarnings(expect_equivalent(stri_locate_all_fixed(NA, character(0)), list()))
   expect_equivalent(stri_locate_all_fixed(character(0), NA), list())
   suppressWarnings(expect_equivalent(stri_locate_all_fixed(LETTERS, character(0)), list()))
   suppressWarnings(expect_equivalent(stri_locate_all_fixed(NA, ""), list(matrix(c(NA,NA_integer_)))))
   expect_equivalent(stri_locate_all_fixed("", NA), list(matrix(c(NA,NA_integer_))))
   expect_equivalent(stri_locate_all_fixed(NA, NA), list(matrix(c(NA,NA_integer_))))

      expect_equivalent(as.integer(stri_locate_all_fixed(NA, "[a-z]")[[1]]),
                     c(NA_integer_, NA_integer_))
   expect_equivalent(as.integer(stri_locate_all_fixed("?", "[a-z]")[[1]]),
                     c(NA_integer_, NA_integer_))
   expect_equivalent(as.integer(stri_locate_all_fixed("?", "[a-z]", omit_no_match = TRUE)[[1]]),
                     integer(0))

   expect_equivalent(stri_locate_all_fixed("\u0105\u0105\u0105", "\u0105\u0105", overlap=TRUE), list(matrix(c(1,2, 2, 3), byrow=TRUE,ncol=2)))
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

   # we have special cases for patterns of length 1,2,3,4
   for (val in c(FALSE, TRUE)) {
      expect_equivalent(stri_locate_first_fixed("b", "ab", case_insensitive=val),         matrix(rep(NA_integer_, 2)))
      expect_equivalent(stri_locate_first_fixed("bc", "abc", case_insensitive=val),       matrix(rep(NA_integer_, 2)))
      expect_equivalent(stri_locate_first_fixed("bcd", "abcd", case_insensitive=val),     matrix(rep(NA_integer_, 2)))
      expect_equivalent(stri_locate_first_fixed("bcde", "abcde", case_insensitive=val),   matrix(rep(NA_integer_, 2)))
      expect_equivalent(stri_locate_first_fixed("bcdef", "abcdef", case_insensitive=val), matrix(rep(NA_integer_, 2)))
      expect_equivalent(stri_locate_first_fixed("a", "a", case_insensitive=val),           matrix(c(1,1)))
      expect_equivalent(stri_locate_first_fixed("ab", "ab", case_insensitive=val),         matrix(c(1,2)))
      expect_equivalent(stri_locate_first_fixed("abc", "abc", case_insensitive=val),       matrix(c(1,3)))
      expect_equivalent(stri_locate_first_fixed("abcd", "abcd", case_insensitive=val),     matrix(c(1,4)))
      expect_equivalent(stri_locate_first_fixed("abcde", "abcde", case_insensitive=val),   matrix(c(1,5)))
      expect_equivalent(stri_locate_first_fixed("abcdef", "abcdef", case_insensitive=val), matrix(c(1,6)))
   
      expect_equivalent(stri_locate_first_fixed("1a\u0105a", "\u0105", case_insensitive=val), matrix(c(3,3)))
      expect_equivalent(stri_locate_first_fixed("aaaaaa", "a", case_insensitive=val),     matrix(c(1,1)))
      expect_equivalent(stri_locate_first_fixed("aaaaaa", "aa", case_insensitive=val),    matrix(c(1,2)))
      expect_equivalent(stri_locate_first_fixed("aaaaaa", "aaa", case_insensitive=val),   matrix(c(1,3)))
      expect_equivalent(stri_locate_first_fixed("aaaaaa", "aaaa", case_insensitive=val),  matrix(c(1,4)))
      expect_equivalent(stri_locate_first_fixed("aaaaaa", "aaaaa", case_insensitive=val), matrix(c(1,5)))
      expect_equivalent(stri_locate_first_fixed("aaaaaa", "aaaaaa", case_insensitive=val), matrix(c(1,6)))
      expect_equivalent(stri_locate_first_fixed("aaaaaa", "aaaaaaa", case_insensitive=val), matrix(c(NA_integer_,NA_integer_)))
      expect_equivalent(stri_locate_first_fixed("aaaaaa", "aaaaaaaa", case_insensitive=val), matrix(c(NA_integer_,NA_integer_)))
      expect_equivalent(stri_locate_first_fixed("xxaaaaaa", "a", case_insensitive=val),     matrix(c(3,3)))
      expect_equivalent(stri_locate_first_fixed("xxaaaaaa", "aa", case_insensitive=val),    matrix(c(3,4)))
      expect_equivalent(stri_locate_first_fixed("xxaaaaaa", "aaa", case_insensitive=val),   matrix(c(3,5)))
      expect_equivalent(stri_locate_first_fixed("xxaaaaaa", "aaaa", case_insensitive=val),  matrix(c(3,6)))
      expect_equivalent(stri_locate_first_fixed("xxaaaaaa", "aaaaa", case_insensitive=val), matrix(c(3,7)))
      expect_equivalent(stri_locate_first_fixed("aa1a12aa123", "123", case_insensitive=val), matrix(c(9,11)))
      expect_equivalent(stri_locate_first_fixed("1-1-2-33--2", "-32", case_insensitive=val), matrix(c(NA_integer_,NA_integer_)))
   }

   expect_warning(expect_equivalent(stri_locate_first_fixed("\u0105a", "\u0105a", overlap=TRUE), matrix(c(1,2))))
   expect_equivalent(stri_locate_first_fixed("\u0105a", "\u0105a"), matrix(c(1,2)))
   expect_equivalent(stri_locate_first_fixed(stri_trans_nfkd("\u0105a"), "\u0105a"), matrix(c(NA_integer_,NA)))
   expect_equivalent(stri_locate_first_fixed("\U0001F0A0a", "a"), matrix(c(2,2)))
   
   # According to UnicodeData.txt, there are characters x for which numbytes(x) != numbytes(u_toupper(x))
   expect_equivalent(stri_locate_first_fixed("aIO", "a\u0131o", case_insensitive=TRUE), matrix(c(1,3)))
   expect_equivalent(stri_locate_first_fixed("aIOoo", "a\u0131o", case_insensitive=TRUE), matrix(c(1,3)))
   expect_equivalent(stri_locate_first_fixed("aaaIOoo", "a\u0131o", case_insensitive=TRUE), matrix(c(3,5)))
   expect_equivalent(stri_locate_first_fixed("\u0131\u0131\u0131", "i", case_insensitive=TRUE), matrix(c(1,1)))
   expect_equivalent(stri_locate_first_fixed("\u0105\u0131\u0105", "I", case_insensitive=TRUE), matrix(c(2,2)))
   expect_equivalent(stri_locate_first_fixed("\u0131\u0105\u0131\u0131\u0131\u0105\u0131", "iIi", case_insensitive=TRUE), matrix(c(3,5)))

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

   expect_equivalent(stri_locate_last_fixed("b", "ab"),         matrix(rep(NA_integer_, 2)))
   expect_equivalent(stri_locate_last_fixed("bc", "abc"),       matrix(rep(NA_integer_, 2)))
   expect_equivalent(stri_locate_last_fixed("bcd", "abcd"),     matrix(rep(NA_integer_, 2)))
   expect_equivalent(stri_locate_last_fixed("bcde", "abcde"),   matrix(rep(NA_integer_, 2)))
   expect_equivalent(stri_locate_last_fixed("bcdef", "abcdef"), matrix(rep(NA_integer_, 2)))

   for (val in c(FALSE, TRUE)) {
      expect_equivalent(stri_locate_last_fixed("a", "a", case_insensitive=val),           matrix(c(1,1)))
      expect_equivalent(stri_locate_last_fixed("ab", "ab", case_insensitive=val),         matrix(c(1,2)))
      expect_equivalent(stri_locate_last_fixed("abc", "abc", case_insensitive=val),       matrix(c(1,3)))
      expect_equivalent(stri_locate_last_fixed("abcd", "abcd", case_insensitive=val),     matrix(c(1,4)))
      expect_equivalent(stri_locate_last_fixed("abcde", "abcde", case_insensitive=val),   matrix(c(1,5)))
      expect_equivalent(stri_locate_last_fixed("abcdef", "abcdef", case_insensitive=val), matrix(c(1,6)))
      expect_equivalent(stri_locate_last_fixed("aba", "ab", case_insensitive=val),         matrix(c(1,2)))
      expect_equivalent(stri_locate_last_fixed("abcab", "abc", case_insensitive=val),       matrix(c(1,3)))
      expect_equivalent(stri_locate_last_fixed("abcdabc", "abcd", case_insensitive=val),     matrix(c(1,4)))
      expect_equivalent(stri_locate_last_fixed("abcdeabcd", "abcde", case_insensitive=val),   matrix(c(1,5)))
      expect_equivalent(stri_locate_last_fixed("abcdefabcde", "abcdef", case_insensitive=val), matrix(c(1,6)))
   
      # we have special cases for patterns of length 1,2,3,4
      expect_equivalent(stri_locate_last_fixed("aaaaaa", "a", case_insensitive=val),       matrix(c(6,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaa", "aa", case_insensitive=val),      matrix(c(5,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaa", "aaa", case_insensitive=val),     matrix(c(4,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaa", "aaaa", case_insensitive=val),    matrix(c(3,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaa", "aaaaa", case_insensitive=val),   matrix(c(2,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaa", "aaaaaa", case_insensitive=val), matrix(c(1,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaa", "aaaaaaa", case_insensitive=val), matrix(c(NA_integer_,NA_integer_)))
      expect_equivalent(stri_locate_last_fixed("aaaaaa", "aaaaaaaa", case_insensitive=val), matrix(c(NA_integer_,NA_integer_)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxx", "a", case_insensitive=val),     matrix(c(6,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxx", "aa", case_insensitive=val),    matrix(c(5,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxx", "aaa", case_insensitive=val),   matrix(c(4,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxx", "aaaa", case_insensitive=val),  matrix(c(3,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxx",  "aaaaa", case_insensitive=val), matrix(c(2,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxaxa", "aa", case_insensitive=val),    matrix(c(5,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxaaxaa", "aaa", case_insensitive=val),   matrix(c(4,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxaaxaaa", "aaaa", case_insensitive=val),  matrix(c(3,6)))
      expect_equivalent(stri_locate_last_fixed("aaaaaaxaaaaxaaaa", "aaaaa", case_insensitive=val), matrix(c(2,6)))
   }
   
   # According to UnicodeData.txt, there are characters x for which numbytes(x) != numbytes(u_toupper(x))
   expect_equivalent(stri_locate_last_fixed("aIO", "a\u0131o", case_insensitive=TRUE), matrix(c(1,3)))
   expect_equivalent(stri_locate_last_fixed("aIOoo", "a\u0131o", case_insensitive=TRUE), matrix(c(1,3)))
   expect_equivalent(stri_locate_last_fixed("aaaIOoo", "a\u0131o", case_insensitive=TRUE), matrix(c(3,5)))
   expect_equivalent(stri_locate_last_fixed("\u0131\u0131\u0131", "i", case_insensitive=TRUE), matrix(c(3,3)))
   expect_equivalent(stri_locate_last_fixed("\u0105\u0131\u0105", "I", case_insensitive=TRUE), matrix(c(2,2)))
   expect_equivalent(stri_locate_last_fixed("\u0131\u0105\u0131\u0131\u0131\u0105\u0131", "iIi", case_insensitive=TRUE), matrix(c(3,5)))

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
   expect_equivalent(stri_locate_last_fixed("bababababaabaa", "aabaa"), matrix(c(10,14)))
   expect_equivalent(stri_locate_last_fixed("bababababaabaaaabbabababbbabaaaabbba", "aabaa"), matrix(c(10,14)))
})


#    for (i in 1:1000) {
#       s <- stri_flatten(sample(c("\u0105", "x"), 10000, replace=TRUE))
#       p <- stri_flatten(sample(c("\u0105", "x"), 10, replace=TRUE))
#       expect_identical(stri_locate_all_fixed(s, p), stri_locate_all_regex(s, p))
#       expect_identical(stri_locate_all_fixed(s, p, case_insensitive=TRUE), stri_locate_all_regex(s, p, case_insensitive=TRUE))
#       expect_identical(stri_locate_first_fixed(s, p), stri_locate_first_regex(s, p))
#       expect_identical(stri_locate_first_fixed(s, p, case_insensitive=TRUE), stri_locate_first_regex(s, p, case_insensitive=TRUE))
#       expect_identical(stri_sub(s, stri_locate_last_fixed(s, p)), p)
#       expect_identical(stri_sub(s, stri_locate_last_fixed(s, p, case_insensitive=FALSE)), p)
#    }
