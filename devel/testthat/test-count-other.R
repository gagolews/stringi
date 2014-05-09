require(testthat)

test_that("stri_count", {

   expect_error(stri_count("aaa", "a"))
   expect_error(stri_count("aaa", regex="a", fixed="a"))
   expect_identical(stri_count("aaa", regex="a"), 3L)
   expect_identical(stri_count("aaa", fixed="a"), 3L)
   expect_identical(stri_count("aaa", coll="a"), 3L)
   expect_identical(stri_count("aaa", charclass="[a]"), 3L)
   
})
