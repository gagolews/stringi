require(testthat)
context("test-count-fixed.R")

test_that("stri_count_fixed", {
   expect_identical(stri_count_fixed(character(0)," "),integer(0))
   expect_identical(stri_count_fixed(NA,"a"),NA_integer_)
   expect_identical(stri_count_fixed("NA",NA),NA_integer_)
   expect_identical(stri_count_fixed("   "," "),3L)
   expect_identical(stri_count_fixed("###",c("#","##","###")),c(3L,1L,1L))
   expect_identical(stri_count_fixed("##########",c("#","##","###", "####","#####","######")),c(10L,5L,3L,2L,2L,1L))
   expect_identical(stri_count_fixed("a a","a"),2L)
   expect_identical(stri_count_fixed("aba","abcdef"),0L)
   suppressWarnings(expect_identical(stri_count_fixed("",""), NA_integer_))
   suppressWarnings(expect_identical(stri_count_fixed("a",""), NA_integer_))
   expect_identical(stri_count_fixed("","a"), 0L)
   expect_equivalent(stri_count_fixed("aaaab", "ab"), 1L)
   expect_equivalent(stri_count_fixed("bababababaab", "aab"), 1L)

   s <- "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Proin
nibh augue, suscipit a, scelerisque sed, lacinia in, mi. Cras vel
lorem. Etiam pellentesque aliquet tellus. Phasellus pharetra nulla ac
diam. Quisque semper justo at risus. Donec venenatis, turpis vel
hendrerit interdum, dui ligula ultricies purus, sed posuere libero dui
id orci. Nam congue, pede vitae dapibus aliquet, elit magna vulputate
arcu, vel tempus metus leo non est. Etiam sit amet lectus quis est
congue mollis. Phasellus congue lacus eget neque. Phasellus ornare,
ante vitae consectetuer consequat, purus sapien ultricies dolor, et
mollis pede metus eget nisi. Praesent sodales velit quis augue. Cras
suscipit, urna at aliquam rhoncus, urna quam viverra nisi, in interdum
massa nibh nec erat."
   s <- stri_dup(s,1:3)
   expect_warning(stri_count_fixed(s,c("o","a")))
   expect_identical(stri_count_fixed(s,"\n"), 1:3*11L)
   expect_identical(stri_count_fixed(s,' '), 1:3*105L)
   expect_identical(stri_count_fixed(s,'a'), 1:3*50L)
   expect_identical(stri_count_fixed(s,"co"), 1:3*6L)
   expect_identical(stri_count_fixed(s,"rem"), 1:3*2L)
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_count_fixed(s,"bab"),c(5L,0L))
   expect_identical(stri_count_fixed(c("lalal","12l34l56","\u0105\u0f3l\u0142"),"l"),3:1)

})
