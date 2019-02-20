require(testthat)
context("test-trans-other")

test_that("stri_trans_char", {

   expect_equivalent(stri_trans_char(c("aaa", "bbb"), NA, "a"), rep(NA_character_,2))
   expect_equivalent(stri_trans_char(c("aaa", "bbb"), "a", NA), rep(NA_character_,2))
   expect_equivalent(stri_trans_char(character(0), "a", "b"), character(0))
   expect_equivalent(stri_trans_char(rep(NA_character_, 10), "a", "b"), rep(NA_character_, 10))
   expect_equivalent(stri_trans_char("abc", "", ""), "abc")
   expect_equivalent(suppressWarnings(stri_trans_char("abc", "", "\u0105")), "abc")
   expect_equivalent(suppressWarnings(stri_trans_char("abc", "\u0105", "")), "abc")
   expect_warning(stri_trans_char("abc", "", "\u0105"))
   expect_warning(stri_trans_char("abc", "\u0105", ""))

   expect_equivalent(stri_trans_char(c("ab", "ba", "bc", "", NA), "ab", "bc"), c("bc", "cb", "cc", "", NA))
   expect_equivalent(stri_trans_char(c("ab", "ba", "bc", "", NA), "ba", "cb"), c("bc", "cb", "cc", "", NA))
   expect_equivalent(stri_trans_char("ąśćźað", "ąśćźað", "śćźąßc"), "śćźąßc")
   expect_equivalent(stri_trans_char("accctggaaactg", "actg", "tgac"), "tgggacctttgac")

   expect_warning(stri_trans_char("aaaa", c("a", "b"), "b"))
   expect_warning(stri_trans_char("aaaa", c("a", "b"), c("a", "b")))
   expect_warning(stri_trans_char("aaaa", "a", "ba"))
   expect_warning(stri_trans_char("aaaa", "ba", "a"))

   expect_equivalent(stri_trans_char("aaaa", "aa", "bc"), "cccc")

   expect_equivalent(stri_trans_char(c("", "abcdef", "\u0105b\u0107d\u0119f", "ABCDEF@264#%#@\u0105\u015b\u0119\u014b\u0144\u00fe\u0142\u017c\u017a\u201d\u0144\u0142\u0259\u00e6\u00fe\u00a9"),
      "fedcba", "123456"), c("", "654321", "\u01055\u01073\u01191", "ABCDEF@264#%#@\u0105\u015b\u0119\u014b\u0144\u00fe\u0142\u017c\u017a\u201d\u0144\u0142\u0259\u00e6\u00fe\u00a9"))
   expect_equivalent(stri_trans_char("\u0105b\u0107d\u0119f", "f\u0119d\u0107b\u0105", "123456"), "654321")
})
