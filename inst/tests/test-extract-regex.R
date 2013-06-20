require(testthat)

test_that("stri_extract_all_regex", {


})



test_that("stri_extract_first_regex", {
   
   expect_equivalent(stri_extract_first_regex("\U00f0ffffb\u0105deb!d", "b.d"), "b\u0105d")
   expect_equivalent(stri_extract_first_regex("\U00f0ffffb\u0105deb!d", "B.D", stri_opts_regex(case_insensitive=TRUE)), "b\u0105d")
   
})


test_that("stri_extract_last_regex", {
   
   expect_equivalent(stri_extract_last_regex("b!d\U00f0ffffb\u0105de", "b.d"), "b\u0105d")
   expect_equivalent(stri_extract_last_regex("b!d\U00f0ffffb\u0105de", "B.D", stri_opts_regex(case_insensitive=TRUE)), "b\u0105d")
   
})

