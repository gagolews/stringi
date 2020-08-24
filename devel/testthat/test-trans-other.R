require(testthat)
context("test-trans-other")

test_that("stri_trans_char", {
    
    expect_equivalent(stri_trans_char(c("aaa", "bbb"), NA, "a"), rep(NA_character_, 
        2))
    expect_equivalent(stri_trans_char(c("aaa", "bbb"), "a", NA), rep(NA_character_, 
        2))
    expect_equivalent(stri_trans_char(character(0), "a", "b"), character(0))
    expect_equivalent(stri_trans_char(rep(NA_character_, 10), "a", "b"), rep(NA_character_, 
        10))
    expect_equivalent(stri_trans_char("abc", "", ""), "abc")
    expect_equivalent(suppressWarnings(stri_trans_char("abc", "", "ą")), "abc")
    expect_equivalent(suppressWarnings(stri_trans_char("abc", "ą", "")), "abc")
    expect_warning(stri_trans_char("abc", "", "ą"))
    expect_warning(stri_trans_char("abc", "ą", ""))
    
    expect_equivalent(stri_trans_char(c("ab", "ba", "bc", "", NA), "ab", "bc"), c("bc", 
        "cb", "cc", "", NA))
    expect_equivalent(stri_trans_char(c("ab", "ba", "bc", "", NA), "ba", "cb"), c("bc", 
        "cb", "cc", "", NA))
    expect_equivalent(stri_trans_char("ąśćźað", "ąśćźað", "śćźąßc"), 
        "śćźąßc")
    expect_equivalent(stri_trans_char("accctggaaactg", "actg", "tgac"), "tgggacctttgac")
    
    expect_warning(stri_trans_char("aaaa", c("a", "b"), "b"))
    expect_warning(stri_trans_char("aaaa", c("a", "b"), c("a", "b")))
    expect_warning(stri_trans_char("aaaa", "a", "ba"))
    expect_warning(stri_trans_char("aaaa", "ba", "a"))
    
    expect_equivalent(stri_trans_char("aaaa", "aa", "bc"), "cccc")
    
    expect_equivalent(stri_trans_char(c("", "abcdef", "ąbćdęf", "ABCDEF@264#%#@ąśęŋńþłżź”ńłəæþ©"), 
        "fedcba", "123456"), c("", "654321", "ą5ć3ę1", "ABCDEF@264#%#@ąśęŋńþłżź”ńłəæþ©"))
    expect_equivalent(stri_trans_char("ąbćdęf", "fędćbą", "123456"), "654321")
})
