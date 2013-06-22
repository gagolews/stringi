require(testthat)

test_that("stri_match_all_regex", {
   
   expect_identical(stri_match_all_regex(NA, "test"), list(matrix(NA_character_,1,1)))
   expect_identical(stri_match_all_regex("", "(test)(rest)"), list(matrix(NA_character_,1,3)))
   expect_identical(stri_match_all_regex("test", NA), list(matrix(NA_character_,1,1)))
   suppressWarnings(expect_identical(stri_match_all_regex("test", ""), list(matrix(NA_character_,1,1))))
   expect_equivalent(sapply(stri_match_all_regex(c("bacab", "bacaba\u0105a", "aa"), "a.a"), as.character),
                     list("aca", c("aca", "a\u0105a"), NA_character_))
   expect_equivalent(sapply(stri_match_all_regex(c("a=b;c=d", "", "e=f"), "([a-z])=([a-z])"), as.character),
                     list(c("a=b", "c=d", "a", "c", "b", "d"), rep(NA_character_, 3), c("e=f", "e", "f")))
   
})
