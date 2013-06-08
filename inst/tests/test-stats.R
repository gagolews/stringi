require('testthat')

test_that("stri_stats_general", {
   
   expect_equivalent(stri_stats_general(c(NA, NA)), rep(0, 4))
   expect_equivalent(stri_stats_general(c("", NA, " ")), c(2,0,1,0))
   expect_equivalent(stri_stats_general(c("a", "  b  c  d  ", " ")), c(3,2,13,4))
   expect_error(stri_stats_general("aaaaaaa\nfffff")
                
)})


test_that("stri_stats_latex", {
   
   expect_equivalent(stri_stats_latex("aba 123 daf"), c(9, 0, 2, 2, 0, 0))
   expect_equivalent(stri_stats_latex("aba% 123 daf"), c(3, 0, 0, 1, 0, 0))
   expect_equivalent(stri_stats_latex("aba\\% 123 daf"), c(9, 2, 2, 2, 1, 0))
   expect_equivalent(stri_stats_latex("\\begin{textit}ala\\end{textit}"), c(3, 26, 0, 1, 0, 1))
   expect_equivalent(stri_stats_latex("\\textit{ala}"), c(3, 7, 2, 1, 1, 0))
   
})
