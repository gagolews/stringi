require(testthat)

test_that("stri_count_fixed", {
   expect_identical(stri_count_fixed(character(0)," "),integer(0))   
   expect_identical(stri_count_fixed(NA,"a"),NA_integer_)
   expect_identical(stri_count_fixed("NA",NA),NA_integer_)
   expect_identical(stri_count_fixed("   "," "),3L)
   expect_identical(stri_count_fixed("###",c("#","##","###")),c(3L,1L,1L))
   expect_identical(stri_count_fixed("a a","a"),2L)
   expect_identical(stri_count_fixed("aba","abcdef"),0L)
   
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
   expect_identical(stri_count_fixed(s,' '), 1:3*116L)
   expect_identical(stri_count_fixed(s,'a'), 1:3*50L)
   expect_identical(stri_count_fixed(s,"co"), 1:3*6L)
   expect_identical(stri_count_fixed(s,"rem"), 1:3*2L)
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_count_fixed(s,"bab"),c(5L,0L))
   expect_identical(stri_count_fixed(c("lalal","12l34l56","ąólł"),"l"),3:1)
   
})

test_that("stri_count_regex", {
   expect_identical(stri_count_regex(character(0)," "),integer(0))   
   expect_identical(stri_count_regex(NA,"a"),NA_integer_)
   expect_identical(stri_count_regex("NA",NA),NA_integer_)
   expect_identical(stri_count_regex("   "," "),3L)
   expect_identical(stri_count_regex("###",c("#","##","###")),c(3L,1L,1L))
   expect_identical(stri_count_regex("a a","a"),2L)
   expect_identical(stri_count_regex("aba","abcdef"),0L)
   
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
   expect_identical(stri_count_regex(s,"m [[a-z]]"), 1:3*7L)
   expect_identical(stri_count_regex(s,"m, [[a-z]]"), 1:3)
   expect_identical(stri_count_regex(s,"[[:digit:]]"), c(0L,0L,0L))
   expect_identical(stri_count_regex(s," [[a-z]]*\\. Phasellus (ph|or|co)"), 1:3*3L)
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_count_regex(s,"bab"),c(5L,0L))
   expect_identical(stri_count_regex(c("lalal","12l34l56","ąólł"),"l"),3:1)
   
})

