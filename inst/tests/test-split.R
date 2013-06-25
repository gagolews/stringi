require(testthat)


test_that("stri_split_charclass", {
   expect_identical(stri_split_charclass(character(0),"Z"),list())   
   expect_identical(stri_split_charclass(NA,"Z"),list(NA_character_))
   expect_identical(stri_split_charclass("???",NA),list(NA_character_))
   expect_identical(stri_split_charclass("???","Z",NA),list(NA_character_))
   expect_identical(stri_split_charclass("???","Z",2,NA),list(NA_character_))
   expect_identical(stri_split_charclass("","Z"),list(""))
   expect_identical(stri_split_charclass("  ","Z"),list(c("", "", "")))
   expect_identical(stri_split_charclass("  ","Z", omit_empty=TRUE),list(character(0)))
   expect_identical(stri_split_charclass(" a  ","Z", omit_empty=TRUE),list("a"))
   expect_identical(stri_split_charclass("ala ma kota", "Z"), list(c("ala", "ma", "kota")))
   expect_identical(stri_split_charclass("ala ma kota", "Z", 0), list(character(0)))
   expect_identical(stri_split_charclass("ala ma kota", "Z", 1), list(c("ala ma kota")))
   expect_identical(stri_split_charclass("ala ma kota", "Z", 2), list(c("ala", "ma kota")))
   expect_identical(stri_split_charclass("a  b", "Z"), list(c("a", "", "b")))
   expect_identical(stri_split_charclass("a  b", "Z", omit_empty=TRUE), list(c("a", "b")))
   expect_identical(stri_split_charclass(c("a1a", "aXa"), c("N", "Lu")), list(c("a", "a"), c("a", "a")))
})


test_that("stri_split_regex", {
   expect_identical(stri_split_regex(character(0)," "),list())   
   expect_identical(stri_split_regex(NA,"a"),list(NA_character_))
   expect_identical(stri_split_regex("NA",NA),list(NA_character_))
   expect_identical(stri_split_regex("NA","a",NA),list(NA_character_))
   expect_identical(stri_split_regex("NA","a",1,NA),list(NA_character_))
   expect_identical(stri_split_regex(" "," "),list(rep("",2)))
   expect_identical(stri_split_regex("aa","a"),list(rep("",3)))
   expect_identical(stri_split_regex("aa","a",-1L,TRUE),list(character(0)))
   
   # n
   expect_identical(stri_split_regex(";123", ";", n=2), list(c("", "123")))
   expect_identical(stri_split_regex(";123", ";", n=2, omit_empty=TRUE), list("123"))
   expect_identical(stri_split_regex("123;456", ";", n=2), list(c("123", "456")))
   expect_identical(stri_split_regex("123;456;789", ";", n=2), list(c("123", "456;789")))
})


test_that("stri_split_fixed [byte]", {
   expect_identical(stri_split_fixed(character(0)," "),list())   
   expect_identical(stri_split_fixed(NA,"a"),list(NA_character_))
   expect_identical(stri_split_fixed("NA",NA),list(NA_character_))
   expect_identical(stri_split_fixed("NA","a",NA),list(NA_character_))
   expect_identical(stri_split_fixed("NA","a",1,NA),list(NA_character_))
   expect_identical(stri_split_fixed(" "," ", opts_collator=NA),list(rep("",2)))
   expect_identical(stri_split_fixed("aa","a", opts_collator=NA),list(rep("",3)))
   expect_identical(stri_split_fixed("aa","a",-1L,TRUE, opts_collator=NA),list(character(0)))
   
   # n
   expect_identical(stri_split_fixed(";123", ";", n=2, opts_collator=NA), list(c("", "123")))
   expect_identical(stri_split_fixed(";123", ";", n=2, omit_empty=TRUE, opts_collator=NA), list("123"))
   expect_identical(stri_split_fixed("123abc456", "abc", n=2, opts_collator=NA), list(c("123", "456")))
   expect_identical(stri_split_fixed("123abc456abc789", "abc", n=2, opts_collator=NA), list(c("123", "456abc789")))
})


test_that("stri_split_fixed", {
   expect_identical(stri_split_fixed(character(0)," "),list())   
   expect_identical(stri_split_fixed(NA,"a"),list(NA_character_))
   expect_identical(stri_split_fixed("NA",NA),list(NA_character_))
   expect_identical(stri_split_fixed("NA","a",NA),list(NA_character_))
   expect_identical(stri_split_fixed("NA","a",1,NA),list(NA_character_))
   expect_identical(stri_split_fixed(" "," "),list(rep("",2)))
   expect_identical(stri_split_fixed("aa","a"),list(rep("",3)))
   expect_identical(stri_split_fixed("aa","a",omit_empty=TRUE),list(character(0)))
   
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
   s <- rep(s,3)
   expect_warning(stri_split_fixed(s,c("o","a")))
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_split_fixed(s,"bab"),strsplit(s,"bab"))
   
   expect_identical(stri_split_fixed("sss","s",1:3),list("sss",c("","ss"),c("","","s")))
   
   # n
   expect_identical(stri_split_fixed(";123", ";", n=2), list(c("", "123")))
   expect_identical(stri_split_fixed(";123", ";", n=2, omit_empty=TRUE), list("123"))
   expect_identical(stri_split_fixed("123;456", ";", n=2), list(c("123", "456")))
   expect_identical(stri_split_fixed("123;456;789", ";", n=2), list(c("123", "456;789")))
})





