library("tinytest")
library("stringi")



expect_equivalent(stri_trans_char(c("aaa", "bbb"), NA, "a"), rep(NA_character_,
    2))
expect_equivalent(stri_trans_char(c("aaa", "bbb"), "a", NA), rep(NA_character_,
    2))
expect_equivalent(stri_trans_char(character(0), "a", "b"), character(0))
expect_equivalent(stri_trans_char(rep(NA_character_, 10), "a", "b"), rep(NA_character_,
    10))
expect_equivalent(stri_trans_char("abc", "", ""), "abc")
expect_equivalent(suppressWarnings(stri_trans_char("abc", "", "\u0105")), "abc")
expect_equivalent(suppressWarnings(stri_trans_char("abc", "\u0105", "")), "abc")
expect_warning(stri_trans_char("abc", "", "\u0105"))
expect_warning(stri_trans_char("abc", "\u0105", ""))

expect_equivalent(stri_trans_char(c("ab", "ba", "bc", "", NA), "ab", "bc"), c("bc",
    "cb", "cc", "", NA))
expect_equivalent(stri_trans_char(c("ab", "ba", "bc", "", NA), "ba", "cb"), c("bc",
    "cb", "cc", "", NA))
expect_equivalent(stri_trans_char("\u0105\u015B\u0107\u017Aa\u00F0", "\u0105\u015B\u0107\u017Aa\u00F0", "\u015B\u0107\u017A\u0105\u00DFc"),
    "\u015B\u0107\u017A\u0105\u00DFc")
expect_equivalent(stri_trans_char("accctggaaactg", "actg", "tgac"), "tgggacctttgac")

expect_warning(stri_trans_char("aaaa", c("a", "b"), "b"))
expect_warning(stri_trans_char("aaaa", c("a", "b"), c("a", "b")))
expect_warning(stri_trans_char("aaaa", "a", "ba"))
expect_warning(stri_trans_char("aaaa", "ba", "a"))

expect_equivalent(stri_trans_char("aaaa", "aa", "bc"), "cccc")

expect_equivalent(stri_trans_char(c("", "abcdef", "\u0105b\u0107d\u0119f", "ABCDEF@264#%#@\u0105\u015B\u0119\u014B\u0144\u00FE\u0142\u017C\u017A\u201D\u0144\u0142\u0259\u00E6\u00FE\u00A9"),
    "fedcba", "123456"), c("", "654321", "\u01055\u01073\u01191", "ABCDEF@264#%#@\u0105\u015B\u0119\u014B\u0144\u00FE\u0142\u017C\u017A\u201D\u0144\u0142\u0259\u00E6\u00FE\u00A9"))
expect_equivalent(stri_trans_char("\u0105b\u0107d\u0119f", "f\u0119d\u0107b\u0105", "123456"), "654321")

