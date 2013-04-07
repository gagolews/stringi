require(testthat)
require(stringr)

test_that("stri_split_fixed", {
   expect_identical(stri_split_fixed(character(0)," "),list())   
   expect_identical(stri_split_fixed(NA,"a"),list(NA_character_))
   expect_identical(stri_split_fixed("NA",NA),list(NA_character_))
   expect_identical(stri_split_fixed("NA","a",NA),list(NA_character_))
   expect_identical(stri_split_fixed("NA","a",1,NA),list(NA_character_))
   expect_identical(stri_split_fixed(" "," "),list(rep("",2)))
   expect_identical(stri_split_fixed("aa","a"),list(rep("",3)))
   expect_identical(stri_split_fixed("aa","a",Inf,TRUE),list(character(0)))
   
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
   expect_identical(stri_split_fixed(s), str_split(s,'\n'))
   expect_identical(stri_split_fixed(s,' '),str_split(s,' '))
   expect_identical(stri_split_fixed(s,'a'),str_split(s,'a'))
   expect_identical(stri_split_fixed(s,"co"),str_split(s,"co"))
   expect_identical(stri_split_fixed(s,"rem"),str_split(s,"rem"))
   s <- c("abababab babab abab bbaba","a")
   expect_identical(stri_split_fixed(s,"bab"),strsplit(s,"bab"))
   expect_identical(stri_split_fixed("lalal","l"),str_split("lalal","l"))
   
   expect_identical(stri_split_fixed("lalal","l",c(-Inf,-1,0)),
                               list(character(0),character(0),character(0)))
   expect_identical(stri_split_fixed("sss","s",1:3),list("sss",c("","ss"),c("","","s")))
   
   # n
   expect_identical(stri_split_fixed(";123", ";", n=2), list(c("", "123")))
   expect_identical(stri_split_fixed(";123", ";", n=2, omitempty=TRUE), list("123"))
   expect_identical(stri_split_fixed("123;456", ";", n=2), list(c("123", "456")))
   expect_identical(stri_split_fixed("123;456;789", ";", n=2), list(c("123", "456;789")))
   
   #exact
   expect_identical(stri_split_fixed("a","b",3,exact=T),list(c("a","","")))
   #if n==inf (default) then exact is not used
   expect_identical(stri_split_fixed("a","b",exact=T),stri_split_fixed("a","b"))
})

