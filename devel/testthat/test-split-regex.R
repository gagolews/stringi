require(testthat)

test_that("stri_split_regex", {
   expect_identical(stri_split_regex(character(0)," "),list())
   expect_identical(stri_split_regex(NA,NA),list(NA_character_))
   expect_identical(stri_split_regex(NA,"a"),list(NA_character_))
   expect_identical(stri_split_regex("NA",NA),list(NA_character_))
   expect_identical(stri_split_regex("NA","a",NA),list(NA_character_))
   expect_identical(stri_split_regex(" "," "),list(rep("",2)))
   expect_identical(stri_split_regex("","Z"),list(""))
   expect_identical(stri_split_regex("","Z", omit_empty=TRUE),list(character(0)))
   expect_identical(stri_split_regex("gas","Z", n_max=0),list(character(0)))
   expect_identical(stri_split_regex("aa","a"),list(rep("",3)))
   expect_identical(stri_split_regex("aa","a",-1L,TRUE),list(character(0)))
   expect_identical(stri_split_regex("ala ma kota 1 a","[a-z] [a-z]"),list(c("al","","ota 1 a")))
   expect_identical(stri_split_regex("ala ma kota 1 a","[a-z] [a-z]*"),list(c("al"," kot","1 a")))
   expect_identical(stri_split_regex("ala ma kota 1 a","[a-z] [a-z]+"),list(c("al"," kota 1 a")))
   expect_identical(stri_split_regex("ala ma kota 1 a","[a-z] [1-9]"),list(c("ala ma kot"," a")))
   expect_identical(stri_split_regex("ala ma kota 1 a","[a-z] [1-9]+"),list(c("ala ma kot"," a")))

   # n
   expect_identical(stri_split_regex(";123", ";", n=2), list(c("", "123")))
   expect_identical(stri_split_regex(";123", ";", n=2, omit_empty=TRUE), list("123"))
   expect_identical(stri_split_regex("123;456", ";", n=2), list(c("123", "456")))
   expect_identical(stri_split_regex("123;456;789", ";", n=2), list(c("123", "456;789")))
   expect_identical(stri_split_regex("123-456-789", "-", n=1:3),
                    list(c("123-456-789"),c("123","456-789"),c("123","456","789")))
   expect_identical(stri_split_regex("123-456-789", "[1-8]-.", n=5), list(c("12","5","89")))
   
   # tokens_only
   expect_identical(stri_split_regex("a_b_c_d", "_"), list(c("a", "b", "c", "d")))
   expect_identical(stri_split_regex("a_b_c__d", "_"), list(c("a", "b", "c", "", "d")))
   expect_identical(stri_split_regex("a_b_c__d", "_", omit_empty=TRUE), list(c("a", "b", "c", "d")))
   expect_identical(stri_split_regex("a_b_c__d", "_", n_max=2, tokens_only=FALSE), list(c("a", "b_c__d")))
   expect_identical(stri_split_regex("a_b_c__d", "_", n_max=2, tokens_only=TRUE), list(c("a", "b")))
   expect_identical(stri_split_regex("a_b_c__d", "_", n_max=4, omit_empty=TRUE, tokens_only=TRUE), list(c("a", "b", "c", "d")))
   expect_identical(stri_split_regex("a_b_c__d", "_", n_max=4, omit_empty=FALSE, tokens_only=TRUE), list(c("a", "b", "c", "")))
   expect_identical(stri_split_regex(c("ab_c", "d_ef_g", "h", ""), "_", n_max=1, tokens_only=TRUE, omit_empty=TRUE), list("ab", "d", "h", character(0)))
   expect_identical(stri_split_regex(c("ab_c", "d_ef_g", "h", ""), "_", n_max=2, tokens_only=TRUE, omit_empty=TRUE), list(c("ab", "c"), c("d", "ef"), "h", character(0)))
   expect_identical(stri_split_regex(c("ab_c", "d_ef_g", "h", ""), "_", n_max=3, tokens_only=TRUE, omit_empty=TRUE), list(c("ab", "c"), c("d", "ef", "g"), "h", character(0)))
   
   expect_identical(stri_split_regex(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=TRUE, simplify=TRUE),
      matrix(c("ab", "d", "h", NA, "c", "ef", NA, NA, NA, "g", NA, NA), nrow=4))
   expect_identical(stri_split_regex(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=FALSE, simplify=TRUE),
      matrix(c("ab", "d", "", "", "c", "ef", "h", NA, NA, "g", NA, NA), nrow=4))
   expect_identical(stri_split_regex(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=NA, simplify=TRUE),
      matrix(c("ab", "d", NA, NA, "c", "ef", "h", NA, NA, "g", NA, NA), nrow=4))
   expect_identical(stri_split_regex(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=TRUE),
      list(c("ab", "c"), c("d", "ef", "g"), "h", character()))
   expect_identical(stri_split_regex(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=FALSE),
      list(c("ab", "c"), c("d", "ef", "g"), c("", "h"), ""))
   expect_identical(stri_split_regex(c("ab,c", "d,ef,g", ",h", ""), ",", omit_empty=NA),
      list(c("ab", "c"), c("d", "ef", "g"), c(NA, "h"), NA_character_))
})
