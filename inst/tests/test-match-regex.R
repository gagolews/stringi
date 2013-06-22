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


test_that("stri_match_first_regex", {
   
   expect_identical(stri_match_first_regex(NA, "test"), matrix(NA_character_,1,1))
   expect_identical(stri_match_first_regex("", "(test)(rest)"), matrix(NA_character_,1,3))
   expect_identical(stri_match_first_regex("test", NA), matrix(NA_character_,1,1))
   suppressWarnings(expect_identical(stri_match_first_regex("test", ""), matrix(NA_character_,1,1)))
   expect_equivalent(stri_match_first_regex(c("bacab", "ba\u0105aacaba\u0105a", "aa"), "a.a"),
                     matrix(c("aca", "a\u0105a", NA_character_), 3, 1))
   expect_equivalent(stri_match_first_regex(c("a=b;c=d", "", "e=f"), "([a-z])=([a-z])"),
                     matrix(c("a=b", NA, "e=f", "a", NA, "e", "b", NA, "f"), 3, 3))
   
})


test_that("stri_match_last_regex", {
   
   expect_identical(stri_match_last_regex(NA, "test"), matrix(NA_character_,1,1))
   expect_identical(stri_match_last_regex("", "(test)(rest)"), matrix(NA_character_,1,3))
   expect_identical(stri_match_last_regex("test", NA), matrix(NA_character_,1,1))
   suppressWarnings(expect_identical(stri_match_last_regex("test", ""), matrix(NA_character_,1,1)))
   expect_equivalent(stri_match_last_regex(c("bacab", "ba\u0105aacaba\u0104a", "aa"), "a.a"),
                     matrix(c("aca", "a\u0104a", NA_character_), 3, 1))
   expect_equivalent(stri_match_last_regex(c("a=b;c=d", "", "e=f"), "([a-z])=([a-z])"),
                     matrix(c("c=d", NA, "e=f", "c", NA, "e", "d", NA, "f"), 3, 3))
   
})
