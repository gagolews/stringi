require(testthat)

test_that("stri_split_fixed", {
   expect_identical(stri_split_fixed(character(0)," "),list())
   expect_identical(stri_split_fixed("","Z"),list(""))
   expect_identical(stri_split_fixed("","Z", omit_empty=TRUE),list(character(0)))
   expect_identical(stri_split_fixed("gas","Z", n_max=0),list(character(0)))
   expect_identical(stri_split_fixed(NA,NA),list(NA_character_))
   expect_identical(stri_split_fixed(NA,"a"),list(NA_character_))
   expect_identical(stri_split_fixed("NA",NA),list(NA_character_))
   expect_identical(stri_split_fixed("NA","a",NA),list(NA_character_))
   expect_identical(stri_split_fixed("NA","a",1,NA),list(NA_character_))
   expect_identical(stri_split_fixed(" "," "),list(rep("",2)))
   expect_identical(stri_split_fixed("aa","a"),list(rep("",3)))
   expect_identical(stri_split_fixed("aa","a",-1L,TRUE),list(character(0)))

   # n
   expect_identical(stri_split_fixed(";123", ";", n=2), list(c("", "123")))
   expect_identical(stri_split_fixed(";123", ";", n=2, omit_empty=TRUE), list("123"))
   expect_identical(stri_split_fixed("123abc456", "abc", n=2), list(c("123", "456")))
   expect_identical(stri_split_fixed("123abc456abc789", "abc", n=2), list(c("123", "456abc789")))
})
