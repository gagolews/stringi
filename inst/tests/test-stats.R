require('testthat')

test_that("stri_stats_general", {
   
   expect_equivalent(stri_stats_general(c(NA, NA)), rep(0, 4))
   expect_equivalent(stri_stats_general(c("", NA, " ")), c(2,0,1,0))
   expect_equivalent(stri_stats_general(c("a", "  b  c  d  ", " ")), c(3,2,13,4))
   
)})
