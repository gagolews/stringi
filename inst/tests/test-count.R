require(testthat)



test_that("stri_count_charclass", {
   expect_identical(stri_count_charclass("a", NA), NA_integer_)
   expect_identical(stri_count_charclass(NA, "Z"), NA_integer_)
   expect_identical(stri_count_charclass(NA, NA), NA_integer_)
   expect_identical(suppressWarnings(stri_count_charclass("a", "WTF????")), NA_integer_)
   expect_warning(stri_count_charclass("a", "WTF????"))

   expect_identical(stri_count_charclass(c(""), "L"), 0L)

   expect_identical(stri_count_charclass(c("a", "ab", "abc", "1234"), "L"), c(1L,2L,3L,0L))
   expect_identical(stri_count_charclass("a\u0105bc", c("L", "Ll", "Lu")), c(4L,4L,0L))
   expect_identical(stri_count_charclass("a\u0105bc", c("l", "ll", "lu")), c(4L,4L,0L))
   expect_identical(stri_count_charclass("a\u0105bc", c("^l", "^ll", "^lu")), c(0L,0L,4L))
   expect_identical(stri_count_charclass("a\u0105bc", c("AlPh_a  bEtic")), c(4L))
})


test_that("stri_count_fixed [byte compare]", {
   expect_identical(stri_count_fixed(character(0)," ", opts_collator=NA),integer(0))
   expect_identical(stri_count_fixed(NA,"a", opts_collator=NA),NA_integer_)
   expect_identical(stri_count_fixed("NA",NA, opts_collator=NA),NA_integer_)
   expect_identical(stri_count_fixed("   "," ", opts_collator=NA),3L)
   expect_identical(stri_count_fixed("###",c("#","##","###"), opts_collator=NA),c(3L,1L,1L))
   expect_identical(stri_count_fixed("a a","a", opts_collator=NA),2L)
   expect_identical(stri_count_fixed("aba","abcdef", opts_collator=NA),0L)
   suppressWarnings(expect_identical(stri_count_fixed("","", opts_collator=NA), NA_integer_))
   suppressWarnings(expect_identical(stri_count_fixed("a","", opts_collator=NA), NA_integer_))
   expect_identical(stri_count_fixed("","a", opts_collator=NA), 0L)
   expect_equivalent(stri_count_fixed("aaaab", "ab", NA), 1L)
   expect_equivalent(stri_count_fixed("bababababaab", "aab", NA), 1L)

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
   expect_warning(stri_count_fixed(s,c("o","a"), opts_collator=NA))
   expect_identical(stri_count_fixed(s,"\n", opts_collator=NA), 1:3*11L)
   expect_identical(stri_count_fixed(s,' ', opts_collator=NA), 1:3*105L)
   expect_identical(stri_count_fixed(s,'a', opts_collator=NA), 1:3*50L)
   expect_identical(stri_count_fixed(s,"co", opts_collator=NA), 1:3*6L)
   expect_identical(stri_count_fixed(s,"rem", opts_collator=NA), 1:3*2L)
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_count_fixed(s,"bab", opts_collator=NA),c(5L,0L))
   expect_identical(stri_count_fixed(c("lalal","12l34l56","\u0105\u0f3l\u0142"),"l", opts_collator=NA),3:1)

})



test_that("stri_count_fixed [collation]", {
   expect_identical(stri_count_fixed(character(0)," "),integer(0))
   expect_identical(stri_count_fixed(NA,"a"),NA_integer_)
   expect_identical(stri_count_fixed("NA",NA),NA_integer_)
   expect_identical(stri_count_fixed("   "," "),3L)
   expect_identical(stri_count_fixed("###",c("#","##","###")),c(3L,1L,1L))
   expect_identical(stri_count_fixed("a a","a"),2L)
   expect_identical(stri_count_fixed("aba","abcdef"),0L)
   suppressWarnings(expect_identical(stri_count_fixed("",""), NA_integer_))
   suppressWarnings(expect_identical(stri_count_fixed("a",""), NA_integer_))
   expect_identical(stri_count_fixed("","a"), 0L)

   expect_identical(stri_count_fixed("aaaaa", "aa"), 2L)
   expect_identical(stri_count_fixed("aaAAa-a", "aa"), 1L)
   expect_identical(stri_count_fixed("aaAAa-a", "aa", opts_collator=list(strength=1)), 2L)
   expect_identical(stri_count_fixed("aaAAa-a", "aa", opts_collator=stri_opts_collator(strength=1, alternate_shifted=TRUE)), 3L)

   expect_equivalent(stri_count_fixed("aaaab", "ab"), 1L)
   expect_equivalent(stri_count_fixed("bababababaab", "aab"), 1L)
})



test_that("stri_count_regex", {
   expect_identical(stri_count_regex(character(0)," "),integer(0))
   expect_identical(stri_count_regex(NA,"a"),NA_integer_)
   expect_identical(stri_count_regex("NA",NA),NA_integer_)
   expect_identical(stri_count_regex("   "," "),3L)
   expect_identical(stri_count_regex("###",c("#","##","###")),c(3L,1L,1L))
   expect_identical(stri_count_regex("a a","a"),2L)
   expect_identical(stri_count_regex("aba","abcdef"),0L)
   suppressWarnings(expect_identical(stri_count_regex("",""), NA_integer_))
   suppressWarnings(expect_identical(stri_count_regex("a",""), NA_integer_))

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
   expect_warning(stri_count_regex(s,c("o","a")))
   expect_error(stri_count_regex(s,"[[:numbers:]]"))
   expect_identical(stri_count_regex("ALA","ala"), 0L)
   expect_identical(stri_count_regex("ALA","ala",stri_opts_regex(case_insensitive=TRUE)), 1L)
   expect_identical(stri_count_regex(s,"m [[a-z]]"), 1:3*7L)
   expect_identical(stri_count_regex(s,"m, [[a-z]]"), 1:3)
   expect_identical(stri_count_regex(s,"[[:digit:]]"), c(0L,0L,0L))
   expect_identical(stri_count_regex(s," [[a-z]]*\\. Phasellus (ph|or|co)"), 1:3*3L)
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_count_regex(s,"bab"),c(5L,0L))
   expect_identical(stri_count_regex(c("lalal","12l34l56","\u0105\u0f3l\u0142"),"l"),3:1)
   expect_equivalent(stri_count_regex("aaaab", "ab"), 1L)
   expect_equivalent(stri_count_regex("bababababaab", "aab"), 1L)

   expect_identical(stri_count_regex("X\U00024B62\U00024B63\U00024B64X",
                               c("\U00024B62", "\U00024B63", "\U00024B64", "X")),
                                      c(1L, 1L, 1L, 2L))
})
